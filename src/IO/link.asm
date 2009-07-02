__link_begin:
#DEFINE TIMEOUT 0FFFFh
;bit 0=tip/red.  Pull low first for logical 0
;bit 1=ring/white.  Pull low first for logical 1
.module sendAByte
;;sendAByte: sends a byte via the link port
;;\DIV
;;Input:
;;	A=byte to send
;;Output:
;;	Carry set if transmission error
;;Modifies:
;;	af,bc,de
;;\DIV
sendAByte:
	ld c,a
	ld b,8
    ld de,TIMEOUT    ;timeout counter
_loop_byte_send:
	rr c
    ld a,1
	jr nc,_is_reset
	ld a,2
_is_reset:
	out (0),a
_bit_loop:
	in a,(0)
	and 3
	jr z,_bit_done  ;wait for other line low (ack)
	dec de
	ld a,d
	or e            ;if no ack, check timeout and keep waiting
	jr nz,_bit_loop
_link_error:
	scf
	ret
_bit_done:          ;recieved ACK
	xor a
	out (0),a       ;release lines
	ld de,TIMEOUT
_really_done:
	dec de
	ld a,d
	or e
	jr z,_link_error
	in a,(0)
	and 3
	cp 3            ;wait for ACK to be released
	jr nz,_really_done
	djnz _loop_byte_send
	scf
	ccf
	ret
.endmodule

.module recvAByte
recvAByte:
	ld b,8
    ld de,TIMEOUT    ;timeout counter
_waitBit:
    dec de
    ld a,d
    or e
    jr z,_linkError
    in a,(0)
    and 3
    cp 3
    jr z,_waitBit    ;wait until one line is low
_gotBit:
    push af
     rra
     jr nc,_gotBitValue
     scf
_gotBitValue:       ;value gotten is in carry flag
     rl c
     pop af
    and 3           ;mask old link value for ACK (write set to pull low, so it's easy)
    ld de,TIMEOUT/4
    out (0),a
_ackPull:
    dec de
    ld a,d
    or e
    jr nz,_ackPull
    xor a
    out (0),a       ;release ACK
    ret             ;xor resets C, all's well
_linkError:
    scf
    ret
.endmodule

;;sendPacketHeader: sends the header for a given packet type
;;Inputs:
;;  A=CID
sendPacketHeader:
    push af
     ld a,73h
     call sendAByte
     pop af
    push af
     call sendAByte
     pop af
    call _CID_hasData
    ret
    
sendHL:
    ld a,l
    call sendAByte
    ld a,h
    call sendAByte
    ret
    
.include "src/asm/IO/packet.asm"
.echo "link.asm      "\.echo $-__link_begin\.echo " bytes\n"