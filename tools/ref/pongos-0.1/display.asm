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

__display_asm:

ClearSysScreen:
	ld hl,sysScreenBuf
	ld de,sysScreenBuf+1
	ld (hl),0
	ld bc,767
	ldir
	ret

ClearScreenTitle:
	call ClearSysScreen
	ld hl,TitleImage
	ld de,sysScreenBuf
	ld bc,TitleImageSize
	ldir
	ld bc,TOPROW
	ret

LCDIOut:
;;; Slow but safe method for sending LCD init commands
	push af
LCDIOut_loop:
	in a,($10)
	and $80
	jr nz,LCDIOut_loop
	pop af
	out ($10),a
	ret

;;; Note: if you want to run at 15 MHz, you'll need to add code to set
;;; 6 MHz for this routine (though you might be better off using
;;; fasterCopy if you're worried about speed)

CopySysScreen:
	ld a,$80
	out ($10),a		; ****
	ld hl,sysScreenBuf+(12*65) ; 10
	ld c,$0C		; 7
	nop
CopySysScreenLoop:
	ld b,64			; 7
	ld a,c			; 4
	set 5,a			; 8
	dec a			; 4
	ld de,-1-(12*64)	; 10
	out ($10),a		; ****
	add hl,de		; 11
	nop			; 4
CopySysScreenSubLoop:		;    (Loop=13)
	ld a,(hl)		; 7
	ld a,(hl)		; 7
	ld a,(hl)		; 7
	ld de,12		; 10
	add hl,de		; 11
	out ($11),a		; ****
	djnz CopySysScreenSubLoop ; 8
	dec c			; 4
	jr nz,CopySysScreenLoop	; 12
	ret

WINTOP = 10*12

ConPutNum:
	ld de,numbuf
	push bc
	call WriteNum
	pop bc
	ld hl,numbuf
ConPutS:
	ld a,(hl)
	inc hl
	or a
	ret z
	call ConPutChar
	jr ConPutS

ConPutNL:
	ld a,c
	add a,6
	ld c,a
	ld b,0
	cp 59
	ret c
	push bc
	push de
	push hl
	ld hl,sysScreenBuf+WINTOP+(12*6)
	ld de,sysScreenBuf+WINTOP
	ld bc,768-WINTOP-(12*6)
	ldir
	ld hl,sysScreenBuf+768-(12*6)
	ld de,sysScreenBuf+1+768-(12*6)
	ld (hl),0
	ld bc,12*6-1
	ldir
	pop hl
	pop de
 	pop bc
	ld a,c
	sub 6
	ld c,a
	ret

ConPutNumBin1:
	ld l,1
	ld h,a
ConPutNumBinLoop:
	ld a,'0'/2
	add hl,hl
	rla
	call ConPutChar
	ld a,l
	or a
	jr nz,ConPutNumBinLoop
	ret

WriteNum:
	;; Right-aligned, padded with spaces
	;; HL = number
	;; DE -> buffer
	push hl
	ld h,d
	ld l,e
	ld (hl),' '
	inc de
	ldi
	ldi
	ldi
	pop hl
WriteNumLoop:
	call DivHLBy10
	add a,'0'
	ld (de),a
	dec de
	ld a,h
	or l
	jr nz,WriteNumLoop
	ret

DivHLBy10:
	ld c,10
DivHLByC:
	xor a
	ld b,16
DivHLByC_Loop:
	add	hl,hl
	rla
	cp	c
	jr	c,DivHLByC_Next
	sub	c
	inc	l
DivHLByC_Next:
	djnz DivHLByC_Loop
	ret


ConPutNumHex:
	ld a,h
	call ConPutHighNibble
	ld a,h
	call ConPutLowNibble
	ld a,l
ConPutNumHex1:
	ld l,a
	call ConPutHighNibble
	ld a,l
	jr ConPutLowNibble
ConPutHighNibble:
	rrca
	rrca
	rrca
	rrca
ConPutLowNibble:
	and $0f
	add a,'0'
	cp ':'
	jr c,ConPutChar
	add a,'A'-':'
ConPutChar:
	;; A = character
	;; B = X-coord / 4
	;; C = Y-coord
	;; (coordinates preserved)
	cp 10
	jp z,ConPutNL
ConPutCharF:
	di
	push hl
	push af
	ld l,c
	ld h,0
	ld d,h
	ld e,l
	add hl,hl
	add hl,de
	add hl,hl
	add hl,hl
	ld e,b
	srl e
	add hl,de
	ld de,sysScreenBuf
	add hl,de
	pop af
	push hl
	ld l,a
	ld h,0
	ld e,a
	ld d,h
	add hl,hl
	add hl,hl
	add hl,de
	ld de,FixedFont
	add hl,de
	pop ix
	ld de,12
	push bc
	bit 0,b
	ld b,5
	jr nz,ConPutCharRotateLoop
ConPutCharNormalLoop:
	ld a,(ix)
	and $0f
	or (hl)
	ld (ix),a
	add ix,de
	inc hl
	djnz ConPutCharNormalLoop
	jr ConPutCharDone
ConPutCharRotateLoop:
	ld a,(hl)
	rrca
	rrca
	rrca
	rrca
	ld c,a
	ld a,(ix)
	and $f0
	or c
	ld (ix),a
	add ix,de
	inc hl
	djnz ConPutCharRotateLoop
ConPutCharDone:	
	pop bc
	pop hl
	ei
	inc b
	ld a,b
	cp 24
	ret c
	call ConPutNL
	ret


GetCoord:
	;; H = X
	;; L = Y
	ld a,h
	ld h,0
	bit 7,l
	jr z,GetCoordPos
	dec h
GetCoordPos:
	ld e,l
	ld d,h
	add hl,hl
	add hl,de
	add hl,hl
	add hl,hl
	ld d,0
	ld e,a
	srl e
	srl e
	srl e
	add hl,de
	ld de,sysScreenBuf
	add hl,de
	and 7
	ret

DrawSprite:
	push de
	call GetCoord
	jr z,DrawSpriteBitAligned
	ld c,a
	ld de,11
	pop ix
DrawSpriteLoop:
	ld a,(ix)
	or a
	ret z
	ld b,c
DrawSpriteSubLoop:
	rra
	rr d
	djnz DrawSpriteSubLoop
	xor (hl)
	ld (hl),a
	inc hl
	ld a,d
	xor (hl)
	ld (hl),a
	ld d,0
	add hl,de
	inc ix
	jr DrawSpriteLoop
DrawSpriteBitAligned:
	ld bc,12
	pop de
DrawSpriteBitAlignedLoop:
	ld a,(de)
	or a
	ret z
	xor (hl)
	ld (hl),a
	add hl,bc
	inc de
	jr DrawSpriteBitAlignedLoop

.echo "display.asm   "\.echo $-__display_asm\.echo " bytes\n"
