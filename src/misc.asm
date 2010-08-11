;miscellaneous utility syscalls
misc_begin:

;Function: pushAll
;Pushes AF, BC, DE, HL and IX onto the stack.
pushAll:
	ex (sp),hl	;this gives me my return address and pushes hl
	push af
	push bc
	push de
	push ix
	push hl		;save return address
	ret

;Function: popAll
;Gets saved register values back from a previous <pushAll>.  The stack
;must be in the same state as it was at the initial push.
popAll:
	pop hl
	pop ix
	pop de
	pop bc
	pop af
	ex (sp),hl	;put the return address back and get hl
	ret


.module check16
;Function: check16
;Calculates the 16-bit modular checksum of a block of memory.
;
;Inputs:
; HL - pointer to the block to checksum
; BC - size of block at (HL)
;
;Outputs:
; HL - checksum value
;
;Modifies:
; AF, BC, DE, HL
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

;Function: coordsReset
;Resets the text render coordinates <xyCoords> to (0,0).
;
;Modifies:
; HL
coordsReset:
	ld hl,0
	ld (xyCoords),hl
	ret

;Function: getOSVersion
;Gets version information about the currently running OS.
;
;Outputs:
; H - <LIFOS_VER_MAJOR>
; L - <LIFOS_VER_MINOR>
; A - <LIFOS_VER_BUILD>
getOSVersion:
	ld hl,(256*LIFOS_VER_MAJOR)+LIFOS_VER_MINOR
	ld a,LIFOS_VER_BUILD
	ret

;Function: swapRAM
;Swaps two blocks of RAM.
;
;Inputs:
; HL - pointer to first block
; DE - pointer to second block
; BC - size of blocks to swap
;
;Modifies:
; AF, BC, DE, HL
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

;Function: strLen
;Find the length of a null-terminated string.
;
;Inputs:
; HL - pointer to string
;
;Outputs:
; B - length of string at (HL), excluding null terminator
;
;Modifies:
; AF, B
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
    
;Function: memCmp
;Lexicographically compare two blocks of memory.
;
;Inputs:
; HL - pointer to first block
; DE - pointer to second block
; B - size of block to compare
;
;Outputs:
; Z flag - set if blocks are equal
; C flag - set if (HL) > (DE), else reset.  State is meaningless if Z is set.
;
;Modifies:
; AF, B, DE, HL
compStrs:
;TODO: might cpir be useful here?
	ld a,(de)
	cp (hl)
	ret nz
	inc hl
	inc de
	djnz compStrs
	ret

;Function: rand8
;Generate a pseudo-random 8-bit number.
;
;Outputs:
; A - generated number
;
;Modifies:
; AF, B
;
;See Also:
; <randSeed>
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

;Function: getHardVersion
;Gets the hardware revision which is currently running (83+, 84+, etc).
;
;Outputs:
; A - <calcType> code for the current hardware.
;
;Modifies:
; AF
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
	
.echo "misc.asm:	"\.echo $-misc_begin\.echo " bytes\n"
