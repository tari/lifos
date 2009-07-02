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

;;; Secure your calc sort of like the Krolypto password protection,
;;; only better. :)

;;; (Battery-Del will of course still work.  Michael says it's
;;; technically infeasible for any ordinary human to perform the
;;; necessary modifications to write the boot sector.  Your other
;;; options would be to attack the gatearray or the PCB itself,
;;; neither of which sounds promising.)

__password_asm:

passChar = stringMax
Pass_Max = 56

md5_Buffer = $8292
bc_MD5Setup = $408D
bc_MD5Run = $4090

RequirePassword:
	ld a,(password-1)
	inc a
	ret z
	call ClearScreenTitle
	ld hl,PassPromptText
	call ConPutS
	call EnterPassword
	ld de,password
CheckPass:
	ld hl,dataBuf+1
	ld b,16
PasswordCompareLoop:
	ld a,(de)
	cp (hl)
	ret nz
	djnz PasswordCompareLoop
	ret

SetupPassword:
	ld a,(password-1)
	inc a
	jp nz,MainMenu
	call ClearScreenTitle
	ld hl,PassPromptText
	call ConPutS
	call EnterPassword
	ld hl,dataBuf+1
	ld de,dataBuf+128
	ld bc,16
	ldir

	call ClearScreenTitle
	ld hl,PassRepeatText
	call ConPutS
	call EnterPassword
	ld de,dataBuf+128
	call CheckPass
	jr nz,SetupPasswordError
	
	xor a
	ld (dataBuf),a
	ld (flashMoveSrc+2),a
	ld (flashMoveDest+2),a
	ld hl,dataBuf
	ld (flashMoveSrc),hl
	ld hl,password+$4000-1
	ld (flashMoveDest),hl
	ld hl,17
	ld (flashMoveSize),hl
	jp MoveFlash

SetupPasswordError:
	call ClearScreenTitle
	ld hl,PassErrorText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	jp MainMenu


EnterPassword:
	ld b,0
	push bc
	ld a,'%'
	ld (passChar),a
	ld hl,dataBuf
	ld (hl),0
	ld de,dataBuf+1
	ld bc,Pass_Max-1
	ldir
EnterPasswordOverback:
	pop bc
EnterPasswordLoop:
	ld a,(passChar)
	sub 5
	ld e,a
	call GetKeyCurW
	cp skEnter
	jr z,EnterPasswordDone
	cp skDel
	jr z,EnterPasswordBack
	cp skLeft
	jr z,EnterPasswordBack
	push af
	push bc
	xor a
	ld hl,dataBuf
	ld bc,Pass_Max
	cpir
	jr nz,EnterPasswordLoop
	ld (hl),0
	dec hl
	pop bc
	pop af
	ld (hl),a
	ld a,(passChar)
	call ConPutChar
	ld c,TOPROW+(2*6)
	ld a,
	or a
	jr z,EnterPasswordLoop
EnterPasswordBack:
	push bc
	xor a
	ld hl,dataBuf
	cp (hl)
	jr z,EnterPasswordOverback
	ld bc,Pass_Max+1
	cpir
	dec hl
	dec hl
	ld (hl),0
	pop bc
	ld a,b
	or a
	jr nz,EnterPasswordBackC
	ld a,(passChar)
	sub 5
	ld (passChar),a
	ld b,24
EnterPasswordBackC:
	dec b
	jr EnterPasswordLoop
EnterPasswordDone:
	ld hl,PassMD5Size
	ld de,dataBuf+56
	ld bc,8
	ldir
	ld a,$1f
	call SetPage
	call MD5Setup
	ld hl,dataBuf
	ld bc,64
	call MD5Run
	ld hl,md5_Buffer
	ld de,dataBuf+1
	ld bc,16
	ldir
	;; MD5 code scribbles on our screen buffer
	call ClearScreenTitle
	ret

MD5Setup:
	push hl
	ld hl,bc_MD5Setup
	jr BootJumpHL
MD5Run:
	push hl
	ld hl,bc_MD5Run
BootJumpHL:
	push af
	push de
	ld e,(hl)
	inc hl
	ld d,(hl)
	inc hl
	ld a,(hl)
	ex de,hl
	pop de
	out (6),a
	pop af
	ex (sp),hl
	ret

PassMD5Size:
	.dw 64,0,0,0

	.db $ff
password: .export password
	;; put your hash here
	.db $ff,$ff,$ff,$ff
	.db $ff,$ff,$ff,$ff
	.db $ff,$ff,$ff,$ff
	.db $ff,$ff,$ff,$ff

PassPromptText:
	.db "Enter password:",10,10,0

PassRepeatText:
	.db "Re-type:",10,10,0

PassErrorText:
	.db "Passwords didn't match!",0

.echo "password.asm  "\.echo $-__password_asm\.echo " bytes\n"
