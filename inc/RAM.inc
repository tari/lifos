;
; Definition file for system RAM areas in upper static RAM
;
#DEFINE flag(addr) addr-flagsBegin
hardStackBegin		.EQU	0FFFFh	;	top of memory
allocStackBegin 	.EQU	0FC00h	;	bottom of stacks
allocSP				.EQU	0FBFEh	;2	->top of allocation stack
dispBuf2			.EQU	0F8FDh	;768	secondary display buffer
dispBuf				.EQU	0F5FCh	;768	display buffer
contrast			.EQU	0F5E5h	;1	system contrast setting
spriteClipMask		.EQU	0F5FAh	;1	temporary mask data for clipped sprite routines
dependencyTab		.EQU	0F5F5h	;5	table of dependency pages
OPN					.EQU	0F5EAh	;11	OPerator Name
VATEnd				.EQU	0F5E8h	;2	->first byte after end of VAT
varsLowEnd			.EQU	0F5E6h	;2	->first free byte after lowest var in memory
xyCoords			.EQU	0F5E3h	;2	x and y coords to display text at
curCol				.EQU	xyCoords	;1	x coordinate
curRow				.EQU	curCol+1	;1	y coordinate
randSeed			.EQU	0F5E1h	;2	random number seed
errorCodeMin        .EQU    0F5E0h  ;1
errorCodeMaj        .EQU    0F5DFh  ;1
errorCodes          .EQU    errorCodeMaj

;unused to F5E6
flagsBegin			.EQU	0F50Ah	;for macros
drawFlags			.EQU	flagsBegin	;1	flags for display routines
textToBuf			.EQU	0	;write text to dispBuf (1=do, 0=to LCD)
inverseText			.EQU	1	;invert text (1 = do)

OSRAM				.EQU	0F500h	;10	scrap RAM for the OS
im2Tab				.EQU	0F400h	;255

usrRAM_top			.EQU	0F3FFh	;yeah, not a pointer or anything
VAT_begin			.EQU	usrRAM_top

;VAT entry types
VtProgNRP			.EQU	80h		;unrelocatable program
VtProgFRP			.EQU	81h		;fully dynamic (fully relocatable)
VtProgDRP			.EQU	82h		;DRP program (dynamically relocatable)