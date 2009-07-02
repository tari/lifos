Opcode_CB:
	inc ix
	inc iy
	pop hl	;junk...remove return address
	pop af
	ld sp,speedstack
	out (7),a
	ld l,(iy-1)
	ld a,81h
	out (7),a
	ld h,44h >> 1
	sla l
	rl h
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp (hl)
CB_40:
	;bit 0,b
	exx
	ex af,af'
	bit 0,b
	ex af,af'
	exx
	ret
CB_41:
	;bit 0,c
	exx
	ex af,af'
	bit 0,c
	ex af,af'
	exx
	ret
CB_42:
	;bit 0,d
	exx
	ex af,af'
	bit 0,d
	ex af,af'
	exx
	ret
CB_43:
	;bit 0,e
	exx
	ex af,af'
	bit 0,e
	ex af,af'
	exx
	ret
CB_44:
	;bit 0,h
	exx
	ex af,af'
	bit 0,h
	ex af,af'
	exx
	ret
CB_45:
	;bit 0,l
	exx
	ex af,af'
	bit 0,l
	ex af,af'
	exx
	ret
CB_46:
	;bit 0,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 0,e
	ex af,af'
	ret
CB_47:
	;bit 0,a
	ex af,af'
	bit 0,a
	ex af,af'
	ret
CB_48:
	;bit 1,b
	exx
	ex af,af'
	bit 1,b
	ex af,af'
	exx
	ret
CB_49:
	;bit 1,c
	exx
	ex af,af'
	bit 1,c
	ex af,af'
	exx
	ret
CB_4A:
	;bit 1,d
	exx
	ex af,af'
	bit 1,d
	ex af,af'
	exx
	ret
CB_4B:
	;bit 1,e
	exx
	ex af,af'
	bit 1,e
	ex af,af'
	exx
	ret
CB_4C:
	;bit 1,h
	exx
	ex af,af'
	bit 1,h
	ex af,af'
	exx
	ret
CB_4D:
	;bit 1,l
	exx
	ex af,af'
	bit 1,l
	ex af,af'
	exx
	ret
CB_4E:
	;bit 1,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 1,e
	ex af,af'
	ret
CB_4F:
	;bit 1,a
	ex af,af'
	bit 1,a
	ex af,af'
	ret
CB_50:
	;bit 2,b
	exx
	ex af,af'
	bit 2,b
	ex af,af'
	exx
	ret
CB_51:
	;bit 2,c
	exx
	ex af,af'
	bit 2,c
	ex af,af'
	exx
	ret
CB_52:
	;bit 2,d
	exx
	ex af,af'
	bit 2,d
	ex af,af'
	exx
	ret
CB_53:
	;bit 2,e
	exx
	ex af,af'
	bit 2,e
	ex af,af'
	exx
	ret
CB_54:
	;bit 2,h
	exx
	ex af,af'
	bit 2,h
	ex af,af'
	exx
	ret
CB_55:
	;bit 2,l
	exx
	ex af,af'
	bit 2,l
	ex af,af'
	exx
	ret
CB_56:
	;bit 2,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 2,e
	ex af,af'
	ret
CB_57:
	;bit 2,a
	ex af,af'
	bit 2,a
	ex af,af'
	ret
CB_58:
	;bit 3,b
	exx
	ex af,af'
	bit 3,b
	ex af,af'
	exx
	ret
CB_59:
	;bit 3,c
	exx
	ex af,af'
	bit 3,c
	ex af,af'
	exx
	ret
CB_5A:
	;bit 3,d
	exx
	ex af,af'
	bit 3,d
	ex af,af'
	exx
	ret
CB_5B:
	;bit 3,e
	exx
	ex af,af'
	bit 3,e
	ex af,af'
	exx
	ret
CB_5C:
	;bit 3,h
	exx
	ex af,af'
	bit 3,h
	ex af,af'
	exx
	ret
CB_5D:
	;bit 3,l
	exx
	ex af,af'
	bit 3,l
	ex af,af'
	exx
	ret
CB_5E:
	;bit 3,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 3,e
	ex af,af'
	ret
CB_5F:
	;bit 3,a
	ex af,af'
	bit 3,a
	ex af,af'
	ret
CB_60:
	;bit 4,b
	exx
	ex af,af'
	bit 4,b
	ex af,af'
	exx
	ret
CB_61:
	;bit 4,c
	exx
	ex af,af'
	bit 4,c
	ex af,af'
	exx
	ret
CB_62:
	;bit 4,d
	exx
	ex af,af'
	bit 4,d
	ex af,af'
	exx
	ret
CB_63:
	;bit 4,e
	exx
	ex af,af'
	bit 4,e
	ex af,af'
	exx
	ret
CB_64:
	;bit 4,h
	exx
	ex af,af'
	bit 4,h
	ex af,af'
	exx
	ret
CB_65:
	;bit 4,l
	exx
	ex af,af'
	bit 4,l
	ex af,af'
	exx
	ret
CB_66:
	;bit 4,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 4,e
	ex af,af'
	ret
CB_67:
	;bit 4,a
	ex af,af'
	bit 4,a
	ex af,af'
	ret
CB_68:
	;bit 5,b
	exx
	ex af,af'
	bit 5,b
	ex af,af'
	exx
	ret
CB_69:
	;bit 53,c
	exx
	ex af,af'
	bit 5,c
	ex af,af'
	exx
	ret
CB_6A:
	;bit 5,d
	exx
	ex af,af'
	bit 5,d
	ex af,af'
	exx
	ret
CB_6B:
	;bit 5,e
	exx
	ex af,af'
	bit 5,e
	ex af,af'
	exx
	ret
CB_6C:
	;bit 5,h
	exx
	ex af,af'
	bit 5,h
	ex af,af'
	exx
	ret
CB_6D:
	;bit 5,l
	exx
	ex af,af'
	bit 5,l
	ex af,af'
	exx
	ret
CB_6E:
	;bit 5,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 5,e
	ex af,af'
	ret
CB_6F:
	;bit 5,a
	ex af,af'
	bit 5,a
	ex af,af'
	ret
CB_70:
	;bit 6,b
	exx
	ex af,af'
	bit 6,b
	ex af,af'
	exx
	ret
CB_71:
	;bit 6,c
	exx
	ex af,af'
	bit 6,c
	ex af,af'
	exx
	ret
CB_72:
	;bit 6,d
	exx
	ex af,af'
	bit 6,d
	ex af,af'
	exx
	ret
CB_73:
	;bit 6,e
	exx
	ex af,af'
	bit 6,e
	ex af,af'
	exx
	ret
CB_74:
	;bit 6,h
	exx
	ex af,af'
	bit 6,h
	ex af,af'
	exx
	ret
CB_75:
	;bit 6,l
	exx
	ex af,af'
	bit 6,l
	ex af,af'
	exx
	ret
CB_76:
	;bit 6,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 6,e
	ex af,af'
	ret
CB_77:
	;bit 6,a
	ex af,af'
	bit 6,a
	ex af,af'
	ret
CB_78:
	;bit 7,b
	exx
	ex af,af'
	bit 7,b
	ex af,af'
	exx
	ret
CB_79:
	;bit 7,c
	exx
	ex af,af'
	bit 7,c
	ex af,af'
	exx
	ret
CB_7A:
	;bit 7,d
	exx
	ex af,af'
	bit 7,d
	ex af,af'
	exx
	ret
CB_7B:
	;bit 7,e
	exx
	ex af,af'
	bit 7,e
	ex af,af'
	exx
	ret
CB_7C:
	;bit 7,h
	exx
	ex af,af'
	bit 7,h
	ex af,af'
	exx
	ret
CB_7D:
	;bit 7,l
	exx
	ex af,af'
	bit 7,l
	ex af,af'
	exx
	ret
CB_7E:
	;bit 7,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	bit 7,e
	ex af,af'
	ret
CB_7F:
	;bit 7,a
	ex af,af'
	bit 7,a
	ex af,af'
	ret
CB_80:
	;res 0,b
	exx
	res 0,b
	exx
	ret
CB_81:
	;res 0,c
	exx
	res 0,c
	exx
	ret
CB_82:
	;res 0,d
	exx
	res 0,d
	exx
	ret
CB_83:
	;res 0,e
	exx
	res 0,e
	exx
	ret
CB_84:
	;res 0,h
	exx
	res 0,h
	exx
	ret
CB_85:
	;res 0,l
	exx
	res 0,l
	exx
	ret
CB_86:
	;res 0,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 0,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_87:
	;res 0,a
	ex af,af'
	res 0,a
	ex af,af'
	ret
CB_88:
	;res 1,b
	exx
	res 1,b
	exx
	ret
CB_89:
	;res 1,c
	exx
	res 1,c
	exx
	ret
CB_8A:
	;res 1,d
	exx
	res 1,d
	exx
	ret
CB_8B:
	;res 1,e
	exx
	res 1,e
	exx
	ret
CB_8C:
	;res 1,h
	exx
	res 1,h
	exx
	ret
CB_8D:
	;res 1,l
	exx
	res 1,l
	exx
	ret
CB_8E:
	;res 1,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 1,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_8F:
	;res 1,a
	ex af,af'
	res 1,a
	ex af,af'
	ret
CB_90:
	;res 2,b
	exx
	res 2,b
	exx
	ret
CB_91:
	;res 2,c
	exx
	res 2,c
	exx
	ret
CB_92:
	;res 2,d
	exx
	res 2,d
	exx
	ret
CB_93:
	;res 2,e
	exx
	res 2,e
	exx
	ret
CB_94:
	;res 2,h
	exx
	res 2,h
	exx
	ret
CB_95:
	;res 2,l
	exx
	res 2,l
	exx
	ret
CB_96:
	;res 2,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 2,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_97:
	;res 2,a
	ex af,af'
	res 2,a
	ex af,af'
	ret
CB_98:
	;res 3,b
	exx
	res 3,b
	exx
	ret
CB_99:
	;res 3,c
	exx
	res 3,c
	exx
	ret
CB_9A:
	;res 3,d
	exx
	res 3,d
	exx
	ret
CB_9B:
	;res 3,e
	exx
	res 3,e
	exx
	ret
CB_9C:
	;res 3,h
	exx
	res 3,h
	exx
	ret
CB_9D:
	;res 3,l
	exx
	res 3,l
	exx
	ret
CB_9E:
	;res 3,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 3,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_9F:
	;res 3,a
	ex af,af'
	res 3,a
	ex af,af'
	ret
CB_A0:
	;res 4,b
	exx
	res 4,b
	exx
	ret
CB_A1:
	;res 4,c
	exx
	res 4,c
	exx
	ret
CB_A2:
	;res 4,d
	exx
	res 4,d
	exx
	ret
CB_A3:
	;res 4,e
	exx
	res 4,e
	exx
	ret
CB_A4:
	;res 4,h
	exx
	res 4,h
	exx
	ret
CB_A5:
	;res 4,l
	exx
	res 4,l
	exx
	ret
CB_A6:
	;res 4,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 4,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_A7:
	;res 4,a
	ex af,af'
	res 4,a
	ex af,af'
	ret
CB_A8:
	;res 5,b
	exx
	res 5,b
	exx
	ret
CB_A9:
	;res 5,c
	exx
	res 5,c
	exx
	ret
CB_AA:
	;res 5,d
	exx
	res 5,d
	exx
	ret
CB_AB:
	;res 5,e
	exx
	res 5,e
	exx
	ret
CB_AC:
	;res 5,h
	exx
	res 5,h
	exx
	ret
CB_AD:
	;res 5,l
	exx
	res 5,l
	exx
	ret
CB_AE:
	;res 5,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 5,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_AF:
	;res 5,a
	ex af,af'
	res 5,a
	ex af,af'
	ret
CB_B0:
	;res 6,b
	exx
	res 6,b
	exx
	ret
CB_B1:
	;res 6,c
	exx
	res 6,c
	exx
	ret
CB_B2:
	;res 6,d
	exx
	res 6,d
	exx
	ret
CB_B3:
	;res 6,e
	exx
	res 6,e
	exx
	ret
CB_B4:
	;res 6,h
	exx
	res 6,h
	exx
	ret
CB_B5:
	;res 6,l
	exx
	res 6,l
	exx
	ret
CB_B6:
	;res 6,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 6,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_B7:
	;res 6,a
	ex af,af'
	res 6,a
	ex af,af'
	ret
CB_B8:
	;res 7,b
	exx
	res 7,b
	exx
	ret
CB_B9:
	;res 7,c
	exx
	res 7,c
	exx
	ret
CB_BA:
	;res 7,d
	exx
	res 7,d
	exx
	ret
CB_BB:
	;res 7,e
	exx
	res 7,e
	exx
	ret
CB_BC:
	;res 7,h
	exx
	res 7,h
	exx
	ret
CB_BD:
	;bit 7,l
	exx
	res 7,l
	exx
	ret
CB_BE:
	;res 7,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	res 7,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_BF:
	;res 7,a
	ex af,af'
	res 7,a
	ex af,af'
	ret
CB_C0:
	;set 0,b
	exx
	set 0,b
	exx
	ret
CB_C1:
	;set 0,c
	exx
	set 0,c
	exx
	ret
CB_C2:
	;set 0,d
	exx
	set 0,d
	exx
	ret
CB_C3:
	;set 0,e
	exx
	set 0,e
	exx
	ret
CB_C4:
	;set 0,h
	exx
	set 0,h
	exx
	ret
CB_C5:
	;set 0,l
	exx
	set 0,l
	exx
	ret
CB_C6:
	;set 0,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 0,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_C7:
	;set 0,a
	ex af,af'
	set 0,a
	ex af,af'
	ret
CB_C8:
	;set 1,b
	exx
	set 1,b
	exx
	ret
CB_C9:
	;set 1,c
	exx
	set 1,c
	exx
	ret
CB_CA:
	;set 1,d
	exx
	set 1,d
	exx
	ret
CB_CB:
	;set 1,e
	exx
	set 1,e
	exx
	ret
CB_CC:
	;set 1,h
	exx
	set 1,h
	exx
	ret
CB_CD:
	;set 1,l
	exx
	set 1,l
	exx
	ret
CB_CE:
	;set 1,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 1,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_CF:
	;set 1,a
	ex af,af'
	set 1,a
	ex af,af'
	ret
CB_D0:
	;set 2,b
	exx
	set 2,b
	exx
	ret
CB_D1:
	;set 2,c
	exx
	set 2,c
	exx
	ret
CB_D2:
	;set 2,d
	exx
	set 2,d
	exx
	ret
CB_D3:
	;set 2,e
	exx
	set 2,e
	exx
	ret
CB_D4:
	;set 2,h
	exx
	set 2,h
	exx
	ret
CB_D5:
	;set 2,l
	exx
	set 2,l
	exx
	ret
CB_D6:
	;set 2,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 2,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_D7:
	;set 2,a
	ex af,af'
	set 2,a
	ex af,af'
	ret
CB_D8:
	;set 3,b
	exx
	set 3,b
	exx
	ret
CB_D9:
	;set 3,c
	exx
	set 3,c
	exx
	ret
CB_DA:
	;set 3,d
	exx
	set 3,d
	exx
	ret
CB_DB:
	;set 3,e
	exx
	set 3,e
	exx
	ret
CB_DC:
	;set 3,h
	exx
	set 3,h
	exx
	ret
CB_DD:
	;set 3,l
	exx
	set 3,l
	exx
	ret
CB_DE:
	;set 3,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 3,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_DF:
	;set 3,a
	ex af,af'
	set 3,a
	ex af,af'
	ret
CB_E0:
	;set 4,b
	exx
	set 4,b
	exx
	ret
CB_E1:
	;set 4,c
	exx
	set 4,c
	exx
	ret
CB_E2:
	;set 4,d
	exx
	set 4,d
	exx
	ret
CB_E3:
	;set 4,e
	exx
	set 4,e
	exx
	ret
CB_E4:
	;set 4,h
	exx
	set 4,h
	exx
	ret
CB_E5:
	;set 4,l
	exx
	set 4,l
	exx
	ret
CB_E6:
	;set 4,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 4,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_E7:
	;set 4,a
	ex af,af'
	set 4,a
	ex af,af'
	ret
CB_E8:
	;set 5,b
	exx
	set 5,b
	exx
	ret
CB_E9:
	;set 5,c
	exx
	set 5,c
	exx
	ret
CB_EA:
	;set 5,d
	exx
	set 5,d
	exx
	ret
CB_EB:
	;set 5,e
	exx
	set 5,e
	exx
	ret
CB_EC:
	;set 5,h
	exx
	set 5,h
	exx
	ret
CB_ED:
	;set 5,l
	exx
	set 5,l
	exx
	ret
CB_EE:
	;set 5,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 5,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_EF:
	;set 5,a
	ex af,af'
	set 5,a
	ex af,af'
	ret
CB_F0:
	;set 6,b
	exx
	set 6,b
	exx
	ret
CB_F1:
	;set 6,c
	exx
	set 6,c
	exx
	ret
CB_F2:
	;set 6,d
	exx
	set 6,d
	exx
	ret
CB_F3:
	;set 6,e
	exx
	set 6,e
	exx
	ret
CB_F4:
	;set 6,h
	exx
	set 6,h
	exx
	ret
CB_F5:
	;set 6,l
	exx
	set 6,l
	exx
	ret
CB_F6:
	;set 6,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 6,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_F7:
	;set 6,a
	ex af,af'
	set 6,a
	ex af,af'
	ret
CB_F8:
	;set 7,b
	exx
	set 7,b
	exx
	ret
CB_F9:
	;set 7,c
	exx
	set 7,c
	exx
	ret
CB_FA:
	;set 7,d
	exx
	set 7,d
	exx
	ret
CB_FB:
	;set 7,e
	exx
	set 7,e
	exx
	ret
CB_FC:
	;set 7,h
	exx
	set 7,h
	exx
	ret
CB_FD:
	;bit 7,l
	exx
	set 7,l
	exx
	ret
CB_FE:
	;set 7,(hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	set 7,(hl)
	exx
	ld a,81h
	out (7),a
	ret
CB_FF:
	;set 7,a
	ex af,af'
	set 7,a
	ex af,af'
	ret
CB_3F:
	;srl a
	ex af,af'
	srl a
	ex af,af'
	ret
CB_38:
	;srl b
	exx
	ex af,af'
	srl b
	ex af,af'
	exx
	ret
CB_39:
	;srl c
	exx
	ex af,af'
	srl c
	ex af,af'
	exx
	ret
CB_3A:
	;srl d
	exx
	ex af,af'
	srl d
	ex af,af'
	exx
	ret
CB_3B:
	;srl e
	exx
	ex af,af'
	srl e
	ex af,af'
	exx
	ret
CB_3C:
	;srl h
	exx
	ex af,af'
	srl h
	ex af,af'
	exx
	ret
CB_3D:
	;srl l
	exx
	ex af,af'
	srl l
	ex af,af'
	exx
	ret
CB_3E:
	;srl (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	srl (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_2F:
	;sra a
	ex af,af'
	sra a
	ex af,af'
	ret
CB_28:
	;sra b
	exx
	ex af,af'
	sra b
	ex af,af'
	exx
	ret
CB_29:
	;sra c
	exx
	ex af,af'
	sra c
	ex af,af'
	exx
	ret
CB_2A:
	;sra d
	exx
	ex af,af'
	sra d
	ex af,af'
	exx
	ret
CB_2B:
	;sra e
	exx
	ex af,af'
	sra e
	ex af,af'
	exx
	ret
CB_2C:
	;sra h
	exx
	ex af,af'
	sra h
	ex af,af'
	exx
	ret
CB_2D:
	;sra l
	exx
	ex af,af'
	sra l
	ex af,af'
	exx
	ret
CB_2E:
	;sra (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	sra (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_20:
	;sla b
	exx
	ex af,af'
	sla b
	ex af,af'
	exx
	ret
CB_27:
	;sla a
	ex af,af'
	sla a
	ex af,af'
	ret
CB_21:
	;sla c
	exx
	ex af,af'
	sla c
	ex af,af'
	exx
	ret
CB_22:
	;sla d
	exx
	ex af,af'
	sla d
	ex af,af'
	exx
	ret
CB_23:
	;sla e
	exx
	ex af,af'
	sla e
	ex af,af'
	exx
	ret
CB_24:
	;sla h
	exx
	ex af,af'
	sla h
	ex af,af'
	exx
	ret
CB_25:
	;sla l
	exx
	ex af,af'
	sla l
	ex af,af'
	exx
	ret
CB_26:
	;sla (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	sla (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_1F:
	;rr a
	ex af,af'
	rr a
	ex af,af'
	ret
CB_18:
	;rr b
	exx
	ex af,af'
	rr b
	ex af,af'
	exx
	ret
CB_19:
	;rr c
	exx
	ex af,af'
	rr c
	ex af,af'
	exx
	ret
CB_1A:
	;rr d
	exx
	ex af,af'
	rr d
	ex af,af'
	exx
	ret
CB_1B:
	;rr e
	exx
	ex af,af'
	rr e
	ex af,af'
	exx
	ret
CB_1C:
	;rr h
	exx
	ex af,af'
	rr h
	ex af,af'
	exx
	ret
CB_1D:
	;rr l
	exx
	ex af,af'
	rr l
	ex af,af'
	exx
	ret
CB_1E:
	;rr (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	rr (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_0F:
	;rrc a
	ex af,af'
	rrc a
	ex af,af'
	ret
CB_08:
	;rrc b
	exx
	ex af,af'
	rrc b
	ex af,af'
	exx
	ret
CB_09:
	;rrc c
	exx
	ex af,af'
	rrc c
	ex af,af'
	exx
	ret
CB_0A:
	;rrc d
	exx
	ex af,af'
	rrc d
	ex af,af'
	exx
	ret
CB_0B:
	;rrc e
	exx
	ex af,af'
	rrc e
	ex af,af'
	exx
	ret
CB_0C:
	;rrc h
	exx
	ex af,af'
	rrc h
	ex af,af'
	exx
	ret
CB_0D:
	;rrc l
	exx
	ex af,af'
	rrc l
	ex af,af'
	exx
	ret
CB_0E:
	;rrc (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	rrc (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_16:
	;rl (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	rl (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_17:
	;rl a
	ex af,af'
	rl a
	ex af,af'
	ret
CB_10:
	;rl b
	exx
	ex af,af'
	rl b
	ex af,af'
	exx
	ret
CB_11:
	;rl c
	exx
	ex af,af'
	rl c
	ex af,af'
	exx
	ret
CB_12:
	;rl d
	exx
	ex af,af'
	rl d
	ex af,af'
	exx
	ret
CB_13:
	;rl e
	exx
	ex af,af'
	rl e
	ex af,af'
	exx
	ret
CB_14:
	;rl h
	exx
	ex af,af'
	rl h
	ex af,af'
	exx
	ret
CB_15:
	;rl l
	exx
	ex af,af'
	rl l
	ex af,af'
	exx
	ret
CB_06:
	;rlc (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	rlc (hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_07:
	;rlc a
	ex af,af'
	rlc a
	ex af,af'
	ret
CB_00:
	;rlc b
	exx
	ex af,af'
	rlc b
	ex af,af'
	exx
	ret
CB_01:
	;rlc c
	exx
	ex af,af'
	rlc c
	ex af,af'
	exx
	ret
CB_02:
	;rlc d
	exx
	ex af,af'
	rlc d
	ex af,af'
	exx
	ret
CB_03:
	;rlc e
	exx
	ex af,af'
	rlc e
	ex af,af'
	exx
	ret
CB_04:
	;rlc h
	exx
	ex af,af'
	rlc h
	ex af,af'
	exx
	ret
CB_05:
	;rlc l
	exx
	ex af,af'
	rlc l
	ex af,af'
	exx
	ret
Opcode_07:
	;rlca
	ex af,af'
	rlca
	ex af,af'
	ret
Opcode_17:
	;rla
	ex af,af'
	rla
	ex af,af'
	ret
Opcode_0F:
	;rrca
	ex af,af'
	rrca
	ex af,af'
	ret
Opcode_1F:
	;rra
	ex af,af'
	rra
	ex af,af'
	ret
CB_30:
	;sll b
	exx
	ex af,af'
	sla b
	set 0,b
	ex af,af'
	exx
	ret
CB_31:
	;sll c
	exx
	ex af,af'
	sla c
	set 0,c
	ex af,af'
	exx
	ret
CB_32:
	;sll d
	exx
	ex af,af'
	sla d
	set 0,d
	ex af,af'
	exx
	ret
CB_33:
	;sll e
	exx
	ex af,af'
	sla e
	set 0,e
	ex af,af'
	exx
	ret
CB_34:
	;sll h
	exx
	ex af,af'
	sla h
	set 0,h
	ex af,af'
	exx
	ret
CB_35:
	;sll l
	exx
	ex af,af'
	sla l
	set 0,l
	ex af,af'
	exx
	ret
CB_36:
	;sll (hl)
	ld a,(currentRAMPage)
	out (7),a
	exx
	ex af,af'
	sla (hl)
	set 0,(hl)
	ex af,af'
	exx
	ld a,81h
	out (7),a
	ret
CB_37:
	;sll a
	ex af,af'
	sla a
	set 0,a
	ex af,af'
	ret
