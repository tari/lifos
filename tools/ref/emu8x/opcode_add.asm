Opcode_09:
	;add hl,bc
	exx
	ex af,af'
	add hl,bc
	ex af,af'
	exx
	ret
Opcode_19:
	;add hl,de
	exx
	ex af,af'
	add hl,de
	ex af,af'
	exx
	ret
Opcode_29:
	;add hl,hl
	exx
	ex af,af'
	add hl,hl
	ex af,af'
	exx
	ret
Opcode_39:
	;add hl,sp
	ld de,(registerSP)
	exx
	push hl
	exx
	pop hl
	ex af,af'
	add hl,de
	ex af,af'
	push hl
	exx
	pop hl
	exx
	ret
Opcode_CE:
	;adc a,nn
	call Fetch_Byte_PC
	ex af,af'
	adc a,e
	ex af,af'
	ret
Opcode_8E:
	;adc a,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	adc a,e
	ex af,af'
	ret
Opcode_8F:
	;adc a,a
	ex af,af'
	adc a,a
	ex af,af'
	ret
Opcode_88:
	;adc a,b
	exx
	ex af,af'
	adc a,b
	ex af,af'
	exx
	ret
Opcode_89:
	;adc a,c
	exx
	ex af,af'
	adc a,c
	ex af,af'
	exx
	ret
Opcode_8A:
	;adc a,d
	exx
	ex af,af'
	adc a,d
	ex af,af'
	exx
	ret
Opcode_8B:
	;adc a,e
	exx
	ex af,af'
	adc a,e
	ex af,af'
	exx
	ret
Opcode_8C:
	;adc a,h
	exx
	ex af,af'
	adc a,h
	ex af,af'
	exx
	ret
Opcode_8D:
	;adc a,l
	exx
	ex af,af'
	adc a,l
	ex af,af'
	exx
	ret
Opcode_86:
	;add a,(hl)
	exx
	push hl
	exx
	pop hl
	call Fetch_Byte_HL
	ex af,af'
	add a,e
	ex af,af'
	ret
Opcode_C6:
	;add a,nn
	call Fetch_Byte_PC
	ex af,af'
	add a,e
	ex af,af'
	ret
Opcode_87:
	;add a,a
	ex af,af'
	add a,a
	ex af,af'
	ret
Opcode_80:
	;add a,b
	exx
	ex af,af'
	add a,b
	ex af,af'
	exx
	ret
Opcode_81:
	;add a,c
	exx
	ex af,af'
	add a,c
	ex af,af'
	exx
	ret
Opcode_82:
	;add a,d
	exx
	ex af,af'
	add a,d
	ex af,af'
	exx
	ret
Opcode_83:
	;add a,e
	exx
	ex af,af'
	add a,e
	ex af,af'
	exx
	ret
Opcode_84:
	;add a,h
	exx
	ex af,af'
	add a,h
	ex af,af'
	exx
	ret
	ret
Opcode_85:
	;add a,l
	exx
	ex af,af'
	add a,l
	ex af,af'
	exx
	ret
