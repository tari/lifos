Main_Screen:
	B_CALL ClrScrnFull
	B_CALL HomeUp
	ld hl,Main_1
	call putstr
	ld hl,2
	ld (currow),hl
Main_Screen_ROM_List:
	ld b,4
	ld de,Calculator_ROMs
	xor a
	ld (menucount),a
Main_Screen_ROM_Loop:
	ld a,(de)
	cp 0FFh
	jr z,Main_Menu
	ld hl,Main_82
	push bc
	ld b,a
	call GetString
	push de
	call putstr
	B_CALL NewLine
	ld hl,menucount
	inc (hl)
	pop de
	pop bc
	inc de
	djnz Main_Screen_ROM_Loop
Main_Menu:
	xor a
	ld (menucur),a
	ld hl,2
	ld (currow),hl
	ld a,5
	B_CALL PutMap
Main_Menu_Loop:
	B_CALL GetKey
	cp 40h
	jp z,App_Exit
	cp kClear
	jp z,App_Exit
	cp kUp
	jr z,Main_Menu_Up
	cp kDown
	jp z,Main_Menu_Down
	cp kEnter
	jr nz,Main_Menu_Loop
	;Enter pressed
	ld hl,Calculator_ROMs
	ld c,1
	ld a,(menucur)
	or a
	jr z,Prepare_Done
	ld b,a
Prepare_ROM_Loop:
	ld a,(hl)
	ld d,8
	rra
	jr nc,Prepare_ROM
	ld d,14
	cp 1
	jr z,Prepare_ROM
	ld d,13
Prepare_ROM:
	ld a,c
	add a,d
	ld c,a
	inc hl
	djnz Prepare_ROM_Loop
Prepare_Done:
	;Run it!
	in a,(6)
	sub c
	ld (basepage),a
	ld a,(hl)
	ld (calculatorModel),a		;0 - 82, 1 - 83, 2 - 85, 3 - 86
	B_CALL ClrLCDFull
	ld hl,0
	ld (currow),hl
	ld hl,Emulation_Starting
	call putstr
	di
	ld a,(calculatorModel)
	cp 2
	jr nc,Prepare_3
	ld a,84h
	out (7),a
	ld hl,8000h
	call SaveDisplay
	ld a,81h
	out (7),a
Prepare_3:
	call Initialize_Emulator
	ld (originalstack),sp
	jp Emulation_Resume
Main_Menu_Up:
	ld a,(menucur)
	or a
	jp z,Main_Menu_Loop
	dec a
	ld (menucur),a
	ld a,' '
	B_CALL PutMap
	ld hl,currow
	dec (hl)
	ld a,5
	B_CALL PutMap
	jp Main_Menu_Loop
Main_Menu_Down:
	ld a,(menucount)
	ld b,a
	ld a,(menucur)
	inc a
	cp b
	jp z,Main_Menu_Loop
	ld (menucur),a
	ld a,' '
	B_CALL PutMap
	ld hl,currow
	inc (hl)
	ld a,5
	B_CALL PutMap
	jp Main_Menu_Loop
Main_82:
	DB "  TI-82",0
Main_83:
	DB "  TI-83",0
Main_85:
	DB "  TI-85",0
Main_86:
	DB "  TI-86",0
Main_1:
	DB "Select a ROM:",0
Emulation_Halted:
	B_CALL ClrLCDFull
	B_CALL HomeUp
	ld hl,Emulator_Options
	set textInverse,(iy+textFlags)
	call putstr
	res textInverse,(iy+textFlags)
	call putstr
	push hl
	ld a,(interruptspeed)
	ld l,a
	ld h,0
	B_CALL DispHL
	B_CALL NewLine
	pop hl
	call putstr
	B_CALL GetCSC		;absorb ALPHA key
Emulation_Halted_Loop:
	B_CALL GetKey
	cp kQuit
	jp z,Main_Screen
	cp kClear
	jp z,Emulation_Resume
	cp kUp
	jr z,Emulation_Halted_Up
	cp kDown
	jr z,Emulation_Halted_Down
	cp kStore
	jp z,Emulation_Store
	cp kRecall
	jp z,Emulation_Recall
	jr Emulation_Halted_Loop
Emulation_Halted_Up:
	ld a,(interruptspeed)
	dec a
	cp 2
	jr c,Emulation_Halted_Loop
Emulation_Halted_Point:
	ld (interruptspeed),a
	call Emulation_Halted_Speed
	jr Emulation_Halted_Loop
Emulation_Halted_Down:
	ld a,(interruptspeed)
	inc a
	jr z,Emulation_Halted_Loop
	jr Emulation_Halted_Point
Emulation_Halted_Speed:
	ld hl,6*256+5
	ld (currow),hl
	ld l,a
	ld h,0
	B_CALL DispHL
	ret
Emulator_Options:
	DB "**   Emu8x    **",0
	DB "2nd+Quit - Exit "
	DB "CLEAR - Resume  "
	DB "STO - Save      "
	DB "Rcl - Load      "
	DB "Speed:",0
	DB "Up/Down - Adjust"
	DB "speed",0
 INCLUDE "states.asm"

