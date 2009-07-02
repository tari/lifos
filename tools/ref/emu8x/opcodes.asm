Debug:
	nop
	ret
	nop
MainEmulation:
	ld sp,speedpage
	ld hl,MainEmulation_Loop
	ld (speedstack),hl
MainEmulation_Loop:
	;Check for interrupt
	in a,(32h)
	dec a
 ifndef DEBUG
	jp z,Interrupt_Generated
 endif
 ifdef DEBUG
 	ld hl,(8700h)
	ld de,1
	add hl,de
	ld (8700h),hl
	ld hl,(8702h)
	ld de,0
	adc hl,de
	ld (8702h),hl
	ld a,(8702h)
	cp 4
	jr nz,DEBUG_2
	ld hl,(8700h)
	ld de,851
	or a
	sbc hl,de
	jr nz,DEBUG_2
	nop
DEBUG_2:
 	ld hl,(8710h)
	dec hl
	ld (8710h),hl
	ld a,h
	or l
	jr nz,DEBUG_1
	ld hl,1250
	ld (8710h),hl
	jp Interrupt_Generated
DEBUG_1:
 endif
	inc ix
	inc iy
	pop af
	ld sp,speedstack
	out (7),a
	ld l,(iy-1)
	ld a,81h
	out (7),a
	ld h,42h >> 1
	sla l
	rl h
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
Fetch_Byte_PC:
	inc ix
	inc iy
	ld a,(speedpage+1)
	out (7),a
	ld e,(iy-1)
	ld a,81h
	out (7),a
	ret
Fetch_Word_PC:
	inc ix
	inc ix
	inc iy
	inc iy
	ld a,(speedpage+1)
	out (7),a
	ld l,(iy-2)
	ld h,(iy-1)
	ld a,81h
	out (7),a
	ret
Fetch_Byte_HL:
	push hl
	bit 7,h
	jr nz,Fetch_Byte_RAM
	;From flash
	bit 6,h
	jr z,Fetch_Byte_Page0
	;From arbitrary flash page
	ld a,(currompage)
	set 7,h
	res 6,h
	out (7),a
	ld e,(hl)
	ld a,81h
	out (7),a
	pop hl
	ret
Fetch_Byte_Page0:
	ld a,(basepage)
	set 7,h
	out (7),a
	ld e,(hl)
	ld a,81h
	out (7),a
	pop hl
	ret
Fetch_Byte_RAM:
	ld a,(currentRAMPage)
	out (7),a
	;RAM pages set up
	ld e,(hl)
	ld a,81h
	out (7),a
	pop hl
	ret
Write_Byte:
	;This will write byte C to HL
Write_Byte_RAM:
	ld a,(currentRAMPage)
	out (7),a
	;RAM pages set up
	ld (hl),c
	ld a,81h
	out (7),a
	ret
Opcode_F3:
	;di
	ld hl,emulatorflags
	res interruptsEnabled,(hl)
	ret
Opcode_FB:
	;ei
	ld hl,emulatorflags
	set interruptsEnabled,(hl)
	ret
Opcode_76:
	;halt
	dec ix
	dec iy
	ld hl,emulatorflags
	set haltActive,(hl)
	ret
Opcode_3F:
	;ccf
	ex af,af'
	ccf
	ex af,af'
	ret
Opcode_37:
	;scf
	ex af,af'
	scf
	ex af,af'
	ret
Opcode_27:
	;daa
	ex af,af'
	daa
	ex af,af'
	ret
Opcode_2F:
	;cpl
	ex af,af'
	cpl
	ex af,af'
	ret
Opcode_E1:
	;pop hl
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	exx
	pop hl
	exx
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_D1:
	;pop de
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	exx
	pop de
	exx
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_C1:
	;pop bc
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	exx
	pop bc
	exx
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_F1:
	;pop af
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	pop af
	ex af,af'
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_E5:
	;push hl
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	exx
	push hl
	exx
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_D5:
	;push de
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	exx
	push de
	exx
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_C5:
	;push bc
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	exx
	push bc
	exx
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_F5:
	;push af
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	push af
	ex af,af'
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
Opcode_F9:
	;ld sp,hl
	exx
	ld (registerSP),hl
	exx
	ret
Opcode_78:
	;ld a,b
	ex af,af'
	exx
	ld a,b
	exx
	ex af,af'
	ret
Opcode_79:
	;ld a,c
	ex af,af'
	exx
	ld a,c
	exx
	ex af,af'
	ret
Opcode_7A:
	;ld a,d
	ex af,af'
	exx
	ld a,d
	exx
	ex af,af'
	ret
Opcode_7B:
	;ld a,e
	ex af,af'
	exx
	ld a,e
	exx
	ex af,af'
	ret
Opcode_7C:
	;ld a,h
	ex af,af'
	exx
	ld a,h
	exx
	ex af,af'
	ret
Opcode_7D:
	;ld a,l
	ex af,af'
	exx
	ld a,l
	exx
	ex af,af'
	ret
Opcode_7E:
	;ld a,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	ld a,e
	ex af,af'
	ret
Opcode_0A:
	;ld a,(bc)
	exx
	push bc
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	ld a,e
	ex af,af'
	ret
Opcode_1A:
	;ld a,(de)
	exx
	push de
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	ld a,e
	ex af,af'
	ret
Opcode_47:
	;ld b,a
	ex af,af'
	exx
	ld b,a
	exx
	ex af,af'
	ret
Opcode_41:
	;ld b,c
	exx
	ld b,c
	exx
	ret
Opcode_42:
	;ld b,d
	exx
	ld b,d
	exx
	ret
Opcode_43:
	;ld b,e
	exx
	ld b,e
	exx
	ret
Opcode_44:
	;ld b,h
	exx
	ld b,h
	exx
	ret
Opcode_45:
	;ld b,l
	exx
	ld b,l
	exx
	ret
Opcode_46:
	;ld b,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld b,a
	exx
	ret
Opcode_4F:
	;ld c,a
	exx
	ex af,af'
	ld c,a
	ex af,af'
	exx
	ret
Opcode_48:
	;ld c,b
	exx
	ld c,b
	exx
	ret
Opcode_4A:
	;ld c,d
	exx
	ld c,d
	exx
	ret
Opcode_4B:
	;ld c,e
	exx
	ld c,e
	exx
	ret
Opcode_4C:
	;ld c,h
	exx
	ld c,h
	exx
	ret
Opcode_4D:
	;ld c,l
	exx
	ld c,l
	exx
	ret
Opcode_4E:
	;ld c,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld c,a
	exx
	ret
Opcode_57:
	;ld d,a
	exx
	ex af,af'
	ld d,a
	ex af,af'
	exx
	ret
Opcode_50:
	;ld d,b
	exx
	ld d,b
	exx
	ret
Opcode_51:
	;ld d,c
	exx
	ld d,c
	exx
	ret
Opcode_53:
	;ld d,e
	exx
	ld d,e
	exx
	ret
Opcode_54:
	;ld d,h
	exx
	ld d,h
	exx
	ret
Opcode_55:
	;ld d,l
	exx
	ld d,l
	exx
	ret
Opcode_56:
	;ld d,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld d,a
	exx
	ret
Opcode_5F:
	;ld e,a
	exx
	ex af,af'
	ld e,a
	ex af,af'
	exx
	ret
Opcode_58:
	;ld e,b
	exx
	ld e,b
	exx
	ret
Opcode_59:
	;ld e,c
	exx
	ld e,c
	exx
	ret
Opcode_5A:
	;ld e,d
	exx
	ld e,d
	exx
	ret
Opcode_5C:
	;ld e,h
	exx
	ld e,h
	exx
	ret
Opcode_5D:
	;ld e,l
	exx
	ld e,l
	exx
	ret
Opcode_5E:
	;ld e,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld e,a
	exx
	ret
Opcode_67:
	;ld h,a
	exx
	ex af,af'
	ld h,a
	ex af,af'
	exx
	ret
Opcode_60:
	;ld h,b
	exx
	ld h,b
	exx
	ret
Opcode_61:
	;ld h,c
	exx
	ld h,c
	exx
	ret
Opcode_62:
	;ld h,d
	exx
	ld h,d
	exx
	ret
Opcode_63:
	;ld h,e
	exx
	ld h,e
	exx
	ret
Opcode_65:
	;ld h,l
	exx
	ld h,l
	exx
	ret
Opcode_66:
	;ld h,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld h,a
	exx
	ret
Opcode_6F:
	;ld l,a
	exx
	ex af,af'
	ld l,a
	ex af,af'
	exx
	ret
Opcode_68:
	;ld l,b
	exx
	ld l,b
	exx
	ret
Opcode_69:
	;ld l,c
	exx
	ld l,c
	exx
	ret
Opcode_6A:
	;ld l,d
	exx
	ld l,d
	exx
	ret
Opcode_6B:
	;ld l,e
	exx
	ld l,e
	exx
	ret
Opcode_6C:
	;ld l,h
	exx
	ld l,h
	exx
	ret
Opcode_6E:
	;ld l,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld l,a
	exx
	ret
Opcode_02:
	;ld (bc),a
	exx
	push bc
	exx
	pop hl
	ex af,af'
	ld c,a
	ex af,af'
	jp Write_Byte
Opcode_12:
	;ld (de),a
	exx
	push de
	exx
	pop hl
	ex af,af'
	ld c,a
	ex af,af'
	jp Write_Byte
Opcode_77:
	;ld (hl),a
	exx
	push hl
	exx
	pop hl
	ex af,af'
	ld c,a
	ex af,af'
	jp Write_Byte
Opcode_70:
	;ld (hl),b
	exx
	push hl
	ld a,b
	exx
	pop hl
	ld c,a
	jp Write_Byte
Opcode_71:
	;ld (hl),c
	exx
	push hl
	ld a,c
	exx
	pop hl
	ld c,a
	jp Write_Byte
Opcode_72:
	;ld (hl),d
	exx
	push hl
	ld a,d
	exx
	pop hl
	ld c,a
	jp Write_Byte
Opcode_73:
	;ld (hl),e
	exx
	push hl
	ld a,e
	exx
	pop hl
	ld c,a
	jp Write_Byte
Opcode_74:
	;ld (hl),h
	exx
	push hl
	ld a,h
	exx
	pop hl
	ld c,a
	jp Write_Byte
Opcode_75:
	;ld (hl),l
	exx
	push hl
	ld a,l
	exx
	pop hl
	ld c,a
	jp Write_Byte
Opcode_36:
	;ld (hl),n
	call Fetch_Byte_PC
	exx
	push hl
	exx
	pop hl
	ld c,e
	jp Write_Byte
Opcode_49:
Opcode_40:
Opcode_52:
Opcode_7F:
Opcode_00:
Opcode_5B:
Opcode_64:
Opcode_6D:
ED_4F:
	;ld a,a
	;ld b,b
	;ld c,c
	;ld d,d
	;ld e,e
	;ld h,h
	;ld l,l
	;ld r,a
	;nop
	ret
 INCLUDE "loadnn.asm"
 INCLUDE "opcode_dd.asm"
 INCLUDE "opcode_fd.asm"
 INCLUDE "opcode_ed.asm"
 INCLUDE "opcode_block.asm"
 INCLUDE "opcode_add.asm"
 INCLUDE "opcode_sub.asm"
 INCLUDE "opcode_logical.asm"
 INCLUDE "opcode_rotate.asm"
 INCLUDE "opcode_exec.asm"
