;Packet format:
;Offset|Length|Type
;0      1      Machine ID (MID)
;1      1      Command ID (CID)
;2      2      Length of data - some CIDs don't have data, but this is always here
;4      n      Data (if included)
;4+n    2      Checksum (if data included)

;Incoming packets should have MID 0x23 or 0x73 -
; computer sending 8(3|4)+ data or 8(3|4)+
;Important CIDs:
;0x09   CTS: clear to send (no data)
;0x2D   VER: request version (silent link)
;0x56   ACK: acknowledge (no data)
;0x68   RDY: check if ready to recieve (no data)
;0x92   EOT: end of transmission

;;TALKTI: entry point to handle TI-OS protocol exchanges
;;  Includes variable transfers, remote control, and screenshots
;;Inputs:
;;  A=first byte of exchange recieved
;;Notes:
;;  Trashes OSRAM, and requires additional memory for large packets
TALKTI:
    cp 23h
    jr z,_MID_OK
    cp 73h
    jr nz,_MID_FAIL
    
_MID_FAIL:          ;Abort send with 0x36 CID (REJECT)
    call recvAByte  ;CID
    call _CID_has_data
    push af
     call recvAByte  ;length LSB
     ld e,a
     call recvAByte  ;length MSB
     ld d,a
     pop af
    jr z,_MID_FAIL_SEND
_MID_FAIL_getData:
    call recvAByte
    dec de
    ld a,e
    or d
    jr nz,_MID_FAIL_getData ;got data field
    call recvAByte
    call recvByte           ;checksum
_MID_FAIL_SEND: ;send the rejection packet
    ld a,36h
    call sendPacketHeader   ;MID, CID
    ld hl,1
    call sendHL ;length
    ld a,01h    ;EXIT code
    call sendAByte
    ;all of the above preserve HL
    call sendHL ;checksum
    ;;wait for an ACK in here, maybe?
    ret
    
;Input:
;   A=CID
;Output:
;   ZF set if CID has data field
;   Reset otherwise
;Trashes:
;   HL, B
_CID_hasData:
    ld hl,_CID_hasDataTab
    ld b,_CID_hasDataTabEnd-_CID_hasDataTab
_CID_hasDataSeek:
    cp (hl)
    ret z
    inc hl
    djnz _CID_hasDataSeek
    ret
_CID_hasDataTab:    ;list of CIDs which have data fields
    .db 06h         ;VAR - variable header, NULL padded
    .db 15h         ;DAT - data packet - screenshot/variable/whatever
    .db 36h         ;BRK - break (skip/exit)
    .db 88h         ;DEL - delete - same data as VAR
    .db 0A2h        ;REQ - request variable - VAR data
    .db 0C9h        ;RTS - request to send (VAR)
_CID_hasDataTabEnd: