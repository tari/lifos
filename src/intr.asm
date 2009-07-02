.module sysint
;the IM 1 ISR
SYSINT:
	ex af,af'
	exx
	in a,(4)
	bit 3,a
	jr z,_onIntTriggered
	bit 4,a
	jr nz,_linkIntTriggered
	jr _exitInt
_onIntTriggered:
	
	ld a,$FD
	out (1),a
	nop
	nop
	in a,(1)
	bit 1,a
	jr z,_contrastUp
	bit 2,a
	jr nz,_exitInt
_contrastDown:
	ld a,(contrast)
	dec a
	bit 6,a		;bit six will only be reset if a < $C0
	jr _applyContrast
_contrastUp:
	ld a,(contrast)
	inc a
_applyContrast:
	jr z,_exitInt	;ignores if command wouldn't affect contrast (<$C0) or wrapped around (0)
	ld (contrast),a
	out ($10),a
_LCDWaitLoop:
    in a,(pLCDComm)
    rla
    jr c,_LCDWaitLoop
_linkIntTriggered:
_exitInt:
	ld a,%00001000
	out (3),a	;ack and disable all ints
	ld a,$B
	out (3),a	;now re-enable
	ex af,af'
	exx
	ei
	reti	;I don't know how much of this is actually necessary, but TI uses all of it	
