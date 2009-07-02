
instrParse:
	ld hl,regPC
	ld a,(hl)
	cp $FD
	jr z,prefixedFD
	cp $DD
	jr z,prefixedDD
	cp $CB
	jr z,prefixedCB
	cp $ED
	jr z,prefixedED
.module noPrefix
	inc hl
	ld h,(hl)
	ld l,a
	ld l,(hl)
	ld h,0
	add hl,hl
	add hl,hl
	ld de,interpTab
	add hl,de		;points to correct location in the table now
	ld a,(hl)
	or a
	jr z,_unsafeNative
_safeNatives:			;(not a cannibal instruction)
	push hl
	 ld hl,(lastIntTStates)
	 ld e,a
	 ld d,0
	 add hl,de
	 ld (lastIntTStates),hl	;updated T states counter
	 pop hl
	inc hl
	ld b,(hl)		;b is the instruction length
	ld a,(nativeExecBufLen)
	ld c,a
	add a,b
	cp c
	ld a,c			;doing this after flushing would bork the count
	call nc,flushNatives	;flush the buffer if it would overflow
	add a,b
	ld (nativeExecBufLen),a	;updated buffer length
	ld e,c
	ld d,0			;MAYBE NEED TO INCREMENT DE BEFORE ADDING..
	ld hl,nativeBuf
	add hl,de
	ex de,hl
	ld hl,regPC
_bufferAppend:
	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	djnz _bufferAppend
	ld (regPC),hl
	jr instrParse