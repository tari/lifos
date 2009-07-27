__rom00_begin:
.org 0000h
	jp Boot

.org 0008h
	jp scanKey

.org 0010h
	jp putSprite

.org 0018h
	jp mAlloc

.org 0020h
	push af		;20
	in a,($10)	;21
	rla			;23
	jr c,$0021	;24
	pop af		;26
	ret			;27

.org 0028h
	;jp DEPMACRO
	ret

.org 0030h
	ret
	;put something here

.org 0038h
;system interrupt
	jp SYSINT

.org 0053h
;boot code returns here
	jp Boot
.org 0056h
;Something involving validation.  Make this 5AA5 if not signing with 05
	.db $FF, $A5
.org 0064h
;OS version string
	.db LIFOS_VER,0

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
;.include "src/IO/link.asm"		;NOT READY
;.include "src/pucrunch.asm"		;NOT READY
OS_CODE_END:
.echo "Page 00:	"\.echo $\.echo " bytes total, less syscallTab\n"

.org $4000-(3*NUM_SYSCALLS)
syscallTab:
	jp putMap		;26	3FCC	Display a character, don't update coordinates
	jp getHardVersion	;25	3FCE	Return the calculator hardware version
	jp rand8		;24	3FD0	Generate pseudo-random 8-bit number
	jp horizLine		;23	3FD2	Draw a horizontal line
	jp scanKey		;22	3FD4	Scan for depressed keys
	jp waitKey		;21	3FD6	Wait for a keypress
	jp clrLCD		;20	3FD8	Clear dispBuf and the LCD
	jp putSprite		;19	3FDA	Display sprite, XOR
	jp bufCopy		;18	3FDC	Copy dispBuf to the LCD
	jp LCDComm		;17	3FDE	Send a command to the LCD (port $10)
	jp LCDWait		;16	3FE0	Wait until LCD will accept a command
	jp check16		;15	3FE2	Calculate a checksum
	jp popAll		;14	3FE4	Restore from a pushAll
	jp pushAll		;13	3FE6	Save all registers to the stack
	jp getFreeRAM		;12	3FE8	Return amount of free RAM
	jp cpHLDE		;11	3FEA	Non-destructive compare of HL and DE
	jp compStrs		;10	3FEC	Compare strings at (hl) and (de)
	jp swapRAM		;9	3FEE	Swap two blocks of RAM
	jp getOSVersion	;8	3FF0	Return OS version (xx.yy.z)
	jp coordsReset		;7	3FF2	Reset text coordinates
	jp putC		;6	3FF4	Display a character
	jp putS		;5	3FF6	Display null-terminated string
	jp mAlloc		;4	3FF8	Allocate memory block
	jp peekAllocStack	;3	3FFA	Peek alloc stack
	jp popAllocStack	;2	3FFC	Pop allocation stack object
	jp pushAllocStack	;1	3FFE	Push allocation stack object
.echo "syscallTab:	"\.echo 2*NUM_SYSCALLS\.echo " bytes\n"

#IF OS_CODE_END > syscallTab
.fail "OS code overflow onto syscallTab by ",OS_CODE_END-syscallTab," bytes!\n"
#ENDIF