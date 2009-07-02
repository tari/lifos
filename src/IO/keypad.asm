keypad_begin:

.module scanKey
scanKey:
    ld d,$FE           
    xor a            
_loop1:
    ld c,1 
    out (c),d
    ld b,8
    in c,(c)
_loop2:
    inc a
    rrc c              
    ret nc
    djnz _loop2
    rlc d             
    jr c,_loop1
    xor a
    ret


waitKey:
	call scanKey
	halt
	or a
	jr z,waitKey
	ret

.echo "keypad.asm      "\.echo $-keypad_begin\.echo " bytes\n"