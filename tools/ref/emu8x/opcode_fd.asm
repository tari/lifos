Opcode_FD:
	inc ix
	inc iy
	pop hl	;junk...remove return address
	pop af
	ld sp,speedstack
	out (7),a
	ld l,(iy-1)
	ld a,81h
	out (7),a
	ld h,4Ah >> 1
	sla l
	rl h
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
FD_E9:
	;jp (iy)
	ld ix,(registerIY)
	jp Optimize_PC
FD_CB:
	call FD_LoadRFromIY
	push hl
	call Fetch_Byte_PC
	ld d,0
	ld hl,Opcode_FD_CB_Table
	ld b,e
	ld a,e
	srl a
	srl a
	and 11111100b
	ld e,a
	ld a,b
	and 8
	srl a
	srl a
	add a,e
	ld e,a
	add hl,de
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
Opcode_FD_CB_Table:
	DW FD_CB_06
	DW FD_CB_0E
	DW FD_CB_16
	DW FD_CB_1E
	DW FD_CB_26
	DW FD_CB_2E
	DW FD_CB_36
	DW FD_CB_3E
	DW FD_CB_46
	DW FD_CB_4E
	DW FD_CB_56
	DW FD_CB_5E
	DW FD_CB_66
	DW FD_CB_6E
	DW FD_CB_76
	DW FD_CB_7E
	DW FD_CB_86
	DW FD_CB_8E
	DW FD_CB_96
	DW FD_CB_9E
	DW FD_CB_A6
	DW FD_CB_AE
	DW FD_CB_B6
	DW FD_CB_BE
	DW FD_CB_C6
	DW FD_CB_CE
	DW FD_CB_D6
	DW FD_CB_DE
	DW FD_CB_E6
	DW FD_CB_EE
	DW FD_CB_F6
	DW FD_CB_FE
FD_CB_BE:
	;res 7,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 7,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_B6:
	;res 6,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 6,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_AE:
	;res 5,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 5,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_A6:
	;res 4,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 4,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_9E:
	;res 3,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 3,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_96:
	;res 2,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 2,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_8E:
	;res 1,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 1,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_86:
	;res 0,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 0,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_FE:
	;set 7,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 7,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_F6:
	;set 6,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 6,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_EE:
	;set 5,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 5,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_E6:
	;set 4,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 4,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_DE:
	;set 3,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 3,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_D6:
	;set 2,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 2,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_CE:
	;set 1,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 1,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_C6:
	;set 0,(iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 0,(hl)
	ld a,81h
	out (7),a
	ret
FD_CB_7E:
	;bit 7,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 7,e
	ex af,af'
	ret
FD_CB_76:
	;bit 6,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 6,e
	ex af,af'
	ret
FD_CB_6E:
	;bit 5,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 5,e
	ex af,af'
	ret
FD_CB_66:
	;bit 4,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 4,e
	ex af,af'
	ret
FD_CB_5E:
	;bit 3,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 3,e
	ex af,af'
	ret
FD_CB_56:
	;bit 2,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 2,e
	ex af,af'
	ret
FD_CB_4E:
	;bit 1,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 1,e
	ex af,af'
	ret
FD_CB_46:
	;bit 0,(iy+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 0,e
	ex af,af'
	ret
FD_CB_3E:
	;srl (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	srl (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_36:
	;sll (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	sla (hl)
	set 0,(hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_2E:
	;sra (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	sra (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_26:
	;sla (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	sla (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_1E:
	;rr (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rr (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_0E:
	;rrc (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rrc (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_16:
	;rl (iy)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rl (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_CB_06:
	;rlc (iy+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rlc (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_2B:
	;dec iy
	ld hl,(registerIY)
	dec hl
	ld (registerIY),hl
	ret
FD_23:
	;inc iy
	ld hl,(registerIY)
	inc hl
	ld (registerIY),hl
	ret
FD_09:
	;add iy,bc
	ld hl,(registerIY)
	exx
	push bc
	exx
	pop bc
	ex af,af'
	add hl,bc
	ex af,af'
	ld (registerIY),hl
	ret
FD_19:
	;add iy,de
	ld hl,(registerIY)
	exx
	push de
	exx
	pop de
	ex af,af'
	add hl,de
	ex af,af'
	ld (registerIY),hl
	ret
FD_29:
	;add iy,iy
	ld hl,(registerIY)
	ex af,af'
	add hl,hl
	ex af,af'
	ld (registerIY),hl
	ret
FD_39:
	;add iy,sp
	ld hl,(registerIY)
	ld bc,(registerSP)
	ex af,af'
	add hl,bc
	ex af,af'
	ld (registerIY),hl
	ret
FD_35:
	;dec (iy+d)
	call Fetch_Byte_PC
	ld hl,(registerIY)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	dec (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_34:
	;inc (iy+d)
	call Fetch_Byte_PC
	ld hl,(registerIY)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	inc (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
FD_BE:
	;cp (iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	cp b
	ex af,af'
	ret
FD_AE:
	;xor (iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	xor b
	ex af,af'
	ret
FD_B6:
	;or (iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	or b
	ex af,af'
	ret
FD_A6:
	;and (iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	and b
	ex af,af'
	ret
FD_9E:
	;sbc a,(iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
  	sbc a,b
	ex af,af'
	ret
FD_96:
	;sub (iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	sub b
	ex af,af'
	ret
FD_8E:
	;adc a,(iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	adc a,b
	ex af,af'
	ret
FD_86:
	;add a,(iy+d)
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	add a,b
	ex af,af'
	ret
FD_E3:
	;ex (sp),iy
	ld sp,(registerSP)
	ld hl,(registerIY)
	ld a,(currentRAMPage)
	out (7),a
	ex (sp),hl
	ld a,81h
	out (7),a
	ld (registerIY),hl
	ld sp,speedstack
	ret
FD_E1:
	;pop iy
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	pop hl
	ld a,81h
	out (7),a
	ld (registerIY),hl
	ld (registerSP),sp
	ld sp,speedstack
	ret
FD_E5:
	;push iy
	ld sp,(registerSP)
	ld hl,(registerIY)
	ld a,(currentRAMPage)
	out (7),a
	push hl
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
FD_F9:
	;ld sp,iy
	ld hl,(registerIY)
	ld (registerSP),hl
	ret
FD_22:
	;ld (nnnn),iy
	call Fetch_Word_PC
	ld a,(registerIY)
	ld c,a
	call Write_Byte
	inc hl
	ld a,(registerIY+1)
	ld c,a
	jp Write_Byte
FD_2A:
	;ld iy,(nnnn)
	call Fetch_Word_PC
	call Fetch_Byte_HL
	ld a,e
	ld (registerIY),a
	inc hl
	call Fetch_Byte_HL
	ld a,e
	ld (registerIY+1),a
	ret
FD_21:
	;ld iy,nnnn
	call Fetch_Word_PC
	ld (registerIY),hl
	ret
FD_7E:
	call FD_LoadRFromIY
	ld b,a
	ex af,af'
	ld a,b
	ex af,af'
	ret
FD_4E:
	call FD_LoadRFromIY
	exx
	ld c,a
	exx
	ret
FD_46:
	call FD_LoadRFromIY
	exx
	ld b,a
	exx
	ret
FD_56:
	call FD_LoadRFromIY
	exx
	ld d,a
	exx
	ret
FD_5E:
	call FD_LoadRFromIY
	exx
	ld e,a
	exx
	ret
FD_66:
	call FD_LoadRFromIY
	exx
	ld h,a
	exx
	ret
FD_6E:
	call FD_LoadRFromIY
	exx
	ld l,a
	exx
	ret
FD_77:
	ex af,af'
	ld c,a
	ex af,af'
	jp FD_WriteToIY
FD_70:
	exx
	ld a,b
	exx
	ld c,a
	jp FD_WriteToIY
FD_71:
	exx
	ld a,c
	exx
	ld c,a
	jp FD_WriteToIY
FD_72:
	exx
	ld a,d
	exx
	ld c,a
	jp FD_WriteToIY
FD_73:
	exx
	ld a,e
	exx
	ld c,a
	jp FD_WriteToIY
FD_74:
	exx
	ld a,h
	exx
	ld c,a
	jp FD_WriteToIY
FD_75:
	exx
	ld a,l
	exx
	ld c,a
	jp FD_WriteToIY
FD_36:
	;ld (iy+n),nn
	call FD_FindIY
	push hl
	call Fetch_Byte_PC
	pop hl
	ld c,e
	jp Write_Byte
FD_LoadRFromIY:
	call Fetch_Byte_PC
	ld hl,(registerIY)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	call Fetch_Byte_HL
	ld a,e
	ret
FD_WriteToIY:
	call Fetch_Byte_PC
	ld hl,(registerIY)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	ld a,(currentRAMPage)
	out (7),a
	ld (hl),c
	ld a,81h
	out (7),a
	ret
FD_FindIY:
	call Fetch_Byte_PC
	ld hl,(registerIY)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	ret
FD_0:
	
FD_1:
	
FD_2:
	
FD_3:
	
FD_4:
	
FD_5:
	
FD_6:
	
FD_7:
	
FD_8:
	
FD_A:
	
FD_B:
	
FD_C:
	
FD_D:
	
FD_E:
	
FD_F:
	
FD_10:
	
FD_11:
	
FD_12:
	
FD_13:
	
FD_14:
	
FD_15:
	
FD_16:
	
FD_17:
	
FD_18:
	
FD_20:
	
FD_24:
	
FD_25:
	
FD_26:
	
FD_27:
	
FD_28:
	
FD_2C:
	
FD_2D:
	
FD_2E:
	
FD_2F:
	
FD_30:
	
FD_31:
	
FD_32:
	
FD_33:
	
FD_37:
	
FD_38:
	
FD_3A:
	
FD_3B:
	
FD_3C:
	
FD_3D:
	
FD_3E:
	
FD_3F:
	
FD_40:
	
FD_41:
	
FD_42:
	
FD_43:
	
FD_44:
	
FD_45:
	
FD_47:
	
FD_48:
	
FD_49:
	
FD_4A:
	
FD_4B:
	
FD_4C:
	
FD_4D:
	
FD_4F:
	
FD_50:
	
FD_51:
	
FD_52:
	
FD_53:
	
FD_54:
	
FD_55:
	
FD_57:
	
FD_58:
	
FD_59:
	
FD_5A:
	
FD_5B:
	
FD_5C:
	
FD_5D:
	
FD_5F:
	
FD_60:
	
FD_61:
	
FD_62:
	
FD_63:
	
FD_64:
	
FD_65:
	
FD_67:
	
FD_68:
	
FD_69:
	
FD_6A:
	
FD_6B:
	
FD_6C:
	
FD_6D:
	
FD_6F:
	
FD_78:
	
FD_79:
	
FD_7A:
	
FD_7B:
	
FD_7C:
	
FD_7D:
	
FD_7F:
	
FD_80:
	
FD_81:
	
FD_82:
	
FD_83:
	
FD_84:
	
FD_85:
	
FD_87:
	
FD_88:
	
FD_89:
	
FD_8A:
	
FD_8B:
	
FD_8C:
	
FD_8D:
	
FD_8F:
	
FD_90:
	
FD_91:
	
FD_92:
	
FD_93:
	
FD_94:
	
FD_95:
	
FD_97:
	
FD_98:
	
FD_99:
	
FD_9A:
	
FD_9B:
	
FD_9C:
	
FD_9D:
	
FD_9F:
	
FD_A0:
	
FD_A1:
	
FD_A2:
	
FD_A3:
	
FD_A4:
	
FD_A5:
	
FD_A7:
	
FD_A8:
	
FD_A9:
	
FD_AA:
	
FD_AB:
	
FD_AC:
	
FD_AD:
	
FD_AF:
	
FD_B0:
	
FD_B1:
	
FD_B2:
	
FD_B3:
	
FD_B4:
	
FD_B5:
	
FD_B7:
	
FD_B8:
	
FD_B9:
	
FD_BA:
	
FD_BB:
	
FD_BC:
	
FD_BD:
	
FD_BF:
	
FD_C0:
	
FD_C1:
	
FD_C2:
	
FD_C3:
	
FD_C4:
	
FD_C5:
	
FD_C6:
	
FD_C7:
	
FD_C8:
	
FD_C9:
	
FD_CA:
	
FD_CC:
	
FD_CD:
	
FD_CE:
	
FD_CF:
	
FD_D0:
	
FD_D1:
	
FD_D2:
	
FD_D3:
	
FD_D4:
	
FD_D5:
	
FD_D6:
	
FD_D7:
	
FD_D8:
	
FD_D9:
	
FD_DA:
	
FD_DB:
	
FD_DC:
	
FD_DD:
	
FD_DE:
	
FD_DF:
	
FD_E0:
	
FD_E2:
	
FD_E4:
	
FD_E6:
	
FD_E7:
	
FD_E8:
	
FD_EA:
	
FD_EB:
	
FD_EC:
	
FD_ED:
	
FD_EE:
	
FD_EF:
	
FD_F0:
	
FD_F1:
	
FD_F2:
	
FD_F3:
	
FD_F4:
	
FD_F5:
	
FD_F6:
	
FD_F7:
	
FD_F8:
	
FD_FA:
	
FD_FB:
	
FD_FC:
	
FD_FD:
	
FD_FE:
	
FD_FF:
	
FD_1A:
	
FD_1B:
	
FD_1C:
	
FD_1D:
	
FD_1E:
	
FD_1F:
	
FD_76:
	call Debug
	ret
