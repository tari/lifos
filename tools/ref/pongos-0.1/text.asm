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

__text_asm:

WelcomeText:
	     ;;;;----====----====----
	.db 10
	.db "        Welcome!",10
	.db 10
	.db " This is PongOS version",10
	.db " 0.1 by Benjamin Moody.",10
	.db 10
	.db "Don't do anything really"
	.db " dumb ... but have fun!",10
	.db 0


MainMenuText:;;;;----====----====----
	.db "Main Menu >>",10
	.db " 1: Play Pong!",10
	.db " 2: System Tools",10
	.db " 3: Help",10
	.db " 4: About this OS",10
	.db " 5: Poweroff",0

GameMenuText:;;;;----====----====----
	.db "Pong >>",10
	.db " 1: Speed:             ",0
	.db " 2: Left Player:   ",0
	.db " 3: Right Player:  ",0
	.db " 4: New Game",10
	.db " 5: Resume Game",10
	.db " 6: Main menu",0

Score1Text:  ;;;;----====----====----
	.db "Player 1:",0
Score2Text:
	.db "Player 2:",0
PauseText:
	.db "Paused",0
	.db "[ENTER] to continue",0
	.db "[MODE] to quit",0

PlayerHuman:
	.db "Human",0
PlayerComp:
	.db " Calc",0

ToolsMenuText:
	     ;;;;----====----====----
	.db "Tools >>",10
	.db " 1: Hex Editor",10
	.db " 2: Move Flash",10
	.db " 3: Erase Flash",10
	.db " 4: Port Monitor",10
	.db " 5: Main menu",0

HexEditText: ;;;;----====----====----
	.db "Hex Edit >>",0

HexEditSetPageText:
	.db 10,10," Current page: ",0
	.db 10," New page: ",0

HexEditSetAddressText:
	.db 10,10," Current address: ",0
	.db 10," New address: ",0

ArchiveFinishedText:
	.db 10,10
	.db "No further archive data",10
	.db "available.",10,0

HexEditFindText:
	.db 10,10," Find: ",0

FMCopyText:
	     ;;;;----====----====----
	.db "Flash Copy >>",10
	.db " Source Page: ",0,10
	.db " Address:     ",0,10
	.db " Dest Page:   ",0,10
	.db " Address:     ",0,10
	.db " Size:        ",0

MovingFlashText:
	.db "Flash Mover >>",10
	.db 10
	.db "Please Wait...",0

MovedFlashText:
	.db "Flash Mover >>",10
DoneText:
	.db 10
	.db "Done!!",0

EraserText:
	.db "Flash Eraser >>",10
	.db " Page address: ",0

ErasePage1EText:
	     ;;;;----====----====----
	.db "Flash Eraser >>",10
	.db "It is a SERIOUSLY BAD",10
	.db "IDEA to erase one of",10
	.db "these sectors unless you"
	.db "know what you're doing."
	.db 10
	.db "If you think you do, and"
	.db "you deliberately chose",10
	.db "page 1E, then you",10
	.db "probably don't."
	.db 0

	.db "(And if you need to be",10
	.db "told this, you certainly"
	.db "don't know what you're",10
	.db "doing.)",10
	.db "YOU HAVE BEEN WARNED!",10
	.db 10
	.db "Press 8 or 9 to erase",10
	.db "anyway, or any other",10
	.db "key to cancel.",0

ErasePageText:
	.db "Flash Eraser >>",10
	.db 10
	.db "ERASE SECTOR at",10
	.db " Page:    ",0,10
	.db " Address: ",0

FlashErrorText:
	     ;;;;----====----====----
	.db "ERROR",10
	.db "Flash write timed out.",10
	.db "This may be due to the",10
	.db "memory having been",10
	.db "previously programmed,",10
	.db "or simply a bug.",10
	.db 10,0

FlashEraseErrorText:
	     ;;;;----====----====----
	.db "ERROR",10
	.db "Flash erase timed out.",10
	.db "Might this be due to the"
	.db "chosen sector being",10
	.db "protected?",10
	.db "If not, that's a bad",10
	.db "thing.",10
	.db 10,0

PortMonitorText:
	.db "Port Monitor >>",10
	.db "Port:  ",0,10
	.db "Value: ",0,"h = ",0

PortMonitorOutputText:
	.db "Output value: ",0

PortMonitorAddressText:
	.db "Port address: ",0

YesOrNoText:
	     ;;;;----====----====----
	.db " ----Are you sure?----",0
YesOrNoPromptText:
	.db " -[Y=]=Yes, [GRAPH]=No-",0


PAKText:
	.db 10," ----Press any key----",0


AboutScreenText:
	     ;;;;----====----====----	
	.db 10
	.db "   PongOS version 0.1",10
	.db 10
	.db "     Copyright 2003",10
	.db "     Benjamin Moody",10
	.db 10
	.db "  benjamin@ecg.mit.edu",10
	.db 0

	.db "Special Thanks To:",10
	.db 10
	.db "  Dan Englender",10
	.db "  Scott Dial",10
	.db "  Michael Vincent",10
	.db "  Jason Malinowski",10
	.db "  Rob van Wijk",10
	.db 0,0

HelpScreenText:
	     ;;;;----====----====----
	.db "Pong controls:",10
	.db 10
	.db "Player 1   Player 2",10
	.db "[2nd]      Up",10
	.db "[ALPHA]    Down",10
	.db 10
	.db "[ENTER] = Pause",10
	.db 0

	.db "Interrupt keys:",10
	.db 10
	.db "[ON]+[2nd] Power off",10
	.db "[ON]+[+]   Inc Contrast",10
	.db "[ON]+[-]   Dec Contrast",10
	.db "[ON]+[LOG] Instant Debug"
	.db "[ON]+[DEL] Reboot",10
	.db 0

	.db "Hex editor:",10
	.db 10
	.db "[G]     Go to address",10
	.db "[R]     Go to page",10
	.db "[ENTER] Change a byte",10
	.db "[A]     Toggle Hex/ASCII"
	.db "[V]     Move to next 83+"
	.db "        Archive entry"
	.db 0

	.db "Normal      [2nd]",10
	.db " a b c       A B C",10
	.db " d e f g h   D E F G H",10
	.db " i j k l m   I J K L M",10
	.db " n o p q r   N O P Q R",10
	.db " s t u v w   S T U V W",10
	.db " x y z   ",39,"   X Y Z   ",34,10
	.db "  (S). ?(R)   (S): !(R)",0

	.db "[ALPHA]     Both",10
	.db " =",10
	.db " ~       ^           |",10
	.db " ` , ( ) /       { } ",92,10
	.db "   7 8 9 *     & * ( [",10
	.db " < 4 5 6 -     $ % ^ ]",10
	.db " > 1 2 3 +     ! @ #",10
	.db "   0 . -(R)    ) ",59," _(R)",0

	.db 10
	.db 10
	.db "To enter boot mode:",10
	.db 10
	.db "Hold [DEL] while you",10
	.db "remove and re-insert a",10
	.db "battery."
	.db 10,0,0

.echo "text.asm      "\.echo $-__text_asm\.echo " bytes\n"
