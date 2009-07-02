Opcode_FE:
	;cp nn
	call Fetch_Byte_PC
	ex af,af'
	cp e
	ex af,af'
	ret
Opcode_F6:
	;or nn
	call Fetch_Byte_PC
	ex af,af'
	or e
	ex af,af'
	ret
Opcode_EE:
	;xor nn
	call Fetch_Byte_PC
	ex af,af'
	xor e
	ex af,af'
	ret
Opcode_0B:
	;dec bc
	exx
	dec bc
	exx
	ret
Opcode_1B:
	;dec de
	exx
	dec de
	exx
	ret
Opcode_2B:
	;dec hl
	exx
	dec hl
	exx
	ret
Opcode_3B:
	;dec sp
	ld hl,(registerSP)
	dec hl
	ld (registerSP),hl
	ret
Opcode_03:
	;inc bc
	exx
	inc bc
	exx
	ret
Opcode_13:
	;inc de
	exx
	inc de
	exx
	ret
Opcode_23:
	;inc hl
	exx
	inc hl
	exx
	ret
Opcode_33:
	;inc sp
	ld hl,(registerSP)
	inc hl
	ld (registerSP),hl
	ret
Opcode_3D:
	;dec a
	ex af,af'
	dec a
	ex af,af'
	ret
Opcode_05:
	;dec b
	exx
	ex af,af'
	dec b
	ex af,af'
	exx
	ret
Opcode_0D:
	;dec c
	exx
	ex af,af'
	dec c
	ex af,af'
	exx
	ret
Opcode_15:
	;dec d
	exx
	ex af,af'
	dec d
	ex af,af'
	exx
	ret
Opcode_1D:
	;dec e
	exx
	ex af,af'
	dec e
	ex af,af'
	exx
	ret
Opcode_25:
	;dec h
	exx
	ex af,af'
	dec h
	ex af,af'
	exx
	ret
Opcode_2D:
	;dec l
	exx
	ex af,af'
	dec l
	ex af,af'
	exx
	ret
Opcode_3C:
	;inc a
	ex af,af'
	inc a
	ex af,af'
	ret
Opcode_0C:
	;inc c
	exx
	ex af,af'
	inc c
	ex af,af'
	exx
	ret
Opcode_04:
	;inc b
	exx
	ex af,af'
	inc b
	ex af,af'
	exx
	ret
Opcode_14:
	;inc d
	exx
	ex af,af'
	inc d
	ex af,af'
	exx
	ret
Opcode_1C:
	;inc e
	exx
	ex af,af'
	inc e
	ex af,af'
	exx
	ret
Opcode_24:
	;inc h
	exx
	ex af,af'
	inc h
	ex af,af'
	exx
	ret
Opcode_2C:
	;inc l
	exx
	ex af,af'
	inc l
	ex af,af'
	exx
	ret
Opcode_34:
	;inc (hl)
	exx
	push hl
	exx
	pop hl
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	inc (hl)
	ex af,af'
	ld a,81h
	out (7),a
	ret
Opcode_35:
	;dec (hl)
	ld a,(currentRAMPage)
	out (7),a
	ex af,af'
	exx
	dec (hl)
	exx
	ex af,af'
	ld a,81h
	out (7),a
	ret
Opcode_BF:
	;cp a
	ex af,af'
	cp a
	ex af,af'
	ret
Opcode_B8:
	;cp b
	exx
	ex af,af'
	cp b
	ex af,af'
	exx
	ret
Opcode_B9:
	;cp c
	exx
	ex af,af'
	cp c
	ex af,af'
	exx
	ret
Opcode_BA:
	;cp d
	exx
	ex af,af'
	cp d
	ex af,af'
	exx
	ret
Opcode_BB:
	;cp e
	exx
	ex af,af'
	cp e
	ex af,af'
	exx
	ret
Opcode_BC:
	;cp h
	exx
	ex af,af'
	cp h
	ex af,af'
	exx
	ret
Opcode_BD:
	;cp l
	exx
	ex af,af'
	cp l
	ex af,af'
	exx
	ret
Opcode_BE:
	;cp (hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	cp e
	ex af,af'
	ret
Opcode_AF:
	;xor a
	ex af,af'
	xor a
	ex af,af'
	ret
Opcode_A8:
	;xor b
	exx
	ex af,af'
	xor b
	ex af,af'
	exx
	ret
Opcode_A9:
	;xor c
	exx
	ex af,af'
	xor c
	ex af,af'
	exx
	ret
Opcode_AA:
	;xor d
	exx
	ex af,af'
	xor d
	ex af,af'
	exx
	ret
Opcode_AB:
	;xor e
	exx
	ex af,af'
	xor e
	ex af,af'
	exx
	ret
Opcode_AC:
	;xor h
	exx
	ex af,af'
	xor h
	ex af,af'
	exx
	ret
Opcode_AD:
	;xor l
	exx
	ex af,af'
	xor l
	ex af,af'
	exx
	ret
Opcode_AE:
	;xor (hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	xor e
	ex af,af'
	ret
Opcode_B7:
	;or a
	ex af,af'
	or a
	ex af,af'
	ret
Opcode_B0:
	;or b
	exx
	ex af,af'
	or b
	ex af,af'
	exx
	ret
Opcode_B1:
	;or c
	exx
	ex af,af'
	or c
	ex af,af'
	exx
	ret
Opcode_B2:
	;or d
	exx
	ex af,af'
	or d
	ex af,af'
	exx
	ret
Opcode_B3:
	;or e
	exx
	ex af,af'
	or e
	ex af,af'
	exx
	ret
Opcode_B4:
	;or h
	exx
	ex af,af'
	or h
	ex af,af'
	exx
	ret
Opcode_B5:
	;or l
	exx
	ex af,af'
	or l
	ex af,af'
	exx
	ret
Opcode_B6:
	;or (hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	or e
	ex af,af'
	ret
Opcode_E6:
	;and nn
	call Fetch_Byte_PC
	ex af,af'
	and e
	ex af,af'
	ret
Opcode_A7:
	;and a
	ex af,af'
	and a
	ex af,af'
	ret
Opcode_A0:
	;and b
	exx
	ex af,af'
	and b
	ex af,af'
	exx
	ret
Opcode_A1:
	;and c
	exx
	ex af,af'
	and c
	ex af,af'
	exx
	ret
Opcode_A2:
	;and d
	exx
	ex af,af'
	and d
	ex af,af'
	exx
	ret
Opcode_A3:
	;and e
	exx
	ex af,af'
	and e
	ex af,af'
	exx
	ret
Opcode_A4:
	;and h
	exx
	ex af,af'
	and h
	ex af,af'
	exx
	ret
Opcode_A5:
	;and l
	exx
	ex af,af'
	and l
	ex af,af'
	exx
	ret
Opcode_A6:
	;and (hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	and e
	ex af,af'
	ret
