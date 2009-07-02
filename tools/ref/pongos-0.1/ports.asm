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

__ports_asm:

PortMonitor:
	call ClearScreenTitle
	ld hl,PortMonitorText
	call ConPutS
	push hl
	ld a,(portAddr)
	call ConPutNumHex1
	pop hl
	call ConPutS
	push bc
	ld a,(portAddr)
	ld c,a
	in a,(c)
	pop bc
	push af
	push hl
	call ConPutNumHex1
	pop hl
	call ConPutS
	pop af
	call ConPutNumBin1
	ld a,'b'
	call ConPutChar
	call ConPutNL
	call ConPutNL

	ld a,(portAddr)
	ld hl,PortNames-2
PortMonitorSearchLoop:
	inc hl
	inc hl
	cp (hl)
	jr c,PortMonitorUnknown
	inc hl
	jr nz,PortMonitorSearchLoop
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	jr PortMonitorKnown
PortMonitorUnknown:
	ld hl,UnknownPort
PortMonitorKnown:
	call ConPutS
	call CopySysScreen
	call GetKey

	cp skUp
	jr z,PortMonitorUp
	cp skDown
	jr z,PortMonitorDown
	cp skLeft
	jr z,PortMonitorLeft
	cp skRight
	jr z,PortMonitorRight
	cp skEnter
	jr z,PortMonitorOutput
	cp skG
	jr z,PortMonitorSetAddress
	cp skMode
	jp z,MainMenu
	cp skClear
	jp z,MainMenu
	jr PortMonitor

PortMonitorUp:
	ld a,(portAddr)
	inc a
	ld (portAddr),a
PortMonitor1:
	jp PortMonitor

PortMonitorDown:
	ld a,(portAddr)
	dec a
	ld (portAddr),a
	jr PortMonitor1

PortMonitorLeft:
	ld a,(portAddr)
	sub 16
	ld (portAddr),a
	jr PortMonitor1

PortMonitorRight:
	ld a,(portAddr)
	add a,16
	ld (portAddr),a
	jr PortMonitor1

PortMonitorOutput:
	ld bc,TOPROW+(8*6)
	ld hl,PortMonitorOutputText
	call ConPutS
	call InputHex1
	jr c,PortMonitor1
	ld e,a
	ld a,$1c
	call SetPage
	ld b,e
	ld a,(portAddr)
	ld c,a
	call OutInd
	jr PortMonitor1

PortMonitorSetAddress:
	ld bc,TOPROW+(8*6)
	ld hl,PortMonitorAddressText
	call ConPutS
	call InputHex1
	jr c,PortMonitor1
	ld (portAddr),a
	jr PortMonitor1

PortNames:
	.db $00 \ .dw PN00 \	.db $01 \ .dw PN01
	.db $02 \ .dw PN02 \	.db $03 \ .dw PN03
	.db $04 \ .dw PN04 \	.db $05 \ .dw PN05
	.db $06 \ .dw PN06 \	.db $07 \ .dw PN07
	.db $08 \ .dw PN08 \	.db $09 \ .dw PN09
	.db $0A \ .dw PN0A
	.db $0D \ .dw PN0D

	.db $10 \ .dw PN10 \	.db $11 \ .dw PN11

	.db $14 \ .dw PN14

	.db $20 \ .dw PN20 \	.db $21 \ .dw PN21
	.db $22 \ .dw PN22 \	.db $23 \ .dw PN23

	.db $25 \ .dw PN25 \	.db $26 \ .dw PN26

	.db $29 \ .dw PN29

	.db $30 \ .dw PN30 \	.db $31 \ .dw PN31
	.db $32 \ .dw PN32 \	.db $33 \ .dw PN33
	.db $34 \ .dw PN34 \	.db $35 \ .dw PN35
	.db $36 \ .dw PN36 \	.db $37 \ .dw PN37
	.db $38 \ .dw PN38

	.db $40 \ .dw PN40 \	.db $41 \ .dw PN41
	.db $42 \ .dw PN42 \	.db $43 \ .dw PN43
	.db $44 \ .dw PN44 \	.db $45 \ .dw PN45
	.db $46 \ .dw PN46 \	.db $47 \ .dw PN47
	.db $48 \ .dw PN48

	.db $ff \ .dw UnknownPort

UnknownSEProtPort:
	.db "[SE] * "
UnknownPort:
	.db "Unknown Port",0

PN00:	.db "Direct Link",10
	.db "I: --OO--ii",10
	.db "O: ------OO",0

PN01:	.db "Keypad",10
	.db "I: Keys Not Pressed",10
	.db "O: Inactive Key Groups",0

PN02:	.db "Status",10
	.db "I: h?h???LB",0

PN03:	.db "Interrupt Select",10
	.db "O: ---l??to",0

PN04:	.db "Interrupt Status",10
	.db "I: xxxlO?to",10
	.db "O: ?????SSm",0

PN05:	.db "[SE] Bank 3 RAM",10
	.db "IO: RAM page",0

PN06:	.db "Bank 1 Flash/RAM",10
	.db "IO: absolute page",0

PN07:	.db "Bank 2 Flash/RAM",10
	.db "IO: absolute page",0

PN08:	.db "[SE] DBUS Enable",10
	.db "IO: E-------",0

PN09:	.db "[SE] DBUS Status",10
	.db "I: -eBwo---",0

PN0A:	.db "[SE] DBUS Read",10
	.db "I: data",0

PN0D:	.db "[SE] DBUS Write",10
	.db "O: data",0

PN10:	.db "LCD Control",10
	.db "I: bwpr--mm",10
	.db "O: command",0

PN11:	.db "LCD Data",10
	.db "I: read+inc",10
	.db "O: write+inc",0

PN14:	.db "* Flash Write Enable",10
	.db "O: -------e",0

PN20:	.db "[SE] CPU Speed",10
	.db "IO: -------s",0

PN21 = UnknownSEProtPort

PN22:	.db "[SE] * Begin Restricted",10
	.db "IO: flash page",0

PN23:	.db "[SE] * End Restricted",10
	.db "IO: flash page",0

PN25 = UnknownSEProtPort

PN26 = UnknownSEProtPort

PN29:	.db "[SE] LCD Speed",10
	.db "IO: speed value",0

PN30:	.db "[SE] Timer Mode",10
	.db "IO: mmssssss",0

PN31:	.db "[SE] Timer Loop Control",10
	.db "IO: -----liu",0

PN32:	.db "[SE] Timer",10
	.db "IO: timer value",0

PN33 = PN30

PN34 = PN31

PN35 = PN32

PN36 = PN30

PN37 = PN31

PN38 = PN32

PN40:	.db "[84] Clock Control",10
	.db "IO: ------Sr",0

PN41:	.db "[84] Clock Set Register",10
	.db "IO: one byte of the",10
	.db "    32-bit time value",0

PN42 = PN41

PN43 = PN41

PN44 = PN41

PN45:	.db "[84] Clock",10
	.db "I: one byte of the",10
	.db "   32-bit time value",0

PN46 = PN45

PN47 = PN45

PN48 = PN45

.echo "ports.asm     "\.echo $-__ports_asm\.echo " bytes\n"
