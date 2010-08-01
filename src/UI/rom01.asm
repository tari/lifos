UI_MAIN:
.include "src/unittest.asm"
#IFNDEF UNIT_TEST
	set textToBuf,(IY+0)
	call clrLCD
	;Horizontal delimiters
	ld l,8
	call horizLine
	ld l,64-13
	call horizLine
	;URL and general pimping
	ld hl,$3400
	ld (xyCoords),hl
	ld hl,URLPlug
	call sPutS
    ;OS version string
	ld hl,0
	ld (xyCoords),hl
	ld hl,$0064
	call putS
	;TI-8 prefix on hardware version
	ld hl,$0900
	ld (xyCoords),hl
	ld hl,TI8x
	call sPutS
    ;Hardware version suffix
	call getHardVersion
	ld l,a
	ld h,0
	add hl,hl	;2x
	ld e,l
	ld d,h
	add hl,hl	;4x
	add hl,de	;6x
	ld de,modelStrs
	add hl,de
	call sPutS
	;Boot code version prefix
	ld hl,$0F00
	ld (xyCoords),hl
	ld hl,bootVer
	call sPutS
	;Boot code version number
	ld hl,4
	call mAlloc
	jr nc,_allocOK
	ld hl,bootVerAllocFailed
	call sPutS
	jr _putLogo
_allocOK:
	ex de,hl		;de->block
	ld a,$1F
	ld hl,$400F
	ld bc,4
	call pagedRead	;preserves de
	ex de,hl
	call sPutS
	call popAllocStack
    ;Logo
_putLogo:
	ld hl,dispBuf+(12*18)+9
	ld ix,LIFOSLogo
	ld de,10
	ld b,24
_logoLoop:
	ld a,(ix)
	ld (hl),a
	inc ix
	inc hl
	ld a,(ix)
	ld (hl),a
	inc ix
	inc hl
	ld a,(ix)
	ld (hl),a
	inc ix
	add hl,de
	djnz _logoLoop
	
	call bufCopy
	jr $

TI8x:
	.db "TI-8",0
modelStrs:
	.db "3+   ",0
	.db "3+ SE",0
	.db "4+   ",0
	.db "4+ SE",0
URLPlug:
	.db "Updates and news at",$D
	.db "http://lifos.taricorp.net",0
bootVer:
	.db "Boot code ",0
bootVerAllocFailed:
	.db "-ALLOC FAILED",0
LIFOSLogo:
	.db %01111111,%11111111,%11111110
	.db %11111111,%11111111,%11111111
	.db %11100000,%00000000,%00000111
	.db %11001111,%11111111,%11110011
	.db %11011111,%11111111,%11111011
	.db %11011111,%11111111,%11111011
	.db %00000000,%00000000,%01111011
	.db %11111111,%11111111,%01111011
	.db %10000000,%00000001,%00000000
	.db %10100000,%10001101,%11111111
	.db %10100000,%00001000,%00000001
	.db %10100001,%10011101,%11011101
	.db %10100000,%10001001,%01010001
	.db %10111101,%11001001,%11011101
	.db %10000000,%00000000,%00000101
	.db %11111111,%11111111,%10011101
	.db %00000000,%00000000,%10000001
	.db %11011111,%11111110,%11111111
	.db %11011111,%11111110,%00000000
	.db %11001111,%11111111,%11111011
	.db %11100000,%00000000,%00000011
	.db %11111111,%11111111,%11111111
	.db %11111111,%11111111,%11111111
	.db %01111111,%11111111,%11111110
#ENDIF
