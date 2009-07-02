;* PUCRUNCH unpacker for ti83+
;*   ported to ti83+ by Martin Warmer based on
;* PUCRUNCH unpacker for GB
;*   Modeled after Pasi Ojala's C64 code.

; Pucrunch file format
;;; db INPOS low     (endAddr + overlap - size) & 0xff
;;; db INPOS high    (endAddr + overlap - size) >> 8
;;; db 'p'
;;; db 'u'
;;; db (endAddr - 0x100) & 0xff
;;; db (endAddr - 0x100) >> 8
; db escape>>(8-escBits)
;;; db (start & 0xff) (OUTPOS low)
;;; db (start >> 8) (OUTPOS high)
; db escBits
; db maxGamma + 1
; db (1<<maxGamma); /* Short/Long RLE */
; db extraLZPosBits;
;;; db (exec & 0xff)
;;; db (exec >> 8)
; db rleUsed (31)  ;needed
; ds rleUsed
;  ....data....
;entries with (;;;) are skipped in fullheader mode
; in non full header mode they are assumed to be deleted

;allocate a 45 byte block and point IX at it for safeRAM
; equates are offset from IX
OutPtr          = 0
lzpos           = 2
regy		= 4
escPu           = 5
EscBits         = 6
Esc8Bits        = 7
MaxGamma        = 8
Max8Gamma       = 9
Max1Gamma       = 10
Max2Gamma       = 11
ExtraBits       = 12
tablePu         = 13 ;uses 31 (+1 if full header) bytes

; HL = InPtr
; D = bitstr
; E = X
; BC = temps

; ****** Unpack pucrunch data ******
; Entry: HL = Source packed data
;        DE = Destination for unpacked data

Unpack:
        ld   (OutPtr),de

; Read the file header & setup variables

		ifdef fullheader
        ld      bc,6
        add     hl,bc
		endif
							
		  ld de,escPu

        ldi	;copy escPu

		ifdef fullheader
        inc     hl
        inc     hl
		endif

        ld      b,(hl) ;was [hl+]
		  ldi ;copy EscBits

        ld      a,8
        sub     b
        ld      (de),a
		  inc de

        ld      b,(hl) ;was [hl+]
		  ldi ;copy MaxGamma
        ld      a,9 ; 8-(b-1)=9-b
        sub     b
        ld      (de),a ;Max8Gamma
		  inc de

        ld      a,(hl) ;was [hl+]
		  ldi ;Max1Gamma
        add     a
        dec     a
        ld      (de),a ;Max2Gamma
		  inc de

        ldi ;ExtraBits

		ifdef fullheader
        inc     hl
        inc     hl
		endif

        ld      c,(hl) ;was [hl+]
		  inc hl
		ifdef fullheader 
		  inc c
		  dec c	;uses 1 byte of ram less but takes 3 bytes extra decompression code
		  jr z,$f
		endif

; Copy the RLE table (maximum of 31 bytes) to RAM
		  ld b,0
		  ldir
$$:
		ifndef fullheader
		  dec hl ;because bc is 1 too large
		endif

        ld      d,80h

        jr      .main


.newesc:
        ld      b,a

        ld      a,(escPu)
        ld      (regy),a

        ld      a,(EscBits)
        ld      e,a

        ld      a,b

        inc     e

        call    .getchk

        ld      (escPu),a

        ld      a,(regy)

        ; Fall through and get the rest of the bits.

.noesc:
        ld      b,a

        ld      a,(Esc8Bits)
        ld      e,a

        ld      a,b

        inc     e

        call    .getchk

; Write out the escaped/normal byte

        ld    bc,(OutPtr)
        ld      (bc),a
        inc     bc
        ld   (OutPtr),bc

       ; Fall through and check the escape bits again

.main:
        ld      a,(EscBits)
        ld      e,a

        xor     a               ; A = 0
        ld      (regy),a

        inc     e

        call    .getchk         ; X=2 -> X=0

        ld      b,a
        ld      a,(escPu)
        cp      b
        ld      a,b

        jr      nz,.noesc       ; Not the escape code -> get the rest of the byte

        ; Fall through to packed code

        call    .getval         ; X=0 -> X=0

        ld      (lzpos),a       ; xstore - save the length for a later time

        srl     a               ; cmp #1        ; LEN == 2 ? (A is never 0)
        jr      nz,.lz77        ; LEN != 2      -> LZ77

        call    .get1bit        ; X=0 -> X=0

        srl     a               ; bit -> C, A = 0

        jr      nc,.lz77_2      ; A=0 -> LZPOS+1        LZ77, len=2

	; e..e01
        call    .get1bit        ; X=0 -> X=0
        srl     a               ; bit -> C, A = 0
        jr      nc,.newesc      ; e..e010               New Escape

	; e..e011				Short/Long RLE
        ld      a,(regy)        ; Y is 1 bigger than MSB loops
        inc     a
        ld      (regy),a

        call    .getval         ; Y is 1, get len,  X=0 -> X=0
        ld      (lzpos),a       ; xstore - Save length LSB

        ld      c,a

        ld      a,(Max1Gamma)
        ld      b,a

        ld      a,c

        cp      b               ; ** PARAMETER 63-64 -> C set, 64-64 -> C clear..

        jr      c,.chrcode      ; short RLE, get bytecode

	; Otherwise it's long RLE
.longrle:
        ld      b,a
        ld      a,(Max8Gamma)
        ld      e,a             ; ** PARAMETER  111111xxxxxx
        ld      a,b

        call    .getbits        ; get 3/2/1 more bits to get a full byte,  X=2 -> X=0
        ld      (lzpos),a       ; xstore - Save length LSB

        call    .getval         ; length MSB, X=0 -> X=0

        ld      (regy),a        ; Y is 1 bigger than MSB loops

.chrcode:
        call    .getval         ; Byte Code,  X=0 -> X=0

        ld      e,a
;FIX
		  dec a
		  ld      c,tablePu%256
        add     c
        ld      c,a
        ld      a,tablePu/256
;FIX
        adc     0
        ld      b,a

        ld      a,e
        cp      32              ; 31-32 -> C set, 32-32 -> C clear..
        ld      a,(bc)
        jr      c,.less32       ; 1..31

	; Not ranks 1..31, -> 11111°xxxxx (32..64), get byte..

        ld      a,e        ; get back the value (5 valid bits)

        ld      e,3

        call    .getbits        ; get 3 more bits to get a full byte, X=3 -> X=0

.less32:
        push    hl
        push    af

        ld      a,(lzpos)
        ld      e,a          ; xstore - get length LSB

        ld      b,e
        inc     b               ; adjust for cpx#$ff;bne -> bne

        ld      a,(regy)
        ld      c,a

        ld   hl,(OutPtr)

        pop     af

.dorle:
        ld      (hl),a ;was [hl+]
		  inc hl

        djnz .dorle       ; xstore 0..255 -> 1..256

        dec     c
        jr      nz,.dorle       ; Y was 1 bigger than wanted originally

        ld   (OutPtr),hl

        pop     hl
        jr      .main

.lz77:
        call    .getval         ; X=0 -> X=0

        ld      b,a

        ld      a,(Max2Gamma)
        cp      b               ; end of file ?
        ret     z               ; yes, exit

        ld      a,(ExtraBits)   ; ** PARAMETER (more bits to get)
        ld      e,a

        ld      a,b

        dec     a               ; subtract 1  (1..126 -> 0..125)

        inc     e

        call    .getchk ;f        ; clears Carry, X=0 -> X=0

.lz77_2:
        ld      (lzpos+1),a     ; offset MSB

        ld      e,8

        call    .getbits        ; clears Carry, X=8 -> X=0

                        ; Note: Already eor:ed in the compressor..
        ld      b,a

        ld      a,(lzpos)
        ld      e,a             ; xstore - LZLEN (read before it's overwritten)

        ld      a,(OutPtr)
        add     b               ; -offset -1 + curpos (C is clear)
        ld      (lzpos),a

        ld      a,(lzpos+1)
        ld      b,a

        ld      a,(OutPtr+1)
        ccf
        sbc     b
        ld      (lzpos+1),a     ; copy X+1 number of chars from LZPOS to OUTPOS



; Write decompressed bytes out to RAM
        ld      c,e

        inc     e               ; adjust for cpx#$ff;bne -> bne

        push    de
        push    hl

        ld   hl,(lzpos)
        ld   de,(OutPtr)

		  ld      b,0
		  inc     bc
		  ldir

        ld   (OutPtr),de		  

        pop     hl
        pop     de
        jr      .main


; getval : Gets a 'static huffman coded' value
; ** Scratches X, returns the value in A **
.getval:                        ; X must be 0 when called!
        ld      a,1
        ld      e,a
.loop0:
        sla     d

        jr      nz,.loop1

        ld      d,(hl)
        inc     hl

        rl      d               ; Shift in C=1 (last bit marker)
                                ; bitstr initial value = $80 == empty
.loop1:
        jr      nc,.getchk      ; got 0-bit

        inc     e

        ld      b,a             ; save a

        ld      a,(MaxGamma)
        cp      e

        ld      a,b             ; restore a

        jr      nz,.loop0

        jr      .getchk


; getbits: Gets X bits from the stream
; ** Scratches X, returns the value in A **

.get1bit:
        inc     e
.getbits:
        sla     d

        jr      nz,.loop3

        ld      d,(hl)
        inc     hl

        rl      d               ; Shift in C=1 (last bit marker)
                                ; bitstr initial value = $80 == empty
.loop3:
        rla
.getchk:
        dec     e
        jr      nz,.getbits
        or      a       ; clear carry flag
        ret
