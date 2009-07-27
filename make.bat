@echo off
rem Tools
set ass=tools\asm\Brass.exe
echo Assembler = "%ass%"
set emu=tools\emu\pindurti.exe
echo Emulator = "%emu%"
set send=tools\emu\send.exe
echo sendutil = "%send%"
set hexconv=tools\asm\Hex2Rom.exe
echo hexconv = "%hexconv%"
set asmdoc=tools\doc\asmdoc.exe
echo Asmdoc = "%asmdoc%"
rem Files
set main=src\main.asm
echo main source file = "%main%"
set bin=bin\LIFOS.rom
echo output file = "%bin%"
set hex=bin\LIFOS.hex
echo hexfile = "%hex%"
rem Directories
set sourced=src\
echo source directory = "%sourced%"
set asmdocd=doc\asmdoc\
echo asmdoc directory = "%asmdocd%"
set layoutd=doc\layout\
echo layout directory = "%layoutd%"
rem Targets
IF "%1" == "" GOTO build
IF "%1" == "run" GOTO run
IF "%1" == "asmdoc" GOTO asmdoc
echo.
echo Run make without any parameters to build project
echo Run using "make run" to run the project
echo Run using "make asmdoc" to generate documentation to %asmdocd%
GOTO done
:build
%ASS% %MAIN% %HEX%
%HEXCONV% %HEX% %BIN%
del bin\LIFOS.rom.pti
echo LIFOS.rom.pti is the bane of my existence, deleting..
GOTO done
:run
start %EMU%
> "%Temp%.\sleep.vbs" ECHO WScript.Sleep 1000
CSCRIPT //NoLogo "%Temp%.\sleep.vbs"
DEL "%Temp%.\sleep.vbs"
%SEND% 0 %BIN%
GOTO done
:asmdoc
%ASMDOC% %SOURCED% %ASMDOCD% %LAYOUTD%
:done