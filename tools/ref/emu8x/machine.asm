Emulation_Pause:
	xor a
	out (5),a
	out (0),a		;clear link lines
	ld a,81h
	out (7),a
	ld (realPC),iy
	ld (registerPC),ix
	ld iy,flags
	ld sp,(originalstack)
	exx
	ex af,af'
	push af
	push bc
	push de
	push hl
	exx
	ex af,af'
	pop hl
	ld (registerHL),hl
	pop hl
	ld (registerDE),hl
	pop hl
	ld (registerBC),hl
	pop hl
	ld (registerAF),hl
	;Save LCD information
	call lcddelay
	in a,(10h)
	ld (lcdSave),a
	;Reset contrast
	ld a,(contrast)
	add a,18h
	or 0C0h
	call lcddelay
	out (10h),a
	ld a,(calculatorModel)
	cp 2
	jr nc,Emulation_Pause_1
	ld a,84h
	out (7),a
	ld hl,8000h
	call SaveDisplay
	ld a,81h
	out (7),a
Emulation_Pause_1:
	ei
	jp Emulation_Halted
Emulation_Resume:
	ld a,1
	out (20h),a
	di
	ld a,(calculatorModel)
	cp 2
	jr nc,Emulation_Resume_1
	ld a,84h
	out (7),a
	ld hl,8000h
	call CopyLayer
	ld a,81h
	out (7),a
	ld a,(lcdSave)
	rlca
	rlca
	and 1
	out (10h),a		;set 8/6 bit
	call lcddelay
	ld a,(lcdSave)
	and 3
	or 4
	out (10h),a		;set counters
Emulation_Resume_1:
	ld iy,(realPC)
	ld ix,(registerPC)
	ld hl,(registerAF)
	push hl
	ld hl,(registerBC)
	push hl
	ld hl,(registerDE)
	push hl
	ld hl,(registerHL)
	push hl
	exx
	pop hl
	pop de
	pop bc
	ex af,af'
	pop af
	ex af,af'
	exx
	ld sp,speedstack
	ld a,3
	out (5),a
	ld a,41h
	out (30h),a
	ld a,1
	out (31h),a
	ld a,0FFh
	out (32h),a
	call Optimize_PC
	jp MainEmulation
 INCLUDE "interrupts.asm"
;Initialize the machine
Initialize_Emulator:
	di
	ld hl,emulatorflags
	ld (hl),0
	xor a
	ld (registerI),a
	ld (interruptMode),a
	ld a,(basepage)
	ld (currompage),a
	ld a,(calculatorModel)
	or a
	call z,Set_PC_82
	cp 1
	call z,Set_PC_83
	cp 2
	call z,Set_PC_85
	cp 3
	call z,Set_PC_86
	rrca
	rrca
	ld (calculatorPortOffset),a
	ld (realPC),iy
	ld (registerPC),ix
	ld hl,0
	ld (registerSP),hl
	ld (registerAF),hl
	ld (registerBC),hl
	ld (registerDE),hl
	ld (registerHL),hl
	ld (registerIX),hl
	ld (registerIY),hl
	ld a,82h
	ld (currentRAMPage),a
	;RAM
	out (7),a
	ld a,3
	out (5),a
	ld a,82h
	out (7),a
	ld hl,8000h
	ld bc,8000h-1
	ld de,8001h
	ld (hl),0
	ldir
	dec a
	out (7),a
	xor a
	out (5),a
	;Set up pretend interrupts
	ld a,41h
	out (30h),a
	ld a,1
	out (31h),a
	ld a,80
	out (32h),a
	ret
Find_Initialization_Point:
	;DE points to the bytes to find
	ld a,(basepage)
	out (7),a
	ld hl,8000h
	push de
	ld b,4
Find_Bytes_Loop:
	ld a,b
	cp 4
	jr z,Find_Bytes_Loop_1
	dec hl
	dec de
Find_Bytes_Loop_1:
	pop de
	push de
	ld b,4
Find_Bytes_Loop2:
	ld a,(de)
	cp (hl)
	inc hl
	inc de
	jr nz,Find_Bytes_Loop
	djnz Find_Bytes_Loop2
	pop de
	ld de,8004h
	or a
	sbc hl,de
	push hl
	pop ix
	ld a,81h
	out (7),a
	ret
Set_PC_82:
	;Set up 82 hardware
	ld a,0Ah
	ld (port3),a
	ld a,0FFh	;0FFh for port 4
	ld (port4),a
	ld a,0F8h
	ld (port2),a
	ld a,0C0h
	ld (port0),a
	ld a,15h
	ld (interruptspeed),a
	ld de,Init_82_Bytes
	call Find_Initialization_Point
	call Optimize_PC
	xor a
	ret
Init_82_Bytes:
	ld a,16h
	out (4),a
Set_PC_83:
	;Set up 83 hardware
	xor a
	ld (port2),a
	ld (rom83page),a
	dec a
	ld (port4),a
	ld a,0Ah
	ld (port3),a
	ld a,0C0h
	ld (port0),a
	ld a,15h
	ld (interruptspeed),a
	xor a
	ld (rom83page),a
	ld de,Init_82_Bytes
	call Find_Initialization_Point
	call Optimize_PC
	ld a,1
	ret
Set_PC_85:
	;Set up 85 hardware
	xor a
	ld (port6),a
	ld (lcd85offset),a
	ld a,0A0h
	ld (lcd85status),a
	ld a,07Ch
	ld (port0),a
	ld a,42
	ld (interruptspeed),a
	ld de,Init_82_Bytes
	call Find_Initialization_Point
	call Optimize_PC
	ld a,2
	ret
Set_PC_86:
	;Set up 86 hardware
	ld hl,interruptMode
	inc (hl)
	xor a
	ld (port5),a
	ld (lcd85offset),a
	ld a,0A0h
	ld (lcd85status),a
	ld a,41h
	ld (port6),a
	ld a,07Ch
	ld (port0),a
	ld a,42
	ld (interruptspeed),a
	ld a,84h
Set_PC_86_Loop:
	out (7),a
	ld hl,8000h
	ld de,8001h
	ld bc,4000h-1
	ld (hl),0
	ldir
	inc a
	cp 88h
	jr nz,Set_PC_86_Loop
	ld a,81h
	out (7),a
	;Set up ROM/RAM page table
	ld h,99h
	ld b,0
	ld l,b
TI86_RAM_Table_Loop:
	bit 6,b
	jr nz,TI86_RAM_Table_RAM
	ld a,b
	and 0Fh
	ld c,a
	ld a,(basepage)
	sub c
	ld (hl),a
	inc hl
	inc b
	jr nz,TI86_RAM_Table_Loop
TI86_RAM_Table_RAM:
	ld a,b
	and 7
	ld ix,TI86_RAM_Table
	ld d,0
	ld e,a
	add ix,de
	ld a,(ix)
	ld (hl),a
	inc hl
	inc b
	jr nz,TI86_RAM_Table_Loop
	ld de,TI86_Bytes
	call Find_Initialization_Point
	call Optimize_PC
	ld a,3
	ret
TI86_Bytes:
	ld a,56h
	out (4),a
TI86_RAM_Table:
	DB 83h,82h,00h,00h,84h,85h,86h,87h
Optimize_PC:
	;Set IY to the actual PC location
	push ix
	pop de
	bit 7,d
	jr nz,Optimize_PC_RAM
	bit 6,d
	jr z,Optimize_PC_0
	ld iy,4000h
	add iy,de
	ld a,(currompage)
	ld (speedpage+1),a
	ld a,40h
	ld (speedpage),a
	ret
Optimize_PC_0:
	ld iy,8000h
	add iy,de
	ld a,(basepage)
	ld (speedpage+1),a
	ld a,40h
	ld (speedpage),a
	ret
Optimize_PC_RAM:
	push de
	pop iy
	ld a,(currentRAMPage)
	ld l,0
	ld h,a
	ld (speedpage),hl
	ret
Opcode_DB:
	;in a,(nn)
	call Fetch_Byte_PC
	call Port_Input
	ld b,a
	ex af,af'
	ld a,b
	ex af,af'
	ret
Port_Input:
	ld a,e
	and 31
	add a,a
	ld hl,calculatorPortOffset
	add a,(hl)
	ld l,a
	ld h,4Dh
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
Read_85_Port4:
	ld a,1
	ret
Read_85_ROM:
	ld a,(port5)
	ret
Read_85_Port6:
	ld a,(port6)
	ret
Read_Interrupt:
	;ld a,(port4)
	ld a,0FFh	;hey, VTI does it too!
	ret
Read_Status:
	;3 if ON is down
	;1010b if it is not
	in a,(4)
	and 8
	jr nz,Read_Status_OK
	ld a,3
	ret
Read_Status_OK:
	ld a,00001010b
	ret
Read_ROM:
	ld a,(port2)
	ret
Read_Link:
	in a,(0)
	ld b,a
	srl b
	srl b
	and 00000011b
	or b
	ret
Read_Keyboard:
	in a,(1)
	ret
Read_LCD_Data:
	in a,(11h)
	ret
Read_LCD_Command:
	in a,(10h)
	ret
Opcode_D3:
	;out (nn),a
	call Fetch_Byte_PC
	ex af,af'
	ld d,a
	ex af,af'
Port_Output:
	ld a,e
	and 31
	add a,a
	ld hl,calculatorPortOffset
	add a,(hl)
	ld l,a
	ld h,4Ch
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
Write_86_ROM:
	ld a,d
	ld (port5),a
	ld h,99h
	ld l,a
	ld a,(hl)
	ld (currompage),a
	ret
Write_86_RAM:
	ld a,d
	ld (port6),a
	ld h,99h
	ld l,a
	ld a,(hl)
	ld (currentRAMPage),a
	ret
Write_85_ROM:
	ld a,d
	ld (port5),a
	and 7
	ld b,a
	ld a,(basepage)
	sub b
	ld (currompage),a
	ret
Write_85_Interrupt:
	ld a,d
	ld (port6),a
	ret
Write_85_LCD:
	ld a,d
	ld (port0),a
	ret
Write_85_Contrast:
	ld a,d
	and 31
	ld b,0E0h
	add a,b
	cp 0C0h
	ret c
	out (10h),a
	ret
Write_Status:
	ld a,d
	ld (port3),a
	ld hl,emulatorflags
	set onEnabled,(hl)
	rra
	jr c,Write_Status_1
	res onEnabled,(hl)
Write_Status_1:
	set timerEnabled,(hl)
	rra
	ret c
	res timerEnabled,(hl)
	ret
Write_ROM:
	ld a,d
	ld (port2),a
	and 7
	ld b,a
	ld a,(basepage)
	sub b
	ld (currompage),a
	ret
Write_Link:
	ld a,d
	and 00001100b
	srl a
	srl a
	out (0),a
	ret
Write_Keyboard:
	ld a,d
	out (1),a
	ret
Write_LCD_Data:
	ld a,d
	out (11h),a
	ret
Write_LCD_Command:
	ld a,d
	sub 8
	cp 20h-8
	ret c
	add a,8
	out (10h),a
Dummy_Port:
	ret
Write_83_ROM:
	ld a,d
	ld (port2),a
	and 7
	ld d,a
	ld a,(rom83page)
	and 8
	or d
	ld (rom83page),a
	ld b,a
	ld a,(basepage)
	sub b
	ld (currompage),a
	ret
Write_83_Link:
	ld a,d
	ld (port0),a
	and 00000011b
	out (0),a
	ld a,d
	and 16
	srl a
	ld b,a
	ld a,(rom83page)
	and 7
	or b
	ld (rom83page),a
	ld b,a
	ld a,(basepage)
	sub b
	ld (currompage),a
	ret
Read_83_Link:
	in a,(0)
	and 00000011b
	add a,a
	add a,a
	ld b,a
	ld a,(port0)
	and 3
	or b
	ld b,a
	ld a,(rom83page)
	and 8
	add a,a
	or b
	ret
