; Including Macros Library
INCLUDE ship.inc
INCLUDE bullet.inc
INCLUDE refl.inc
INCLUDE lib.inc
	.MODEL SMALL
        .STACK 64
        .DATA 
; Printing Strings
;****************************************************
st0 db "to end game click f4 & TO PAUSE F1 $"
st1 db "To Start Chatting Press F1",10,13,10,13,"       To Start Playing Game Press F2",10,13,10,13,"       To End The Programe Press Esc",10,13,10,13,'$'
st2 db "press Enter to back to main menu",10,13,10,13,'$'
st3 db "screen for chatting ",10,13,10,13,'$'
st4 db "screen for playing ",10,13,10,13,'$'
st5 db "screen for Exiting ",10,13,10,13,'$'

; Printing and Drawing variables
;*****************************************************
BGCOLOR         EQU 0H   ; background color
REFLECTORCOLOR  EQU 56H  ; reflector color
SHIP1COLOR      EQU 33H  ; ship 1 color
SHIP2COLOR      EQU 33H  ; ship 1 color
BOARDSCOLOR     EQU 043H ; boards color
BOARDERTHICK    EQU  2   ; boards thickness
BOARDER1FY      EQU 145  ; frist boarder y
BOARDER1FX      EQU  0   ; boards frist x
BOARDER1EX      EQU 640  ; boards end x
REFLECTORlen    EQU  60  ;reflector length
ShipSizep1y     EQU  30  ; part 1 in ship length
ShipSizep2Y     EQU  8   ; part 2 in ship length
PLAYER_SC_pY    EQU 13H  ;player score position y
PLAYER1_SC_pX   EQU 01H  ;player 1 score position x
PLAYER2_SC_pX   EQU 14H  ;player 2 score position y
PLAYER1_msg_py  EQU 15H  ;player 1 message position y
PLAYER2_msg_py  EQU 18H  ;player 2 message position y

; Player 1 Variables
;****************************************************
sh1health   DB 100D    
sh1p1fy   DW 1
sh1p2fy   DW 16
sh1p1fx   EQU 5
sh1p1ENDx equ 15
sh1p2fx   EQU 16
sh1p2ENDx equ 21
player1_h_str db   'P1 health: 100$'
player1_ms db   'Player1: $'
p1_bulls   db   0       ; No of bullets fired

; Player 2 Variables
;****************************************************
sh2health   DB 100D    
sh2p1fy   DW   1
sh2p2fy   DW   16
sh2p1fx   EQU 620
sh2p1ENDx equ 630
sh2p2fx   EQU 614
sh2p2ENDx equ 619
player2_h_str db   'P2 health: 100$'
player2_ms db   'Player2: $'
p2_bulls   db   0       ; No of bullets fired

; Reflector Variables
;****************************************************
REFfristY DW    1
REFfristX EQU  471
REFendX   EQU  476
REFflag   db    01             ; it take one or two  to detrmine if it move down "if 1" or move up "if 0"
REFSPEED  EQU   0fffh          ;It is the counter when equal zero the reflector step & it control speed of reflector
REFCTR    dw    0fffh
; Bullets Variables
;****************************************************
buW     equ     20      ; Bullet width. No need to keep its height, just 3.
; All Bullets Positions Array, Each bullet is represented by 2 words
; LSW => stores X of the top-left px.
; MSW => stores Y of the top-left px. in the first byte, and type of the bullet in the MSB
; Type of bullet is 0 for left-to-right bullet and 1 for right-to-left
bullPoses   dw  100 dup(0FFFFH), 0FEFEH 
bullLSpeed  EQU  0AFFH   ; Speed of left-to-right bullets in gameloop units
bullLCtr    dw  0AFFH   ; Speed of left-to-right bullets in gameloop units
bullRSpeed  EQU  0AFFH   ; Speed of right-to-left bullets in gameloop units
bullRCtr    dw  0AFFH   ; Speed of right-to-left bullets in gameloop units

        .CODE
MAIN	PROC	FAR

        MOV	AX,@DATA
        MOV	DS,AX

        ; But DI at the first element of the bullets array
        MOV DI,bullPoses
        ; Changes to the mode 
        DETERMINE_MODE 13H ,00H ; VIDEO MODE
MAIN_MENU: 
        CALL SHOW_MAIN_MENU
MAIN_GET_USER_INP:
        GETKEY
        COMPARE_KEY 03BH        ; Scan code of F1 Key
        JE CHAT
        COMPARE_KEY 03CH        ; Scan code of F2 Key
        JE GAME
        COMPARE_KEY 01H        ; Scan code of ESC key
        JE  ENDG
        JMP MAIN_GET_USER_INP

; Branch of Chatting screen calls the SHOW_CHAT Proc.
CHAT:   CALL SHOW_CHAT 
CHAT_GET_USER_INP:        ; Sometimes we need to jump here without redrawing the chat screen
        GETKEY
        COMPARE_KEY 01CH
        JE MAIN_MENU            ; If the user clicks enter, go to main-menu
        JMP CHAT_GET_USER_INP        ;If the user didn't click enter, wait again

; Branch of Game screen calls the SHOW_GAME Proc.
GAME:   CALL SHOW_GAME
        JMP MAIN_MENU            ; If the user clicks enter, go to main-menu
        
        PAUSE

ENDG:   DETERMINE_MODE 03H, 00H
        HALT
MAIN	ENDP



; Procedures
;************************************************************
SHOW_MAIN_MENU  PROC
    PREP_BACKBROUND BGCOLOR ; TO PREPARE BACKGROUD COLOR & QUALITIES
    MOVE_CURSOR 7H,7H,0 ;to write in the middle of screen
    PRINTMESSAGE st1   ;Print 3 cases
    RET
SHOW_MAIN_MENU ENDP

;*************************************************
; **** SHOW_CHAT - Showes the Chat screen ****
; * USES :  AX, BX, CX , DX
; * PARAMS :  NONE
; ************************************************
SHOW_CHAT PROC
        PREP_BACKBROUND BGCOLOR  ; TO PREPARE BACKGROUD COLOR & QUALITIES
        MOVE_CURSOR 1,1,00H  ;to write at the top of screen
        PRINTMESSAGE st2     ;Display ST2
        PRINTMESSAGE st3     ;Display ST3
        RET
SHOW_CHAT ENDP


;*************************************************
; **** SHOW_GAME - Shows the game screen ****
; * USES :  ALL
; * PARAMS :  DI => *First_Empty_Byte
; ************************************************
SHOW_GAME PROC
        PREP_BACKBROUND BGCOLOR
        CALL DRWINFO
        CALL DRWREFL
        CALL DRWSHIPS
GM_LP:
        GETKEY
        ; Handle Pause and stop clicks
        COMPARE_KEY 03EH        ; Scan code for f4
        JNE CHK_PAUSE
        RET                     ; Ends the game if f4 is clicked
CHK_PAUSE:
        COMPARE_KEY 03BH
        JNE GO
        PAUSE

        ; Handle click of first player
GO:     COMPARE_KEY  72   ; Scan code for UP arrow
        CALL_MACRO_IF_EQUAL MVSH1UP
        COMPARE_KEY  80   ; Scan code for DOWN arrow
        CALL_MACRO_IF_EQUAL MVSH1DOWN
        COMPARE_KEY 39H   ; Scan code for Space
        CALL_MACRO_IF_EQUAL ADDBULL

        ; Handle click of second player
        COMPARE_KEY 11H    ; Scan code for W
        CALL_MACRO_IF_EQUAL MVSH2UP
        COMPARE_KEY 1FH
        CALL_MACRO_IF_EQUAL MVSH2DOWN
        COMPARE_KEY 02DH    ; Scan code for X
        CALL_MACRO_IF_EQUAL ADDBULR

        ; Move Reflector
        CMP REFCTR,0
        JE  MVREFL_LB

MVBUL_LB:
        ; Decrement speed counter
        DEC REFCTR
        DEC bullLCtr
        DEC bullRCtr
        JMP GM_LP

        ; Branch of reflector motion
MVREFL_LB: 
        MVREFL
        JMP MVBUL_LB

        RET
SHOW_GAME ENDP

;*************************************************
; ****  DRWINFO - Draws Players' Info ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWINFO PROC
        ; Drawing Borders
        drow_thick_line BOARDER1FX,BOARDER1EX ,BOARDER1FY,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW UPPER BOARD
	drow_thick_line BOARDER1FX,BOARDER1EX,BOARDER1FY+15,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW MIDLE BOARD
	drow_thick_line BOARDER1FX,BOARDER1EX ,BOARDER1FY+32,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW down BOARD
        ; Printing Strings
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER_SC_pY,0
        PRINTMESSAGE player1_h_str
        MOVE_CURSOR  PLAYER2_SC_pX,PLAYER_SC_pY,0
        PRINTMESSAGE player2_h_str
        ; Draw Chat Area
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER1_msg_py,0
        PRINTMESSAGE player1_ms
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py-1,0
        PRINTMESSAGE player2_ms
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py,0
        ; Draw End game statment
        PRINTMESSAGE st0
        RET
DRWINFO ENDP

;*************************************************
; **** GAMECHAT - Function for in-game chatting ****
; * USES :  AX, BX, CX, DX
; * PARAMS : NONE
; ************************************************
GAMECHAT PROC
        RET
GAMECHAT ENDP

;*******************************************************
;*******************************************************
;               Ship drawing functions
;*******************************************************
;       can be moved into a separate module
;*******************************************************
;*******************************************************

;*************************************************
; **** DRWSHIPL - Draws both ship ****
; * USES :  ALL
; * PARAMS :  Param1 => Reg, Param2 => Reg, ...
; ************************************************
DRWSHIPS PROC
        drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
        drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 2
        drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 1
        drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 2
        RET
DRWSHIPS ENDP

;*******************************************************
;               Reflector drawing functions
;*******************************************************
;       can be moved into a separate module
;*******************************************************

;*************************************************
; ****  DRWREFL - Draws the reflector ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWREFL PROC
        drow_thick_line REFfristX,REFendX,REFfristY,REFLECTORlen,REFLECTORCOLOR 
        RET
DRWREFL ENDP


END	MAIN