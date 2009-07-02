;Interrupt check
Interrupt_Generated:
	ld a,41h
	out (30h),a
	ld a,1
	out (31h),a
	ld a,(interruptspeed)
	out (32h),a
	ld a,0FFh
	out (1),a
	nop
	ld a,0DFh
	out (1),a
	nop
	in a,(1)
	cp 7Fh
	jr nz,Interrupt_Generated_85NoOn
	ld a,0FFh
	out (1),a
	nop
	dec a		;0FEh
	out (1),a
	nop
	nop
	in a,(1)
	cp 0FDh
	jr z,TI85_LCD_Left
	cp 0FDh & 0FBh
	jp z,Emulation_Pause
	cp 0FBh
	jr nz,Interrupt_Generated_85NoOn
	;Scroll right
	ld a,(lcd85offset)
	inc a
	cp 5
	jr z,Interrupt_Generated_85NoOn
	ld (lcd85offset),a
  	jr Interrupt_Generated_85NoOn
TI85_LCD_Left:
	ld a,(lcd85offset)
	or a
	jr z,Interrupt_Generated_85NoOn
	dec a
	ld (lcd85offset),a
Interrupt_Generated_85NoOn:
	ld a,(calculatorModel)
	cp 2
	jp c,Interrupt_Generated_OK
	;Display LCD?
	ld sp,speedstack
	ld hl,lcd85status
	ld a,20h
	xor (hl)
	ld (hl),a
	ld d,a
	dec d
	add a,60h
	ld a,0C0h >> 2
	rla
	add a,a
	ld h,a
	ld a,(port0)
	and 3Fh
	add a,h
	ld h,a
	xor a
	out (20h),a
	ld a,0F7h
	out (29h),a
	ld a,7
	out (10h),a
	ld e,20h
	ld c,11h
	ld a,(lcd85offset)
	ld l,a
TI85_LCD_Copy:
	inc d
	ld a,d
	out (10h),a
	ld a,20h
	out (10h),a
	ld b,12
	otir
	inc hl
	inc hl
	inc hl
	inc hl
	dec e
	jr nz,TI85_LCD_Copy
	ld a,1
	out (20h),a
	ld a,17h
	out (29h),a
	pop hl		;junk to remove return address
Interrupt_Generated_OK:
	ld a,(emulatorflags)
	bit interruptsEnabled,a
	jp z,MainEmulation_Loop
	;Interrupts are enabled!
	bit onEnabled,a
	jp z,Interrupt_TimerCheck
	in a,(4)
	bit 3,a
	jr nz,Interrupt_TimerCheck
	ld a,3
	call lcddelay
	out (10h),a
	ld hl,port3
	res 3,(hl)
Interrupt_Trigger:
	ld hl,emulatorflags
	res interruptsEnabled,(hl)
	bit haltActive,(hl)
	jr z,Interrupt_Trigger_1
	res haltActive,(hl)
	inc ix
	inc iy
Interrupt_Trigger_1:
	ld a,(interruptMode)
	cp 2
	jr z,Interrupt_IM2
	;IM0 or IM1 - 38h
	ld hl,MainEmulation_Loop
	push hl
	jp Opcode_FF
Interrupt_IM2:
	ld a,(registerI)
	ld h,a
	ld l,0FFh
	call Fetch_Byte_HL
	ld c,e
	inc hl
	call Fetch_Byte_HL
	ld d,e
	ld e,c
	jp Opcode_Call_Interface
Interrupt_TimerCheck:
	ld hl,port3
	set 3,(hl)
	ld a,(emulatorflags)
	bit timerEnabled,a
	jp z,MainEmulation_Loop
	jr Interrupt_Trigger