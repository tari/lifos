display_begin:
.include "src/IO/lfont.asm"
.include "src/IO/sfont.asm"

.module dispAHex
;;dispAHex: writes A to the screen in hex
;;Inputs:
;;  A: value to write
;;Outputs:
;;  Cursor updated
;;Modifies:
;;  AF, whatever putC does
dispAHex:
    push af
     and 0Fh
     add a,'0'
     call putC
     pop af
    srl a
    srl a
    srl a
    srl a
    and 0Fh
    add a,'0'
    call putC
    ret

.module LCDWait
LCDWait:
	push af
_loop:
	in a,(pLCDCOMM)
	rla
	jr c,_loop
	pop af
	ret



LCDComm:
	call LCDWait
	out (pLCDCOMM),a
	ret


.module bufCopy
;gleefully stolen.. sorry if anyone wants me to write my own
;Credit goes to Joe Wingbermuehle for this (_fastcopy, anyway) and putSprite
;assumes LCD is in X auto-increment mode
bufCopy:
	call pushAll
	ld a,r
	push af
	ld c,1Fh		;column 0-(minus)1
	di
	call _fastCopy
	pop af
	jp pe,_exit		;_exit if the parity flag is set (interrupts weren't on)
	;wait.. a USE for IFF2?!
	ei
_exit:
	call popAll
	ret

_fastCopy
	ld	a,$80				; 7
	out	($10),a				; 11
	ld	hl,dispBuf-12-(-(12*64)+1)	; 10
	ld	a,$20				; 7
	ld	c,a				; 4
	inc	hl				; 6 waste
	dec	hl				; 6 waste
fastCopyAgain:
	ld	b,64				; 7
	inc	c				; 4
	ld	de,-(12*64)+1			; 10
	out	($10),a				; 11
	add	hl,de				; 11
	ld	de,10				; 10
fastCopyLoop:
	add	hl,de				; 11
	inc	hl				; 6 waste
	inc	hl				; 6 waste
	inc	de				; 6
	ld	a,(hl)				; 7
	out	($11),a				; 11
	dec	de				; 6
	djnz	fastCopyLoop			; 13/8
	ld	a,c				; 4
	cp	$2B+1				; 7
	jr	nz,fastCopyAgain		; 10/1
	ret					; 10
; Critical timings:
;	command->command: 65
;	command->value  : 68
;	value  ->value  : 66
;	value  ->command: 67


.module putSprite
;;putSprite: draws a sprite to the display buffer
;;Inputs:
;;	L=y coordinate
;;	A=x coordinate
;;	B=sprite height (in bytes)
;;	IX->sprite data
;;Modifies:
;;	AF,BC,DE,HL,IX
putSprite:
	ld	e,l
	ld	h,$00
	ld	d,h
	add	hl,de
	add	hl,de
	add	hl,hl
	add	hl,hl		;12x y coord
	ld	e,a			;absolute x coord
	and	$07
	ld	c,a			;relative x (shift this many)
	srl	e
	srl	e
	srl	e			;divide by 8-8 pixels per byte
	add	hl,de
	ld	de,dispBuf
	add	hl,de
putSpriteLoop1:
sl1:	ld	d,(ix)	;byte of data
	ld	e,$00
	ld	a,c			;shift counter
	or	a
	jr	z,putSpriteSkip1	;don't shift it
putSpriteLoop2:
	srl	d
	rr	e
	dec	a
	jr	nz,putSpriteLoop2
putSpriteSkip1:
	ld	a,(hl)
	xor	d
	ld	(hl),a		;read, xor and write- first chunk
	inc	hl
	ld	a,(hl)
	xor	e
	ld	(hl),a		;same, second chunk
	ld	de,$0B
	add	hl,de		;next row
	inc	ix
	djnz	putSpriteLoop1
	ret


clrLCD:
;;clrLCD: erases dispBuf and copies to the LCD
;;Modifies:
;;	BC, DE, HL
	ld hl,dispBuf
	ld de,dispBuf+1
	ld bc,767
	ld (hl),0
	ldir
	call bufCopy
	ret


horizLine:
;l=y coordinate for line
	ld h,0
	ld e,l
	ld d,h
	add hl,hl
	add hl,de
	add hl,hl
	add hl,hl	;hl=12L
	ld de,dispBuf
	add hl,de
	ld (hl),$FF
	ld e,l
	ld d,h
	inc de
	ld bc,11
	ldir
	ret

.module putSpriteLCD
putSpriteLCD:
;;putSpriteLCD: draws a sprite directly to the LCD
;;Inputs:
;;	L=y coordinate
;;	A=x coordinate
;;	B=sprite height
;;	IX->sprite data
;;Modifies:
;;	AF,BC,DE,HL,IX
;iyh=column (LCD's Y)
;iyl=row (LCD's X)
#DEFINE setCol() ld a,iyh
#DEFCONT	\	 call LCDComm
	push iy
	push af
	 and 7
	 ld c,a         ;shift counter
	 ld a,%00000111 ;Y auto-increment mode
	 call LCDComm
	 pop af
	srl a
	srl a
	srl a           ;division by 8
	or %00100000	;set LCD Y command
	call LCDComm
	ld iyh,a
	ld a,l
	or %10000000    ;set LCD X
	ld iyl,a
_updateRow:
	call LCDComm
_spriteRead_Shift:
	ld d,(ix)
	inc ix
	ld e,0
	ld a,c
	or a
	jr z,_alignedSprite
_spriteShiftL:
	srl d
	rr e
	dec a
	jr nz,_spriteShiftL
_alignedSprite:
	setCol()
	in a,($11)      ;dummy read
	in a,($11)
	ld h, a
	in a,($11)
	ld l,a
	setCol()
	ld a,d
	xor h
	call LCDWait	;wait until ready for data
	out ($11),a
	ld a,e
	xor l
	call LCDWait
	out ($11),a
	inc iyl         ;next row
	ld a,iyl
	djnz _updateRow
	ld a,%000000101 ;back to X auto-increment mode
	call LCDComm
	pop iy
	ret
	
.echo "display.asm	"\.echo $-display_begin\.echo " bytes\n"