@echo off

tasm -80 -s -c -fff -o20 page1C.asm page1C.hex
if errorlevel 1 goto ERR

tasm -80 -s -c -fff -o20 page00.asm page00.hex
if errorlevel 1 goto ERR

multihex 00 page00.hex 1C page1C.hex > pongos.hex

packxxu -v 9.99 -h 255 pongos.hex -t 83p -o pongos.8xu
if errorlevel 1 goto ERR

packxxu -v 9.99 -h 255 pongos.hex -t 73 -o pongos.73u
if errorlevel 1 goto ERR

if not exist TI83Plus.clc goto SKIPBE
copy /y TI83Plus.clc pong-be.rom
rompatch pong-be.rom pongos.hex
if errorlevel 1 goto ERR

:SKIPBE

if not exist TI83ps.clc goto SKIPSE
copy /y TI83ps.clc pong-se.rom
rompatch pong-se.rom -s pongos.hex
if errorlevel 1 goto ERR

:SKIPSE

goto DONE

:ERR
echo *****Error*****

:DONE
