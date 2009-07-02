;;; -*- mode: TI-Asm; ti-asm-listing-file: "page00.lst" -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                           ;;
;;  PongOS -- what it sounds like                            ;;
;;                                                           ;;
;;  Version 0.1                                              ;;
;;                                                           ;;
;;  Benjamin Moody                                           ;;
;;                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                           ;;
;;  This program is free software; you can redistribute      ;;
;;  and/or modify it under the terms of the GNU General      ;;
;;  Public License as published by the Free Software         ;;
;;  Foundation; either version 2 of the License, or (at      ;;
;;  your option) any later version.                          ;;
;;                                                           ;;
;;  This program is distributed in the hope that it will be  ;;
;;  useful, but WITHOUT ANY WARRANTY; without even the       ;;
;;  implied warranty of MERCHANTABILITY or FITNESS FOR A     ;;
;;  PARTICULAR PURPOSE. See the GNU General Public License   ;;
;;  for more details.                                        ;;
;;                                                           ;;
;;  You should have received a copy of the GNU General       ;;
;;  Public License along with this program; if not, write    ;;
;;  to the Free Software Foundation, Inc., 59 Temple Place   ;;
;;  - Suite 330, Boston, MA 02111 USA.                       ;;
;;                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__keypad_asm:

IGetGroup:
	ld a,$ff
	out (1),a
	ld a,b
	out (1),a
	nop
	nop
	in a,(1)
	ret

IGetKeyP:
	call IGetGroup
	or c
	inc a
	ret

GetGroup:
	di
	call IGetGroup
	ei
	ret

GetGroup_ShiftsDead:
	ld a,b
	cp dgCtlKeys
	jr z,GetGroup_2ndDead
	cp dgKeys1
	jr z,GetGroup_AlphaDead
	jr GetGroup
GetGroup_2ndDead:
	call GetGroup
	or ~dk2nd
	ret
GetGroup_AlphaDead:
	call GetGroup
	or ~dkAlpha
	ret


GetKey:
	ei
	halt
	in a,(4)
	and 8
	ret z

	ld bc,dgArrowKeys*256+0
GetKeyLoop:
	call GetGroup_ShiftsDead
	inc a
	jr nz,GetKeyFound
	ld a,c
	add a,8
	ld c,a
	rlc b
	jr c,GetKeyLoop
	xor a
	ret
GetKeyFound:
	dec a
	push af
GetKeyWaitLoop:
	ei
	halt
	call GetGroup_ShiftsDead
	inc a
	jr nz,GetKeyWaitLoop
	pop af
	ld b,0
GetKeyLoop2:
	inc b
	rra
	jr c,GetKeyLoop2
	ld a,b
	add a,c
	ret

ALPHA = $80
SECOND = $40

GetKeyShifts:
	call GetKey
	ret z
	push af
	ld b,dgKeys1
	call GetGroup
	or dkAlpha
	inc a
	jr z,GetKeyShiftsNoAlpha
	pop af
	or ALPHA
	push af
GetKeyShiftsNoAlpha:
	ld b,dgCtlKeys
	call GetGroup
	or dk2nd
	inc a
	jr z,GetKeyShiftsNo2nd
	pop af
	or SECOND
	push af
GetKeyShiftsNo2nd:
	pop af
	or a
	ret

GetKeyW:
	call GetKeyShifts
	jr z,GetKeyW
	ret

CURSOR = 1

GetKeyCurW:
	ld e,' '
GetKeyCurWUnder:
	push de
	push bc
GetKeyCurWSet:
	pop bc
	push bc
	ld a,CURSOR
	call ConPutChar
	call CopySysScreen
GetKeyCurWLoop:
	ld a,(intCount)
	and $7f
	jr z,GetKeyNoCurW
	call GetKeyShifts
	jr z,GetKeyCurWLoop
	pop bc
	pop de
	push de
	push bc
	push af
	ld a,e
	call ConPutChar
	call CopySysScreen
	pop af
	pop bc
	pop de
	ret
GetKeyNoCurW:
	pop bc
	pop de
	push de
	push bc
	ld a,e
	call ConPutChar
	call CopySysScreen
GetKeyNoCurWLoop:
	ld a,(intCount)
	and $7f
	jr z,GetKeyCurWSet
	call GetKeyShifts
	jr z,GetKeyNoCurWLoop
	pop bc
	pop de
	ret

KeyToHex:
	ld d,$A
	cp skA
	ret z
	inc d
	cp skB
	ret z
	inc d
	cp skC
	ret z
	inc d
	cp skD
	ret z
	inc d
	cp skE
	ret z
	inc d
	cp skF
	ret z
KeyToDec:
	ld d,0
	cp sk0
	ret z
	inc d
	cp sk1
	ret z
	inc d
	cp sk2
	ret z
	inc d
	cp sk3
	ret z
	inc d
	cp sk4
	ret z
	inc d
	cp sk5
	ret z
	inc d
	cp sk6
	ret z
	inc d
	cp sk7
	ret z
	inc d
	cp sk8	
	ret z
	inc d
	cp sk9
	ret

InputHexitUnder:
	add a,'0'
	ld e,a
	cp ':'
	jr c,InputHexitUX
	add a,'A'-':'
	ld e,a
	jr InputHexitUX

InputHexit:
	ld e,' '
InputHexitUX:
	call GetKeyCurWUnder
	cp skMode
	scf
	ret z
	cp skClear
	scf
	ret z
	cp skLeft
	jr z,InputHexitBack
	cp skDel
	jr z,InputHexitBack
	call KeyToHex
	jr nz,InputHexitUnder
	or $ff
	ld a,d
	push af
	call ConPutLowNibble
	pop af
	ret
InputHexitBack:
	dec b
	xor a
	ret

InputHex1Overback:
	inc b
InputHex1:
	call InputHexit
	ret c
	jr z,InputHex1Overback
	add a,a
	add a,a
	add a,a
	add a,a
	push af
	call InputHexit
	pop de
	ret c
	jr z,InputHex1
	add a,d
	ret

InputHex1UOverback:
	inc b
InputHex1Under:
	push de
	ld a,e
	rrca
	rrca
	rrca
	rrca
	and $0f
	call InputHexitUnder
	pop de
	ret c
	jr z,InputHex1UOverback
	add a,a
	add a,a
	add a,a
	add a,a
	ld d,a
	push de
	ld a,e
	and $0f
	call InputHexitUnder
	pop de
	ret c
	jr z,InputHex1Under
	add a,d
	ret

InputHex2Overback:
	inc b
InputHex2:
	call InputHexit
	ret c
	jr z,InputHex2Overback
	add a,a
	add a,a
	add a,a
	add a,a
	ld (dataBuf+1),a
InputHex2_1:
	call InputHexit
	ret c
	jr z,InputHex2
	ld d,a
	ld a,(dataBuf+1)
	add a,d
	ld (dataBuf+1),a
InputHex2_2:
	call InputHexit
	ret c
	jr z,InputHex2_1
	add a,a
	add a,a
	add a,a
	add a,a
	ld (dataBuf),a
InputHex2_3:
	call InputHexit
	ret c
	jr z,InputHex2_2
	ld hl,(dataBuf)
	add a,l
	ld l,a
	ret


InputHex1_Save:
	push hl
	push bc
	call CopySysScreen
	pop bc
	call InputHex1
	pop hl
	ret

InputHex2_Save:
	push hl
	push bc
	call CopySysScreen
	pop bc
	call InputHex2
	ex de,hl
	pop hl
	ret


InputChar:
	ld e,' '
InputCharUnder:
	call GetKeyCurWUnder
	cp skMode
	scf
	ret z
	cp skClear
	scf
	ret z
	cp skLeft
	jr z,InputCharBack
	cp skDel
	jr z,InputCharBack
	ld l,a
	ld h,0
	push de
	ld de,KeyToCharTab
	add hl,de
	pop de
	ld a,(hl)
	or a
	jr z,InputCharUnder
	push af
	call ConPutChar
	pop af
	ret
InputCharBack:
	dec b
	xor a
	ret


InputString:
	xor a
	ld (dataBuf),a
	ld a,d
	ld (stringMax),a
InputStringLoop:
	call InputChar
	ret c
	jr z,InputStringBack
	cp 10
	ret z
	push bc
	 push af
	  ld hl,dataBuf
	  call StrLen
	  ld a,(stringMax)
	  cp b
	  jr z,InputStringFull
	  pop af
	 ld (hl),a
	 inc hl
	 ld (hl),0
	 pop bc
	jr InputStringLoop
InputStringBack:
	push bc
	 ld hl,dataBuf
	 call StrLen
	 ld a,b
	 or a
	 jr z,InputStringOverback
	 dec hl
	 ld (hl),0
	 pop bc
	jr InputStringLoop
InputStringOverback:
	 pop bc
	inc b
	jr InputStringLoop
InputStringFull:
	  pop af
	 pop bc
	dec b
	jr InputStringLoop


StrLen:	ld b,0
StrLenLoop:
	ld a,(hl)
	or a
	ret z
	inc b
	inc hl
	jr StrLenLoop

YesOrNo:
	ld hl,YesOrNoText
	jr YesOrNoX
YesOrNoPrompt:
	ld hl,YesOrNoPromptText
YesOrNoX:
	ld bc,TOPROW+(6*8)
	call ConPutS
	call CopySysScreen
	call GetKeyW
	cp skYEqu
	ret z
	cp skGraph
	jr nz,YesOrNoPrompt
No:	scf
	ret


KeyToCharTab: .db 0
	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 10, 39, "w","r","m","h",0,  0
	.db "?",0,  "v","q","l","g",0,  0
	.db ".","z","u","p","k","f","c",0
	.db " ","y","t","o","j","e","b",0
	.db 0,  "x","s","n","i","d","a",0
	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 0,  0,  0,  0,  0,  0,  0,  0

	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 10, 34, "W","R","M","H",0,  0
	.db "!",0,  "V","Q","L","G",0,  0
	.db ":","Z","U","P","K","F","C",0
	.db " ","Y","T","O","J","E","B",0
	.db 0,  "X","S","N","I","D","A",0
	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 0,  0,  0,  0,  0,  0,  0,  0

	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 10, "+","-","*","/","^",0,  0
	.db "-","3","6","9",")",0,  0,  0
	.db ".","2","5","8","(",0,  0,  0
	.db "0","1","4","7",",",0,  0,  0
	.db 0,  ">","<",0,  "`","~","=",0
	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 0,  0,  0,  0,  0,  0,  0,  0

	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 10,  0,  "]","[",92, "|",0,  0
	.db "_","#","^","(","}",0,  0,  0
	.db 59, "@","%","*","{",0,  0,  0
	.db ")","!","$","&",0,  0,  0,  0
	.db 0,  0,  0,  0,  0,  0,  0,  0
	.db 0,  0,  0,  0,  0,  0,  0,  0

.echo "keypad.asm    "\.echo $-__keypad_asm\.echo " bytes\n"
