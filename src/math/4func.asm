;Four-function FP math, many thanks to Scott Dial

;;The FP routines use RPN, in a sense.
;;You push allocation entries, acting like a stack.
;;The routines then manipulate the stack, acting upon the top entries.
;;To initialize the stack, call FPInit to load some error-handling (allocate CANARY).
;;
;;FP number format:
;;1 - Sign (1 is negative, 0 is positive)
;;1 - exponent
;;7 - significand
;;1 - scratch byte

;;Notes to self:
;;Use index registers to work on operands, since they're on a stack.
;;Can use .db $DD \ ex (sp),hl to do ex (sp),ix (DD is ix prefix, FD is iy)
.module FPInit
FPInit:
	ld hl,8
	call mAlloc
	ret c		;the routine loads error code
	ld de,_canaryStr
	ld bc,8
	ex de,hl
	ldir		;copy canary value
	CleanExit()
_canaryStr:
	.db "CaNaRy",0
	
.module FPAdd
FPAdd:
;optimization: check if either is 0
	;clear the scratch byte
	xor a
	ld (OP1+9),a
	ld (OP2+9),a
	
	ld a,(OP1)
	ld b,a
	ld a,(OP2)
	cp b
	jr nz,_signsDiffer
_signsSame:
	ld a,(OP2+1)
	ld c,a
	ld a,(OP1+1)
	cp c
	jr z,_expsSame
	jr nc,_adjustExp
;put the larger exponent in number one, so it's all regular
	ld b,a
	push bc	;save my exponents
	 call FPSwapStack
	 pop bc
	ld a,c
	ld c,b	;swap exponents to reflect the swap on the stack
_adjustExp:
	sub c
	cp 15
	ret nc	;a large difference of exponent has no bearing on output anyway
			;(note it's already flagged as a clean exit, due to the condition)
;A=difference of exponents
	call FPsrOP2	;shift second operand down to align exponents
_expsSame:
	call FPsrOP2_1
	call FPsrOP1_1	;free up a byte for carry
;now it's all aligned
	ld hl,OP1+9
	ld de,OP2+9	;begin at the lsb of each, of course
	ld a,(de)
	adc a,(hl)
	daa
	ld (hl),a	;save lsb
	srl a
	srl a
	srl a
	srl a
	cp 5	;last digit gets dropped, but we need to round with it - >= 5 rounds up
	ccf
	ld b,7
_addLoop:	;unrolling is marginally faster- meh
	dec hl
	dec de
	ld a,(de)
	adc a,(hl)
	daa		;how does it determine what to do?  Flags?  No, z80 magic. ;)
	djnz _addLoop
;finished adding
	ld a,(OP1+2)
	and $F0
	jr nz,_noShiftback
	call FPslOP1_1
	CleanExit()		;no chance of overflow (msn of msb is blank)
_noShiftback:
	ld a,(OP1+1)
	inc a
	ld (OP1+1),a	;increment the exponent
	or a		;exponent of 0 means there was overflow
	jr z,_addOverflowed
	CleanExit()
_addOverflowed:
	ErrorOut(MathError, MathError.Overflow)	;error macro prototype, yay

_signsDiffer:
;the signs are opposite, so we'll change this to a subtraction operation
	jr nc,_noSwap
	;swap the operands if #1 is negative
	call FPSwapStack
_noSwap:
	xor 1	;flip the sign of old operand 1, avoiding a loop of calling ;)
	ld (OP2),a
	jp FPSub

.module FPSub
FPSub:
;;FPSub: subtracts OP2 from OP1
	;optimization: check if either is 0
	;clear the scratch byte
	xor a
	ld (OP1+9),a
	ld (OP2+9),a
	ld a,(OP1)
	ld b,a
	ld a,(OP2)
	
	
FPsrOP1_1:
  ld a,1
FPsrOP1:
;shift OP1 right by A nibbles
  ld b,a
  ld de,(OP1+2)
_srl:
  ld h,d
  ld l,e
  xor a
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl
  rrd
  inc hl
  rrd
  djnz FPsr_l
  ret

FPslOP1_1:
	ld a,1
FPslOP1:
;shift OP1 left by A nibbles
	or a
	sla a
	sla a
	ld b,a
_sl_o:
	ld d,b
	ld hl,(OP1+9)
	or a
	ld b,8
_sl_i:
	rl (hl)
	dec hl
	djnz sl_i
	ld b,d
	djnz sl_o
	ret