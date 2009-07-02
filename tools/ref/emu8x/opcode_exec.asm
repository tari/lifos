Opcode_C7:
	;rst 00h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0
	jp Optimize_PC
Opcode_CF:
	;rst 08h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,8
	jp Optimize_PC
Opcode_D7:
	;rst 10h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0010h
	jp Optimize_PC
Opcode_DF:
	;rst 18h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0018h
	jp Optimize_PC
Opcode_E7:
	;rst 20h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0020h
	jp Optimize_PC
Opcode_EF:
	;rst 28h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0028h
	jp Optimize_PC
Opcode_F7:
	;rst 30h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0030h
	jp Optimize_PC
Opcode_FF:
	;rst 38h
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	ld ix,0038h
	jp Optimize_PC
Opcode_Ret:
	ex af,af'
ED_4D:
	;reti
ED_45:
	;retn
Opcode_C9:
	;ret
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	pop ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	jp Optimize_PC
Opcode_D8:
	;ret c
	ex af,af'
	jr c,Opcode_Ret
	ex af,af'
	ret
Opcode_F8:
	;ret m
	ex af,af'
	jp m,Opcode_Ret
	ex af,af'
	ret
Opcode_D0:
	;ret nc
	ex af,af'
	jr nc,Opcode_Ret
	ex af,af'
	ret
Opcode_C0:
	;ret nz
	ex af,af'
	jr nz,Opcode_Ret
	ex af,af'
	ret
Opcode_F0:
	;ret p
	ex af,af'
	jp p,Opcode_Ret
	ex af,af'
	ret
Opcode_E8:
	;ret pe
	ex af,af'
	jp pe,Opcode_Ret
	ex af,af'
	ret
Opcode_E0:
	;ret po
	ex af,af'
	jp po,Opcode_Ret
	ex af,af'
	ret
Opcode_C8:
	;ret z
	ex af,af'
	jr z,Opcode_Ret
	ex af,af'
	ret
Opcode_DC:
	;call c,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jr c,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_FC:
	;call m,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jp m,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_D4:
	;call nc,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jr nc,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_C4:
	;call nz,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jr nz,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_F4:
	;call p,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jp p,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_EC:
	;call pe,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jp pe,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_E4:
	;call po,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jp po,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_CC:
	;call z,nnnn
	call Fetch_Byte_PC
	ld c,e
	call Fetch_Byte_PC
	ex af,af'
	jr z,Opcode_DC_Jump
	ex af,af'
	ret
Opcode_DC_Jump:
	ex af,af'
	ld d,e
	ld e,c
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	push de
	pop ix
	jp Optimize_PC
Opcode_CD:
	;call nnnn
	call Fetch_Word_PC
	ex de,hl
Opcode_Call_Interface:
	ld sp,(registerSP)
	ld a,(currentRAMPage)
	out (7),a
	push ix
	ld a,81h
	out (7),a
	ld (registerSP),sp
	ld sp,speedstack
	push de
	pop ix
	jp Optimize_PC
Opcode_10:
	;djnz nn
	call Fetch_Byte_PC
	exx
	dec b
	exx
	ret z
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add ix,de
	jp Optimize_PC
Opcode_E9:
	;jp (hl)
	exx
	push hl
	pop ix
	exx
	jp Optimize_PC
Opcode_18:
	;jr nn
	call Fetch_Byte_PC
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add ix,de
	jp Optimize_PC
Opcode_28:
	;jr z
	call Fetch_Byte_PC
	ex af,af'
	jr z,Opcode_38_Jump
	ex af,af'
	ret
Opcode_20:
	;jr nz,nn
	call Fetch_Byte_PC
	ex af,af'
	jr nz,Opcode_38_Jump
	ex af,af'
	ret
Opcode_30:
	;jr nc,nn
	call Fetch_Byte_PC
	ex af,af'
	jr nc,Opcode_38_Jump
	ex af,af'
	ret
Opcode_38:
	;jr c,nn
	call Fetch_Byte_PC
	ex af,af'
	jr c,Opcode_38_Jump
	ex af,af'
	ret
Opcode_38_Jump:
	ex af,af'
	ld a,e
	add a,a
	sbc a,a
	ld d,a
	add ix,de
	jp Optimize_PC
Opcode_C3:
	;jp nnnn
	call Fetch_Word_PC
	push hl
	pop ix
	jp Optimize_PC
Opcode_DA:
	;jp c,nnnn
	call Fetch_Word_PC
	ex af,af'
	jr c,Opcode_C2_Jump
	ex af,af'
	ret
Opcode_FA:
	;jp m,nnnn
	call Fetch_Word_PC
	ex af,af'
	jp m,Opcode_C2_Jump
	ex af,af'
	ret
Opcode_D2:
	;jp nc,nnnn
	call Fetch_Word_PC
	ex af,af'
	jr nc,Opcode_D2_Jump
	ex af,af'
	ret
Opcode_D2_Jump:
	ex af,af'
	push hl
	pop ix
	jp Optimize_PC
Opcode_C2:
	;jp nz,nnnn
	call Fetch_Word_PC
	ex af,af'
	jr nz,Opcode_C2_Jump
	ex af,af'
	ret
Opcode_C2_Jump:
	ex af,af'
	push hl
	pop ix
	jp Optimize_PC
Opcode_F2:
	;jp p,nnnn
	call Fetch_Word_PC
	ex af,af'
	jp p,Opcode_C2_Jump
	ex af,af'
	ret
Opcode_EA:
	;jp pe,nnnn
	call Fetch_Word_PC
	ex af,af'
	jp pe,Opcode_C2_Jump
	ex af,af'
	ret
Opcode_E2:
	;jp po,nnnn
	call Fetch_Word_PC
	ex af,af'
	jp po,Opcode_C2_Jump
	ex af,af'
	ret
Opcode_CA:
	;jp z,nnnn
	call Fetch_Word_PC
	ex af,af'
	jr z,Opcode_C2_Jump
	ex af,af'
	ret
