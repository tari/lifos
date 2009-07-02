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

__menu_asm:

TOPROW = 10
BOTROW = TOPROW+4*6

MainMenu:
	call ClearScreenTitle
	ld hl,MainMenuText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	cp sk1
	jp z,GameMenu
	cp sk2
	jp z,ToolsMenu
	cp sk3
	jr z,HelpScreen
	cp sk4
	jr z,AboutScreen
	cp sk5
	jr nz,MainMenu
	call ForcePoweroff
	jr MainMenu

TopLevelTools:
	ld sp,0
	ld hl,0
	push hl
	push hl
ToolsMenu:
	call ClearScreenTitle
	ld hl,ToolsMenuText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	cp skMode
	jp z,MainMenu
	cp skClear
	jp z,MainMenu
	cp sk1
	jp z,HexEdit
	cp sk2
	jp z,FMCopy
	cp sk3
	jp z,FMEraser
	cp sk4
	jp z,PortMonitor
	cp sk5
	jr z,MainMenu
	jr ToolsMenu


HelpScreen:
	ld hl,HelpScreenText
	call ViewHelp
	jr MainMenu

AboutScreen:
	ld hl,AboutScreenText
	call ViewHelp
	jp MainMenu

ViewHelp:
ViewHelpLoop:
	push hl
	call ClearScreenTitle
	pop hl
	call ConPutS
	push hl
	ld hl,PAKText
	call ConPutS
	call CopySysScreen
	call GetKeyW
	pop hl
	ld a,(hl)
	or a
	jr nz,ViewHelpLoop
	ret


.echo "menu.asm      "\.echo $-__menu_asm\.echo " bytes\n"
