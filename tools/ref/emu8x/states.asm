Emulation_Store:
	;Save a 82/83/85/86 calculator to archive
	ld hl,Emulation_Store_Appvar
	ld de,appvarbase
	ld bc,9
	ldir
	call Emulation_Appvar_Correction
	ld (appvarbase+4),a
	;Now check if a state already exists
	ld hl,Store_Go
	push hl
	ld a,(calculatorModel)
	cp 3
	ld a,7
	jr z,Store_86_Model
	ld a,3
Store_86_Model:
	ld (lastappvar),a
	ld b,a
Store_Check_Loop:
	push bc
	ld a,b
	call Appvar_Exists
	pop bc
	jp nc,Overwrite_Prompt
	djnz Store_Check_Loop
	pop hl
Store_Go:
	;Now save!
	AppOnErr Store_Error
	B_CALL ClrLCDFull
	ld hl,2*256+3
	ld (currow),hl
	ld hl,Store_Text
	call putstr
	call Store_Clear
	ld a,(calculatorModel)
	cp 3
	ld a,6
	jr z,Store_86
	ld a,2
Store_86:
	ld de,8201h
Store_Loop:
	push de
	push af
	call Store_Page
	pop af
	pop de
	inc d
	inc e
	cp e
	jr nc,Store_Loop
	call Store_Memory
	AppOffErr
	;Display success message!
	B_CALL ClrLCDFull
	B_CALL HomeUp
	ld hl,Store_Text_Done
	call putstr
	B_CALL GetKey
	jp Emulation_Halted
Store_Text_Done:
	DB "Saved! Press any"
	DB "key.",0
Store_Error:
	B_CALL ClrLCDFull
	B_CALL HomeUp
	ld hl,Store_Error_Text
	call putstr
	B_CALL GetKey
	jp Emulation_Halted
Store_Error_Text:
	DB "Memory error.   "
	DB "Insufficent free"
	DB "RAM or archive.",0
Store_Text:
	DB "Processing...",0
Store_Memory:
	ld a,(lastappvar)
	add a,'0'
	ld (appvarbase+8),a
	ld hl,appvarbase
	rst 20h
	ld hl,768*2
	B_CALL CreateAppVar
	inc de
	inc de
	ld hl,appbackupscreen
	ld bc,768
	ldir
	push de
	di
	ld a,84h
	out (7),a
	ld hl,8000h
	call CopyLayer
	ld a,81h
	out (7),a
	ld hl,plotsscreen
	push hl
	call SaveDisplay
	pop hl
	pop de
	ld bc,768
	ldir
	B_CALL OP4ToOP1
	B_CALL Arc_Unarc
	ret
Store_Page:
	;Stores RAM page D into appvar E
	ld a,e
	add a,'0'
	ld (appvarbase+8),a
	ld hl,appvarbase
	push de
	rst 20h
	ld hl,4000h
	B_CALL CreateAppVar
	inc de
	inc de
	pop hl
	;RAM page D!
	di
	ex af,af'
	ld a,h
	ex af,af'
	ld bc,4000h
	ld hl,8000h
Store_Page_Loop:
	ex af,af'
	out (7),a
	ex af,af'
	ld a,(hl)
	push af
	ld a,81h
	out (7),a
	pop af
	ld (de),a
	inc de
	cpi
	jp pe,Store_Page_Loop
	B_CALL OP4ToOP1
	B_CALL Arc_Unarc
	ei
	ret
Overwrite_Prompt:
	B_CALL ClrLCDFull
	B_CALL HomeUp
	ld hl,Overwrite_Text
	call putstr
	ld de,7
	ld (currow),de
	call putstr
Overwrite_Loop:
	B_CALL GetKey
	cp kYequ
	ret z
	pop hl
	cp kGraph
	jp z,Emulation_Halted
	cp kQuit
	jp z,Emulation_Halted
	push hl
	jr Overwrite_Loop
Overwrite_Text:
	DB "Overwrite       "
	DB "existing files?",0
	DB "Yes          No",0
Appvar_Exists:
	;Input - A contains the "page" (1,2 for 82/83/85, 1-6 for 86)
	add a,'0'
	ld (appvarbase+8),a
	ld hl,appvarbase
	rst 20h
	B_CALL ChkFindSym
	ret
Emulation_Appvar_Correction:
	ld hl,calculatorModel
	ld a,(hl)
	srl a
	add a,(hl)
	add a,'2'
	ret
Store_Clear:
	ld a,(lastappvar)
	ld b,a
Store_Clear_Loop:
	push bc
	ld a,b
	call Appvar_Exists
	jr c,$F
	B_CALL DelVarArc
$$:
	pop bc
	djnz Store_Clear_Loop
	ret
Emulation_Store_Appvar:
	DB AppVarObj,"TI8xRAM"
Recall_NoExist:
	B_CALL ClrLCDFull
	B_CALL HomeUp
	ld hl,Recall_Error_Exist
	call putstr
	B_CALL GetKey
	jp Emulation_Halted
Recall_Error_RAM:
	B_CALL ClrLCDFull
	B_CALL HomeUp
	ld hl,Recall_Error_RAM_1
	B_CALL GetKey
	jp Emulation_Halted
Recall_Error_Exist:
	DB "One or more     "
	DB "appvars missing.",0
Recall_Error_RAM_1:
	DB "The saved       "
	DB "appvars must be "
	DB "archived.",0
Recall_Page:
	;Loads RAM page D from appvar E
	ld a,e
	push de
	add a,'0'
	ld (appvarbase+8),a
	ld hl,appvarbase
	rst 20h
	B_CALL ChkFindSym
	di
	ex af,af'
	ld a,b
	out (7),a
	ex af,af'
	ex de,hl
	ld de,14h
	add hl,de
	set 7,h
	res 6,h
	ld bc,4000h
	pop de
	res 7,d
	ld a,d
	out (5),a
	ld de,0C000h
Recall_Page_Loop:
	ldi
	jp po,Recall_Page_Done
	bit 6,h
	jr z,Recall_Page_Loop
	res 6,h
	ex af,af'
	inc a
	out (7),a
	ex af,af'
	jr Recall_Page_Loop
Recall_Page_Done:
	xor a
	out (5),a
	ld a,81h
	out (7),a
	ei
	ret
Emulation_Recall:
	ld hl,Emulation_Store_Appvar
	ld de,appvarbase
	ld bc,9
	ldir
	call Emulation_Appvar_Correction
	ld (appvarbase+4),a
	;Now we need to make sure that each and every appvar is present before loading.
	ld a,(calculatorModel)
	cp 3
	ld a,7
	jr z,Recall_86_Special
	ld a,3
Recall_86_Special:
	ld (lastappvar),a
	ld b,a
Recall_Check_Loop:
	push bc
	ld a,b
	call Appvar_Exists
	ld a,b
	pop bc
	jp c,Recall_NoExist
	or a
	jp z,Recall_Error_RAM
	djnz Recall_Check_Loop
	;All of them exist
	ld a,(calculatorModel)
	cp 3
	ld a,6
	jr z,Recall_86
	ld a,2
Recall_86:
	ld de,8201h
Recall_Loop:
	push de
	push af
	call Recall_Page
	pop af
	pop de
	inc d
	inc e
	cp e
	jr nc,Recall_Loop
	call Recall_Memory
	jp Emulation_Resume
Recall_Memory:
	ld a,(lastappvar)
	add a,'0'
	ld (appvarbase+8),a
	ld hl,appvarbase
	rst 20h
	B_CALL ChkFindSym
	ex de,hl
	ld de,14h
	add hl,de
	ld a,b
	ld de,appbackupscreen
	ld bc,768
	push hl
	push af
	B_CALL FlashToRam
	pop af
	pop hl
	ld b,a
	ld a,(calculatorModel)
	cp 3
	ret z
	ld a,b
	ld de,768
	add hl,de
	ld de,plotsscreen
	ld bc,768
	B_CALL FlashToRam
	di
	ld a,4
	out (5),a
	ld hl,plotsscreen
	ld de,0C000h
	ld bc,768
	ldir
	xor a
	out (5),a
	ei
	ret
