;memory allocation syscalls

pushAllocStack:
;;pushAllocStack: adds an entry to the allocation stack
;;Inputs:
;;	HL->requested block of memory
;;	DE=size of requested block
;;Modifies:
;;	HL,DE
;;Note that this does NO error checking.  AT ALL.  Use mAlloc instead, whenever possible.
	push de
	 ex de,hl		;de->requested
	 ld hl,(allocSP)
	 ld (hl),e
	 inc hl
	 ld (hl),d
	 inc hl
	 pop de			;de=size of requested
	ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ld (allocSP),hl
	ret


popAllocStack:
;;popAllocStack: removes the top allocation stack entry (deallocates a block of memory)
;;Modifies:
;;	HL
	ld hl,(allocSP)
	dec hl
	dec hl
	dec hl
	dec hl
	ld (allocSP),hl
	ret


.module peekAllocStack
peekAllocStack:
;;peekAllocStack: provides information about the top allocated block
;;Outputs:
;;	HL->top allocated block
;;	DE=size of (HL)
;;Modifies:
;;	AF
;stack entry = size, then pointer
	ld hl,(allocSP)
	ld de,allocStackBegin
	call cpHLDE
	jr z,_nothing
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)	;de=size
	dec hl
	push af
	 ld a,(hl)
	 dec hl
	 ld l,(hl)
	 ld h,a		;hl=ptr
	 pop af
	ret
_nothing:
	ld hl,$8000
	ld de,0
	ret


mAlloc:
;;mAlloc: allocates a block of memory
;;Inputs:
;;	HL=amount of memory to allocate
;;Outputs:
;;	HL->allocated block
;;	Carry set if problems
;;Modifies:
;;	AF,DE,HL
	push hl
	 call getFreeRAM	;hl=free
	 pop de
	call cpHLDE	;carry set if DE>HL, so..
	ret c		;fail if requested>available
	push de
	 call peekAllocStack
	 add hl,de	;hl->free space
	 pop de
	call pushAllocStack
	call peekAllocStack
	or a	;ensure I exit with carry reset
	ret
    
;;allocVar: allocates a variable
;;Inputs:
;;    OPN=var name
;;Outputs:
;;	HL->data block
;;	DE=size of allocated block
;;	Variable allocated
;;	Returns eMemory:eMem_OutOfStack/eMem_NoSuchVar if problems
;;Modifies:
;;	AF, BC, DE, HL, IX, OSRAM-(OSRAM+5)
allocVar:
    call peekAllocStack
    add hl,de
;;AllocVarHL: just like allocVar
;;Inputs:
;;    HL=address to allocate at
allocVarHL:
.module allocVar
    ld (_writeToBlock),hl
_allocateBlock:
;error checking
    call freeStackSpace
;Needs 128 byte buffer, 1 word for any ISR, 2 words scrap, and 1 word safety-net
    ld hl,128+8
    or a
    sbc hl,bc
    ErrorOutC(eMemory,eMem_OutOfStack)
_enoughStack:
	call findVar
	jr nc,_exists
    ErrorOut(eMemory,eMem_NoSuchVar)
_exists:
    push de		;save VAT pointer for fixing it later
    ld (_readFromBlock),hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (_copySize),hl
    
_writeToBlock .EQU OSRAM        ;running pointer for the var being moved
_readFromBlock .EQU OSRAM+2     ;ditto
_copySize .EQU OSRAM+4          ;remaining size of ""
    ld (_writeToBlock),de
    ld (_copySize),bc
_loop:
    ld hl,(_copySize)
    ld bc,128
    or a
    sbc hl,bc
    ld (_copySize),hl ;no way bit 15 should be set unless we've underflowed
    jr nc,_loopSizeOK
    ld bc,(_copySize)
_loopSizeOK:    ;bc=amount being moved
    ld hl,(_readFromBlock)
    call saveBlockToStack   ;saved block - now shift everything else up
_shiftOthersUp:
    ex de,hl
    dec de      ;DE->top of new empty block
    push hl     ;grab a copy of the old location and save the new one
     ld hl,(_readFromBlock)
     ex (sp),hl
     ld (_readFromBlock),hl
     pop hl
    dec hl      ;top of block to shift (bottom of new empty-1)
    push bc     ;size of chunk on the stack right now
     ld bc,(varsLowEnd)
     push hl
      or a
      sbc hl,bc
      ld c,l
      ld b,h    ;BC=size of area between HL and varsLowEnd (how much to move)
      pop hl
     lddr
     pop bc     ;now throw the stacked block back into the allocation area
_restoreStacked:
    ld hl,(_writeToBlock)
    call restoreBlockFromStack
    ld (_writeToBlock),hl
_loopbackChk:
    ld hl,(_copySize)
    ld a,h
    or l
    jr nz,_loop
_moveComplete:  ;update this var's VAT entry
    call peekAllocStack
    ex de,hl   ;DE->allocation block
    pop hl		;VAT pointer
    dec hl
    dec hl
    ld (hl),d	;msb of address
    dec hl
    ld (hl),e	;lsb of address
_fixVAT:    ;update the VAT entries of everything in user memory
    ld hl,VAT_begin
_fixLoop:
    
_done:
	call peekAllocStack
	ret			;finished!!
	
deAllocVar:
;;deAllocVar: returns the currently allocated variable to user memory
;;Inputs:
;;	OPN=variable type+name
;;Outputs:
;;	Same as deAlloc
.module deAllocVar
	call findVar
	push de
	 call peekAllocStack
	 inc hl
	 ld b,(hl)
	 dec hl
	 ld c,(hl)		;bc=size
	 add hl,de
	 dec hl			;hl->last byte of data
	 ld de,(varsLowEnd)
	 lddr
	 pop hl
	dec hl
	dec hl			;->addr msb
	ld (hl),d
	dec hl
	ld (hl),e		;updated VAT data pointer
	dec de
	ld (varsLowEnd),de	;updated varsLowEnd
	call deAlloc
	ret

deAlloc:
;;deAlloc: deallocates the top allocated block
;;Outputs:
;;	HL->new top allocated
;;	DE=size of (HL)
	call popAllocStack
	call peekAllocStack
	ret
