#DEFINE lockFlash() protPortWrite($14, 0)
#DEFINE unlockFlash() protPortWrite($14, 1)
#DEFINE protPortWrite(port,output) ld a,output
#DEFCONT			 \ di
#DEFCONT			 \ nop
#DEFCONT			 \ nop
#DEFCONT			 \ im 1
#DEFCONT			 \ di
#DEFCONT			 \ out (port),a

.org 4000h

.module protPortInit
;protected ports are 14,16,22, and 23 - all Flash write/execution protection
;we allow execution on all Flash pages, then relock Flash
protPortInit:
	di
	unlockFlash()
#IF (CALCTYPE != 0)		;for all not-83PBEs
	protPortWrite($22, $FF)	;Set Flash execution lower limit (mirrors port 2 on BE, no one cares)
	protPortWrite($23, 0)	;Flash execution upper limit
#ELSE
	protPortWrite($16, 0)
	protPortWrite($05, 0)	;83PBE flash execution protection, it's a little funky..
#ENDIF
	lockFlash()
	ret

.org 7FFFh
	rst 38h