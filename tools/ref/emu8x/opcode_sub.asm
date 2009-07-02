Opcode_9F:
	;sbc a,a
	ex af,af'
	sbc a,a
	ex af,af'
	ret
Opcode_98:
	;sbc a,b
	exx
	ex af,af'
	sbc a,b
	ex af,af'
	exx
	ret
Opcode_99:
	;sbc a,c
	exx
	ex af,af'
	sbc a,c
	ex af,af'
	exx
	ret
Opcode_9A:
	;sbc a,d
	exx
	ex af,af'
	sbc a,d
	ex af,af'
	exx
	ret
Opcode_9B:
	;sbc a,e
	exx
	ex af,af'
	sbc a,e
	ex af,af'
	exx
	ret
Opcode_9C:
	;sbc a,h
	exx
	ex af,af'
	sbc a,h
	ex af,af'
	exx
	ret
Opcode_9D:
	;sbc a,l
	exx
	ex af,af'
	sbc a,l
	ex af,af'
	exx
	ret
Opcode_DE:
	;sbc a,nn
	call Fetch_Byte_PC
	ex af,af'
	sbc a,e
	ex af,af'
	ret
Opcode_9E:
	;sbc a,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	sbc a,e
	ex af,af'
	ret
Opcode_97:
	;sub a
	ex af,af'
	sub a
	ex af,af'
	ret
Opcode_90:
	;sub b
	exx
	ex af,af'
	sub b
	ex af,af'
	exx
	ret
Opcode_91:
	;sub c
	exx
	ex af,af'
	sub c
	ex af,af'
	exx
	ret
Opcode_92:
	;sub d
	exx
	ex af,af'
	sub d
	ex af,af'
	exx
	ret
Opcode_93:
	;sub e
	exx
	ex af,af'
	sub e
	ex af,af'
	exx
	ret
Opcode_94:
	;sub h
	exx
	ex af,af'
	sub h
	ex af,af'
	exx
	ret
Opcode_95:
	;sub l
	exx
	ex af,af'
	sub l
	ex af,af'
	exx
	ret
Opcode_D6:
	;sub nn
	call Fetch_Byte_PC
	ex af,af'
	sub e
	ex af,af'
	ret
Opcode_96:
	;sub (hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	sub e
	ex af,af'
	ret
