;init routines
init_begin:

;#IF CALCTYPE = ct83PBE
;PRIV_ROM = $1C
;#ELSEIF CALCTYPE = ct83PSE
;PRIV_ROM = $4C
;#ELSEIF CALCTYPE = ct84PBE
;PRIV_ROM = $4C
;#ELSEIF CALCTYPE = ct84PSE
;PRIV_ROM = $7C
;#ENDIF

.module boot
;basically this entire module was ripped off of PongOS
Boot:
	di
	xor a
	out (0),a		; reset link
	dec a
	out (1),a		; reset keypad
	ld a,$0b
	out (3),a		; default interrupt
	ld a,$76
	out (4),a		; standard int clock
.echo "Careful with init.asm, line 26.\n"
	ld a,$1C		;the hardware will mask this if needed.. but Flash Debugger won't.  F'in TI.
	out (6),a
_StackInit:	;this goes here so we're sure the stack is OK before our first call
	ld sp,0
	ld hl,0
	push hl
	push hl
_justABitMore:
	call protPortInit
	ld a,$41
	out (7),a		; ram page 1 in bank 3
	in a,(2)
	and $80
	jr z,_GenericInit
_SESpecial:
	ld a,$81
	out (7),a		; ram page 1 in bank 3
	dec a
	out (8),a		; reset dbus
	xor a
	out (8),a		; enable dbus
	out (5),a		; ram page 0 in bank 4
	out ($20),a		; cpu clock
	ld a,$14
	out ($29),a		; lcd clock
	xor a
	out ($30),a		; clear timers
	out ($33),a
	out ($36),a
_GenericInit:
	im 1
_LCDInit
	ld a,$18		; Reset test mode
	call LCDComm
	ld a,1			; 8-bit mode
	call LCDComm
	ld a,$f0		; Contrast
	ld (contrast),a
	call LCDComm
	ld a,$40		; Reset Z addressing
	call LCDComm
	ld a,$5			; X auto-increment mode (move down)
	call LCDComm
	ld a,$3			;turn the dumb thing on
	call LCDComm
	ei
_memInitChk:
;for now, just reset
;;later, we will checksum all of RAM upon shutdown and check it at reboot
_memInitChkFail:
	ld hl,$8000
	ld de,$8001
	ld bc,$8000
	ld (hl),0
	ldir
	ld hl,allocStackBegin
	ld (allocSP),hl
	;now setup the top end of user RAM
	ld hl,usrRAM_top
	ld (varsLowEnd),hl
	ld (VATEnd),hl
	ld a,r
	ld l,a
	cpl
	ld h,a			;yes, it's a rather pathetic way to scramble HL..
	ld (randSeed),hl
	ld iy,flagsBegin	;an unknown value for flags spells trouble
	jp OS_MAIN

.echo "init.asm:	"\.echo $-init_begin\.echo " bytes\n"