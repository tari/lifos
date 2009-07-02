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

__init_asm:

Boot:
	di
	; Initialize ports
	xor a
	out (0),a		; reset link
	dec a
	out (1),a		; reset keypad
	ld a,$0b
	out (3),a		; default interrupt
	ld a,$76
	out (4),a		; standard int clock
	ld a,$41
	out (7),a		; ram page 1 in bank 3

	in a,(2)
	and $80
	jr z,BootBE

	ld a,$81
	out (7),a		; ram page 1 in bank 3
	dec a
	out (8),a		; reset dbus
	xor a
	out (8),a		; enable dbus
	out (5),a		; ram page 0 in bank 4
	out ($20),a		; cpu clock
	ld a,$14
	out ($29),a		; lcd clock
	xor a
	out ($30),a		; clear timers
	out ($33),a
	out ($36),a
BootBE:
	im 1
	ld sp,0
	ld hl,0
	push hl
	push hl

	ld a,$18		; Reset test mode
	call LCDIOut
	ld a,1			; 8-bit mode
	call LCDIOut
	ld a,$f0		; Contrast
	ld (contrast),a
	call LCDIOut
	ld a,$40		; Vertical shift
	call LCDIOut
	ld a,5			; Downward motion
	call LCDIOut
	ld a,1
	ld (intCount),a
	ld (calcOn),a
	ld a,3
	ld (gameSpeed),a
	xor a
	ld (player1),a
	ld (player2),a
	ld (numbuf+5),a
	ld (hexEditAscii),a
	ld (portAddr),a
	ld hl,$4001
	ld (hexEditAddr),hl
	ld a,8
	ld (hexEditPage),a
	call ResetGame
	call ForcePoweroff
	call ClearScreenTitle
	ld hl,WelcomeText
	call ConPutS
	call CopySysScreen
	call GetKeyW

TopLevel:
	ld sp,0
	ld hl,0
	push hl
	push hl
	jp MainMenu

.echo "init.asm      "\.echo $-__init_asm\.echo " bytes\n"
