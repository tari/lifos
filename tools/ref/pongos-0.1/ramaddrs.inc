;;; -*- ti-asm -*-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                           ;;
;;  PongOS -- what it sounds like                            ;;
;;                                                           ;;
;;  Version 0.0.1                                            ;;
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
;;  implied warranty of MERCHANTIBILTY or FITNESS FOR A      ;;
;;  PARTICULAR PURPOSE. See the GNU General Public License   ;;
;;  for more details.                                        ;;
;;                                                           ;;
;;  You should have received a copy of the GNU General       ;;
;;  Public License along with this program; if not, write    ;;
;;  to the Free Software Foundation, Inc., 59 Temple Place   ;;
;;  - Suite 330, Boston, MA 02111 USA.                       ;;
;;                                                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ramCode		= $8000		; 256
sysScreenBuf	= $8160		; 768 + 96 bytes unused on each side
contrast	= $84C0		; 1
calcOn		= $84C1		; 1
intCount	= $84C2		; 1
slowScroll	= $84C3		; 1
numbuf		= $84C4		; 6
gameSpeed	= $84CA		; 1
player1		= $84CB		; 1
player2		= $84CC		; 1
player1score	= $84CD		; 2
player2score	= $84CF		; 2
ballPos		= $84D1		; 2
ballDir		= $84D3		; 2
player1pos	= $84D5		; 1
player2pos	= $84D6		; 1
randSeed	= $84D7		; 1
hexEditAddr	= $84D8		; 2
hexEditPage	= $84DA		; 1
hexEditAscii	= $84DB		; 1
stringMax	= $84DC		; 1
flashMoveSrc	= $84DD		; 3
flashMoveDest	= $84E0		; 3
flashMoveSize	= $84E3		; 2
portAddr	= $84E5		; 1
linkMode	= $84E6		; 1
linkDevType	= $84E7		; 1
varMode		= $84E8		; 1
hdrMode		= $84E9		; 1
varHeader	= $84EA		; 13
dataBuf		= $8500
linkData	= $8600
