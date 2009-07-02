;;; -*- mode: TI-Asm; ti-asm-listing-file: "page1C.lst" -*-
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

;******** Page 1C ********

.org $4000

	.db "0.1 PongOS",0

FlashUnlock:	.export FlashUnlock
	ld a,i
	push af
	di
	ld a,1
	nop
	nop
	im 1
	di
	out ($14),a
	pop af
	ret po
	ei
	ret

FlashLock:	.export FlashLock
	ld a,i
	push af
	di
	xor a
	nop
	nop
	im 1
	di
	out ($14),a
	pop af
	ret po
	ei
	ret

OutInd:	.export OutInd
	;; Output B to port C  (except port 6 because that's dumb)
	di
	ld a,c
	cp 6
	ret z
	cp $14
	jr z,Out14
	cp $21
	jr z,Out21
	cp $22
	jr z,Out22
	cp $23
	jr z,Out23
	cp $25
	jr z,Out25
	cp $26
	jr z,Out26
	out (c),b
	ret

Out14:				; Flash write-enable flip-flop
	ld a,b
	nop
	nop
	im 1
	di
	out ($14),a
	ret

Out21:				; Unknown protected port (83+SE 1.00 sets $01)
	ld a,b			; (hardware version, recorded by boot code?)
	nop
	nop
	im 1
	di
	out ($21),a
	ret

Out22:				; Beginning of restricted area
	ld a,b
	nop
	nop
	im 1
	di
	out ($22),a
	ret

Out23:				; End of restricted area
	ld a,b
	nop
	nop
	im 1
	di
	out ($23),a
	ret

Out25:				; Unknown protected port (83+SE 1.00 sets $10)
	ld a,b
	nop
	nop
	im 1
	di
	out ($25),a
	ret

Out26:				; Unknown protected port (83+SE 1.00 sets $20)
	ld a,b
	nop
	nop
	im 1
	di
	out ($26),a
	ret

.db "PongOS v0.1 by Benjamin Moody "
.db "-- END OF PAGE 1C --"

.echo "Page 1C: "
.echo $-$4000
.echo " bytes total\n"

#ifndef QUICK_INSTALL
.org $7fff
	rst 38h
#endif

.end
END
