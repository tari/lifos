;=========Assembler housekeeping==========
.binarymode intel
;=========Page and sector definitions===========
.defpage 00, $4000, $0000 
.defpage 01, $4000, $4000
.defpage 02, $4000, $4000
.defpage 03, $4000, $4000
.defpage 04, $4000, $4000
.defpage 05, $4000, $4000
.defpage 06, $4000, $4000
.defpage 07, $4000, $4000
.defpage 08, $4000, $4000
.defpage 09, $4000, $4000
.defpage 10, $4000, $4000
.defpage 11, $4000, $4000
.defpage 12, $4000, $4000
.defpage 13, $4000, $4000
.defpage 14, $4000, $4000
.defpage 15, $4000, $4000
.defpage 16, $4000, $4000
.defpage 17, $4000, $4000
.defpage 18, $4000, $4000
.defpage 19, $4000, $4000
.defpage 20, $4000, $4000
.defpage 21, $4000, $4000
.defpage 22, $4000, $4000
.defpage 23, $4000, $4000
.defpage 24, $4000, $4000
.defpage 25, $4000, $4000
.defpage 26, $4000, $4000
.defpage 27, $4000, $4000
.defpage 28, $4000, $4000
.defpage 29, $4000, $4000
.defpage 30, $4000, $4000
.defpage 31, $4000, $4000

;==========Macro definitions============
#DEFINE		sector(xx)	.page 4*xx
#DEFCONT		\	.page (4*xx)+1
#DEFCONT		\	.page (4*xx)+2
#DEFCONT		\	.page (4*xx)+3
#DEFINE		CleanExit() ret
#DEFINE		ErrorOut(EMain_T) rst rERROROUT
#DEFCONT		\	.dw 256*eMinor_Undef + eMain_T
#DEFINE     ErrorOut(EMain_T,ESub_T) call EOUT_MACRO
#DEFCONT        \   .dw 256*eSub_T + eMain_T
#DEFINE     ErrorOutC(EMain_T,ESub_T) jr nc,{@}
#DEFCONT        \   ErrorOut(EMain_T,ESub_T)
#DEFCONT        \   @
#DEFINE     ErrorOutNC(EMain_T,ESub_T) jr c,{@}
#DEFCONT        \   ErrorOut(EMain_T,ESub_T)
#DEFCONT        \   @
#DEFINE     ErrorOutZ(EMain_T,ESub_T) jr nz,{@}
#DEFCONT        \   ErrorOut(EMain_T,ESub_T)
#DEFCONT        \   @
#DEFINE     ErrorOutNZ(EMain_T,ESub_T) jr z,{@}
#DEFCONT        \   ErrorOut(EMain_T,ESub_T)
#DEFCONT        \   @

#DEFINE NUM_SYSCALLS	26
#DEFINE LIFOS_VER "LIFOS 0.1.2a"
#DEFINE LIFOS_VER_MAJOR 0
#DEFINE LIFOS_VER_MINOR 1
#DEFINE LIFOS_VER_BUILD 2
#DEFINE CALCTYPE ct83PBE
;#DEFINE UNIT_TEST

.echo "Building as version "\.echo LIFOS_VER_MAJOR\.echo "."\.echo LIFOS_VER_MINOR\.echo "."\.echo LIFOS_VER_BUILD
.echo " for hardware type "\.echo CALCTYPE\.echo "\n"

.include "inc/hardware.inc"
.include "inc/RAM.inc"
.include "inc/getCSC.inc"
.include "inc/errors.inc"

.page 00	;kernel code
.include "src/rom00.asm"
.page 01
.include "src/UI/rom01.asm"
.page 02
.page 03	;these three pages will probably house the MUI

sector(1)	;04-07 |
sector(2)	;08-0B |
sector(3)	;0C-0F |
sector(4)	;10-13  |User archive space
sector(5)	;14-17  |
sector(6)	;18-1B  |

.page 28	;privileged page 1
.include "src/rom1C.asm"

.page 29	;privileged page 2
.page 30	;certificate sectors here
.page 31	;boot code here

.end
END
