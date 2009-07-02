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

__pics_asm:

TitleImage:
;;;SPRITE 96x9x1
.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
.db $E3,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$DB,$1F
.db $D8,$7F,$FF,$FC,$10,$42,$87,$04,$3F,$FD,$B6,$0F
.db $E3,$0F,$FF,$FC,$D3,$4A,$9F,$34,$FF,$FB,$6C,$17
.db $F8,$61,$FF,$FC,$13,$4A,$97,$34,$3F,$FB,$6C,$0F
.db $FF,$0C,$7F,$FC,$F3,$4A,$97,$37,$3F,$FB,$6C,$57
.db $FF,$E1,$BF,$FC,$F0,$48,$87,$04,$3F,$FD,$B6,$AF
.db $FF,$FC,$7F,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$DB,$5F
.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
TitleImageSize = $-TitleImage

BallSprite:
;;; SPRITE 8x5x1
.db %01110000
.db %10011000
.db %10011000
.db %11111000
.db %01110000
.db 0

Paddle1Sprite:
;;;SPRITE 8x9x1
.db %01100000
.db %10100000
.db %10100000
.db %10100000
.db %10100000
.db %10100000
.db %10100000
.db %10100000
.db %01100000
.db 0

Paddle2Sprite:
;;;SPRITE 8x9x1
.db %00000110
.db %00000101
.db %00000101
.db %00000101
.db %00000101
.db %00000101
.db %00000101
.db %00000101
.db %00000110
.db 0

.echo "pics.asm      "\.echo $-__pics_asm\.echo " bytes\n"
