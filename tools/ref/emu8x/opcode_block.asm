Opcode_EB:
	;ex de,hl
	exx
	ex de,hl
	exx
	ret
Opcode_08:
	;ex af,af'
	ld hl,(a_registerAF)
	push hl
	ex af,af'
	push af
	pop hl
	ld (a_registerAF),hl
	pop af
	ex af,af'
	ret
Opcode_D9:
	;exx
	ld hl,(a_registerBC)
	push hl
	ld hl,(a_registerDE)
	push hl
	ld hl,(a_registerHL)
	push hl
	exx
	ld (a_registerBC),bc
	ld (a_registerDE),de
	ld (a_registerHL),hl
	pop hl
	pop de
	pop bc
	exx
	ret
Opcode_E3:
	;ex (sp),hl
	exx
	push hl
	exx
	pop hl
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	ex (sp),hl
	ld a,81h
	out (7),a
	ld sp,speedstack
	push hl
	exx
	pop hl
	exx
	ret
	
