Opcode_22:
	;ld (nnnn),hl
	call Fetch_Word_PC
	exx
	ld a,l
	exx
	ld c,a
	call Write_Byte
	inc hl
	exx
	ld a,h
	exx
	ld c,a
	jp Write_Byte
Opcode_2A:
	;ld hl,(nnnn)
	call Fetch_Word_PC
	call Fetch_Byte_HL
	ld a,e
	exx
	ld l,a
	exx
	inc hl
	call Fetch_Byte_HL
	ld a,e
	exx
	ld h,a
	exx
	ret
Opcode_01:
	;ld bc,nnnn
	call Fetch_Word_PC
	push hl
	exx
	pop bc
	exx
	ret
Opcode_11:
	;ld de,nnnn
	call Fetch_Word_PC
	push hl
	exx
	pop de
	exx
	ret
Opcode_21:
	;ld hl,nnnn
	call Fetch_Word_PC
	push hl
	exx
	pop hl
	exx
	ret
Opcode_31:
	;ld sp,nnnn
	call Fetch_Word_PC
	ld (registerSP),hl
	ret
Opcode_32:
	;ld (nnnn),a
	call Fetch_Word_PC
	ex af,af'
	ld c,a
	ex af,af'
	jp Write_Byte
Opcode_3A:
	;ld a,(nnnn)
	call Fetch_Word_PC
	ld a,(currentRAMPage)
	out (7),a
	ld c,(hl)
	ld a,81h
	out (7),a
	ex af,af'
	ld a,c
	ex af,af'
	ret
Opcode_3E:
	;ld a,nn
	call Fetch_Byte_PC
	ex af,af'
	ld a,e
	ex af,af'
	ret
Opcode_06:
	;ld b,nn
	call Fetch_Byte_PC
	ld a,e
	exx
	ld b,a
	exx
	ret
Opcode_0E:
	;ld c,nn
	call Fetch_Byte_PC
	ld a,e
	exx
	ld c,a
	exx
	ret
Opcode_16:
	;ld d,nn
	call Fetch_Byte_PC
	ld a,e
	exx
	ld d,a
	exx
	ret
Opcode_1E:
	;ld e,nn
	call Fetch_Byte_PC
	ld a,e
	exx
	ld e,a
	exx
	ret
Opcode_26:
	;ld h,nn
	call Fetch_Byte_PC
	ld a,e
	exx
	ld h,a
	exx
	ret
Opcode_2E:
	;ld l,nn
	call Fetch_Byte_PC
	ld a,e
	exx
	ld l,a
	exx
	ret
