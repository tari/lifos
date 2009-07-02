;memory management syscalls
getFreeRAM:
;;getFreeRAM: returns the amount of free RAM
;;Output:
;;	HL=amount of free RAM
;;Modifies:
;;	AF,HL,DE
	call peekAllocStack
	add hl,de			;gets top end of allocated areas
	ld de,(varsLowEnd)	;..and bottom of stored vars
	inc de
	ex de,hl
	or a
	sbc hl,de			;so (varsLowEnd)-[allocation top]
	ret

mov11ToOPN:
;;mov11ToOP2: copies the 11 bytes at (HL) to OPN
;;Input:
;;	HL->string/whatever
;;Modifies:
;;	HL
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

;;pagedRead: read bytes from Flash
;;Inputs:
;; HL=address to read from
;; DE->where to write A:(HL)
;; BC=size of block to copy
;;Outputs:
;; Data copied
;;Modifies:
;; AF,BC,DE,HL,AF'
pagedRead:
	di
	ex af,af'
	push af		;saved af'
	 in a,(6)
	 push af	;saved old page
	  ex af,af'	;a= requested page
	  push de
	   out (6),a
	   ldir
	   pop de
	  pop af
	 out (6),a
	 pop af
	ex af,af'
	ei
	ret

;;saveBlockToStack: saves a block of memory to the stack
;;Inputs:
;; HL->block to save
;; BC=size of (HL)
;;Outputs:
;; Block saved to stack
;; HL->point after block saved
;;Modifies:
;; AF
saveBlockToStack:
    push bc
    push de
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ex de,hl
    ex (sp),hl
    dec sp
    dec sp
    ex (sp),hl
    ex de,hl
    dec bc
    ld a,b
    or c
    jr nz,_loop
    pop de
    pop bc
    ret

;;restoreBlockFromStack: restore a previously saved block of memory from the stack
;;Inputs:
;; HL->restore area
;; BC=size of block
;;Outputs:
;; Block restored
;;Modifies:
;; AF,BC,DE,HL,IX
restoreBlockFromStack:
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

;;freeStackSpace: gets the amount of unused stack space
;;Outputs:
;; BC=amount of available stack space
;;Modifies:
;; AF,BC
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
