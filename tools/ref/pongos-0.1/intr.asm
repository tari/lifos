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

__intr_asm:

Interrupt:
	ex af,af'
	exx

	ld a,(intCount)
	inc a
	ld (intCount),a

Interrupt_WaitOnKey:
	in a,(4)
	and 8
	jp nz,Interrupt_NoOnKey

	ld a,(calcOn)
	or a
	jr nz,Interrupt_OnFunction_NoPower
	inc a
	ld (calcOn),a
	pop hl
	ld a,3
	call LCDIOut
	ld a,$18
	call LCDIOut
	ld a,1
	call LCDIOut
	ld a,(contrast)
	call LCDIOut
	jr Interrupt_PowerOnWait
Interrupt_OnFunction_NoPower:

	ld bc,0
	call IGetKeyP
	jr z,Interrupt_WaitOnKey

	ld bc,dgCtlKeys*256+dk2nd
	call IGetKeyP
	jr z,Interrupt_No2ndKey
Interrupt_2ndKey:
	call IGetKeyP
	jr nz,Interrupt_2ndKey
	xor a
	ld (calcOn),a
	ld hl,TurnCalcOff
	push hl
	jr Interrupt_PowerOnWait
Interrupt_No2ndKey:

	ld bc,dgCtlKeys*256+dkDel
	call IGetKeyP
	jp nz,0

	ld bc,dgKeys1*256+dkLog
	call IGetKeyP
	jr z,Interrupt_NoLogKey
Interrupt_LogKey:
	call IGetKeyP
	jr nz,Interrupt_LogKey
	ld hl,DebugMode
	push hl
	jr Interrupt_WaitOnKey
Interrupt_NoLogKey:

	ld a,(intCount)
	and $1f
	jr nz,Interrupt_NoOnKey

	ld bc,dgKeys5*256+dkAdd
	call IGetKeyP
	jr z,Interrupt_NoAddKey
Interrupt_AddKey:
	call IGetKeyP
	jr nz,Interrupt_AddKey
	ld a,(contrast)
	add a,4
	jr c,Interrupt_NoAddKey
	ld (contrast),a
	call LCDIOut
	jp Interrupt_WaitOnKey
Interrupt_NoAddKey:

	ld bc,dgKeys5*256+dkSub
	call IGetKeyP
	jr z,Interrupt_NoSubKey
Interrupt_SubKey:
	call IGetKeyP
	jr nz,Interrupt_SubKey
	ld a,(contrast)
	sub 4
	bit 6,a
	jr z,Interrupt_NoSubKey
	ld (contrast),a
	call LCDIOut
	jp Interrupt_WaitOnKey

Interrupt_PowerOnWait:
	in a,(4)
	and 8
	jr z,Interrupt_PowerOnWait

Interrupt_NoSubKey:
Interrupt_NoOnKey:
	xor a
	out (3),a
	ld a,$0f
	out (3),a
	exx
	ex af,af'
	ei
	ret



ForcePoweroff:
	xor a
	ld (calcOn),a
TurnCalcOff:
	di
	push af
	ld a,2
	call LCDIOut
	pop af
OffLoop:
	push af
	ld a,$36
	out (4),a
	ld a,$11
	out (3),a
	pop af
	ei
	halt
	jr OffLoop


DebugMode:
	push hl
	push bc
	push de
	push af
	push ix
	push iy

	ld iy,0
	add iy,sp

	ld hl,sysScreenBuf+12
	ld de,sysScreenBuf+13
	ld (hl),0
	ld bc,12*7-1
	ldir

	ld bc,2
	in a,(6)
	call ConPutNumHex1
	ld a,' '
	call ConPutChar
	ld l,(iy+12)
	ld h,(iy+13)
	call ConPutNumHex
	ld a,' '
	call ConPutChar
	ld l,(iy+14)
	ld h,(iy+15)
	call ConPutNumHex
	ld a,' '
	call ConPutChar
	ld l,(iy+16)
	ld h,(iy+17)
	call ConPutNumHex
	ld a,' '
	call ConPutChar
	ld l,(iy+18)
	ld h,(iy+19)
	call ConPutNumHex
	call CopySysScreen
	call GetKeyW

	ld hl,sysScreenBuf+12
	ld de,sysScreenBuf+13
	ld (hl),0
	ld bc,12*7-1
	ldir
	call CopySysScreen

	pop iy
	pop ix
	pop af
	pop de
	pop bc
	pop hl
	ret

.echo "intr.asm      "\.echo $-__intr_asm\.echo " bytes\n"
