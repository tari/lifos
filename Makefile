## Tools

ASS 	= tools/asm/Brass.exe
EMU 	= tools/emu/pti.sh
HEX2ROM	= tools/asm/Hex2Rom.exe
ASMDOC	= tools/doc/asmdoc
PTI	= tools/emu/pindurti.exe
LINCALC = tools/emu/lincalc/run.sh

## Files

DEPS 	=	src/* \

MAIN	= src/asm/main.asm
BIN	= bin/Vera.rom
HEX	= bin/Vera.hex

## Directories

SOURCED	= src/
ASMDOCD	= doc/asmdoc/
LAYOUTD	= doc/layout/

## Targets

default : $(DEPS)
	chmod +x $(ASS)
	chmod +x $(HEX2ROM)
	mono $(ASS) $(MAIN) $(HEX)
	mono $(HEX2ROM) $(HEX) $(BIN)

run :
	$(EMU) $(BIN)

asmdoc :
	$(ASMDOC) $(SOURCED) $(ASMDOCD) $(LAYOUTD)

pti :	
	chmod +x $(PTI)
	$(PTI)
	rm -f pti.conf bin/Vera.rom.pti

lincalc:
	chmod +x $(LINCALC)
	$(LINCALC) $(BIN)

