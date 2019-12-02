; Including Macros Library
INCLUDE ship.inc
INCLUDE bullet.inc
INCLUDE refl.inc
INCLUDE name.inc
INCLUDE lib.inc


	.MODEL SMALL
	.386
        .STACK 64
        .DATA 
;name page
;****************************************************
		playership1 db 15 dup('$'),'$' ; NAME OF PLAYER SHIP 1
		playership2 DB 15 DUP('$'),'$' ; NAME OF PLAYER SHIP 2
		MES         DB 'Press enter to continue $','$'
		MESSHIP1    DB 'Please Enter the name of the left ship player $','$'
		MESSHIP2    DB 'Please Enter the name of the rigth ship player $','$'
		SCN         DB 1  ; TO DETERMINE NAME PAGE TO PLAYER SHIP 1 '1'OR SHIP 2 '2'
		word_color equ 0fh	
; Printing Strings
;****************************************************
		st0 db "to end game click f4 & TO PAUSE F1 $"
		st1 db "To Start Chatting Press F1",10,13,10,13,"       To Start Playing Game Press F2",10,13,10,13,"       To End The Programe Press Esc",10,13,10,13,'$'
		st2 db "press Enter to back to main menu",10,13,10,13,'$'
		st3 db "screen for chatting ",10,13,10,13,'$'
		st4 db "screen for playing ",10,13,10,13,'$'
		st5 db "screen for Exiting ",10,13,10,13,'$'
		window_winner db "***  The Winner is  *** ",10,13,10,13,'$'
		equal_window db "***  no one  ****",'$'

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
		ship2Damage     EQU 44h  ; color to damage 
		ship1Damage     EQU 44h  ;color to damage
		helthfy         equ 151
		helthlen        equ 8
		helthsh1fx      dw 99 ,104,109,114,119,124,129,134,139,144
		helthsh1ex      dw 102,107,112,117,122,127,132,137,142,147
		helthcolor      equ 04h
		helthsh2fx      dw  249,254,259,264,269,274,279,284,289,294  
		helthsh2Ex		dw  252,257,262,267,272,277,282,287,292,297
; Player 1 Variables
;****************************************************
		sh1health   Dw 10    
		sh1p1fy   DW 1
		sh1p2fy   DW 12
		sh1p1fx   EQU 5
		sh1p1ENDx equ 15
		sh1p2fx   EQU 16
		sh1p2ENDx equ 21
		p1_bulls   db   0       ; No of bullets fired
		fl       db   00h 

		; Player 2 Variables
		;****************************************************
		sh2health   Dw 10   
		sh2p1fy   DW   1
		sh2p2fy   DW   16
		sh2p1fx   EQU 300
		sh2p1ENDx equ 310
		sh2p2fx   EQU 294
		sh2p2ENDx equ 299
		p2_bulls   db   0       ; No of bullets fired
		fr       db   00h
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
;******************************************************
; the health packet when the player tack he will tack one health

		HB_FLAG   DB  1          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		HB_fy     dw  8 ;; FRIST Y
		HB_CA     dw  0ffffh ; WHEN HB_CA &HB_CANUM =0 health packet LEFT
		HB_CANUM  dw 00h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		HB_CDA    dw  0h  ;NUM IT STILL APEAR
		HB_CDANUM dw  0h  ;NUM IT STILL APEAR
		HB_ON     DB  0H   ; TO DETERMINE IF HEALTH BACKET ON OR OFF 
		
		HB_LEN     EQU 8
		HBR_fx     EQU 180 		; RIGTH SIDE FRIST X
		HBR_ex     EQU 185 		; RIGTH SIDE END X
		HBL_fx     EQU 70	 	; LEFT SIDE FRIST X
		HBL_ex     EQU 75 		; LEFT SIDE END X
		HB_MCANUM  equ 00h     ; main NUM TO MAKE IT ABEAR AFTER LARGE TIME
		HB_MCDANUM equ 03h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		HB_color  equ 04h
		HB_MCA    equ 0ffffh  ; THE MAIN VALUE OF HB_CA 
		HB_MCDA   equ 0Ffffh ; MAIN NUM IT STILL APEAR
		;HB_yCH    equ 7   ; THE CHANG IN Y 
		;HB_xCH    equ 10   ; THE CHANG IN x
		HB_MAXY   equ 137 ; THE MAX Y POSSIBL
		;HB_MAXx   equ 305 ; THE MAX x POSSIBL
;*******************************************************
;buffer to take name
		MyBuffer LABEL BYTE ; TO READ IN 
		BufferSize db 40
		ActualSize db ?
		BufferData db 40 dup('$')	

   .CODE
MAIN	PROC	FAR

        MOV	AX,@DATA
        MOV	DS,AX
        ;**********************; TO USE STRING OPERATION
		mov AX,DS   
        mov ES,AX 
		;***********************
		name_page
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
;***********************************************************
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
		 call drawhelthsh1
		call drawhelthsh2
		
GM_LP:
		
        ; Moving Reflector and bullets
        ; Moving Reflector
		;call drawhelth
		
		cmp HB_CDA,0
		jnz labhd1
		CMP  HB_CDANUM,0
		jnz labhd1
			dec_HBAL  HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON
		jmp continue1
		labhd1:
			dec_HBDAL HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON,HB_MCANUM
			
		continue1:
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
		DETERMINE_MODE 00,00
		PREP_BACKBROUND 0fh
        MOVE_CURSOR  07,07,0
		PRINTMESSAGE window_winner
		MOVE_CURSOR  0fh,09,0
		mov ax,sh2health
		CMP sh1health,ax
		ja labt1
		je labt2
		jb labt3
		labt1:
		PRINTMESSAGE playership1
		jmp endtlab
		labt2:
		PRINTMESSAGE equal_window
		jmp endtlab
		labt3:
		PRINTMESSAGE playership2
		jmp endtlab
		endtlab:
		DELAY
		;HALT  ; should be stop 5 sec then go MAIN  main menu 
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
        PRINTMESSAGE playership1
        MOVE_CURSOR  PLAYER2_SC_pX,PLAYER_SC_pY,0
        PRINTMESSAGE playership2
        ; Draw Chat Area
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER1_msg_py,0
        PRINTMESSAGE playership1
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py-1,0
        PRINTMESSAGE playership2
        MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py,0
        ; Draw End game statment
        PRINTMESSAGE st0
        RET
DRWINFO ENDP
;******************************************
;****DRAW heath 
;*****************************************
drawhelthsh1 proc
	push cx
	push si
	push di
	mov cx,0
	mov si,offset helthsh1fx
	mov di,offset helthsh1ex
	
	labh2:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,BGCOLOR
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,10
	jnz labh2
	mov cx,0
	mov si,offset helthsh1fx
	mov di,offset helthsh1ex
	labh1:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,helthcolor
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,sh1health
	jnz labh1
	
	pop di
	pop si 
	pop cx
	ret
drawhelthsh1 endp
;************************************************
drawhelthsh2 proc
	push cx
	push si
	push di
	mov cx,0
	mov si,offset helthsh2fx
	mov di,offset helthsh2ex
	
	labh3:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,BGCOLOR
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,10
	jnz labh3
	mov cx,0
	mov si,offset helthsh2fx
	mov di,offset helthsh2ex
	labh4:
	push cx
	drow_thick_line [si],[di] ,helthfy,helthlen,helthcolor
	add di,2
	add si,2
	pop cx
	inc cx
	cmp cx,sh2health
	jnz labh4
	
	pop di
	pop si 
	pop cx
	ret
drawhelthsh2 endp

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
        CMP AX,ShipSizep1y+3
        JNC BULL_CHECK_REFL
		mov fl,01h
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
        CMP AX,REFLECTORlen+3
        JNC BULL_CHECK_OTHERS
        JMP INV_BULL

BULL_CHECK_OTHERS:
        ;*******************************************************
        ; TODO: HERE YOU CAN DETECT COLLISION IN OTHER OBJECTS
        ;*******************************************************
		CMP HB_ON,0
		JZ MOVE_BULLET_LEFT
		CMP HB_FLAG,0
		JZ MOVE_BULLET_LEFT
BULL_CHECK_HELTHBACKETLEFT:		

		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,HBL_fx
        JNE MOVE_BULLET_LEFT
        MOV AX,HB_fy
        ADD AX,HB_LEN
        SUB AX,DX
        CMP AX,HB_fy+3
        JNC MOVE_BULLET_LEFT
        CALL INCSH1HEALTH
		
        JMP DEL_BUL_LEFT
		
        ; Call MVBULL, it moves the left bullet and stores the new position in [SI]
MOVE_BULLET_LEFT:
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
        CMP AX,ShipSizep1y+3
        JNC BULR_CHECK_REFL
		mov fr,01h
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
        CMP AX,REFLECTORlen+3
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
		CALL changeColor
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
        CMP sh1health, 1
        JlE PLAYER2_WINS        ; Because the signed value of the health can be negative so we need signed comparison
        MOV AX,sh1health
        SUB AX,bullRPwr
		pusha
		dec sh1health
		call drawhelthsh1
		popa
        JMP OUT_DECH1_LB
		
        ; TODO: Redraw the number
PLAYER2_WINS: ; winner 
        DETERMINE_MODE 00,00
		PREP_BACKBROUND 0fh
        MOVE_CURSOR  07,07,0
		PRINTMESSAGE window_winner
		MOVE_CURSOR  0fh,09,0
		PRINTMESSAGE playership2
		DELAY
		HALT  ; should be stop 5 sec then go main menu
OUT_DECH1_LB:        
        RET
DECP1HEALTH ENDP

;*************************************************
; **** DECP2HEALTH - Decreases health of player2 and redraws the number + handles winning of P1****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DECP2HEALTH PROC
        CMP sh2health, 1
        JlE PLAYER1_WINS        ; Because the signed value of the health can be negative so we need signed comparison
        MOV AX,sh2health
        SUB AX,bullLPwr
		pusha
		dec sh2health
		call drawhelthsh2
		popa
        JMP OUT_DECH2_LB
PLAYER1_WINS:
		DETERMINE_MODE 00,00
		PREP_BACKBROUND 0fh
        MOVE_CURSOR  07,07,0
		PRINTMESSAGE window_winner
		MOVE_CURSOR  0fh,09,0
		PRINTMESSAGE playership1
		DELAY
		HALT  ; should be stop 5 sec then go main menu
OUT_DECH2_LB:        
        RET
DECP2HEALTH ENDP

INCSH1HEALTH PROC 
	
	PUSHA
	PUSH DI
	PUSH SI
	dec sh2health
	call drawhelthsh2
	MOV AX,1
	MOV HB_CDA ,1
	MOV AX,0
	MOV	HB_CDANUM,AX
	DELETEH_HB HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON,HB_MCANUM
	POP SI
	POP DI
	POPA
	RET

INCSH1HEALTH ENDP

changeColor proc
cmp fr,01h;flag for ship1 if bullet touch ship1
je color_Right; if yes chang color of ship1
jne check_color_Left;check for ship2
color_Right:
call changeColorRight
check_color_Left:
cmp fl,00h;flag if bullet touch screen 
JE exit1;do nothing
;else change color of ship2
drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2Damage; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 1
drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2Damage  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 2
jmp continue ; to avoide out of range
;******************
exit1:
jmp exit;to avoide out of range
;***************
continue:
push ax; to save it's value ,if it used in other function before 
mov ax,0ffffh;time of change color of ship
Time_loop_Continue:
 cmp ax,0
 dec ax
 jz Time_loop_End
 jnz Time_loop_Continue
Time_loop_End:
pop ax
;Returne color of ship 
drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2color  ; "dROW_THICK_line" IS MACRO TO DR
drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRA
mov fl,00h;return default of flag value
exit:
ret
changeColor endp
;**************************************
changeColorRight proc
;change color of ship1
drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship2Damage  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship2Damage  ; "dROW_THICK_line" 
;***************
push ax
mov ax,0ffffh;time of change color of ship
Time_loop_Continue1:
cmp ax,0
dec ax
jz Time_loop_End1
jnz Time_loop_Continue1
Time_loop_End1:
pop ax
;return color of ship1
drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship1color  ; "dROW_THICK_line" 
mov fr,00h;return default of flag value
exit3:
ret
changeColorRight endp

END	MAIN