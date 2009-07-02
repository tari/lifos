Opcode_ED:
	inc ix
	inc iy
	pop hl	;junk...remove return address
	pop af
	ld sp,speedstack
	out (7),a
	ld l,(iy-1)
	ld a,81h
	out (7),a
	ld h,46h >> 1
	sla l
	rl h
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
ED_78:
	;in a,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a		;temporary port storage
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	ret
ED_40:
	;in b,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	exx
	ld b,a
	exx
	ret
ED_48:
	;in c,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	exx
	ld c,a
	exx
	ret
ED_50:
	;in d,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	exx
	ld d,a
	exx
	ret
ED_58:
	;in e,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	exx
	ld e,a
	exx
	ret
ED_60:
	;in h,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	exx
	ld h,a
	exx
	ret
ED_68:
	;in l,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in a,(c)
	ex af,af'
	exx
	ld l,a
	exx
	ret
ED_70:
	;in f,(c)
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	out (35h),a
	ld c,35h
	ex af,af'
	in f,(c)
	ex af,af'
	ret
ED_AB:
	;outd
	exx
	push hl
	ld a,c
	exx
	ld d,a
	pop hl
	call Fetch_Byte_HL
	call Port_Output
	exx
	dec hl
	ex af,af'
	dec b
	ex af,af'
	exx
	ret
ED_A3:
	;outi
	exx
	push hl
	ld a,c
	exx
	ld d,a
	pop hl
	call Fetch_Byte_HL
	call Port_Output
	exx
	inc hl
	ex af,af'
	dec b
	ex af,af'
	exx
	ret
ED_BB:
	;otdr
	call ED_AB
	ex af,af'
	jr z,ED_BB_Done
	ex af,af'
	jr ED_BB
ED_BB_Done:
	ex af,af'
	ret
ED_B3:
	;otir
	call ED_A3
	ex af,af'
	jr z,ED_B3_Done
	ex af,af'
	jr ED_B3
ED_B3_Done:
	ex af,af'
	ret
ED_49:
	call Debug
	;out (c),c
	exx
	ld a,c
	exx
	ld e,a
	exx
	ld a,c
	exx
	ld d,a
	jp Port_Output
ED_51:
	call Debug
	;out (c),d
	exx
	ld a,c
	exx
	ld e,a
	exx
	ld a,d
	exx
	ld d,a
	jp Port_Output
ED_59:
	call Debug
	;out (c),b
	exx
	ld a,c
	exx
	ld e,a
	exx
	ld a,e
	exx
	ld d,a
	jp Port_Output
ED_71:
	call Debug
	;out (c),f
	exx
	ld a,c
	exx
	ld e,a
	ld d,0
	jp Port_Output
ED_61:
	call Debug
	;out (c),h
	exx
	ld a,c
	exx
	ld e,a
	exx
	ld a,h
	exx
	ld d,a
	jp Port_Output
ED_69:
	call Debug
	;out (c),b
	exx
	ld a,c
	exx
	ld e,a
	exx
	ld a,l
	exx
	ld d,a
	jp Port_Output
ED_41:
	call Debug
	;out (c),b
	exx
	ld a,c
	exx
	ld e,a
	exx
	ld a,b
	exx
	ld d,a
	jp Port_Output
ED_79:
	call Debug
	;out (c),a
	;E is the port
	;D is the value
	exx
	ld a,c
	exx
	ld e,a
	ex af,af'
	ld d,a
	ex af,af'
	jp Port_Output
ED_BA:
	call Debug
	;indr
	call ED_AA
	ex af,af'
	jr z,ED_BA_Done
	ex af,af'
	jr ED_BA
ED_BA_Done:
	ex af,af'
	ret
ED_AA:
	call Debug
	;ind
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	ld c,a
	exx
	push hl
	exx
	pop hl
	call Write_Byte
	exx
	ex af,af'
	dec hl
	dec b
	ex af,af'
	exx
	ret
ED_B2:
	call Debug
	;inir
	call ED_A2
	ex af,af'
	jr z,ED_B2_Done
	ex af,af'
	jr ED_B2
ED_B2_Done:
	ex af,af'
	ret
ED_A2:
	call Debug
	;ini
	exx
	ld a,c
	exx
	ld e,a
	call Port_Input
	ld c,a
	exx
	push hl
	exx
	pop hl
	call Write_Byte
	exx
	ex af,af'
	inc hl
	dec b
	ex af,af'
	exx
	ret
ED_67:
	;rrd
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	rrd
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
ED_6F:
	;rld
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	rld
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
ED_42:
	;sbc hl,bc
	exx
	ex af,af'
	sbc hl,bc
	ex af,af'
	exx
	ret
ED_52:
	;sbc hl,de
	exx
	ex af,af'
	sbc hl,de
	ex af,af'
	exx
	ret
ED_62:
	;sbc hl,hl
	exx
	ex af,af'
	sbc hl,hl
	ex af,af'
	exx
	ret
ED_72:
	;sbc hl,sp
	exx
	push hl
	exx
	pop hl
	ld de,(registerSP)
	ex af,af'
	sbc hl,de
	ex af,af'
	push hl
	exx
	pop hl
	exx
	ret
ED_4A:
	;adc hl,bc
	exx
	ex af,af'
	adc hl,bc
	ex af,af'
	exx
	ret
ED_5A:
	;adc hl,de
	exx
	ex af,af'
	adc hl,de
	ex af,af'
	exx
	ret
ED_6A:
	;adc hl,hl
	exx
	ex af,af'
	adc hl,hl
	ex af,af'
	exx
	ret
ED_7A:
	;adc hl,sp
	exx
	push hl
	exx
	pop hl
	ld de,(registerSP)
	ex af,af'
	adc hl,de
	ex af,af'
	push hl
	exx
	pop hl
	exx
	ret
ED_46:
	;im 0
	xor a
	ld (interruptMode),a
	ret
ED_56:
	;im 1
	ld a,1
	ld (interruptMode),a
	ret
ED_5E:
	;im 2
	ld a,2
	ld (interruptMode),a
	ret
ED_44:
	;neg
	ex af,af'
	neg
	ex af,af'
	ret
ED_B9:
	;cpdr
	call ED_A9
	ex af,af'
	push af
	ex af,af'
	pop af
	ret z
	ret po
	jr ED_B9
ED_B1:
	;cpir
	call ED_A1
	ex af,af'
	push af
	ex af,af'
	pop af
	ret z
	ret po
	jr ED_B1
ED_A9:
	;cpd
	exx
	push bc
	push hl
	dec hl
	dec bc
	exx
	pop hl
	call Fetch_Byte_HL
	ld hl,ramCode
	ld (hl),e
	ex af,af'
	pop bc
	cpd
	ex af,af'
	ret
ED_A1:
	;cpi
	exx
	push bc
	push hl
	inc hl
	dec bc
	exx
	pop hl
	call Fetch_Byte_HL
	ld hl,ramCode
	ld (hl),e
	ex af,af'
	pop bc
	cpi
	ex af,af'
	ret
ED_B8:
	;lddr
	exx
	bit 7,h
	jr z,LDDR_Flash
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	lddr
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
LDDR_Flash:
	exx
LDDR_Flash_Loop:
	call ED_A8
	ex af,af'
	push af
	ex af,af'
	pop af
	ret po
	jr LDDR_Flash_Loop
ED_B0:
	;ldir
	exx
	bit 7,h
	jr z,LDIR_Flash
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	ldir
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
LDIR_Flash:
	exx
LDIR_Flash_Loop:
	call ED_A0
	ex af,af'
	push af
	ex af,af'
	pop af
	ret po
	jr LDIR_Flash_Loop
ED_A8:
	;ldd
	exx
	push bc
	push de
	push hl
	dec hl
	dec de
	dec bc
	exx
	pop hl
	call Fetch_Byte_HL
	ld c,e
	pop hl
	call Write_Byte
	ex af,af'
	ld hl,ramCode
	ld d,h
	ld e,l
	pop bc
	ldi
	ex af,af'
	ret
ED_A0:
	;ldi
	exx
	push bc
	push de
	push hl
	inc hl
	inc de
	dec bc
	exx
	pop hl
	call Fetch_Byte_HL
	ld c,e
	pop hl
	call Write_Byte
	ex af,af'
	ld hl,ramCode
	ld d,h
	ld e,l
	pop bc
	ldi
	ex af,af'
	ret
ED_73:
	;ld (nnnn),sp
	call Fetch_Word_PC
	ld a,(registerSP)
	ld c,a
	call Write_Byte
	inc hl
	ld a,(registerSP+1)
	ld c,a
	jp Write_Byte
ED_53:
	;ld (nnnn),de
	call Fetch_Word_PC
	exx
	ld a,e
	exx
	ld c,a
	call Write_Byte
	inc hl
	exx
	ld a,d
	exx
	ld c,a
	jp Write_Byte
ED_43:
	;ld (nnnn),bc
	call Fetch_Word_PC
	exx
	ld a,c
	exx
	ld c,a
	call Write_Byte
	inc hl
	exx
	ld a,b
	exx
	ld c,a
	jp Write_Byte
ED_7B:
	;ld sp,(nnnn)
	call Fetch_Word_PC
	call Fetch_Byte_HL
	ld a,e
	ld (registerSP),a
	inc hl
	call Fetch_Byte_HL
	ld a,e
	ld (registerSP+1),a
	ret
ED_5B:
	;ld de,(nnnn)
	call Fetch_Word_PC
	call Fetch_Byte_HL
	ld a,e
	exx
	ld e,a
	exx
	inc hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld d,a
	exx
	ret
ED_4B:
	;ld bc,(nnnn)
	call Fetch_Word_PC
	call Fetch_Byte_HL
	ld a,e
	exx
	ld c,a
	exx
	inc hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld b,a
	exx
	ret
ED_47:
	;ld i,a
	ex af,af'
	ld (registerI),a
	ex af,af'
	ret
ED_5F:
	;ld a,r
	ld hl,emulatorflags
	bit interruptsEnabled,(hl)
	jr nz,ED_5F_EI
	ex af,af'
	ld a,r
	ex af,af'
	ret
ED_5F_EI:
	ex af,af'
	ld a,r
	push af
	pop bc
	set 2,c
	push bc
	pop af
	ex af,af'
	ret
ED_57:
	;ld a,i
	ex af,af'
	ld a,(registerI)
	ld i,a
	ld a,i
	ex af,af'
	ret
ED_0:
	
ED_1:
	
ED_2:
	
ED_3:
	
ED_4:
	
ED_5:
	
ED_6:
	
ED_7:
	
ED_8:
	
ED_9:
	
ED_A:
	
ED_B:
	
ED_C:
	
ED_D:
	
ED_E:
	
ED_F:
	
ED_10:
	
ED_11:
	
ED_12:
	
ED_13:
	
ED_14:
	
ED_15:
	
ED_16:
	
ED_17:
	
ED_18:
	
ED_19:
	
ED_1A:
	
ED_1B:
	
ED_1C:
	
ED_1D:
	
ED_1E:
	
ED_1F:
	
ED_20:
	
ED_21:
	
ED_22:
	
ED_23:
	
ED_24:
	
ED_25:
	
ED_26:
	
ED_27:
	
ED_28:
	
ED_29:
	
ED_2A:
	
ED_2B:
	
ED_2C:
	
ED_2D:
	
ED_2E:
	
ED_2F:
	
ED_30:
	
ED_31:
	
ED_32:
	
ED_33:
	
ED_34:
	
ED_35:
	
ED_36:
	
ED_37:
	
ED_38:
	
ED_39:
	
ED_3A:
	
ED_3B:
	
ED_3C:
	
ED_3D:
	
ED_3E:
	
ED_3F:
ED_4C:
ED_4E:
	
ED_54:
	
ED_55:
	
ED_5C:
	
ED_5D:
	
ED_63:
	
ED_64:
	
ED_65:
	
ED_66:
	
ED_6B:
	
ED_6C:
	
ED_6D:
	
ED_6E:
	
ED_74:
	
ED_75:
	
ED_76:
	
ED_77:
	
ED_7C:
	
ED_7D:
	
ED_7E:
	
ED_7F:
	
ED_80:
	
ED_81:
	
ED_82:
	
ED_83:
	
ED_84:
	
ED_85:
	
ED_86:
	
ED_87:
	
ED_88:
	
ED_89:
	
ED_8A:
	
ED_8B:
	
ED_8C:
	
ED_8D:
	
ED_8E:
	
ED_8F:
	
ED_90:
	
ED_91:
	
ED_92:
	
ED_93:
	
ED_94:
	
ED_95:
	
ED_96:
	
ED_97:
	
ED_98:
	
ED_99:
	
ED_9A:
	
ED_9B:
	
ED_9C:
	
ED_9D:
	
ED_9E:
	
ED_9F:
	
ED_A4:
	
ED_A5:
	
ED_A6:
	
ED_A7:
	
ED_AC:
	
ED_AD:
	
ED_AE:
	
ED_AF:
	
ED_B4:
	
ED_B5:
	
ED_B6:
	
ED_B7:
	
ED_BC:
	
ED_BD:
	
ED_BE:
	
ED_BF:
	
ED_C0:
	
ED_C1:
	
ED_C2:
	
ED_C3:
	
ED_C4:
	
ED_C5:
	
ED_C6:
	
ED_C7:
	
ED_C8:
	
ED_C9:
	
ED_CA:
	
ED_CB:
	
ED_CC:
	
ED_CD:
	
ED_CE:
	
ED_CF:
	
ED_D0:
	
ED_D1:
	
ED_D2:
	
ED_D3:
	
ED_D4:
	
ED_D5:
	
ED_D6:
	
ED_D7:
	
ED_D8:
	
ED_D9:
	
ED_DA:
	
ED_DB:
	
ED_DC:
	
ED_DD:
	
ED_DE:
	
ED_DF:
	
ED_E0:
	
ED_E1:
	
ED_E2:
	
ED_E3:
	
ED_E4:
	
ED_E5:
	
ED_E6:
	
ED_E7:
	
ED_E8:
	
ED_E9:
	
ED_EA:
	
ED_EB:
	
ED_EC:
	
ED_ED:
	
ED_EE:
	
ED_EF:
	
ED_F0:
	
ED_F1:
	
ED_F2:
	
ED_F3:
	
ED_F4:
	
ED_F5:
	
ED_F6:
	
ED_F7:
	
ED_F8:
	
ED_F9:
	
ED_FA:
	
ED_FB:
	
ED_FC:
	
ED_FD:
	call Debug
ED_FE:
	;Used to display B lines of the LCD
	ld hl,emulatorflags
	res interruptsEnabled,(hl)
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	ld a,(calculatorModel)
	dec a
	jr z,ED_FE_83
	exx
	ex af,af'
	ld a,7
	out (10h),a
	call lcddelay
	ld a,07Fh
ED_FE_Outer_Loop:
	push bc
	inc a
	ld (8011h),a
	push af
	ld a,7
	call lcddelay
	out (10h),a
	pop af
	call lcddelay
	out (10h),a
	ld a,20h
	call lcddelay
	out (10h),a
	ld b,0Ch
ED_FE_Inner_Loop:
	ld a,(hl)
	inc hl
	call lcddelay
	out (11h),a
	djnz ED_FE_Inner_Loop
	pop bc
	ld a,(8011h)
	djnz ED_FE_Outer_Loop
	ld a,5
	call lcddelay
	out (10h),a
	ex af,af'
	exx
	pop ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	jp Optimize_PC
ED_FE_83:
	exx
	ex af,af'
	ld a,7
	out (10h),a
	call lcddelay
	ld a,07Fh
ED_FE_83_Outer_Loop:
	push bc
	inc a
	ld (8012h),a
	push af
	ld a,7
	call lcddelay
	out (10h),a
	pop af
	call lcddelay
	out (10h),a
	ld a,20h
	call lcddelay
	out (10h),a
	ld b,0Ch
	push hl
	ld hl,8567h+14h
	bit 1,(hl)
	pop hl
	jr z,ED_FE_83_Inner_Loop
	ld b,5
ED_FE_83_Inner_Loop:
	ld a,(hl)
	inc hl
	call lcddelay
	out (11h),a
	djnz ED_FE_83_Inner_Loop
	push hl
	ld hl,8567h+14h
	bit 1,(hl)
	pop hl
	jr z,ED_FE_83_1
	ld a,(hl)
	or 1
	call lcddelay
	out (11h),a
	ld bc,7
	add hl,bc
ED_FE_83_1:
	pop bc
	ld a,(8012h)
	djnz ED_FE_83_Outer_Loop
	ld a,5
	call lcddelay
	out (10h),a
	ex af,af'
	exx
	pop ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	jp Optimize_PC
ED_FF:
	;Used to skip an LCD delay
	inc ix
	inc iy
	ret
