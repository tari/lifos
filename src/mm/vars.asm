;;Program var types:
;;Unrelocatable (NRP):
;;	Assembled to run only from $8100 in RAM
;;Fully relocatable (FRP):
;;	May be run from anywhere in RAM (uses relative references only)
;;DRP (dynamically relocatable)::
;;	May be run from anywhere in RAM, but must first be dynamically modified by the OS
;;	to account for absolute data references.
;;
;;VAT entry spec:
;;	type | 1 [VtProg*]
;;	page | 1
;;	addr | 2
;;	name | 10
;;New header spec:
;;  size | 2        | Variable size (including header)
;;  version | 2     | Minimum OS version
;;==== Special entries valid only for DRPs ====
;;==== Current DRP header version: 0       ====
;;  headerv | 1     | DRP header version
;;  pdssize | 2     | Size of PDS
;;  pdssig  | 4     | PDS signature
;;  vdssize | 2     | Size of VDS
;;  data    | size  | Program code- main entry point

createVar:
;;createVar: creates a variable
;;Inputs:
;;	HL=requested size of var (must include header for programs, doesn't count size word)
;;	(OPN)=variable type,11 byte name (preceded by type byte)
;;Outputs:
;;	HL->variable data block+2 (just past size word)
;returns HL->data block, so our header can be filled in by them
	push hl		;save var size
	 call getFreeRAM
	pop de
	push de		;still requested size
	 ex de,hl
	 ld bc,14+2	;VAT entry size+size word
	 add hl,bc
	 ex de,hl	;added 16 to requested size, now in de
	 or a
	 sbc hl,de	;check if I have enough RAM
	pop de		;this is the 'real' requested size
    ErrorOutC(eMemory,eMem_OutOfRAM)
_mkVAT:
	push de
	 ld hl,(varsLowEnd)
	 ex de,hl
	 ld hl,(vatEnd)
	 or a
	 sbc hl,de
	 ld c,l
	 ld b,h		;bc=size of vars block
	 push de
	  ex de,hl
	  ld de,-14	;size of VAT entry
	  add hl,de	;hl is copy to location for data block move
	  ex de,hl	;now it's de
	  pop hl
	 inc hl		;copy from hl, yay
	 ld a,b
	 or c		;if the size to copy is 0, we would lddr FFFF bytes..
	 jr z,_lddrSkip
	 lddr		;copy the data block down by 14 bytes, making room for the new VAT entry
_lddrSkip:
	 ld hl,(vatEnd)
	 ld de,-14
	 add hl,de
	 ld (vatEnd),hl		;updated VAT end pointer
	 ld hl,(varsLowEnd)
	 add hl,de
	 ld (varsLowEnd),hl	;fixed varsLowEnd to account for the shift
_vatShiftUpdate:		;account for the shift down of all vars in RAM
;need to account for allocated vars, too (don't 'fix'/break them)
	 call pushall		;easiest way to shove this in here
	  ld hl,usrRAM_top	;VAT begins
_shiftUpdateLoop:
	  ld de,(VATEnd)
	  call cpHLDE
	  jr z,_shiftUpdateDone
;we found a VAT entry
	  dec hl		;HL->page
	  xor a
	  cp (hl)
	  jr nz,_shiftUpdateFlash
;indicated var is in RAM, but allocated?
	  dec hl
	  ld d,(hl)
	  dec hl		;HL->address
	  ld e,(hl)		;DE=address
	  push hl
	   push de
	    call peekAllocStack
	    ex de,hl
	    inc de
	    pop hl		;DE->last entry on alloc stack+1, HL=address of var
	   call cpHLDE	;if HL<DE, jump
	   ex de,hl		;DE=address of var
	   pop hl		;pointer to address is back
	  jr c,_shiftUpdateAllocated
;at this point, the only way we're here is if it got shifted
	  ld bc,-15
	  ex de,hl		;HL=var address, DE->addr
	  add hl,bc
	  ex de,hl		;DE=var addr,HL->addr
	  ld (hl),e
	  inc hl
	  ld (hl),d
	  dec hl
;same pointer as up above, just run through
_shiftUpdateAllocated:	;var is allocated, don't 'fix'/break its address
	  ld de,-11
	  jr _shiftUpdateNext
_shiftUpdateFlash:	;indicated var is in Flash
	  ld de,-13
_shiftUpdateNext:
	  add hl,de
	  jr _shiftUpdateLoop
_shiftUpdateDone:
	  call popall
	 pop de
	inc de
	inc de			;account for the size word in all remaining calculations :)
_mkData:
	push de			;yet again, the requested var size
	 ld a,e
	 cpl
	 ld e,a
	 ld a,d
	 cpl
	 ld d,a			;negate de, so I can add that to varsLowEnd to get the new value for it
	 ld hl,(varsLowEnd)
	 add hl,de
	 ld (varsLowEnd),hl
_writeData:
	 pop de
	inc hl
	ld (hl),e
	inc hl
	ld (hl),d		;wrote the size to the var header
_writeVAT:
	ld hl,(vatEnd)
	inc hl
	ld de,OPN+10
	ld b,10
_nameCopyLoop:
	ld a,(de)
	ld (hl),a
	inc hl
	dec de
	djnz _nameCopyLoop	;wrote name
	ld a,(de)
	ex de,hl
	ld hl,(varsLowEnd)
	inc hl
	ex de,hl
	ld (hl),e
	inc hl
	ld (hl),d		;wrote data ptr
	inc hl
	ld (hl),0		;wrote flash page
	inc hl
	ld (hl),a		;wrote var type
	ex de,hl		;swap, so DE->variable header
	inc hl
	inc hl			;now actual header, not size
	or a
	ret
	
.module findVar
;;findVar: finds a variable
;;Inputs:
;;	OPN=variable type+name (11 bytes)
;;Outputs:
;;	HL->variable data block
;;	DE->VAT entry
;;	A=page (or 0 if in RAM)
;;	Returns carry set if var not found
findVar:
	ld hl,VAT_begin
_typeLoop:
	ld de,(VATEnd)
	call cpHLDE		;should be equal if just past end
	ErrorOutZ(eMemory,eMem_NoSuchVar)
	ld de,OPN
	ld a,(de)
	cp (hl)
	jr z,_typeFits
_typeFail:
	ld de,-14	;size of complete entry
	add hl,de
	jr _typeLoop
_typeFits:
	push hl
	 dec hl		;page
	 dec hl
	 dec hl		;address
	 dec hl		;first byte of name in VAT
	 inc de		;first byte of name at OPN
	 ld b,10
_nameFindLoop:
	 ld a,(de)
	 cp (hl)
	 jr nz,_nameFindMiss
	 dec hl
	 inc de
	 djnz _nameFindLoop
_nameFindHit:
	 pop hl
	push hl
	 dec hl
	 ld a,(hl)	;page
	 dec hl
	 ld d,(hl)	;msn of addr
	 dec hl
	 ld e,(hl)	;lsn of addr
	 pop hl		;VAT entry
	ex de,hl
	or a
	ret
_nameFindMiss:
	 pop hl
	jr _typeFail

.module runProg
runProg:
;;runProg: executes a program stored in RAM
;;Inputs:
;;	OPN=variable name+type
;;Outputs:
;;	Carry set if unable to execute
;;Modifies:
;;	All
	call findVar
    ErrorOutC(eMemory,eMem_NoSuchVar)
	or a
    ErrorOutNZ(eRuntime,eRuntime_Unimplemented) ;program is not in RAM
_existsAndFound:    ;check minimum OS version
    inc hl
    inc hl      ;->version
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ex de,hl
    call getOSVersion
    call cpHLDE
    jr nc,_versionOK
    call deAllocVar ;Need to clean up
    ErrorOut(eRuntime,eRuntime_BadVersion)
_versionOK:         ;check type and dispatch as applicable
	ld a,(de)
	cp VtProgNRP
    jr z,_handleNRP
    cp VtProgDRP
    jr z,_handleDRP
_handleFRP:
    ErrorOut(eRuntime,eRuntime_Unimplemented)

_handleNRP: ;==== NRP runtime handler ====
	call peekAllocStack
	add hl,de		;bottom of free space
	ld de,$8100	    ;where it needs to be
	ex de,hl
	or a
	sbc hl,de
    ErrorOutC(eMemory,eMem_Allocation)  ;something already allocated there
;allocate and run
	ld hl,$8100
	call allocVarHL
	ret c
	call $8100
	or a
	ret
    
_handleDRP: ;==== DRP runtime handler ====
    ErrorOut(eRuntime,eRuntime_Unimplemented)