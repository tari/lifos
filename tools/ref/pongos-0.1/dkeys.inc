;;; -*- ti-asm -*-
; dkeys.inc: Direct key input for 83+
; Benjamin Moody
; Contains group and key bits for use with direct keypad input on TI83+
;  dgXXX = group number
;  dkXXX = key number

#ifndef __DKEYS_INC__
#define __DKEYS_INC__

#define dgroup(SCANCODE) 0ffh-(1<<((SCANCODE-1)&38h))
#define dkey(SCANCODE) 0ffh-(1<<((SCANCODE-1)&07h))
#define dbit(SCANCODE) (SCANCODE-1)&07h

dinp7           = 07fh
dinp6           = 0bfh
dinp5           = 0dfh
dinp4           = 0efh
dinp3           = 0f7h
dinp2           = 0fbh
dinp1           = 0fdh
dinp0           = 0feh

; Softkey and control key group

dgCtlKeys       = dinp6

dkYequ          = dinp4
dkWindow        = dinp3
dkZoom          = dinp2
dkTrace         = dinp1
dkGraph         = dinp0

dk2nd           = dinp5
dkMode          = dinp6
dkDel           = dinp7

; Alternate names for softkeys

dgSoftKeys      = dinp6

dkF1 = dkYequ
dkF2 = dkWindow
dkF3 = dkZoom
dkF4 = dkTrace
dkF5 = dkGraph

; Arrow keys

dgArrowKeys     = dinp0

dkUp            = dinp3
dkLeft          = dinp1
dkRight         = dinp2
dkDown          = dinp0

; Normal keys

dgKeys1         = dinp5
dkAlpha         = dinp7
dkMath          = dinp6
dkInverse       = dinp5
dkSquare        = dinp4
dkLog           = dinp3
dkLn            = dinp2
dkStore         = dinp1

dgKeys2         = dinp4
dkXvar          = dinp7
dkApps          = dinp6
dkSin           = dinp5
dkComma         = dinp4
dk7             = dinp3
dk4             = dinp2
dk1             = dinp1
dk0             = dinp0

dgKeys3         = dinp3
dkStat          = dinp7
dkPrgm          = dinp6
dkCos           = dinp5
dkLParen        = dinp4
dk8             = dinp3
dk5             = dinp2
dk2             = dinp1
dkPeriod        = dinp0

dgKeys4         = dinp2
dkVars          = dinp6
dkTan           = dinp5
dkRParen        = dinp4
dk9             = dinp3
dk6             = dinp2
dk3             = dinp1
dkNegate        = dinp0

dgKeys5         = dinp1
dkClear         = dinp6
dkPower         = dinp5
dkDiv           = dinp4
dkMul           = dinp3
dkSub           = dinp2
dkAdd           = dinp1
dkEnter         = dinp0

; Alternate names

dkA = dkMath
dkB = dkApps
dkC = dkPrgm
dkD = dkInverse
dkE = dkSin
dkF = dkCos
dkG = dkTan
dkH = dkPower
dkI = dkSquare
dkJ = dkComma
dkK = dkLParen
dkL = dkRParen
dkM = dkDiv
dkN = dkLog
dkO = dk7
dkP = dk8
dkQ = dk9
dkR = dkMul
dkS = dkLn
dkT = dk4
dkU = dk5
dkV = dk6
dkW = dkSub
dkX = dkStore
dkY = dk1
dkZ = dk2

#endif


