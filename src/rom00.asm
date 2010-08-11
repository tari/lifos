__rom00_begin:
.define code_overflow(addr) .if $ >= addr \ .fail "Code overflow past ",addr,": ",$ \ .endif
;Routines: RST vectors
;Reset vectors for optimized calls.  All of these may be called with the rst
;instruction as well as normal calls.
;
;rREBOOT - vectors to <Boot>
;rLDHLIND - Loads HL with the word stored at (HL), preserving all other
;           registers.
;rERROROUT - Worker for <ErrorOut(EMain_T,ESub_T)>.  Do not use.
;rCPHLDE - Acts just like the `cp' instruction, but with HL instead of A and
;          DE instead of some 8-bit register.
;rLCDWAIT - Stalls until the LCD driver reports ready, as given by bit 7 of
;           port 10h.  Modifies AF.
;rINTR - Vectors to <SYSINT>.
.org 0000h
rREBOOT:
	jp Boot

.org 0008h
rLDHLIND:
	push af
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	pop af
	ret
	code_overflow(0010h)

.org 0010h
rERROROUT:
	ex (sp),hl
	rst rLDHLIND
	ld (errorCodes),hl
	pop hl
	ret
    code_overflow(0018h)

.org 0018h
rCPHLDE
    or a
    push hl
    sbc hl,de
    pop hl
	ret

.org 0020h
rLCDWAIT:
	in a,($10)
	rla
	jr c,$0021
	ret
    code_overflow(0028h)
    
.org 0028h
	;jp DEPMACRO
	ret

.org 0030h
	ret
	;put something here

.org 0038h
rINTR:
	jp SYSINT

.org 0053h
;boot code returns here
	jp Boot
.org 0056h
;Something involving validation.  Make this 5AA5 if not signing the image
	.db $FF, $A5
.org 0064h
;OS version string
	.db LIFOS_VER,0

;Function: OS_MAIN
;Main OS entry point.  Mostly just jumps out to UI_MAIN on ROM page 1.
OS_MAIN:

	ld a,1
	out (6),a
	jp UI_MAIN
	
.include "src/macros.asm"
.include "src/mm/alloc.asm"
.include "src/mm/memory.asm"
.include "src/mm/vars.asm"
.include "src/init.asm"
.include "src/intr.asm"
.include "src/misc.asm"
.include "src/IO/display.asm"
.include "src/IO/keypad.asm"
.include "src/IO/link.asm"
;.include "src/pucrunch.asm"		;NOT READY
OS_CODE_END:
.echo "Page 00:	"\.echo $\.echo " bytes total, less syscallTab\n"

;;TODO: refactor again so we use vectors
.org $4000-(3*NUM_SYSCALLS)
syscallTab:

.echo "syscallTab:	"\.echo 2*NUM_SYSCALLS\.echo " bytes\n"
    code_overflow(4000h)    ;In case we miss updating NUM_SYSCALLS

#IF OS_CODE_END > syscallTab
.fail "OS code overflow onto syscallTab by ",OS_CODE_END-syscallTab," bytes!\n"
#ENDIF