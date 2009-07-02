;the dependency macro will live here

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