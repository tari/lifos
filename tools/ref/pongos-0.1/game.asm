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

__game_asm:

GameMenu:
	call ClearScreenTitle
	ld hl,GameMenuText
	call ConPutS
	push bc
	ld a,(gameSpeed)
	ld b,a
	ld a,'9'
	sub b
	pop bc
	call ConPutChar
	call ConPutS
	ld a,(player1)
	call ConPutPlayer
	call ConPutS
	ld a,(player2)
	call ConPutPlayer
	call ConPutS
	call CopySysScreen
	call GetKeyW
	cp skMode
	jp z,MainMenu
	cp skClear
	jp z,MainMenu
	cp sk1
	jr z,GameMenuSetSpeed
	cp sk2
	jr z,GameMenuToggle1
	cp sk3
	jr z,GameMenuToggle2
	cp sk4
	jr z,PlayGame
	cp sk5
	jr z,ResumeGame
	cp sk6
	jr nz,GameMenu
	jp MainMenu

GameMenuToggle1:
	ld a,(player1)
	xor 1
	ld (player1),a
	jr GameMenu

GameMenuToggle2:
	ld a,(player2)
	xor 1
	ld (player2),a
	jr GameMenu

GameMenuSetSpeed:
	ld a,(gameSpeed)
	ld b,a
	ld a,'9'
	sub b
	ld e,a
	ld bc,TOPROW+(1*6)+(23*256)
	call GetKeyCurWUnder
	call KeyToDec
	jp nz,GameMenu
	ld a,9
	sub d
	ld (gameSpeed),a
	jp GameMenu

PSIZE = 9
HPSIZE = 4
BALLDIR_P1 = 1*256+1
BALLDIR_P2 = 255*256+255
BALLPOS_P1 = 22*256+31
BALLPOS_P2 = 83*256+31
DEFPOS = BALLPOS_P2
DEFDIR = BALLDIR_P2
DEFPPOS = 31-PSIZE
MAXPPOS = 64-PSIZE
P1X = 3
P2X = 92

ResetGame:
	ld hl,0
	ld (player1score),hl
	ld (player2score),hl
	ld hl,DEFPPOS*256+DEFPPOS
	ld (player1pos),hl
	ld hl,DEFPOS
	ld (ballPos),hl
	ld hl,DEFDIR
	ld (ballDir),hl
	ret

PlayGame:
	call ResetGame
ResumeGame:
PlayGameLoop:
	call ClearSysScreen
	ld hl,(ballPos)
	ld a,l
	sub 2
	ld l,a
	ld a,h
	sub 2
	ld h,a
	ld de,BallSprite
	call DrawSprite

	ld a,(player1pos)
	ld l,a
	ld h,0
	ld de,Paddle1Sprite
	call DrawSprite

	ld a,(player2pos)
	ld l,a
	ld h,88
	ld de,Paddle2Sprite
	call DrawSprite

	call CopySysScreen

	ld hl,(ballPos)
	ld de,(ballDir)
	ld a,h
	add a,d
	cp P1X+1
	call c,CheckP1
	cp P2X
	call nc,CheckP2
	ld h,a
	ld a,l
	add a,e
	and $7f
	ld l,a
	cp 64
	jr c,MoveBallNoReflect
	xor $7f
	ld l,a
	ld a,(ballDir)
	neg
	ld (ballDir),a
MoveBallNoReflect:
	ld (ballPos),hl

	ld a,(player1)
	ld c,a
	or a
	call z,P1Human
	ld a,c
	or a
	call nz,P1Calc

	ld a,(player2)
	ld c,a
	or a
	call z,P2Human
	ld a,c
	or a
	call nz,P2Calc

	ld b,dgKeys5
	call GetGroup
	or dkEnter
	inc a
	call nz,Pause

	ld a,(gameSpeed)
	or a
GameWaitLoop:
	jp z,PlayGameLoop
	ei
	halt
	dec a
	jr GameWaitLoop


CheckP1:
	push af
	push hl
	ld a,(player1pos)
	sub 2
	cp l
	jp p,Player1Miss
	add a,PSIZE+2
	cp l
	jp m,Player1Miss
	ld hl,(player1score)
	inc hl
	ld (player1score),hl
	ld a,(ballDir+1)
	neg
	ld (ballDir+1),a
	pop hl
	pop af
	ret

CheckP2:
	push af
	push hl
	ld a,(player2pos)
	sub 2
	cp l
	jp p,Player2Miss
	add a,PSIZE+2
	cp l
	jp m,Player2Miss
	ld hl,(player2score)
	inc hl
	ld (player2score),hl
	ld a,(ballDir+1)
	neg
	ld (ballDir+1),a
	pop hl
	pop af
	ret

Player1Miss:
	ld hl,BALLDIR_P1
	ld (ballDir),hl
	ld hl,BALLPOS_P1
	ld (ballPos),hl
	jr RandBall

Player2Miss:
	ld hl,BALLDIR_P2
	ld (ballDir),hl
	ld hl,BALLPOS_P2
	ld (ballPos),hl
RandBall:
	call Random
	ld (ballPos),a
	call Pause
	jp PlayGameLoop


P2Human:
	ld b,dgArrowKeys
	call GetGroup
	ld b,a
	or dkUp
	inc a
	jr z,P2NoMoveUp
P2MoveUp:
	ld a,(player2pos)
	sub 1
	ret c
	ld (player2pos),a
	ret
P2NoMoveUp:
	ld a,b
	or dkDown
	inc a
	ret z
P2MoveDown:
	ld a,(player2pos)
	cp MAXPPOS
	ret nc
	inc a
	ld (player2pos),a
	ret

P2Calc:
	ld a,(ballDir+1)
	and $80
	ret nz
	call AIMove
	ld b,a
	ld a,(player2pos)
	cp b
	ret z
	jr c,P2MoveDown
	jr P2MoveUp

P1Human:
	ld b,dgCtlKeys
	call GetGroup
	or dk2nd
	inc a
	jr z,P1NoMoveUp
P1MoveUp:
	ld a,(player1pos)
	sub 1
	ret c
 	ld (player1pos),a
	ret
P1NoMoveUp:
	ld b,dgKeys1
	call GetGroup
	or dkAlpha
	inc a
	ret z
P1MoveDown:
	ld a,(player1pos)
	cp MAXPPOS
	ret nc
	inc a
	ld (player1pos),a
	ret

P1Calc:
	ld a,(ballDir+1)
	and $80
	ret z
	call AIMove
	ld b,a
	ld a,(player1pos)
	cp b
	ret z
	jr c,P1MoveDown
	jr P1MoveUp


Pause:
	ld hl,Score1Text
	ld bc,5*256+17
	call ConPutS
	ld hl,(player1score)
	call ConPutNum
	ld hl,Score2Text
	ld bc,5*256+23
	call ConPutS
	ld hl,(player2score)
	call ConPutNum
	ld hl,PauseText
	ld bc,9*256+33
	call ConPutS
	ld bc,3*256+40
	call ConPutS
	ld bc,5*256+46
	call ConPutS
	call CopySysScreen
PauseLoop0:
	ld b,0
	call GetGroup
	inc a
	jr nz,PauseLoop0
PauseLoop:
	call GetKeyW
	cp skEnter
	ret z
	cp skMode
	jr nz,PauseLoop
	jp TopLevel


AIMove:
	ld hl,(ballPos)
	ld a,(ballDir+1)
	and $80
	jr nz,AIMoveNeg
	ld a,95
	sub h
	ld h,a
AIMoveNeg:
	ld a,(ballDir)
	and $80
	jr z,AIMoveDown
	ld a,l
	xor $7f
	ld l,a
AIMoveDown:
	ld a,h
	add a,l
	sub P1X
	and $7f
	cp $40
	ret c
	xor $7f
	ret

ConPutPlayer:
	push hl
	or a
	jr nz,ConPutPlayerComp
	ld hl,PlayerHuman
	jr ConPutPlayerHuman
ConPutPlayerComp:
	ld hl,PlayerComp
ConPutPlayerHuman:
	call ConPutS
	pop hl
	ret


Random:
	;; Generate a random number < 64

	;; (Way too sophisticated for a pong game, but nowhere near
	;; secure, this routine is pointless except as an excercise.)

	;; First, a dumb linear generator
	ld a,(randSeed)
	ld c,a
	add a,a
	add a,a
	add a,b
	inc a
	ld (randSeed),a

	;; (whose higher bits give the most noise)
	rra
	rra
	ld c,a

	;; Then the R-count, which will vary slightly as things
	;; happen, and of course whenever the user does something
	ld a,r
	xor c
	ld c,a

	;; Finally some noise from page 1E, which tends not to float
	;; as much as we'd like
	ld a,$1e
	call SetPage
	ld a,($4000)
	xor c

	and $3f
	ret

.echo "game.asm      "\.echo $-__game_asm\.echo " bytes\n"
