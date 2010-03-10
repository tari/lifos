__link_begin:
#DEFINE TIMEOUT 0FFFFh
;;Link protocol outline:
;;The sending device pulls one of the link lines low to send a bit.  Bit 0 of
;; port 0 for socket tip, and bit 1 for the ring.  Pulling the tip low first
;; indicates a logical 0, ring first is a logical 1.
;;Recieving device pulls other line low to acknowledge receipt, and waits for
;; sending device to release the line.  Finally, sending device waits for
;; recieving device to release the ACK line.

LINK_TIMEOUT:
	ErrorOut(eLink,eLink_Timeout)
LINK_ERROR:
	ErrorOut(eLink,eLink_Generic)

;;Sends the value in A out via the link port (TI-OS protocol), using the link
;; assist if available.
;;Inputs:
;;	A: byte to send
;;Outputs:
;;	None
;;Modifies:
;;	See sendCByte
;;Errors:
;;	eLink/eLink_Timeout: if routine recieves no ACK within ~.25 seconds
sendAByte:
	ld c,a
sendCByte:
	di		;;TODO: conditionally re-enable when done
;	call is83PBE
;	jr z,_sendCByteLA
	ld b,8
_sendLoop:
	ld de,TIMEOUT
	rr c
	jr nc,_sendLowBit
	ld a,2
	jr _sendContinue
_sendLowBit:
	ld a,1
_sendContinue:
	out (0),a
_sendAckWait:	;wait for other line low (ACK)
	in a,(0)
	and 3
	jr z,_sendBitDone
	in a,(0)
	and 3
	jr z,_sendBitDone
	dec de
	ld a,d
	or e
	jp nz_sendAckWait
	jr LINK_TIMEOUT
_sendBitDone:
	xor a
	out (0),a	;clear pulls
	ld de,TIMEOUT
_sendBitReallyDone:
	dec de
	ld a,d
	or e
	jr z,LINK_TIMEOUT
	in a,(0)
	and 3
	cp 3		;wait for other line to release
	jr nz,_sendBitReallyDone
	djnz _sendLoop
	ei
	CleanExit()

recvAByte:
	call recvCByte
	ld a,c
	ret
	
;;Modifies:
;;	AF,BC,DE
recvCByte:
	push hl
	di			;;TODO: replace with contitional re-enablement of interrupts
	;call is83PBE
	;jr z,_recvLA_SE
	;;TODO: actually use link assists
_recvLA_SE:
_recvBE:
	ld b,8
	ld de,TIMEOUT
_recvCLoop:
	in a,(0)
	and 3
	jr nz,_recvC
	dec de
	ld a,d
	or e
	jr nz,_recvCLoop
	jp LINK_TIMEOUT
_recvC:
	cp 1		;..meaning sent a logical 0
	jr z,_recvCAck
	scf			;`and` reset carry earlier
_recvCAck:
	rl c		;carry reflects recieved bit
	xor 3
	ld h,a		;expected link state when send is released
	out (0),a	;send ACK
	ld de,TIMEOUT
_recvCAckWait:
	in a,(0)
	cp h
	jr z,_recvCReleaseAck
	dec de
	ld a,d
	or e
	jr nz,_recvCAckWait
	jp LINK_TIMEOUT
_recvCReleaseAck:
	xor a
	out (0),a	;release ACK
	djnz _recvCLoop
	ei
	pop hl
	CleanExit()
	

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
    
.include "src/IO/packet.asm"
__link_end:
.echo "link.asm      "\.echo $-__link_begin\.echo " bytes\n"