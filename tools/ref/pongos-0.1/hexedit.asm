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

__hexedit_asm:

HexEdit:
	call ClearScreenTitle

	ld a,$1c
	call SetPage
	call FlashUnlock

	ld a,(hexEditPage)
	out (6),a
	ld bc,TOPROW
	ld hl,HexEditText
	call ConPutS
	ld hl,(hexEditAddr)
	call HexDisplay

	ld a,$1c
	call SetPage
	call FlashLock
	ei

	call CopySysScreen
	call GetKeyW

	cp skUp
	jr z,HexEditUp
	cp skDown
	jr z,HexEditDown
	cp skLeft
	jr z,HexEditLeft
	cp skRight
	jr z,HexEditRight
	cp skUp|SECOND
	jr z,HexEdit2Up
	cp skDown|SECOND
	jr z,HexEdit2Down
	cp skLeft|SECOND
	jr z,HexEdit2Left
	cp skRight|SECOND
	jr z,HexEdit2Right
	cp skR
	jr z,HexEditSetPage
	cp skG
	jr z,HexEditSetAddress
	cp skEnter
	jp z,HexEditSetByte
	cp skA
	jp z,HexEditToggleAscii
	cp skV
	jp z,HexEditArchiveSkip
	cp skF
	jp z,HexEditFindByte
	cp skE
	jp z,HexEditFindWord
	cp skMode
	jp z,MainMenu
	cp skClear
	jp z,MainMenu
	jr HexEdit

HexEditUp:
	ld bc,-8
HexEditPlus:
	ld hl,(hexEditAddr)
	add hl,bc
	ld (hexEditAddr),hl
	jp HexEdit
HexEditDown:
	ld bc,8
	jr HexEditPlus
HexEditLeft:
	ld bc,-1
	jr HexEditPlus
HexEditRight:
	ld bc,1
	jr HexEditPlus
HexEdit2Up:
	ld bc,-64
	jr HexEditPlus
HexEdit2Down:
	ld bc,64
	jr HexEditPlus
HexEdit2Left:
	ld bc,-256
	jr HexEditPlus
HexEdit2Right:
	ld bc,256
	jr HexEditPlus

HexEditSetPage:
	call ClearScreenTitle
	ld hl,HexEditText
	call ConPutS
	ld hl,HexEditSetPageText
	call ConPutS
	push hl
	ld a,(hexEditPage)
	call ConPutNumHex1
	pop hl
	call ConPutS
	call InputHex1
	jp c,HexEdit
	ld (hexEditPage),a
	jp HexEdit

HexEditSetAddress:
	call ClearScreenTitle
	ld hl,HexEditText
	call ConPutS
	ld hl,HexEditSetAddressText
	call ConPutS
	push hl
	ld hl,(hexEditAddr)
	call ConPutNumHex
	pop hl
	call ConPutS
	call InputHex2
	jp c,HexEdit
	ld (hexEditAddr),hl
	jp HexEdit

HexEditSetByte:
	ld a,(hexEditPage)
	out (6),a
	ld hl,(hexEditAddr)
	ld e,(hl)
	ld a,(hexEditAscii)
	or a
	jr nz,HexEditSetByteAscii
	ld bc,TOPROW+(6*256)+(1*6)
	call InputHex1Under
	jp c,HexEdit
	ld hl,(hexEditAddr)
	ld (hl),a
	jp HexEdit

HexEditSetByteAscii:
	ld bc,TOPROW+(7*256)+(1*6)
	call InputCharUnder
	jp c,HexEdit
	jp z,HexEdit
	ld hl,(hexEditAddr)
	ld (hl),a
	jp HexEdit

HexEditToggleAscii:
	ld a,(hexEditAscii)
	xor 1
	ld (hexEditAscii),a
	jp HexEdit

HexEditFindByte:
	call ClearScreenTitle
	ld hl,HexEditText
	call ConPutS
	ld hl,HexEditFindText
	call ConPutS
	push hl
	call InputHex1
	jp c,HexEdit
	push af

	ld a,$1c
	call SetPage
	call FlashUnlock

	ld a,(hexEditPage)
	out (6),a
	ld hl,(hexEditAddr)

	ld bc,0
	pop af
	cpir
	dec hl
	ld (hexEditAddr),hl

	ld a,$1c
	call SetPage
	call FlashLock
	jp HexEdit

HexEditFindWord:
	call ClearScreenTitle
	ld hl,HexEditText
	call ConPutS
	ld hl,HexEditFindText
	call ConPutS
	push hl
	call InputHex2
	jp c,HexEdit
	push hl

	ld a,$1c
	call SetPage
	call FlashUnlock

	ld a,(hexEditPage)
	out (6),a
	ld hl,(hexEditAddr)

	ld bc,0
	pop de
HexEditFindWordLoop:
	ld a,d
	cpir
	jp po,HexEditFindWordFailed
	ld a,(hl)
	cp e
	jr nz,HexEditFindWordLoop
	dec hl
HexEditFindWordFailed:
	ld (hexEditAddr),hl

	ld a,$1c
	call SetPage
	call FlashLock
	jp HexEdit

HexEditArchiveSkip:
	;; Assuming we are looking at the flag byte of an archived
	;; variable, skip to the next one.
	ld a,(hexEditPage)
	out (6),a
	ld b,a
	ld hl,(hexEditAddr)
	ld a,(hl)
	or 1
	cp $ff
	jr z,HexEditArchiveNextSector
	call Inc_PHL
	ld e,(hl)
	call Inc_PHL
	ld a,(hl)
	ld d,a
	and e
	inc a			; if length=ffff, this is bad, skip this
	jr z,HexEditArchiveNextSector ; sector entirely
	inc de			; add one for the second length byte
	ld a,h
	and $3f
	ld h,a
	add hl,de
	ld a,4
	jr c,HexEditArchiveReallyBig
	ld a,h
	rlca
	rlca
	and 3
HexEditArchiveReallyBig:
	add a,b
	ld (hexEditPage),a
	res 7,h
	set 6,h
	ld (hexEditAddr),hl
	jp HexEdit

HexEditArchiveNextSector:
	ld a,b
	and $fc
	out (6),a
HexEditArchiveNextSectorLoop:
	in a,(6)
	add a,4
	out (6),a
	ld a,($4000)
	cp $ff
	jr z,HexEditArchiveNextSectorLoop
	cp $fe
	jr z,HexEditArchiveNextSectorLoop
	cp $f0
	jr nz,HexEditArchiveFinished
	ld hl,$4001
	ld (hexEditAddr),hl
	in a,(6)
	ld (hexEditPage),a
	jp HexEdit

HexEditArchiveFinished:
	call ClearScreenTitle
	ld hl,ArchiveFinishedText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	ld a,8
	ld (hexEditPage),a
	ld hl,$4001
	ld (hexEditAddr),hl
	jp HexEdit

HexDisplay:
	ld d,8
HexLoop1:
	call ConPutNL
	ld b,1
	ld e,8
	push de
	push hl
	call ConPutNumHex
	ld a,':'
	call ConPutChar
	pop hl
	pop de
	ld b,6
HexLoop2:
	push de
	push hl
	ld a,(hexEditAscii)
	or a
	jr nz,HexDisplayAscii
	ld a,(hl)
	call ConPutNumHex1
	jr HexDisplayOK
HexDisplayAscii:
	ld a,' '
	call ConPutChar
	ld a,(hl)
	call ConPutCharF
HexDisplayOK:
	pop hl
	pop de
	inc hl
	dec e
	jr nz,HexLoop2
	dec d
	jr nz,HexLoop1
	ret


Inc_PHL:
	inc hl
	bit 7,h
	ret z
	res 7,h
	set 6,h
	in a,(6)
	inc a
	out (6),a
	ret

.echo "hexedit.asm   "\.echo $-__hexedit_asm\.echo " bytes\n"
