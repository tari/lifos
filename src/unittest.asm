;Various unit tests for all major routines
#IFDEF UNIT_TEST
.module TESTS
#DEFINE test_next() \ pop hl
#DEFCONT            \ inc hl
#DEFCONT            \ push hl
;track current test
    ld hl,0
    push hl
;====Test misc.asm====
;check16
    
    test_next()
;strLen
    ld hl,_compStrsStr
    call strLen
    ld a,b
    cp 12
    call nz,_testFailed
    test_next()
;compStrs
    ld hl,_compStrsStr
    ld de,_compStrsStr
    ld b,13
    call compStrs
    call nz,_testFailed
    ld hl,_compStrsStr
    ld de,_compStrsStr2
    ld b,13
    call z,_testFailed
    call nc,_testFailed
    test_next()
;swapRAM
;    ld de,$8000
;    ld hl,_swapRAMStr
;    ld bc,_swapRAMStr_End-_swapRAMStr
;    ldir
    
_compStrsStr:
    .db "The internet",0
_compStrsStr2:
    .db "Is a series of tubes",0
_testStatusStrs:
    .db "check16 "
    .db "strLen  "
    .db "compStrs"
    .db "swapRAM "
    
_testFailed:
    push hl
    ld hl,_testFailedStr
    call sPutS
    pop hl
    push hl
    add hl,hl
    add hl,hl
    add hl,hl
    ld de,_testStatusStrs
    add hl,de
    ld b,8
_testFailedLoop:
    ld a,(hl)
    inc hl
    call sPutC
    djnz _testFailedLoop
    ld a,$D
    call sPutC
    pop hl
    ret
_testFailedStr:
    .db "Test failed!",$D,0
#ENDIF
