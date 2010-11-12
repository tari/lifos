;memory management syscalls

;Routine: getFreeRAM
;Gets the amount of free RAM
;
;Outputs:
; HL - number of bytes of RAM free
;
;Modifies:
; AF, DE, HL
getFreeRAM:
	call peekAllocStack
	add hl,de			;gets top end of allocated areas
	ld de,(varsLowEnd)	;..and bottom of stored vars
	inc de
	ex de,hl
	or a
	sbc hl,de			;so (varsLowEnd)-[allocation top]
	ret

;Routine: mov11ToOPN
;Copies the 11 bytes at HL into OPN
;
;Inputs:
; HL - pointer to 11 bytes of data to copy to OPN
;
;Outputs:
; Data copied
;
;Modifies:
; HL
mov11ToOPN:
	push de
	push bc
	push af	;ldi modifies P/V
	ld de,OPN
.repeat 11
	ldi		;I didn't want to type 'ldi' 11 times...
.loop
	pop af
	pop bc
	pop de
	ret

;Routine: pagedRead
;Reads bytes from Flash on the given page, in a similar manner to a simple
;ldir copy.  DO NOT USE- IS INCOMPLETE.
;
;Inputs:
; A - Flash page to read from
; HL - address to read from, in the 0x4000 to 0x8000 range.  Other values
;      are valid, but not useful.
; DE - pointer to a buffer to read data into
; BC - number of bytes to read
;
;Outputs:
; Data copied
;
;Modifies:
; AF, BC, DE, HL, <OSRAM>
pagedRead:
_savedPage .EQU OSRAM
    push af
     in a,(6)
     ld (_savedPage),a
     pop af
    out (6),a
    ldir
    ld a,(_savedPage)
    out (6),a
    CleanExit()

;Routine: saveBlockToStack
;Saves a block of memory to the stack, rendering anything else on the stack
;temporarily unacessible.  Useful for moving data around when a small amount
;of scratch space is required and it's possible none will be available from
;the system.
;
;Inputs:
; HL - pointer to block of memory to save to the stack
; BC - size (in bytes) of the block to save
;
;Outputs:
; Block saved to stack
;
;Modifies:
; F, BC, DE, HL.  Interrupts are disabled.
;
;See Also:
; <restoreBlockFromStack>, <freeStackSpace>
saveBlockToStack:
    di
    inc sp
    inc sp          ;Return address, we need this
_sb2S_loop:
    ld d,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ex de,hl
    ex (sp),hl      ;Write a word to the stack, move return addr
    push hl         ;Push return addr back and move sp
    ex de,hl
    dec bc
    ld a,b
    or c
    jr nz,_sb2S_loop
    CleanExit()

;Routine: restoreBlockFromStack
;Restore a previously saved block of data from the stack, as in
;<saveBlockToStack>.
;BUGGY.  DO NOT USE.
;
;Inputs:
; HL - pointer to location to move block to from stack
; BC - size (in bytes) of block to recover
;
;Outputs:
; Block restored
;
;Modifies:
; AF,BC,DE,HL,IX
restoreBlockFromStack:
.fail "FIXME: rewrite to handle odd-sized blocks"
    pop ix ;return address
_loop:
    pop de
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    dec bc
    ld a,b
    or c
    djnz _loop
    push ix
    ret

;Routine: freeStackSpace
;Gets the amount of unused space in the stack.  Mostly only useful when using
;<saveBlockToStack> and <restoreBlockFromStack>, but may be useful for such
;things as detecting stack overflows as well.
;
;Outputs:
; BC - number of bytes free in the stack, as calculated from SP
;
;Modifies:
; AF, BC
freeStackSpace:
    push hl
    ld hl,0
    add hl,sp
    ld bc,(allocSP)
    or a
    sbc hl,bc
    ld c,l
    ld b,h
    pop hl
    ret
