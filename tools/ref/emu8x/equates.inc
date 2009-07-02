;Register equates
registerAF equ appbackupscreen	;2 bytes
registerBC equ registerAF+2
registerDE equ registerBC+2
registerHL equ registerDE+2
registerIX equ registerHL+2
registerIY equ registerIX+2
registerI equ registerIY+2
a_registerAF equ registerI+1
a_registerBC equ a_registerAF+2
a_registerDE equ a_registerBC+2
a_registerHL equ a_registerDE+2
registerSP equ a_registerHL+2
interruptMode equ registerSP+2	;byte
registerPC equ interruptMode+1
realPC equ registerPC+2

basepage equ realPC+2	;byte, page
currompage equ basepage+1
currentRAMPage equ currompage+1
calculatorModel equ currentRAMPage+1	;82,83,85,86
port2 equ calculatorModel+1
port0 equ port2+1
port3 equ port0+1
port4 equ port3+1
port5 equ port4+1
port6 equ port5+1
originalstack equ port6+1
interruptspeed equ originalstack+2
emulatorflags equ interruptspeed+1
lcd85status equ emulatorflags+1
lcd85offset equ lcd85status+1
calculatorPortOffset equ lcd85offset+1
rom83page equ calculatorPortOffset+1
lcdSave equ rom83page+1

;UI equates
menucur EQU lcdSave+1
menucount EQU menucur+1

;Saving/loading memory locations
lastappvar EQU menucount+1

;registerPC,currom,00,currompage,speedreturn
speedpage EQU ramCode
speedstack EQU ramCode-2

;Flag equates (emulatorflags)
interruptsEnabled equ 0
timerEnabled equ 1
onEnabled equ 2
haltActive equ 3

;Saving/loading equates
appvarbase equ statvars
