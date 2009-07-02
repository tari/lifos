putS:
	ld a,(hl)
	inc hl
	or a
	ret z
	call putC
	jr putS

.module putMap
;;=================
;;Display a character
;;Inputs:
;;A=character value
;;(xyCoords)=coordinate
PutMap:
	call pushAll
	 call _drawIt
	call popAll
	ret
_drawIt:
	ld l,a
	ld h,0
	add hl,hl	;2
	ld e,a
	ld d,h
	add hl,de	;3
	add hl,hl	;6
	add hl,de	;7
	ld de,_charTab
	add hl,de
;copy the character to OSRAM, so I can invert it as needed
	ld de,OSRAM
	ld b,7
_cplLoop:
	ld a,(hl)
	bit inverseText,(iy+0)
	jr z,$+1+2		;skip the cpl
	cpl
	ld (de),a
	inc hl
	inc de
	djnz _cplLoop
	ld ix,OSRAM
	ld hl,(xyCoords)
	ld a,l
	ld l,h
	ld b,7
	bit textToBuf,(iy+0)
	jp nz,putSprite	;it will return to my caller
	jp putSpriteLCD
_charTab:
.include "src/asm/IO/lfont.h"

PutC:
   cp $D		;CR (nyah nyah, CR/LF)
   jr nz, _putMap
_carriageReturn:
   xor a
   ld (curCol),a
   ld a,(curRow)
   add a,8
   ld (curRow),a
   ret
_putMap:
   call PutMap
   ld a,(curCol)
   add a,6
   cp 96-5
   jr c,_saveX
   ld a,(curRow)
   add a,8
   cp 64-6
   jr c,_saveY
   xor a
_saveY:
   ld (curRow),a
   xor a
_saveX:
   ld (curCol),a
   ret