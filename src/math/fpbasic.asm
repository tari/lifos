;;FP number format
;;Offset | Size | Function
;; 0.7     .1	  Sign - reset for positive (not yet implemented)
;; 1.0	   .7	  Exponent
;; 1.7	   .1	  Exponent sign
;; 2	   7	  Mantissa
;;Mantissa is left-justified.  

;Number of digits of precision in mantissa
#DEFINE FP_PRECISION 14

;;Note to self: use CORDIC or Taylor approximation for more complex operations.

;Find which value has lower exponent, shift to align exponents
FPAdd:
;	ld hl,OP1_Sign
;	ld de,OP2_Sign
;	ld a,(de)
;	xor (hl)
;	jr nz,nnnn	;Signs differ
;	bit 7,(hl)	;check sign of OP1
;	jr nz,_FPAdd_BothNegative
;	...
	ld hl,OP1_Exponent
	ld a,(OP2_Exponent)
	cp (hl)
	jr z,_ExponentsAligned
;Align exponents to the greater one
	sub (hl)	;sub OP1 exponent from OP2's
	jr c, _alignExpToOP1
_alignExpToOP2:	;Align OP1's exponent to OP2's
	add (hl)
	ld b,a
	ld a,(hl)
_alignExpToOP2L:
	inc a
	cp b
	jr nz,_alignExpToOP2L
	ld (hl),a
	jr _ExponentsAligned
_alignExpToOP1:	;Align OP2's exponent to OP1's
	add (hl)	;get OP2 exponent back
_alignExpToOP1L:
	inc a
	cp (hl)
	jr nz,_alignExpToOP1L
	ld (OP2_Exponent),a
_ExponentsAligned:
	ld hl,(OP1_End)
	ld de,(OP2_End)
	or a
	ld b,FP_PRECISION/2
_FPAddLoop:		;Add significands
	ld a,(de)
	adc (hl)
	daa
	ld (hl),a
	dec hl
	dec de
	djnz _FPAddLoop
    ;;TODO
	

;;Shift the FP number at OP1 right by B
;;[Convert from m*10^n to (m/10^B)*10^(n+B)]
;;Modifies:
;;	AF, B, HL
_FPShiftExpRightB:
	ld hl,OP1_Exponent
	ld a,(hl)
	add a,b
	ld (hl),a
_FPShiftExpRight_loop:
	ld hl,OP1_Mantissa
	xor a
.repeat 7
	rrd		;rotate a.lsn->(hl).msn->(hl).lsn->a.lsn
	inc hl
.loop
	djnz _FPShiftExpRight_loop
	ret