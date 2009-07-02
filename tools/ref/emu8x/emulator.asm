;
; TI-82, 83, 85, 86 Emulator
;
; Project started 08-28-04.
;
; Copyright (C) 2004, by Michael Vincent. All rights reserved.
 INCLUDE "header.inc"
 NOLIST
 INCLUDE "..\ti83plus.inc"
 INCLUDE "..\michael.inc"
 LIST
 INCLUDE "equates.inc"
;DEBUG EQU 1
;Memory map -
;82h - 8000-BFFFh of emulated calculator
;83h - C000-FFFFh of emulated calculator
;84h - miscellaneous page
;		8000-82FFh - Emulated calculator LCD stored while paused
App_Start:
 ifdef DEBUG
 	ld hl,0
	ld (8700h),hl
	ld (8702h),hl
	ld (8787h),hl
 endif
	ld a,(Calculator_ROMs)
	inc a
	ld hl,App_NoROMs
	jp z,App_Error
	in a,(2)
	rla
	ld hl,App_NotSE
	jp nc,App_Error
	;Splash screen here
	B_CALL DelRes
	B_CALL DisableApd
	B_CALL ForceFullScreen
	B_CALL ClrScrnFull
	ld hl,3*256
	ld (currow),hl
	ld hl,Splash_Data
	set textInverse,(iy+textFlags)
	call putstr
	res textInverse,(iy+textFlags)
	ld a,14
	call vputcentered
	ld a,25
	call vputcentered
	ld a,32
	call vputcentered
	ld a,50
	call vputcentered
	ld a,57
	call vputcentered
	B_CALL GetKey
 	jp Main_Screen
Emulation_Starting:
	DB "Emulator is     "
	DB "loading...",0
Splash_Data:
	DB "Emu8x v1.00",0
	DB 18,"By Michael Vincent",0
	DB 7, "E-mail:",0
	DB 15,"me@michaelv.org",0
	DB 18,"Detached Solutions",0
	DB 21,"detachedsolutions.com",0
App_Exit:
	B_CALL JForceCmdNoChar
App_NotSE:
	DB "A TI-83 Plus    "
	DB "Silver Edition  "
	DB "or TI-84 Plus   "
	DB "model is        "
	DB "required.",0
App_Error:
	push hl
	B_CALL ClrScrnFull
	B_CALL HomeUp
	pop hl
	call putstr
	B_CALL GetKey
	jr App_Exit
App_NoROMs:
	DB "There are no    "
	DB "calculator ROMs "
	DB "present.",0
 INCLUDE "tables.asm"
 INCLUDE "ui.asm"
 INCLUDE "opcodes.asm"
SaveDisplay:
	di
	ld b,64
	ld a,07h
	call lcddelay
	out (10h),a
	ld a,80h-1
Slayerloop1:
	push bc
	ld b,0Ch
	inc a
	ld (OP1),a
	call lcddelay
	out (10h),a
	call lcddelay
	ld a,20h
	out (10h),a
	call lcddelay
	in a,(11h)
Slayerloop2:
	call lcddelay
	in a,(11h)
	ld (hl),a
	inc hl
	djnz Slayerloop2
	pop bc
	ld a,(OP1)
	djnz Slayerloop1
	ld a,05h
	call lcddelay
	out (10h),a
	ret
CopyLayer:
	di
	ld b,64
	ld a,07h
	out (10h),a
	ld a,80h-1
layerloop1:
	push bc
	ld b,0Ch
	inc a
	ld (OP1),a
	call lcddelay
	out (10h),a
	call lcddelay
	ld a,20h
	out (10h),a
layerloop2:
	ld a,(hl)
	call lcddelay
	out (11h),a
	inc hl
	djnz layerloop2
	pop bc
	ld a,(OP1)
	djnz layerloop1
	ld a,5
	call lcddelay
	out (10h),a
	ret
lcddelay:
	push af
lcddelayloop:
	in a,(10h)
	and 80h		;take the slower approach to burn more clock cycles
	jr nz,lcddelayloop
	pop af
	ret
putstr:
	ld a,(hl)
	inc hl
	or a
	ret z
	B_CALL PutC
	jr putstr
vputcentered:
	push hl
	ld (penrow),a
	ld de,ramCode
	push de
	B_CALL StrCopy
	pop hl
	B_CALL SStringLength
	srl b
	ld a,48
	sub b
	ld (pencol),a
	pop hl
	inc hl
vputstr:
	ld a,(hl)
	inc hl
	or a
	ret z
	B_CALL VPutMap
	jr vputstr
GetString:
	ld a,b
	or a
	ret z
GetString_Loop:
	push bc
	xor a
	ld bc,-1
	cpir
	pop bc
	djnz GetString_Loop
	ret
 INCLUDE "machine.asm"
