__link_begin:
;;Simple half-duplex communication:
;;  Bit values are sent inverted, so they come out as the literal bit on the
;;      other end (write 1 to pull a line low).
;;  Bytes are clocked in MSB first
;;  Sample on falling edge

;Should be enough even when linking 16 MHz->6 MHz
#define HDLP_SEND_BITTIME 16
;Really loose timing here since we can afford to
#define HDLP_RECV_TIMEOUT 256

.module hdlp_sendCByte
;;hdlp_sendCByte: send the byte in C via HDLP
;;Inputs:
;;  C=byte to send
;;Outputs:
;;  None
;;Modifies:
;;  AF, B
;;Errors:
;;  None
hdlp_sendCByte:
    ld b,8
_bitLoop:
    ;Write bit (provide time to stabilize before clocking out)
    xor a
    rlc c
    rla
    xor 1
    out (0),a
    ;Clock out
    set 1,a
    out (0),a
    ;Wait a bit to ensure reception
    ld a,HDLP_SEND_BITTIME     
_bitStall:
    dec a
    jr nz,_bitStall
    ;Release both lines
    xor a
    out (0),a
    ;Next bit or done
    djnz _bitLoop
    or a
    ret         ;Clean exit
.endmodule

.module hdlp_recvCByte
;;hdlp_recvCByte: recieve a byte via HDLP
;;Outputs:
;;  C=byte recieved
;;Modifies:
;;  AF,BC,DE
;;Errors:
;;  
hdlp_recvCByte:
    ld b,8
    ld de,HDLP_RECV_TIMEOUT
_waitClock:     ;Wait for clock to go low
    in a,(0)
    bit 1,a             ;Not in (c) as a safety net against odd port behaviour
    jr z,_bitRotate
    dec de
    ld a,d
    or e
    jr nz,_waitClock
    jr hdlp_timeout     ;Fail out
    ;Rotate bit into result
_bitRotate
    rra
    rl c
    ;Wait for clock high again
    ;(guard against spurious reception from quick re-entry)
    ld de,HDLP_RECV_TIMEOUT
_waitClockH:
    in a,(0)
    bit 1,a
    jr nz,_bitLoopback
    ;Check timeout
    dec de
    ld a,d
    or e
    jr nz,_waitClockH
hdlp_timeout:
    ErrorOut(eLink,eLink_Timeout)
_bitLoopback:
    djnz _waitClock
    or a
    ret         ;clean exit
.endmodule

__link_end:
.echo "link.asm      "\.echo $-__link_begin\.echo " bytes\n"