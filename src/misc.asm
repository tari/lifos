;miscellaneous utility syscalls
misc_begin:

pushAll:
	ex (sp),hl	;this gives me my return address and pushes hl
	push af
	push bc
	push de
	push ix
	push hl		;save return address
	ret


popAll:
	pop hl
	pop ix
	pop de
	pop bc
	pop af
	ex (sp),hl	;put the return address back and get hl
	ret


.module check16
;;check16: calculates a 16-bit checksum
;;Inputs:
;; HL->area to checksum
;; BC=size of (HL)
;;Outputs:
;; HL=checksum
;;Modifies:
;; AF,BC,DE
check16:
	ld d,0
	push hl
	ld hl,0
	ex (sp),hl
_loop:
	ld e,(hl)
	ex (sp),hl
	add hl,de
	ex (sp),hl
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,_loop
	pop hl
	ret


coordsReset:
	ld hl,0
	ld (xyCoords),hl
	ret


getOSVersion:
	ld hl,(256*LIFOS_VER_MAJOR)+LIFOS_VER_MINOR
	ld a,LIFOS_VER_BUILD
	ret

;;swapRAM: swap two blocks of RAM
;;Inputs:
;; HL->first block
;; DE->second block
;; BC=size of blocks
;;Outputs:
;; Blocks swapped
;;Modifies:
;; AF,BC,DE,HL
swapRAM:
	ld a,(de)
	push af
	ld a,(hl)
	ld (de),a
	pop af
	ld (hl),a
	inc hl
	inc de
	dec bc
	ld a,b
	or c
	jr nz,swapRAM
	ret

;;strLen: get the length of a null-terminated string
;;Inputs:
;; HL->string
;;Outputs:
;; B=length (excluding terminator)
;;Modifies:
;; AF,B
strLen:
    push hl
    ld b,$FF
_strLenLoop:
    inc b
    ld a,(hl)
    or a
    inc hl
    jr nz,_strLenLoop
    pop hl
    ret
    
;;compStrs: compare two strings
;;CHECKME: is cpir just as useful?
;;Inputs:
;; HL->first string
;; DE->second string
;; B=string length
;;Outputs:
;; ZF if strings are same
;; CF if (HL)>(DE)
;; NCF if (DE)>(HL)
;;Modifies:
;; AF,B,DE,HL
compStrs:
	ld a,(de)
	cp (hl)
	ret nz
	inc hl
	inc de
	djnz compStrs
	ret


cpHLDE:
	or a
	sbc hl,de
	add hl,de
	ret


.module rand8
rand8:
	push	hl
	push	de
	ld	hl,(randSeed)
	ld	a,r
	ld	d,a
	ld	e,(hl)
	add	hl,de
	add	a,l
	xor	h
	ld	(randSeed),hl
	sbc	hl,hl
	ld	e,a
	ld	d,h
_loop:
	add	hl,de
	djnz	_loop
	ld	a,h
	pop	de
	pop	hl
	ret

	
getHardVersion:
	in a,(2)
	bit 7,a
	ld a,0		;no xor, since that would set the Z flag in all cases
	ret z
	in a,(2)
	bit 5,a
	ld a,1
	ret z
	in a,(21h)
	bit 1,a
	ld a,2
	ret z
	inc a
	ret
	
;;is83PBE: returns nz if 83+, z otherwise
is83PBE:
	push bc
	 push af
	  in a,(2)
	  bit 7,a	;reset on 83PBE
	  pop bc
	 ld a,b
	 pop bc
	ret
.echo "misc.asm:	"\.echo $-misc_begin\.echo " bytes\n"
