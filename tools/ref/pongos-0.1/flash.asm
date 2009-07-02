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

__flash_asm:

FMCopy:
	call ClearScreenTitle
	ld hl,FMCopyText

	call ConPutS
	call InputHex1_Save
	jp c,ToolsMenu
	ld (flashMoveSrc+2),a

	call ConPutS
	call InputHex2_Save
	jp c,ToolsMenu
	ld (flashMoveSrc),de

	call ConPutS
	call InputHex1_Save
	jp c,ToolsMenu
	ld (flashMoveDest+2),a

	call ConPutS
	call InputHex2_Save
	jp c,ToolsMenu
	ld (flashMoveDest),de

	call ConPutS
	call InputHex2_Save
	jp c,ToolsMenu
	ld (flashMoveSize),de

MoveFlash:
	call ClearScreenTitle
	ld hl,FMCopyText
	call ConPutS

	push hl
	ld a,(flashMoveSrc+2)
	call ConPutNumHex1
	pop hl
	call ConPutS

	push hl
	ld hl,(flashMoveSrc)
	call ConPutNumHex
	pop hl
	call ConPutS

	push hl
	ld a,(flashMoveDest+2)
	call ConPutNumHex1
	pop hl
	call ConPutS

	push hl
	ld hl,(flashMoveDest)
	call ConPutNumHex
	pop hl
	call ConPutS

	ld hl,(flashMoveSize)
	call ConPutNumHex

	call YesOrNo
	jp c,ToolsMenu

	call ClearScreenTitle
	ld hl,MovingFlashText
	call ConPutS
	call CopySysScreen

	ld a,(flashMoveDest+1)
	and $80
	jr nz,MoveFlashToRAM

	in a,(2)
	and $80
	rrca
	add a,$40
	ld b,a
	ld a,(flashMoveDest+2)
	cp b
	jr nc,MoveFlashToRAM

	ld a,$1c
	call SetPage
	call FlashUnlock

	ld hl,FlashCopyCode
	ld de,ramCode
	ld bc,FlashCopyCodeSize
	ldir

	di
	call ramCode
	ei
	jr c,MoveFlashError

	ld a,$1c
	call SetPage
	call FlashLock
	ei

MoveFlashDone:
	call ClearScreenTitle
	ld hl,MovedFlashText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	jp MainMenu


MoveFlashToRAM:
	ld hl,(flashMoveSrc)
	ld de,(flashMoveDest)
	ld bc,(flashMoveSize)
MoveFlashToRAMLoop:
	ld a,b
	or c
	jr z,MoveFlashDone

	ld a,(flashMoveSrc+2)
	out (6),a
	ld b,(hl)
	ld a,(flashMoveDest+2)
	out (6),a
	ld a,b
	ld (de),a

	dec bc

	bit 7,h
	inc hl
	jr nz,MoveToRAMSrcNoFlip
	bit 7,h
	jr z,MoveToRAMSrcNoFlip
	res 7,h
	set 6,h
	ld a,(flashMoveSrc+2)
	inc a
	ld (flashMoveSrc+2),a
MoveToRAMSrcNoFlip:

	bit 7,d
	inc de
	jr nz,MoveFlashToRAMLoop
	bit 7,d
	jr z,MoveFlashToRAMLoop
	res 7,d
	set 6,d
	ld a,(flashMoveDest+2)
	inc a
	ld (flashMoveDest+2),a
	jr MoveFlashToRAMLoop


MoveFlashError:
	ld a,$1c
	call SetPage
	call FlashLock
	ei
	call ClearScreenTitle
	ld hl,FlashErrorText
	call ConPutS
	ld hl,PAKText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	jp MainMenu

FMEraser:
	call ClearScreenTitle
	ld hl,EraserText
	call ConPutS
	call InputHex1_Save
	jp c,ToolsMenu
	ld (flashMoveSrc+2),a
	ld e,a

	ld hl,$4000
	in a,(2)
	and $80
	sra a
	rrca
	add a,$1e
	cp e
	jr nz,FMEraserOK
	call ClearScreenTitle
	ld hl,ErasePage1EText
	call ConPutS
	push hl
	call CopySysScreen
	call GetKeyW
	call ClearScreenTitle
	pop hl
	call ConPutS
	call CopySysScreen
	call GetKeyW
	cp sk8
	ld hl,$4000
	jr z,FMEraserOK
	cp sk9
	jp nz,ToolsMenu
	ld hl,$6000
FMEraserOK:
	ld (flashMoveSrc),hl

	call ClearScreenTitle
	ld hl,ErasePageText
	call ConPutS
	push hl
	ld a,(flashMoveSrc+2)
	call ConPutNumHex1
	pop hl
	call ConPutS
	ld hl,(flashMoveSrc)
	call ConPutNumHex

	call YesOrNo
	jp c,ToolsMenu

	di

	ld hl,FlashEraseCode
	ld de,ramCode
	ld bc,FlashEraseCodeSize
	ldir

	ld a,$1c
	call SetPage
	call FlashUnlock

	call ramCode
	jr c,FlashEraseError

	ld a,$1c
	call SetPage
	call FlashLock

	call ClearScreenTitle
	ld hl,ErasePageText
	call ConPutS
	push hl
	ld a,(flashMoveSrc+2)
	call ConPutNumHex1
	pop hl
	call ConPutS
	ld hl,(flashMoveSrc)
	call ConPutNumHex
	ld hl,DoneText
	call ConPutS
	call CopySysScreen
	call GetKeyW

	jp MainMenu

FlashEraseError:
	ld a,$1c
	call SetPage
	call FlashLock
	ei
	call ClearScreenTitle
	ld hl,FlashEraseErrorText
	call ConPutS
	ld hl,PAKText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	jp MainMenu

;;; A "brief" introduction to the FlashROM is perhaps in order.

;;; Commands are sent to the Flash chip by ordinary write cycles.
;;; Keep in mind that a physical address pppppdddddddddddddd
;;; corresponds to a logical address 000ppppp:01dddddddddddddd.

;;; Any unrecognized command, including an attempt to read data, will
;;; reset the chip.  Thus you cannot execute code to write Flash from
;;; within Flash; the code must be copied into RAM and executed there.

;;; When the chip is busy programming or erasing, commands written are
;;; usually ignored.  Reading from the appropriate address will give
;;; status information.

;;;  <AA>: Write AA to address *AAAA
;;;  <55>: Write 55 to address *5555
;;;  [nn]: Write nn to address *AAAA
;;;  (nn): Write nn to any relevant address
;;;  {nn}: Write nn anywhere, address doesn't matter

;;; The commands for the BE (AMD Am29F400B) are:
;;;
;;;  {30}                        Resume suspended erase operation
;;;
;;;  <AA><55>[80]<AA><55>[10]    Automatically erase entire chip
;;;
;;;  <AA><55>[80]<AA><55>(30)    Automatically erase single sector
;;;
;;;  <AA><55>[90]                Read auto-select data
;;;                               (device ID, manufacturer, and sector
;;;                               protect states; used by an embedded
;;;                               device that supports many similar
;;;                               Flash chips but doesn't know which
;;;                               will be used; unneeded since the
;;;                               TI's provide port 2 for this
;;;                               purpose)
;;;
;;;  <AA><55>[A0](xx)            Program one byte
;;;
;;;  {B0}                        Temporarily suspend current erase operation
;;;
;;;  {F0}                        Reset (return to read mode)

;;; The SE (Fujitsu MBM29LV160) supports all of the above plus:
;;;
;;;  <AA><55>[20]                Enable fast programming mode
;;;
;;;  {90}{F0}                    Exit fast mode
;;;
;;;  {A0}(xx)                    Program one byte while in fast mode
;;;
;;;  [98]                        Read CFI (Common Flash Interface) data
;;;                               (a generalization of the same
;;;                               concept as autoselect; the system
;;;                               can find out everything it needs to
;;;                               know -- size of the chip, sizes of
;;;                               sectors, supported command set --
;;;                               and a whole lot more besides.
;;;                               Again, the TI's don't need this.)

;;; If you want to write your own code for accessing Flash, you should
;;; of course read the official documentation, particularly the
;;; section on the status bits.

;;; AMD says that the chip will usually take about 7 microseconds to
;;; program one byte.  It will vary.

;;; It will take about one *second* to erase a sector (plus the time
;;; it takes to automatically program every bit in the sector.)  It
;;; might be nice to try to get some useful work done in that time.

FlashCopyCode:
FlashCopyLoop:
	;; Copies the data in (flashMove...)

	ld hl,(flashMoveSize)
	ld a,h
	or l
	jp z,FlashCopyRet-FlashCopyCode+ramCode

	ld a,l
	or a
	jr nz,FlashCopy_NoDisplay
	ei
	push hl
	ld bc,TOPROW+(3*6)
	call ConPutNum
	call CopySysScreen
	pop hl
	di
FlashCopy_NoDisplay:
	dec hl
	ld (flashMoveSize),hl

	;; Get data to write
	ld a,(flashMoveSrc+2)
	out (6),a
	ld hl,(flashMoveSrc)
	ld b,(hl)

	di
	ld a,$F0
	ld (0),a

	;; Electron dance
	ld a,2
	out (6),a
	ld a,$AA
	ld ($6AAA),a
	ld a,1
	out (6),a
	ld a,$55
	ld ($5555),a
	ld a,2
	out (6),a
	ld a,$A0
	ld ($6AAA),a

	ld a,(flashMoveDest+2)
	out (6),a
	ld hl,(flashMoveDest)
	ld (hl),b		; write out

;;; No sense in waiting for the write to complete before we
;;; work out the next set of addresses
	ex de,hl
	ld hl,(flashMoveSrc)
	bit 7,h			; no page flipping in RAM
	inc hl
	jr nz,FlashCopySrcNoFlip
	bit 7,h
	jr z,FlashCopySrcNoFlip
	res 7,h
	set 6,h
	ld a,(flashMoveSrc+2)
	inc a
	ld (flashMoveSrc+2),a
FlashCopySrcNoFlip:
	ld (flashMoveSrc),hl

	ld hl,(flashMoveDest)
	inc hl
	bit 7,h
	jr z,FlashCopyDestNoFlip
	res 7,h
	set 6,h
	ld a,(flashMoveDest+2)
	inc a
	ld (flashMoveDest+2),a
FlashCopyDestNoFlip:
	ld (flashMoveDest),hl
	ex de,hl

	ld a,b
	and $80
	ld b,a

FlashCopyVerifyLoop:
	ld a,(hl)		; if bit 7 correct, the write finished
	xor b			; successfully
	jp p,FlashCopyLoop-FlashCopyCode+ramCode
	bit 5,a			; if the write has not completed, bit 5
	jr z,FlashCopyVerifyLoop ; tells us if there has been an error
	ld a,(hl)
	xor b			; AMD says to re-check in case you chose to
	jp m,FlashCopyError-FlashCopyCode+ramCode ; read the status at just
	jr FlashCopyVerifyLoop	                  ; the wrong time.
FlashCopyRet:
	ld a,$F0
	ld (0),a		; reset Flash chip
	or a
	ret
FlashCopyError:
	;; If this happens, it's probably because you did something
	;; wrong (tried to program a 1 over a 0, or tried to program
	;; page 1F.)
	ld a,$F0
	ld (0),a		; reset Flash chip
	scf
	ret

FlashCopyCodeSize = $-FlashCopyCode


FlashEraseCode:
	;; Erases a sector

	;; Electron dance
	ld a,2
	out (6),a
	ld a,$AA
	ld ($6AAA),a
	ld a,1
	out (6),a
	ld a,$55
	ld ($5555),a
	ld a,2
	out (6),a
	ld a,$80
	ld ($6AAA),a

	ld a,$AA
	ld ($6AAA),a
	ld a,1
	out (6),a
	ld a,$55
	ld ($5555),a

	ld a,(flashMoveSrc+2)
	out (6),a
	ld a,$30
	ld hl,(flashMoveSrc)
	ld (hl),a

FlashEraseLoop:
	ld a,(hl)
	bit 7,a
	jr nz,FlashEraseDone
	bit 5,a
	jr z,FlashEraseLoop
	ld a,(hl)
	rla
FlashEraseDone:
	ld a,$F0
	ld (0),a
	ret
FlashEraseCodeSize = $-FlashEraseCode

SetPage:
	;; Set local page corresponding to given BE page

	;; Bit    7,in(2)  5,in(2)  0,in(21)
	;; ---------------------------------
	;; 83+BE  0        N/A      N/A
	;; 83+SE  1        0        1
	;; 84+BE  1        1        0
	;; 84+SE  1        1        1

	cp $18
	jr c,SetPageAbs
	ld b,a
	in a,(2)
	and $80
	jr z,SetPageBE
	in a,($21)
	and 1
	rrca
	rrca
	or $20
SetPageBE:
	or b
SetPageAbs:
	out (6),a
	ret

.echo "flash.asm     "\.echo $-__flash_asm\.echo " bytes\n"
