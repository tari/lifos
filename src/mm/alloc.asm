;memory allocation syscalls

;Routine: pushAllocStack
;Pushes a new entry onto the allocation stack.  Do not use this unless you
;know exactly what you're doing- use <mAlloc> instead, as this doesn't
;do any error checking.
;
;Inputs:
; HL - address of block to allocate
; DE - size of block at (HL)
;
;Modifies:
; HL, DE
;
;See Also:
; <popAllocStack>, <peekAllocStack>, <mAlloc>, <allocSP>
pushAllocStack:
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

;Routine: popAllocStack
;Removes the top entry from the allocation stack, effectively freeing that
;block.
;
;Modifies:
; HL
;
;See Also:
; <pushAllocStack>, <peekAllocStack>, <mAlloc>
popAllocStack:
	ld hl,(allocSP)
	dec hl
	dec hl
	dec hl
	dec hl
	ld (allocSP),hl
	ret


.module peekAllocStack
;Routine: peekAllocStack
;Returns information about the topmost allocated memory block.
;
;Outputs:
; HL - pointer to block
; DE - size of block at (HL)
;
;Modifies:
; AF
;
;See Also:
; <pushAllocStack>, <popAllocStack>, <mAlloc>
peekAllocStack:
;stack entry = size, then pointer
	ld hl,(allocSP)
	ld de,allocStackBegin
	rst rCPHLDE
	jr z,_nothing
	dec hl
	ld d,(hl)
	dec hl
	ld e,(hl)	    ;Size
	dec hl
    dec hl
	rst rLDHLIND    ;Ptr
	ret
_nothing:
;Nothing allocated, so it's a 0-byte block at 0x8000
    ld hl,08000h
	ld d,l
    ld e,l
	ret
.endmodule


;Routine: mAlloc
;Allocates a block of memory for general use.
;
;Inputs:
; HL - number of bytes to allocate
;
;Outputs:
; HL - pointer to allocated block
;
;Modifies:
; AF, DE, HL
;
;Errors:
; eMem_OutOfRAM - not enough free RAM to allocate a block of the requested
;                 size.
mAlloc:
	push hl
	 call getFreeRAM	;hl=free
	 pop de
	rst rCPHLDE
    ErrorOutC(eMemory, eMem_OutOfRAM)   ;requested > available
	push de
	 call peekAllocStack
	 add hl,de	;hl->free space
	 pop de
	call pushAllocStack
	call peekAllocStack
	CleanExit()
    
;Routine: allocVar
;Moves a variable in RAM from upper memory into an allocated block.
;
;VAT fixup is not yet implemented, so it'll break things unless the chosen
;variable is the lowermost thing in upper RAM.
;
;Inputs:
; <OPN> - variable type and name
;
;Outputs:
; HL - pointer to variable in new location
; DE - size of block at (HL)
;
;Modifies:
; AF, BC, DE, HL, IX, <OSRAM>
;
;Errors:
; eMem_OutOfStack - insufficient space to swap memory across the stack
allocVar:
    call peekAllocStack
    add hl,de
;Routine: allocVarHL
;Allocate a variable as in <allocVar>, but to the given location rather than
;first available block.  Don't use without very good reason.
;
;Inputs:
; HL - address to allocate at
;
;See Also:
; <allocVar>
allocVarHL:
.module allocVar

_writeToBlock .EQU OSRAM        ;running pointer for the var being moved
_readFromBlock .EQU OSRAM+2     ;ditto
_copySize .EQU OSRAM+4          ;remaining size of ""
_oldVarAddr .EQU OSRAM+6        ;Initial location of sought variable (pre-move)
_oldVarVAT .EQU OSRAM+8         ;Target var's VAT pointer
.fail "Debug me!"
    ld (_writeToBlock),hl
_allocateBlock:
;error checking
    call freeStackSpace
;Needs 128 byte buffer, 1 word for any ISR, 4 words scrap, and 1 word safety-net
    ld l,c
    ld h,b
    ld bc,128+12
    or a
    sbc hl,bc
    ErrorOutC(eMemory,eMem_OutOfStack)
_enoughStack:
	call findVar
	jr nc,_exists
    ErrorOut(eMemory,eMem_NoSuchVar)
_exists:
    ld (_oldVarAddr),hl         ;Save location for VAT fixup
    ld (_oldVarVAT), hl         ;..also our VAT entry for fixup
    ld (_readFromBlock),hl
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld (_copySize),hl
    ld (_writeToBlock),de
    ld (_copySize),bc
_loop:
    ld hl,(_copySize)
    ld bc,128
    or a
    sbc hl,bc
    ld (_copySize),hl
    jr nc,_loopSizeOK
    ld bc,(_copySize)       ;sbc underflowed, so < 128 bytes left to swap
_loopSizeOK:                ;bc=amount being moved
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
    ld hl,(_oldVarVAT)		;VAT pointer
    dec hl
    dec hl
    ld (hl),d	;msb of address
    dec hl
    ld (hl),e	;lsb of address
_fixVAT:    ;update the VAT entries of everything in user memory
    ld hl,VAT_begin
    ld bc,(_oldVarAddr)
_fixLoop:
    ld de,(VATEnd)
    rst rCPHLDE
    jr z,_done      ;Fall out after checking all of VAT
    dec hl
    xor a
    cp (hl)
    dec hl          ;HL->address
    ld d,(hl)
    dec hl          ;..address LSB
    ld e,(hl)
    jr nz,_noFixup  ;Skip entry if not in RAM
    ex de,hl        ;DE->VAT, HL=var address
    push hl
     or a
     sbc hl,bc      ;Compare address against old location of freshly allocated var
     pop hl
    ex de,hl        ;HL->VAT, DE=var addr
    jr nc,_noFixup  ;Fine if var is above the one we moved
;No good, need to update the location since this var shifted
    push hl
     push de
      call peekAllocStack
      ld l,e
      ld h,d        ;HL=size of block which moved
      pop de
     add hl,de      ;Fixed address of current var
     ex de,hl
     pop hl         ;HL->VAT, DE=fixed var addr
    ld (hl),e
    inc hl
    ld (hl),d
    dec hl
_noFixup:           ;Location record doesn't need fixup/go to next
    ld de,-11       ;skip name to hit next entry
    add hl,de
    jr _fixVAT
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
