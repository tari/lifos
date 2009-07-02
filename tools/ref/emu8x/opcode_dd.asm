Opcode_DD:
	inc ix
	inc iy
	pop hl	;junk...remove return address
	pop af
	ld sp,speedstack
	out (7),a
	ld l,(iy-1)
	ld a,81h
	out (7),a
	ld h,48h >> 1
	sla l
	rl h
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
DD_E9:
	;jp (ix)
	ld ix,(registerIX)
	jp Optimize_PC
DD_CB:
	call DD_LoadRFromIX
	push hl
	call Fetch_Byte_PC
	ld d,0
	ld hl,Opcode_DD_CB_Table
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
Opcode_DD_CB_Table:
	DW DD_CB_06
	DW DD_CB_0E
	DW DD_CB_16
	DW DD_CB_1E
	DW DD_CB_26
	DW DD_CB_2E
	DW DD_CB_36
	DW DD_CB_3E
	DW DD_CB_46
	DW DD_CB_4E
	DW DD_CB_56
	DW DD_CB_5E
	DW DD_CB_66
	DW DD_CB_6E
	DW DD_CB_76
	DW DD_CB_7E
	DW DD_CB_86
	DW DD_CB_8E
	DW DD_CB_96
	DW DD_CB_9E
	DW DD_CB_A6
	DW DD_CB_AE
	DW DD_CB_B6
	DW DD_CB_BE
	DW DD_CB_C6
	DW DD_CB_CE
	DW DD_CB_D6
	DW DD_CB_DE
	DW DD_CB_E6
	DW DD_CB_EE
	DW DD_CB_F6
	DW DD_CB_FE
DD_CB_BE:
	;res 7,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 7,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_B6:
	;res 6,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 6,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_AE:
	;res 5,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 5,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_A6:
	;res 4,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 4,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_9E:
	;res 3,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 3,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_96:
	;res 2,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 2,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_8E:
	;res 1,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 1,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_86:
	;res 0,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	res 0,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_7E:
	;bit 7,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 7,e
	ex af,af'
	ret
DD_CB_76:
	;bit 6,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 6,e
	ex af,af'
	ret
DD_CB_6E:
	;bit 5,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 5,e
	ex af,af'
	ret
DD_CB_66:
	;bit 4,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 4,e
	ex af,af'
	ret
DD_CB_5E:
	;bit 3,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 3,e
	ex af,af'
	ret
DD_CB_56:
	;bit 2,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 2,e
	ex af,af'
	ret
DD_CB_4E:
	;bit 1,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 1,e
	ex af,af'
	ret
	ret
DD_CB_46:
	;bit 0,(ix+d)
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 0,e
	ex af,af'
	ret
DD_CB_FE:
	;set 7,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 7,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_F6:
	;set 6,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 6,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_EE:
	;set 5,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 5,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_E6:
	;set 4,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 4,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_DE:
	;set 3,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 3,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_D6:
	;set 2,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 2,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_CE:
	;set 1,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 1,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_C6:
	;set 0,(ix+d)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	set 0,(hl)
	ld a,81h
	out (7),a
	ret
DD_CB_3E:
	;srl (ix)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	srl (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_CB_36:
	;sll (ix)
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
DD_CB_2E:
	;sra (ix)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	sra (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_CB_26:
	;sla (ix)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	sla (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_CB_1E:
	;rr (ix)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rr (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_CB_0E:
	;rrc (ix)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rrc (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_CB_16:
	;rl (ix)
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rl (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_CB_06:
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	rlc (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
DD_2B:
	;dec ix
	ld hl,(registerIX)
	dec hl
	ld (registerIX),hl
	ret
DD_23:
	;inc ix
	ld hl,(registerIX)
	inc hl
	ld (registerIX),hl
	ret
DD_09:
	;add ix,bc
	ld hl,(registerIX)
	exx
	push bc
	exx
	pop bc
	ex af,af'
	add hl,bc
	ex af,af'
	ld (registerIX),hl
	ret
DD_19:
	;add ix,de
	ld hl,(registerIX)
	exx
	push de
	exx
	pop de
	ex af,af'
	add hl,de
	ex af,af'
	ld (registerIX),hl
	ret
DD_29:
	;add ix,ix
	ld hl,(registerIX)
	ex af,af'
	add hl,hl
	ex af,af'
	ld (registerIX),hl
	ret
DD_39:
	;add ix,sp
	ld hl,(registerIX)
	ld bc,(registerSP)
	ex af,af'
	add hl,bc
	ex af,af'
	ld (registerIX),hl
	ret
DD_34:
	;inc (ix+d)
	call Fetch_Byte_PC
	ld hl,(registerIX)
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
DD_35:
	;dec (ix+d)
	call Fetch_Byte_PC
	ld hl,(registerIX)
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
DD_BE:
	;cp (ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	cp b
	ex af,af'
	ret
DD_AE:
	;xor (ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	xor b
	ex af,af'
	ret
DD_B6:
	;or (ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	or b
	ex af,af'
	ret
DD_A6:
	;and (ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	and b
	ex af,af'
	ret
DD_9E:
	;sbc a,(ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
  	sbc a,b
	ex af,af'
	ret
DD_96:
	;sub (ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	sub b
	ex af,af'
	ret
DD_8E:
	;adc a,(ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	adc a,b
	ex af,af'
	ret
DD_86:
	;add a,(ix+d)
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	add a,b
	ex af,af'
	ret
DD_E3:
	;ex (sp),ix
	ld sp,(registerSP)
	ld hl,(registerIX)
	ld a,(currentRAMPage)
	out (7),a
	ex (sp),hl
	ld a,81h
	out (7),a
	ld (registerIX),hl
	ld sp,speedstack
	ret
DD_E1:
	;pop ix
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	pop hl
	ld a,81h
	out (7),a
	ld (registerIX),hl
	ld (registerSP),sp
	ld sp,speedstack
	ret
DD_E5:
	;push ix
	ld sp,(registerSP)
	ld hl,(registerIX)
	ld a,(currentRAMPage)
	out (7),a
	push hl
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ret
DD_F9:
	;ld sp,ix
	ld hl,(registerIX)
	ld (registerSP),hl
	ret
DD_22:
	;ld (nnnn),ix
	call Fetch_Word_PC
	ld a,(registerIX)
	ld c,a
	call Write_Byte
	inc hl
	ld a,(registerIX+1)
	ld c,a
	jp Write_Byte
DD_2A:
	;ld ix,(nnnn)
	call Fetch_Word_PC
	call Fetch_Byte_HL
	ld a,e
	ld (registerIX),a
	inc hl
	call Fetch_Byte_HL
	ld a,e
	ld (registerIX+1),a
	ret
DD_21:
	;ld ix,nnnn
	call Fetch_Word_PC
	ld (registerIX),hl
	ret
DD_36:
	;ld (ix+n),nn
	call DD_FindIX
	push hl
	call Fetch_Byte_PC
	pop hl
	ld c,e
	call Write_Byte
	ret
DD_77:
	ex af,af'
	ld c,a
	ex af,af'
	jp DD_WriteToIX
DD_70:
	exx
	ld a,b
	exx
	ld c,a
	jp DD_WriteToIX
DD_71:
	exx
	ld a,c
	exx
	ld c,a
	jp DD_WriteToIX
DD_72:
	exx
	ld a,d
	exx
	ld c,a
	jp DD_WriteToIX
DD_73:
	exx
	ld a,e
	exx
	ld c,a
	jp DD_WriteToIX
DD_74:
	exx
	ld a,h
	exx
	ld c,a
	jp DD_WriteToIX
DD_75:
	exx
	ld a,l
	exx
	ld c,a
	jp DD_WriteToIX
DD_7E:
	call DD_LoadRFromIX
	ld b,a
	ex af,af'
	ld a,b
	ex af,af'
	ret
DD_4E:
	call DD_LoadRFromIX
	exx
	ld c,a
	exx
	ret
DD_46:
	call DD_LoadRFromIX
	exx
	ld b,a
	exx
	ret
DD_56:
	call DD_LoadRFromIX
	exx
	ld d,a
	exx
	ret
DD_5E:
	call DD_LoadRFromIX
	exx
	ld e,a
	exx
	ret
DD_66:
	call DD_LoadRFromIX
	exx
	ld h,a
	exx
	ret
DD_6E:
	call DD_LoadRFromIX
	exx
	ld l,a
	exx
	ret
DD_LoadRFromIX:
	call Fetch_Byte_PC
	ld hl,(registerIX)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	call Fetch_Byte_HL
	ld a,e
	ret
DD_WriteToIX:
	call Fetch_Byte_PC
	ld hl,(registerIX)
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
DD_FindIX:
	call Fetch_Byte_PC
	ld hl,(registerIX)
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add hl,de
	ret
DD_0:
	
DD_1:
	
DD_2:
	
DD_3:
	
DD_4:
	
DD_5:
	
DD_6:
	
DD_7:
	
DD_8:
	
DD_A:
	
DD_B:
	
DD_C:
	
DD_D:
	
DD_E:
	
DD_F:
	
DD_10:
	
DD_11:
	
DD_12:
	
DD_13:
	
DD_14:
	
DD_15:
	
DD_16:
	
DD_17:
	
DD_18:
	
DD_20:
	
DD_24:
	
DD_25:
	
DD_26:
	
DD_27:
	
DD_28:
	
DD_2C:
	
DD_2D:
	
DD_2E:
	
DD_2F:
	
DD_30:
	
DD_31:
	
DD_32:
	
DD_33:
	
DD_37:
	
DD_38:
	
DD_3A:
	
DD_3B:
	
DD_3C:
	
DD_3D:
	
DD_3E:
	
DD_3F:
	
DD_40:
	
DD_41:
	
DD_42:
	
DD_43:
	
DD_44:
	
DD_45:
	
DD_47:
	
DD_48:
	
DD_49:
	
DD_4A:
	
DD_4B:
	
DD_4C:
	
DD_4D:
	
DD_4F:
	
DD_50:
	
DD_51:
	
DD_52:
	
DD_53:
	
DD_54:
	
DD_55:
	
DD_57:
	
DD_58:
	
DD_59:
	
DD_5A:
	
DD_5B:
	
DD_5C:
	
DD_5D:
	
DD_5F:
	
DD_60:
	
DD_61:
	
DD_62:
	
DD_63:
	
DD_64:
	
DD_65:
	
DD_67:
	
DD_68:
	
DD_69:
	
DD_6A:
	
DD_6B:
	
DD_6C:
	
DD_6D:
	
DD_6F:
	
DD_78:
	
DD_79:
	
DD_7A:
	
DD_7B:
	
DD_7C:
	
DD_7D:
	
DD_7F:
	
DD_80:
	
DD_81:
	
DD_82:
	
DD_83:
	
DD_84:
	
DD_85:
	
DD_87:
	
DD_88:
	
DD_89:
	
DD_8A:
	
DD_8B:
	
DD_8C:
	
DD_8D:
	
DD_8F:
	
DD_90:
	
DD_91:
	
DD_92:
	
DD_93:
	
DD_94:
	
DD_95:
	
DD_97:
	
DD_98:
	
DD_99:
	
DD_9A:
	
DD_9B:
	
DD_9C:
	
DD_9D:
	
DD_9F:
	
DD_A0:
	
DD_A1:
	
DD_A2:
	
DD_A3:
	
DD_A4:
	
DD_A5:
	
DD_A7:
	
DD_A8:
	
DD_A9:
	
DD_AA:
	
DD_AB:
	
DD_AC:
	
DD_AD:
	
DD_AF:
	
DD_B0:
	
DD_B1:
	
DD_B2:
	
DD_B3:
	
DD_B4:
	
DD_B5:
	
DD_B7:
	
DD_B8:
	
DD_B9:
	
DD_BA:
	
DD_BB:
	
DD_BC:
	
DD_BD:
	
DD_BF:
	
DD_C0:
	
DD_C1:
	
DD_C2:
	
DD_C3:
	
DD_C4:
	
DD_C5:
	
DD_C6:
	
DD_C7:
	
DD_C8:
	
DD_C9:
	
DD_CA:
	
DD_CC:
	
DD_CD:
	
DD_CE:
	
DD_CF:
	
DD_D0:
	
DD_D1:
	
DD_D2:
	
DD_D3:
	
DD_D4:
	
DD_D5:
	
DD_D6:
	
DD_D7:
	
DD_D8:
	
DD_D9:
	
DD_DA:
	
DD_DB:
	
DD_DC:
	
DD_DD:
	
DD_DE:
	
DD_DF:
	
DD_E0:
	
DD_E2:
	
DD_E4:
	
DD_E6:
	
DD_E7:
	
DD_E8:
	
DD_EA:
	
DD_EB:
	
DD_EC:
	
DD_ED:
	
DD_EE:
	
DD_EF:
	
DD_F0:
	
DD_F1:
	
DD_F2:
	
DD_F3:
	
DD_F4:
	
DD_F5:
	
DD_F6:
	
DD_F7:
	
DD_F8:
	
DD_FA:
	
DD_FB:
	
DD_FC:
	
DD_FD:
	
DD_FE:
	
DD_FF:
	
DD_1A:
	
DD_1B:
	
DD_1C:
	
DD_1D:
	
DD_1E:
	
DD_1F:
	
DD_76:
	call Debug
	ret
