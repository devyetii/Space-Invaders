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
sh1p2fy   DW 12
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
sh2p1fx   EQU 300
sh2p1ENDx equ 310
sh2p2fx   EQU 294
sh2p2ENDx equ 299
player2_h_str db   'P2 health: 100$'
player2_ms db   'Player2: $'
p2_bulls   db   0       ; No of bullets fired

; Reflector Variables
;****************************************************
REFfristY DW    1
REFfristX EQU  151
REFendX   EQU  156 
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
bullRPwr    db  5
bullLPwr    db  5
bullLSpeed  EQU  00FFH   ; Speed of left-to-right bullets in gameloop units
bullLCtr    dw   00FFH   ; Speed of left-to-right bullets in gameloop units
bullRSpeed  EQU  0AFFH   ; Speed of right-to-left bullets in gameloop units
bullRCtr    dw  0AFFH   ; Speed of right-to-left bullets in gameloop units

        .CODE
MAIN	PROC	FAR

        MOV	AX,@DATA
        MOV	DS,AX

        ; But DI at the first element of the bullets array
        MOV DI,offset bullPoses
        ; Changes to the mode 
        DETERMINE_MODE 13H ,0H ; VIDEO MODE
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
        ; Drawing and preparing
        PREP_BACKBROUND BGCOLOR
        CALL DRWINFO
        CALL DRWREFL
        CALL DRWSHIPS
GM_LP:
        ; Moving Reflector and bullets
        ; Moving Reflector
        CMP REFCTR,0
        JE  MVREFL_LB 
CHK_BULL:
        CMP bullLCtr,0
        JNE  DEC_CTRS_LB
        MOV bullLCtr,bullLSpeed
        CALL FAR PTR MVBULLSPROC
        ; Decrementing speed counter
DEC_CTRS_LB:
        DEC REFCTR
        DEC bullLCtr
        DEC bullRCtr
        JMP FAR PTR USER_INP
        ; Moving Bullets
MVREFL_LB:
        MVREFL
        JMP CHK_BULL

        ; Branch of handling User Input
USER_INP:

        GETKEY_NOWAIT
        
        ; Handle Pause and stop clicks
        COMPARE_KEY 03EH        ; Scan code for f4
        JNE CHK_PAUSE
        RET                     ; Ends the game if f4 is clicked
CHK_PAUSE:
        COMPARE_KEY 03BH        ; Scan code of f1
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

        JMP GM_LP

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

; ***************************************************************
;       SOME BULLET FUNCTIONS
;****************************************************************
; MVBULLS - Main bullet movement logic 
MVBULLSPROC PROC FAR
        ; 1: Use SI to point to the start of the array
        MOV SI, offset bullPoses
BUL_START_LB:   
        ; 2: At the beginning of the loop check if SI points to bullet data
        ; We also check if no data here or reached the mark of the end and if so we break the loop to outside
        CMP [SI],0FFFFH
        JNE  COMPARE_FEFE
        RET
COMPARE_FEFE:
        CMP [SI],0FEFEH
        JNE  GO_BULLS_GO
        RET
GO_BULLS_GO:
        ; 3: Put the initial position of X and Y of the current bullet to CX, DX
        MOV CX, [SI]
        MOV DX, [SI+2]
        ; Note that SI is kept at the X position so as for MVBULL1 to store the new X position in
        ; To call the right function according to the type of the bullet, we know that the type of the bullet
        ; is stored in the MSB of YPos of the bullet, 1 if right and 0 if left, Ok ?
        ; This means that if the bullet is left, YPos will be less than 8000H
        ; We can use this piece of information to make condition on the type
        ; Recall that : CMP dist,src : if dist<src, CF is set (=1)
        CMP DX,8000H
        JNC R_MV        ; No carry means YPos > 8000H i.e. Right Bullet

        ;***************************************************************************
        ; LEFT BULLET CHECKS GOES HERE
        ;***************************************************************************
        ; 1. End of screen
        MOV AX,CX
        ADD AX,buW
        CMP AX, 320D
        JE DEL_BUL_LEFT
        ; 2. Ship
        ; TODO: -for me- Add comments
        MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,sh2p2fx
        JNE BULL_CHECK_REFL
        MOV AX,sh2p1fy
        ADD AX,ShipSizep1y
        SUB AX,DX
        CMP AX,ShipSizep1y
        JNC BULL_CHECK_REFL
        CALL DECP2HEALTH
        JMP DEL_BUL_LEFT
BULL_CHECK_REFL:
        ; 3. Reflector
        ; TODO: -for me- Add comments
        MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,REFfristX
        JNZ BULL_CHECK_OTHERS
        MOV AX,REFfristY
        ADD AX,REFLECTORlen
        SUB AX,DX
        CMP AX,REFLECTORlen
        JNC BULL_CHECK_OTHERS
        JMP INV_BULL

BULL_CHECK_OTHERS:
        ;*******************************************************
        ; TODO: HERE YOU CAN DETECT COLLISION IN OTHER OBJECTS
        ;*******************************************************

        ; Call MVBULL, it moves the left bullet and stores the new position in [SI]
        CALL MVBULL
        JMP  END_BUL_LP
        
        ; Branch for left bullet deletion
DEL_BUL_LEFT:
        DEC p1_bulls
        JMP DEL_BUL

R_MV:   
        ; Don't forget that we store the type of the bullet in the MSB of YPos 
        ; but we don't want this to affect our drawing
        ; so we must make sure it's 0 before drawing or deleting
        AND DX, 7FFFH   
        
        ;***************************************************************************
        ; RIGHT BULLET CHECKS GOES HERE
        ;***************************************************************************
        ; 1. End of screen
        CMP CX, 00D
        JE  DEL_BUL_RIGHT
        ; 2. Ship
        ; TODO: -for me- Add comments
        MOV AX,CX
        DEC AX
        CMP AX,sh1p2ENDx
        JNZ BULR_CHECK_REFL
        MOV AX,sh1p1fy
        ADD AX,ShipSizep1y
        SUB AX,DX
        CMP AX,ShipSizep1y
        JNC BULR_CHECK_REFL
        CALL DECP1HEALTH
        JMP DEL_BUL_RIGHT

BULR_CHECK_REFL:        
        ; 3. Reflector
        ; TODO: -for me- Add comments
        CMP CX,REFendX
        JNE BULR_CHECK_OTHERS
        MOV AX,REFfristY
        ADD AX,REFLECTORlen
        SUB AX,DX
        CMP AX,REFLECTORlen
        JNC BULR_CHECK_OTHERS
        JMP INV_BULR

BULR_CHECK_OTHERS:
        ;*******************************************************
        ; TODO: HERE YOU CAN DETECT COLLISION IN OTHER OBJECTS
        ;*******************************************************

        ; Call MVBULR, it moves the left bullet and stores the new position in [SI]
        CALL MVBULR
        JMP END_BUL_LP 

        ; Branch for right bullet deletion
DEL_BUL_RIGHT:
        DEC p2_bulls        
DEL_BUL:
        CALL DELBUL
        JMP END_BUL_LP_WITHOUT_INC
        
        ;Increment SI by 4 to get a new bullet position
END_BUL_LP:        
        ADD SI,4
END_BUL_LP_WITHOUT_INC:
        JMP BUL_START_LB

        ; Invert Left Bullet Branch
INV_BULL:
        CALL INVBUL
        CALL MVBULR
        JMP END_BUL_LP

        ; Invert Right Bullet Branch
INV_BULR:
        CALL INVBUL
        CALL MVBULL
        JMP END_BUL_LP

        ; 7: Sometimes we don't need to increment SI, e.g. after deleting a bullet due to the way we do deletion by shifting


BULL_OUT_LB: RET
MVBULLSPROC ENDP

;*******************************************
; **** MOVE  LEFT BULLET FUNCTION ***************
; **** Also saves the new position to memory
; * USES : CX , DX, DI
; * PARAMS : X_START => CX, Y_START => DX, 
;          : X_Store => DI     
; *****************************************
MVBULL PROC
        ; Black the first coloumn of the bullet
        DRWPX 00H        
        INC DX
        DRWPX 00H
        INC DX
        DRWPX 00H
        ; Save the new buX in memory
        INC CX
        MOV [SI],CX
        ; Set the position after the end of the bullet
        ADD CX,13H
        ;  White a new column after the end
        DRWPX 0FH        
        DEC DX
        DRWPX 0FH
        DEC DX
        DRWPX 0FH
        RET
MVBULL ENDP

;*******************************************
; **** MOVE RIGHT BULLET FUNCTION ***************
; **** Also saves the new position to memory
; * USES : CX , DX, DI
; * PARAMS : X_END => CX, Y_END => DX, 
;          : X_Store => DI     
; *****************************************
MVBULR PROC
        ; Save the new buX in memory
        DEC CX
        MOV [SI],CX
        ;  White a new coloumn before the start
        DRWPX 0FH        
        INC DX
        DRWPX 0FH
        INC DX
        DRWPX 0FH
        ; Set the position at the end of the bullet
        ADD CX,15H
        ; Black the last column of the bullet
        DRWPX 00H        
        DEC DX
        DRWPX 00H
        DEC DX
        DRWPX 00H
        RET
MVBULR ENDP

;*************************************************
; **** DELETE BULLET FUNCTION ****
; * USES : CX, DX, SI
; * PARAMS :  CX => Start_X, DX => Start_Y, SI => Store_X
; ************************************************
DELBUL  PROC
        ; OK, know we need to apply the best property of our array, shifted deletion !
        ; That is, if some bullet data is to be deleted, we move it at the end of the array and move the last element to its position
        ; This is valid because our array is a bag and we don't care about the order
        ; Our data to be deleted is in [SI],[SI+2]; and the last element is at [DI-4], [DI-2], so lets move it 
        PUSH [DI-4]
        POP  [SI]
        PUSH [DI-2]
        POP  [SI+2]
        ; Then we move DI backward in the array
        SUB  DI,4
        ; And we delete the last element data
        MOV  [DI], 0FFFFH
        MOV  [DI+2],0FFFFH
        PUSH SI         ; We will use it for looping, however, we still need it to complete the bullet loop
        MOV SI,CX
        ADD SI,buW
        INC SI        ; Fixing an error in deleting the right bullet
        ; Don't forget to correct YPos of the bullet to delete the effect of the type bit
        AND DX,7FFFH
UNDRW_L:  
        DRWPX 00H     ;DRAW PIXEL ON LINE ONE
        INC DX              ;GO DOWN A LINE
        DRWPX 00H     ;DRAW PIXEL ON LINE TWO
        INC DX              ;GO DOWN A LINE
        DRWPX 00H     ;DRAW PIXEL ON LINE TWO
        SUB DX,2
        INC CX              
        CMP CX,SI
        JNE UNDRW_L
        POP SI
        RET
DELBUL  ENDP


;*************************************************
; **** INVERT BULLET FUNCTION ****
; * USES : SI
; * PARAMS :  SI => Store_X
; ************************************************
INVBUL  PROC
        XOR [SI+2],8000H
        MOV DX, [SI+2]
        AND DX,7FFFH
        RET
INVBUL  ENDP

;*************************************************
; **** DECP1HEALTH - Decreases health of player1 and redraws the number + handles winning of P2****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DECP1HEALTH PROC
        CMP sh1health, 0
        JLE PLAYER2_WINS        ; Because the signed value of the health can be negative so we need signed comparison
        MOV AX,sh1health
        SUB AX,bullRPwr
        JMP OUT_DECH1_LB
        ; TODO: Redraw the number
PLAYER2_WINS:
        ; TODO: Handle winning situation
         
OUT_DECH1_LB:        
        RET
DECP1HEALTH ENDP

;*************************************************
; **** DECP2HEALTH - Decreases health of player2 and redraws the number + handles winning of P1****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DECP2HEALTH PROC
        CMP sh2health, 0
        JLE PLAYER1_WINS        ; Because the signed value of the health can be negative so we need signed comparison
        MOV AX,sh2health
        SUB AX,bullLPwr
        JMP OUT_DECH2_LB
        ; TODO: Redraw the number
PLAYER1_WINS:
        ; TODO: Handle winning situation 
OUT_DECH2_LB:        
        RET
DECP2HEALTH ENDP

END	MAIN