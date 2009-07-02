@echo off
xcopy ..\emulator.hex . /y
hex2bin emulator.hex emulator.bin /a:4000 /s:16