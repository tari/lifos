;===============================
; Hardware definition file for LIFOS
;===============================

pLINK		.EQU	00h

pKEY		.EQU	01h

pSTAT		.EQU	02h
BATT_STAT	.EQU	0	;reset if low batteries
_84_VER_STAT	.EQU	5	;set on 84 series calcs
_83PBE_VER_STAT .EQU	7	;reset on 83PBE, set on all others

pINTMASK	.EQU	03h
ONSERV_INT	.EQU	0	;service ON key interrupts
TIME1SERV_INT	.EQU	1	;service timer 1 interrupts
TIME2SERV_INT	.EQU	2	;service timer 2 interrupts
LOWPOWERMOD	.EQU	3	;write reset to put into low power mode when a halt executes
LINKSERV_INT	.EQU	4	;service linkport interrupts

pMMAP_INTID	.EQU	04h
INTID_ON	.EQU	0	;interrupt [was] triggered by ON key
INTID_TIME1	.EQU	1	;interrupt triggered by timer 1
INTID_TIME2	.EQU	2	;interrupt triggered by timer 2
ONSTAT		.EQU	3	;reset if ON is depressed
INTID_LINK	.EQU	4	;interrupt triggered by link activity
MMAP_MODE	.EQU	0	;write reset for mmap mode 0

pMBANKA	.EQU	06h	;paging at 4000h

pMBANKB	.EQU	07h	;paging at 8000h

pLCDCOMM	.EQU	10h
;read bits, first
LCD_AUTOINC	.EQU	0	;set if auto-increment
LCD_INCDEC	.EQU	1	;set if auto-movement is on x axis, otherwise on y
LCD_ON		.EQU	5	;set if display is on
LCD_8OR6	.EQU	6	;set if in 8 bit mode, otherwise 6
LCD_STAT	.EQU	7	;reset if commands will be accepted
;now for write values - many aren't included because programs would be ill-advised to directly access the LCD
LCDC_6BITM	.EQU	00h	;set six bit mode
LCDC_8BITM	.EQU	01h	;set eight bit mode
LCDC_OFF	.EQU	02h	;disable the screen (use pINTMASK, port LOWPOWERMOD to turn it off)
LCDC_ON	.EQU	03h	;re-enable screen
LCDC_NOTEST	.EQU	18h	;cancel test mode
LCDC_YESTEST	.EQU	1Ch	;set test mode (please be careful) (note: 1C-1F all do the same thing)
LCDC_CONTRAST 	.EQU	0C0h	;C0-FF set contrast, just add a value to this
;that wasn't so bad, was it?

pLCDDAT	.EQU	11h	;LCD data port

pCPUSPD	.EQU	20h	;CPU speed control (mirrors pLINK on 83PBE)
CPU_6MHZ	.EQU	00h	;running at 6 MHz
CPU_15MHZ	.EQU	01h	;15 MHz mode	(can also just check bit 0)

pHARDTYPE	.EQU	21h	;hardware version indicator
TYPE_SE	.EQU	0	;set on SEs (83PSE/84PSE)

;===================================

;outputs from getHardVersion
ct83PBE	=0
ct83PSE	=1
ct84PBE	=2
ct84PSE	=3