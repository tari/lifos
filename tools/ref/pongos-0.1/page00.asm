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

;******** Page 0 ********

#include "ramaddrs.inc"
#include "dkeys.inc"
#include "scancode.inc"
#include "page1C.exp"

.org $0000

	jp Boot

.org $0008

	;; RST 08
	ret

.org $0010

	;; RST 10
	ret

.org $0018

	;; RST 18
	ret

.org $0020

	;; RST 20
	ret

.org $0026

	;; 0026 = special flag for TI-73 ???
	nop

.org $0028

	;; RST 28
	ret

.org $0030

	;; RST 30
	ret

.org $0038

	;; RST 38 = IM 1 Interrupt
	di
	jp Interrupt

.org $0053

	;; 0053 = boot code returns here after a reset
	jp Boot

	;; 0056 = flag identifying a prevalidated OS
	.db $5A,$A5
	
.org $0064
	;; 0064 = version number string
	.db "0.1 PongOS",0


	;; VTI detection string - doesn't matter where we put
	;; this. Here is as good as anywhere.
#ifdef VTI_DETECT_TI73
	.db "EXPLORER",0
#else
	.db "TI-83 Plus",0
#endif


#include "intr.asm"
#include "init.asm"
#include "display.asm"
#include "keypad.asm"

#include "menu.asm"
#include "game.asm"
#include "hexedit.asm"
#include "flash.asm"
#include "ports.asm"

#include "font.asm"
#include "pics.asm"
#include "text.asm"

.db "PongOS v0.1 by Benjamin Moody "
.db "-- END OF PAGE 00 --"

.echo "Page 00: "\.echo $\.echo " bytes total\n"

#ifndef QUICK_INSTALL
.org $3fff
	rst 38h
#endif

.end
END
