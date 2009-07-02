;Table of instructions/first bytes of instructions, providing a pointer and a
;	flag indicating whether it is safe to natively execute this instruction,
;	as well as providing its size.
;The core will read bytes from the emulated environment, check them in the
;	intrptab (interpreter table), and either interpret them, or add them
;	to the native execution buffer.
;Interrupts will be handled by the real hardware interrupts, but will fire an
;	emulated interrupt every 42857 emulated T-states, which can be tracked
;	by a TStatesXInt (T States since Interrupt) counter, updated by the core,
;	and zeroed by the interrupt handler as needed.

;interpTab format is TSTATES,INSTSIZE,HANDLER, where TSTATES is the number of T states it
;	takes to execute (0 if unsafe to natively execute), INSTSIZE is the size
;	of the instruction (in bytes), and HANDLER is a pointer to the handler routine for
;	it, for if it's unsafe to natively execute.
interpTab:
	.db	x,1 \ .dw NULL		;00 NOP
	.db	x,3 \ .dw NULL		;01 LD BC,nnnn
	.db	0,1 \ .dw handS02	;02 LD (BC),A
	.db	x,1 \ .dw NULL		;03 INC BC
	.db	x,1 \ .dw NULL		;04 INC B
	.db	x,1 \ .dw NULL		;05 DEC B
	.db x,2 \ .dw NULL		;06 LD B,nn
	.db	x,1 \ .dw NULL		;07 RLCA
	.db	0,1 \ .dw handS08	;08 EX AF,AF'
	.db	x,1 \ .dw NULL		;09 ADD HL,BC
	.db	0,1 \ .dw handS0A	;0A LD A,(BC)
	.db	x,1 \ .dw NULL		;0B DEC BC
	.db	x,1 \ .dw NULL		;0C INC C
	.db	x,1 \ .dw NULL		;0D DEC C
	.db	x,2 \ .dw NULL		;0E LD C,nn
	.db	x,1 \ .dw NULL		;0F RRCA
	.db 0,2 \ .dw handS10	;10 DJNZ nn
	.db	x,3 \ .dw NULL		;11 LD DE,nn
	.db	0,1 \ .dw handS12	;12 LD (DE),A
	.db	x,1 \ .dw NULL		;13 INC DE
	.db	x,1 \ .dw NULL		;14 INC D
	.db	x,1 \ .dw NULL		;15 DEC D
	.db	x,2 \ .dw NULL		;16 LD D,nn
	.db	x,1 \ .dw NULL		;17 RLA
	.db	0,2 \ .dw handS18	;18 JR nn
	.db	x,1 \ .dw NULL		;19 ADD HL,DE
	.db	0,1 \ .dw handS1A	;1A LD A,(DE)
	.db	x,1 \ .dw NULL		;1B DEC DE
	.db	x,1 \ .dw NULL		;1C INC E
	.db	x,1 \ .dw NULL		;1D DEC E
	.db	x,2 \ .dw NULL		;1E LD E,nn
	.db	x,1 \ .dw NULL		;1F RRA
	.db	0,2 \ .dw handS20	;20 JR NZ,nn
	.db	x,3 \ .dw NULL		;21 LD HL,nnnn
	.db	0,3 \ .dw handS22	;22 LD (nnnn),HL
	.db	x,1 \ .dw NULL		;23 INC HL
	.db	x,1 \ .dw NULL		;24 INC H
	.db	x,1 \ .dw NULL		;25 DEC H
	.db	x,2 \ .dw NULL		;26 LD H,nn
	.db	x,1 \ .dw NULL		;27 DAA
	.db	0,2 \ .dw handS28	;28 JR Z,nn
	.db	x,1 \ .dw NULL		;29 ADD HL,HL
	.db	0,3 \ .dw handS2A	;2A LD HL,(nnnn)
	.db	x,1 \ .dw NULL		;2B DEC HL
	.db	x,1 \ .dw NULL		;2C INC L
	.db	x,1 \ .dw NULL		;2D DEC L
	.db	x,2 \ .dw NULL		;2E LD L,nn
	.db	x,1 \ .dw NULL		;2F CPL