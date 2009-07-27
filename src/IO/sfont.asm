sPutS:
	ld a,(hl)
	inc hl
	or a
	ret z
	call sPutC
	jr sPutS

.module sPutC
;;================
;;Small font putC
;;Inputs:
;;	A=character value
;;	(xyCoords)=coordinates to display at
;;Modifies:
;;	AF
sPutC:
	push hl
	cp $D			;carriage return
	jr nz, _continue
	;advance the pointers
	xor a
	ld (curCol),a
	ld a,(curRow)
	add a,6
	ld (curRow),a
	pop hl
	ret
_continue:
	call _wrappedUp
	pop hl
	ret
_wrappedUp:
	call sPutMap
	ld hl,curCol
	ld a,(hl)
	add a,6
	ld (hl),a
	ld c,%00001000
_findWidthLoop:
	dec (hl)
	ld a,c
	add a,a
	ret z
	ld c,a
	ld de,OSRAM
	ld b,5
_findWidthLoop2:
	ld a,(de)
	and c
	ret nz
	inc de
	djnz _findWidthLoop2
	jr _findWidthLoop

.module sPutMap
;;================
;;Small font PutMap
;;Input:
;;	A=character value
;;Modifies:
;;	OSRAM - OSRAM+4
sPutMap:
	call pushAll
	sub 32		;nothing exists below $20
	ld l,a
	srl l		;2x(char) for good luck
	ld h,0
	ld e,l
	ld d,h
	add hl,hl
	add hl,hl
	add hl,de	;2 characters per 5-byte block
	ld de,_charTab
	add hl,de	;->sprite block now
	ld de,OSRAM	;5 bytes scrap
	ld b,5
	and 1
	jr z,_unshiftedChar
_shiftedChar:
	ld a,(hl)
	add a,a
	add a,a
	add a,a
	add a,a		;shift left, discard MSN
	ld (de),a
	inc hl
	inc de
	djnz _shiftedChar
	jr _fontSkip
_unshiftedChar:
	ld a,(hl)
	and $F0		;mask out LSN
	bit inverseText,(iy+0)
	jr z,$+1+2	;cpl is a one-byte opcode, jr is 2
	cpl
	ld (de),a
	inc hl
	inc de
	djnz _unshiftedChar
_fontSkip:
	ld ix,OSRAM
	ld hl,(xyCoords)
	ld a,l		;x coord
	ld l,h		;y coord
	inc l
	ld b, 5
	bit textToBuf,(iy+0)
	call nz,putSprite
	bit textToBuf,(iy+0)	;poll again, since putSprite messed with F
	call z,putSpriteLCD
	call popAll
	ret
	
.include "src/IO/sfont.h"