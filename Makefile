## Tools

ASS 	= tools/asm/Brass.exe
HEX2ROM	= tools/asm/Hex2Rom.exe
ASMDOC	= tools/doc/NaturalDocs

EMU		= tools/emu/pti.sh
PTI		= tools/emu/pindurti.exe
SEND 	= tools/emu/send.exe
LINCALC = tools/emu/lincalc/run.sh

# Don't try to use mono under Cygwin, just run normally
MONO = mono
ifeq ($(shell uname -o),Cygwin)
	MONO = 
endif

## Files

DEPS 	=	src/* \

MAIN	= src/main.asm
BIN	= bin/LIFOS.rom
HEX	= bin/LIFOS.hex

## Directories

SOURCED	= src/
ASMDOCD	= doc/asmdoc/
ASMDOC_PRJD = tools/doc/prj/

## Targets

all $(BIN) $(HEX): $(DEPS)
	chmod +x $(ASS) $(HEX2ROM)
	$(MONO) $(ASS) $(MAIN) $(HEX)
	$(MONO) $(HEX2ROM) $(HEX) $(BIN)

clean:
	rm -f pti.conf $(BIN) $(HEX)
	rm -rf $(ASMDOCD)
	
run : $(BIN)
	chmod +x $(PTI) $(SEND)
	$(PTI) &
	sleep 1
	$(SEND) 0 $(BIN)

#TODO: include the inc directory somehow
asmdoc : $(DEPS)
	mkdir -p $(ASMDOCD)
	$(ASMDOC) -r -i $(SOURCED) -o HTML $(ASMDOCD) -p $(ASMDOC_PRJD)

lincalc: $(DEPS)
	chmod +x $(LINCALC)
	$(LINCALC) $(BIN)
