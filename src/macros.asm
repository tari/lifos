;;EOUT_MACRO: basic handler to cleanly exit from system routines on error.
;;Return carry set with detailed info (if available) at errorCodes.
EOUT_MACRO:
    ex (sp),hl
    inc sp
    inc sp
    inc hl
    inc hl
    ld e,(hl) ;ESub_T
    inc hl
    ld d,(hl) ;ESub_T
    ld (errorCodes),hl
    scf
    ret