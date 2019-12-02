
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
		st7 db 10,13,10,13,"Click f4 to return to main menu $"
		window_winner db "***  The Winner is  *** ",10,13,10,13,'$'
		equal_window db "***  no one  ****",'$'

; Printing and Drawing variables
;*****************************************************
		BGCOLOR         EQU 0H   ; background color
		REFLECTORCOLOR  EQU 56H  ; reflector color
		SHIP1COLOR      DB 33H  ; ship 1 color
		SHIP2COLOR      DB 33H  ; ship 1 color
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
		SH1PROTECT_FLAG DB 0
		SH1TIMES_PROTECT   DB 0
		sh1health   Dw 10    
		sh1p1fy   DW 1
		sh1p2fy   DW 12
		sh1p1fx   EQU 5
		sh1p1ENDx equ 15
		sh1p2fx   EQU 16
		sh1p2ENDx equ 21
		p1_bulls   db   0       ; No of bullets fired
		fl       db   00h 
		Ship1_Speed dw 1
		; Player 2 Variables
		;****************************************************
		SH2PROTECT_FLAG DB 0
		SH2TIMES_PROTECT   DB 0
		sh2health   Dw 10   
		sh2p1fy   DW   1
		sh2p2fy   DW   16
		sh2p1fx   EQU 300
		sh2p1ENDx equ 310
		sh2p2fx   EQU 294
		sh2p2ENDx equ 299
		p2_bulls   db   0       ; No of bullets fired
		fr       db   00h
		Ship2_Speed dw 1
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
		HB_CDA    dw 555h  ;NUM IT STILL APEAR
		HB_CDANUM dw  0h  ;NUM IT STILL APEAR
		HB_ON     DB  0H   ; TO DETERMINE IF HEALTH BACKET ON OR OFF 
		
		HB_LEN     EQU 8
		HBR_fx     EQU 180 		; RIGTH SIDE FRIST X
		HBR_ex     EQU 185 		; RIGTH SIDE END X
		HBL_fx     EQU 70	 	; LEFT SIDE FRIST X
		HBL_ex     EQU 75 		; LEFT SIDE END X
		HB_MCANUM  equ 27h     ; main NUM TO MAKE IT ABEAR AFTER LARGE TIME
		HB_MCDANUM equ 03h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		HB_color  equ 04h
		HB_MCA    equ 0ffffh  ; THE MAIN VALUE OF HB_CA 
		HB_MCDA   equ 0Ffffh ; MAIN NUM IT STILL APEAR
		HB_MAXY    EQU 137
;************************************************************
;**************PROTECT SHIP FROM FIVE BULLETS 
		BS_FLAG   DB  1          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		BS_fy     dw  8 ;; FRIST Y
		BS_CA     dw  0ffffh ; WHEN BS_CA &BS_CANUM =0 health packet LEFT
		BS_CANUM  dw 02h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		BS_CDA    dw  0FFFFh  ;NUM IT STILL APEAR
		BS_CDANUM dw  0h  ;NUM IT STILL APEAR
		BS_ON     DB  0H   ; TO DETERMINE IF HEALTH BACKET ON OR OFF 
		
		BS_LEN     EQU 8
		BSR_fx     EQU 190 		; RIGTH SIDE FRIST X
		BSR_ex     EQU 195 		; RIGTH SIDE END X
		BSL_fx     EQU 70	 	; LEFT SIDE FRIST X
		BSL_ex     EQU 75 		; LEFT SIDE END X
		BS_MCANUM  equ 27h     ; main NUM TO MAKE IT ABEAR AFTER LARGE TIME
		BS_MCDANUM equ 03h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		BS_color  equ 0Eh
		BS_MCA    equ 0ffffh  ; THE MAIN VALUE OF BS_CA 
		BS_MCDA   equ 0Ffffh ; MAIN NUM IT STILL APEAR
		BS_MAXY    EQU 137
;************************************************************
;****the rock when touch the bullet  delete it 
		R_FLAG   DB  0          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		R_fy     dw  59 ;; FRIST Y
		R_CA     dw 0ffffh ; WHEN R_CA &R_CANUM =0 health packet LEFT
		R_CANUM  dw 01h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		R_CDA    dw  0h  ;NUM IT STILL APEAR
		R_CDANUM dw  0h  ;NUM IT STILL APEAR
		R_ON     DB  0H   ; TO DETERMINE IF HEALTH BACKET ON OR OFF 
		
		R_LEN     EQU 30
		RR_fx     EQU 180 		; RIGTH SIDE FRIST X
		RR_ex     EQU 187 		; RIGTH SIDE END X
		RL_fx     EQU 70	 	; LEFT SIDE FRIST X
		RL_ex     EQU 77 		; LEFT SIDE END X
		R_MCANUM  equ 27h     ; main NUM TO MAKE IT ABEAR AFTER LARGE TIME
		R_MCDANUM equ 03h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		R_color  equ 67h
		R_MCA    equ 0ffffh  ; THE MAIN VALUE OF R_CA 
		R_MCDA   equ 0Ffffh ; MAIN NUM IT STILL APEAR
		R_MAXY   EQU  110
;*******************************************************
;*******************************************************
;second type:
;******************************************************
; the health packet when the player tack he will tack one health

		Counter1_Speed dw 0ffffh
		Counter2_Speed dw 0ffffh
		S_FLAG   DB  1          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		S_fy     dw  100 ;; FRIST Y;chang
		S_CA     dw  0ffffh ; WHEN HB_CA &HB_CANUM =0 health packet LEFT
		S_CANUM  dw 03h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		S_CDA    dw  0h  ;NUM IT STILL APEAR
	    S_CDANUM dw  0h  ;NUM IT STILL APEAR
		S_ON     DB  0H   ; TO DETERMINE IF HEALTH BACKET ON OR OFF 
		S_LEN     EQU 8
		SR_fx     EQU 170 		; RIGTH SIDE FRIST X
		SR_ex     EQU 175		; RIGTH SIDE END X
		SL_fx     EQU 60	 	; LEFT SIDE FRIST X
		SL_ex     EQU 65 		; LEFT SIDE END X
		S_MCANUM  equ 27h     ; main NUM TO MAKE IT ABEAR AFTER LARGE TIME
		S_MCDANUM equ 03h   ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		S_color  equ 86h     
		S_MCA    equ 0ffffh  ; THE MAIN VALUE OF HB_CA 
		S_MCDA   equ 0Ffffh ; MAIN NUM IT STILL APEAR
		S_MAXY   equ 137 ; THE MAX Y POSSIBL
		fls1    dw 00h
		
;*******************************************************
; IsThereAWinner - boolean value to determine if there's a final winner or not
                IsThereAWinner db 00H
                ; Reflector Variables
 ;****************************************************
;*************************************************************************
;*********************Obstacle to Decrease Speed of ship****************************
		D_FLAG   DB  1          ; TO DETRMINE RIGTH '0' OR LEFT '1'
		D_fy     dw  20 ;FRIST Y
		D_CA     dw  0ffffh ; WHEN D_CA &D_CANUM =0 health packet LEFT
		D_CANUM  dw 02h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		D_CDA    dw  8h  ;NUM IT STILL APEAR
		D_CDANUM dw  0Fh  ;NUM IT STILL APEAR
		D_ON     DB  0H   ; TO DETERMINE IF HEALTH BACKET ON OR OFF 
		D_LEN     EQU 8    ;length of health
		DR_fx     EQU 176 		; RIGTH SIDE FRIST X
		DR_ex     EQU 180 		; RIGTH SIDE END X
		DL_fx     EQU 60	 	; LEFT SIDE FRIST X
		DL_ex     EQU 65 		; LEFT SIDE END X
		D_MCANUM  equ 027h     ; main NUM TO MAKE IT ABEAR AFTER LARGE TIME
		D_MCDANUM equ 03h     ; NUM TO MAKE IT ABEAR AFTER LARGE TIME
		D_color  equ 01h
		D_MCA    equ 0ffffh  ; THE MAIN VALUE OF D_CA 
		D_MCDA   equ 0Ffffh ; MAIN NUM IT STILL APEAR
		D_MAXY    EQU 137
;*******************************************************

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
		pusha
		push di
		push si
        ; Reseting all game variables in the memory
        CALL CLRMEMORY
        ; Drawing and preparing
        PREP_BACKBROUND BGCOLOR
        CALL DRWINFO
        CALL DRWREFL
        CALL DRWSHIPS
		 call drawhelthsh1
		call drawhelthsh2
		
GM_LP:
        ; Handling counters and drawing of Powerups
        CALL POWER_UPS

        ; Moving Reflector and bullets
        ; Cheking for Moving the Reflector
        CMP REFCTR,0
        JE  MVREFL_LB 
        ; Checking for Moving Bullets and moving them
CHK_BULL:
        CMP bullLCtr,0
        JNE  DEC_CTRS_LB
        MOV bullLCtr,bullLSpeed
        CALL FAR PTR MVBULLSPROC
        ; Here we check if it happens to be a winner, then we exit the game function
        CMP IsThereAWinner, 00h
        JE DEC_CTRS_LB
EXIT_IF_F4:
        GETKEY
        COMPARE_KEY 03EH
        JNE EXIT_IF_F4
		pop si
		pop di
		popa
        RET
        ; Decrementing speed counter
DEC_CTRS_LB:
        DEC REFCTR
        DEC bullLCtr
        DEC bullRCtr
        JMP FAR PTR USER_INP

        ; Moving Reflector Branch
MVREFL_LB:
        MVREFL
        JMP CHK_BULL

        ; Branch of handling User Input
USER_INP:
        GETKEY_NOWAIT
        ; Handle Pause and stop clicks
        COMPARE_KEY 03EH        ; Scan code for f4
        JNE CHK_PAUSE
        CALL DRWWINNER
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

;*******************************************************
;*************************************************
; **** DRWPOWERUPS - Draws Health Packet Power-ups of both ships ****
; * USES :  like CX , DX, SI, AL, AH
; * PARAMS :  Param1 => Reg, Param2 => Reg, ...
; ************************************************
POWER_UPS Proc
	cmp D_CDA,0
			jnz labhdD;Delete Health
			CMP  D_CDANUM,0
			jnz labhdD;Delete Health
	; WHEN D_CA &D_CANUM =0 health packet LEFT---->"DRAW Health"		
			dec_HBAL  D_CA ,D_CANUM,D_MCA,D_FLAG,DL_fx,DL_Ex,D_fy,D_LEN,D_color,DR_fx,DR_Ex,D_CDA,D_MCDA,D_CDANUM,D_MCDANUM, D_ON
			jmp continue4
	;Delete Health		
labhdD:
			dec_HBDAL D_CA ,D_CANUM,D_MCA,D_FLAG,DL_fx,DL_Ex,D_fy,D_LEN,D_color,DR_fx,DR_Ex,D_CDA,D_MCDA,D_CDANUM,D_MCDANUM, D_ON,D_MCANUM,D_MAXY 
	;**************************************************************
	;****************Increaes Speed************************
continue4:
		cmp s_CDA,0
		jnz labhdS
		CMP  s_CDANUM,0
		jnz labhds
			dec_HBAL  S_CA ,S_CANUM,S_MCA,S_FLAG,SL_fx,SL_Ex,S_fy,S_LEN,S_color,SR_fx,SR_Ex,S_CDA,S_MCDA,S_CDANUM,S_MCDANUM, S_ON
		jmp continue3
labhds:
		dec_HBDAL S_CA,S_CANUM,S_MCA,S_FLAG,SL_fx,SL_Ex,S_fy,S_LEN,S_color,SR_fx,SR_Ex,S_CDA,S_MCDA,S_CDANUM,S_MCDANUM,S_ON,S_MCANUM,S_MAXY 

continue3:		
		cmp HB_CDA,0
		jnz labhd1
		CMP  HB_CDANUM,0
		jnz labhd1
			dec_HBAL  HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON
		jmp continue2
labhd1:
			dec_HBDAL HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON,HB_MCANUM,HB_MAXY 

continue2:
		cmp R_CDA,0
		jnz labhd2
		CMP  R_CDANUM,0
		jnz labhd2
			dec_HBAL  R_CA ,R_CANUM,R_MCA,R_FLAG,RL_fx,RL_Ex,R_fy,R_LEN,R_color,RR_fx,RR_Ex,R_CDA,R_MCDA,R_CDANUM,R_MCDANUM, R_ON
		jmp continue1
labhd2:
		dec_HBDAL R_CA ,R_CANUM,R_MCA,R_FLAG,RL_fx,RL_Ex,R_fy,R_LEN,R_color,RR_fx,RR_Ex,R_CDA,R_MCDA,R_CDANUM,R_MCDANUM, R_ON,R_MCANUM,R_MAXY 
		
continue1:
        cmp BS_CDA,0
		jnz labhd3
		CMP  BS_CDANUM,0		
		jnz labhd3
			dec_HBAL  BS_CA ,BS_CANUM,BS_MCA,BS_FLAG,BSL_fx,BSL_Ex,BS_fy,BS_LEN,BS_coloR,BSR_fx,BSR_Ex,BS_CDA,BS_MCDA,BS_CDANUM,BS_MCDANUM, BS_ON
		jmp continue0
labhd3:
		Dec_HBDAL BS_CA ,BS_CANUM,BS_MCA,BS_FLAG,BSL_fx,BSL_Ex,BS_fy,BS_LEN,BS_coloR,BSR_fx,BSR_Ex,BS_CDA,BS_MCDA,BS_CDANUM,BS_MCDANUM, BS_ON,BS_MCANUM,BS_MAXY 
		
continue0:
	RET
POWER_UPS ENDP
;*******************************************************
;               Game Helper functions
;*******************************************************
;*******************************************************

;*************************************************
; **** DRWWINNER - Function draws winner screen for 5 seconds ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWWINNER PROC
        PREP_BACKBROUND 00h
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
        RET
DRWWINNER ENDP

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
BULL_CHECK_DELAY_SPEED1:
		CMP D_ON,0
		JZ BULL_CHECK_BS
		CMP D_FLAG,0
		JZ BULL_CHECK_HELTH_DELAY_RIGHT
BULL_CHECK_HELTH_DELAY_LEFT:				
		   MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,DL_fx
        JNE BULL_CHECK_BS
        MOV AX,D_fy
        ADD AX,D_LEN
        SUB AX,DX
        CMP AX,D_LEN+3
        JNC BULL_CHECK_BS
        CALL DELAY_SPEED1
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTH_DELAY_RIGHT:	
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,DR_fx
        JNE BULL_CHECK_BS
        MOV AX,D_fy
        ADD AX,D_LEN
        SUB AX,DX
        CMP AX,D_LEN+3
        JNC BULL_CHECK_BS
        CALL DELAY_SPEED1
        JMP DEL_BUL_LEFT
;*****************************************************************		
BULL_CHECK_BS:
		CMP BS_ON,0
		JZ BULL_CHECK_Speed1
		CMP BS_FLAG,0
		JZ BULL_CHECK_HELTHBSRIGHT
BULL_CHECK_HELTHBSLEFT:	
			
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,BSL_fx
        JNE BULL_CHECK_Speed1
        MOV AX,BS_fy
        ADD AX,BS_LEN
        SUB AX,DX
        CMP AX,BS_LEN+3
        JNC BULL_CHECK_Speed1
		CALL INC_PROTECTBULLETLEFT
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTHBSRIGHT:	
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,BSR_fx
        JNE BULL_CHECK_Speed1
        MOV AX,BS_fy
        ADD AX,BS_LEN
        SUB AX,DX
        CMP AX,BS_LEN+3
        JNC BULL_CHECK_Speed1
        CALL INC_PROTECTBULLETLEFT
        JMP DEL_BUL_LEFT
			
BULL_CHECK_Speed1:
		CMP S_ON,0
		JZ BULL_CHECK_Rocket
		CMP S_FLAG,0
		JZ BULL_CHECK_HELTH_SPEED_RIGHT
BULL_CHECK_HELTH_SPEED_LEFT:				
		   MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,SL_fx
        JNE BULL_CHECK_Rocket
        MOV AX,S_fy
        ADD AX,S_LEN
        SUB AX,DX
        CMP AX,S_LEN+3
        JNC BULL_CHECK_Rocket
        CALL Speed_UP_Sh1_Health
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTH_SPEED_RIGHT:	
		   MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,SR_fx
        JNE BULL_CHECK_Rocket
        MOV AX,S_fy
        ADD AX,S_LEN
        SUB AX,DX
        CMP AX,S_LEN+3
        JNC BULL_CHECK_Rocket
        CALL Speed_UP_Sh1_Health
        JMP DEL_BUL_LEFT



;**********************************************************************
BULL_CHECK_Rocket:
		CMP R_ON,0
		JZ BULL_CHECK_HB
		CMP R_FLAG,0
		JZ BULL_CHECK_HELTHROCKRIGHT
BULL_CHECK_HELTROCKLEFT:	
			
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,RL_fx
        JNE BULL_CHECK_HB
        MOV AX,R_fy
        ADD AX,R_LEN
        SUB AX,DX
        CMP AX,R_LEN+3
        JNC BULL_CHECK_HB
        PUSHA
		PUSH DI
		PUSH SI
		MOV	R_CDANUM,AX
		DELETEH_HB R_CA ,R_CANUM,R_MCA,R_FLAG,RL_fx,RL_Ex,R_fy,R_LEN,R_color,RR_fx,RR_Ex,R_CDA,R_MCDA,R_CDANUM,R_MCDANUM, R_ON,R_MCANUM,R_MAXY
		POP SI
		POP DI
		POPA
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTHROCKRIGHT:	
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,RR_fx
        JNE BULL_CHECK_HB
        MOV AX,R_fy
        ADD AX,R_LEN
        SUB AX,DX
        CMP AX,R_LEN+3
        JNC BULL_CHECK_HB
        PUSHA
		PUSH DI
		PUSH SI
		MOV	R_CDANUM,AX
		DELETEH_HB R_CA ,R_CANUM,R_MCA,R_FLAG,RL_fx,RL_Ex,R_fy,R_LEN,R_color,RR_fx,RR_Ex,R_CDA,R_MCDA,R_CDANUM,R_MCDANUM, R_ON,R_MCANUM,R_MAXY
		POP SI
		POP DI
		POPA
        JMP DEL_BUL_LEFT
	;*********************************************************************	
BULL_CHECK_HB:
		CMP HB_ON,0
		JZ MOVE_BULLET_LEFT
		CMP HB_FLAG,0
		JZ BULL_CHECK_HELTHBACKETRIGHT
BULL_CHECK_HELTHBACKETLEFT:	
			
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,HBL_fx
        JNE MOVE_BULLET_LEFT
        MOV AX,HB_fy
        ADD AX,HB_LEN
        SUB AX,DX
        CMP AX,HB_LEN+3
        JNC MOVE_BULLET_LEFT
        CALL INCSH1HEALTH
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTHBACKETRIGHT:	
		MOV AX,CX
        ADD AX,buW
        INC AX
        CMP AX,HBR_fx
        JNE MOVE_BULLET_LEFT
        MOV AX,HB_fy
        ADD AX,HB_LEN
        SUB AX,DX
        CMP AX,HB_LEN+3
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
;************************************************************
		CMP D_ON,0
		JZ  BULR_CHECK_BS
		CMP D_FLAG,0
		JZ BULL_CHECK_HELTH_DELAY_RIGHT2
BULL_CHECK_HELTH_DELAY_LEFT2:				
		   MOV AX,CX
        dec ax
        CMP AX,DL_Ex
        JNE  BULR_CHECK_BS
        MOV AX,D_fy
        ADD AX,D_LEN
        SUB AX,DX
        CMP AX,D_LEN+3
        JNC  BULR_CHECK_BS
        CALL DELAY_SPEED2
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTH_DELAY_RIGHT2:	
		MOV AX,CX
        dec ax
        CMP AX,DR_Ex
        JNE  BULR_CHECK_BS
        MOV AX,D_fy
        ADD AX,D_LEN
        SUB AX,DX
        CMP AX,D_LEN+3
        JNC  BULR_CHECK_BS
        CALL DELAY_SPEED2
        JMP DEL_BUL_LEFT		
;****************************************************
 BULR_CHECK_BS:
		CMP BS_ON,0
		JZ BULR_CHECK_Speed2
		CMP BS_FLAG,0
		JZ BULR_CHECK_HELTHBSRIGHT
BULR_CHECK_HELTHBSLEFT:	
			
		MOV AX,CX
       
        DEC AX
        CMP AX,BSL_Ex
        JNE BULR_CHECK_Speed2
        MOV AX,BS_fy
        ADD AX,BS_LEN
        SUB AX,DX
        CMP AX,BS_LEN+3
        JNC BULR_CHECK_Speed2
		CALL INC_PROTECTBULLETRIGHT
        JMP DEL_BUL_RIGHT
		
BULR_CHECK_HELTHBSRIGHT:	
		MOV AX,CX
       DEC AX
        CMP AX,BSR_Ex
        JNE BULR_CHECK_Speed2
        MOV AX,BS_fy
        ADD AX,BS_LEN
        SUB AX,DX
        CMP AX,BS_LEN+3
        JNC BULR_CHECK_Speed2
        CALL INC_PROTECTBULLETRIGHT
        JMP DEL_BUL_RIGHT
		
BULR_CHECK_Speed2:
		CMP S_ON,0
		JZ BULL_CHECK_Rocket1
		CMP S_FLAG,0
		JZ BULL_CHECK_HELTH_SPEED_RIGHT1
BULL_CHECK_HELTH_SPEED_LEFT1:				
		MOV AX,CX
        dec AX
        CMP AX,SL_fx
        JNE BULL_CHECK_Rocket1
        MOV AX,S_fy
        ADD AX,S_LEN
        SUB AX,DX
        CMP AX,S_LEN+3
        JNC BULL_CHECK_Rocket1
        CALL Speed_UP_Sh2_Health
        JMP DEL_BUL_LEFT
BULL_CHECK_HELTH_SPEED_RIGHT1:	
		MOV AX,CX
        dec AX
        CMP AX,SR_fx
        JNE BULL_CHECK_Rocket1
        MOV AX,S_fy
        ADD AX,S_LEN
        SUB AX,DX
        CMP AX,S_LEN+3
        JNC BULL_CHECK_Rocket1
        CALL Speed_UP_Sh2_Health
        JMP DEL_BUL_LEFT
;***********************************************************
;******************************************************
BULL_CHECK_Rocket1:
		CMP R_ON,0
		JZ BULR_CHECK_HELTHBACKET
		CMP R_FLAG,0
		JZ BULR_CHECK_HELTHROCKRIGHT
BULR_CHECK_HELTHROCKLEFT:		
		MOV AX,CX
        DEC AX
        CMP AX,RL_Ex
        JNE BULR_CHECK_HELTHBACKET
        MOV AX,R_fy
        ADD AX,R_LEN
        SUB AX,DX
        CMP AX,R_LEN+3
        JNC BULR_CHECK_HELTHBACKET
        PUSHA
		PUSH DI
		PUSH SI
		MOV	R_CDANUM,AX
		DELETEH_HB R_CA ,R_CANUM,R_MCA,R_FLAG,RL_fx,RL_Ex,R_fy,R_LEN,R_color,RR_fx,RR_Ex,R_CDA,R_MCDA,R_CDANUM,R_MCDANUM, R_ON,R_MCANUM,R_MAXY
		POP SI
		POP DI
		POPA
        JMP DEL_BUL_RIGHT
BULR_CHECK_HELTHROCKRIGHT:	
		MOV AX,CX
        DEC AX
        CMP AX,RR_Ex
        JNE BULR_CHECK_HELTHBACKET
        MOV AX,R_fy
        ADD AX,R_LEN
        SUB AX,DX
        CMP AX,R_LEN+3
        JNC BULR_CHECK_HELTHBACKET
        PUSHA
		PUSH DI
		PUSH SI
		MOV	R_CDANUM,AX
		DELETEH_HB R_CA ,R_CANUM,R_MCA,R_FLAG,RL_fx,RL_Ex,R_fy,R_LEN,R_color,RR_fx,RR_Ex,R_CDA,R_MCDA,R_CDANUM,R_MCDANUM, R_ON,R_MCANUM,R_MAXY
		POP SI
		POP DI
		POPA
        JMP DEL_BUL_RIGHT
;********************************************************		
BULR_CHECK_HELTHBACKET:
		CMP HB_ON,0
		JZ MOVE_BULLET_RIGHT
		CMP HB_FLAG,0
		JZ BULR_CHECK_HELTHBACKETRIGHT
BULR_CHECK_HELTHBACKETLEFT:	
			
			
		MOV AX,CX
        DEC AX
        CMP AX,HBL_Ex
        JNE MOVE_BULLET_RIGHT
        MOV AX,HB_fy
        ADD AX,HB_LEN
        SUB AX,DX
        CMP AX,HB_LEN+3
        JNC MOVE_BULLET_RIGHT
        CALL INCSH2HEALTH
        JMP DEL_BUL_RIGHT
BULR_CHECK_HELTHBACKETRIGHT:	
		MOV AX,CX
        ADD AX,buW
        DEC AX
        CMP AX,HBR_Ex
        JNE MOVE_BULLET_RIGHT
        MOV AX,HB_fy
        ADD AX,HB_LEN
        SUB AX,DX
        CMP AX,HB_LEN+3
        JNC MOVE_BULLET_RIGHT
        CALL INCSH2HEALTH
        JMP DEL_BUL_RIGHT
		;*********************************************
MOVE_BULLET_RIGHT:
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

;************************************************************************************************

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
		CMP SH1PROTECT_FLAG,0
		JZ LABDC1
		DEC SH1TIMES_PROTECT
		CMP SH1TIMES_PROTECT,0
		JNZ EMDD
		MOV SH1PROTECT_FLAG,0
		MOV SHIP1COLOR,33H
		CALL DRWSHIPS
		JMP EMDD
		LABDC1:
		dec sh1health
		call drawhelthsh1
		EMDD:
		popa
        JMP OUT_DECH1_LB
		
        ; TODO: Redraw the number
PLAYER2_WINS: ; winner 
        MOV IsThereAWinner, 01H
	PREP_BACKBROUND 00h
        MOVE_CURSOR  07,07,0
        PRINTMESSAGE window_winner
        MOVE_CURSOR  0fh,09,0
        PRINTMESSAGE playership2
        PRINTMESSAGE st7
        DELAY
       
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
		CMP SH2PROTECT_FLAG,0
		JZ LABDC21
		DEC SH2TIMES_PROTECT
		CMP SH2TIMES_PROTECT,0
		JNZ EMDD2
		MOV SH2PROTECT_FLAG,0
		MOV SHIP2COLOR,33H
		CALL DRWSHIPS
		JMP EMDD2
		LABDC21:
		dec sh2health
		call drawhelthsh2
		EMDD2:
		popa
        JMP OUT_DECH2_LB
PLAYER1_WINS:
		MOV IsThereAWinner, 01H
        PREP_BACKBROUND 00h
        MOVE_CURSOR  07,07,0
        PRINTMESSAGE window_winner
        MOVE_CURSOR  0fh,09,0
        PRINTMESSAGE playership1
        PRINTMESSAGE st7
        DELAY
OUT_DECH2_LB:      
        RET
DECP2HEALTH ENDP

INC_PROTECTBULLETLEFT Proc
	    PUSHA
		PUSH DI
		PUSH SI
		MOV	BS_CDANUM,AX
		DELETEH_HB BS_CA ,BS_CANUM,BS_MCA,BS_FLAG,BSL_fx,BSL_Ex,BS_fy,BS_LEN,BS_color,BSR_fx,BSR_Ex,BS_CDA,BS_MCDA,BS_CDANUM,BS_MCDANUM, BS_ON,BS_MCANUM,BS_MAXY
		MOV SH1PROTECT_FLAG,1
		
		MOV SHIP1COLOR,BS_COLOR
		CALL DRWSHIPS
		MOV SH1TIMES_PROTECT,5
		
		POP SI
		POP DI
		POPA
		RET
INC_PROTECTBULLETLEFT ENDP

INC_PROTECTBULLETRIGHT Proc
	    PUSHA
		PUSH DI
		PUSH SI
		MOV	BS_CDANUM,AX
		DELETEH_HB BS_CA ,BS_CANUM,BS_MCA,BS_FLAG,BSL_fx,BSL_Ex,BS_fy,BS_LEN,BS_color,BSR_fx,BSR_Ex,BS_CDA,BS_MCDA,BS_CDANUM,BS_MCDANUM, BS_ON,BS_MCANUM,BS_MAXY
		MOV SH2PROTECT_FLAG,1
		MOV SHIP2COLOR,BS_COLOR
		CALL DRWSHIPS
		MOV SH2TIMES_PROTECT,5
		POP SI
		POP DI
		POPA
		RET
INC_PROTECTBULLETRIGHT ENDP

INCSH2HEALTH PROC 
	
	PUSHA
	PUSH DI
	PUSH SI
	cmp sh2health,10
	jz  conthb2
	inc sh2health
	call drawhelthsh2
	conthb2:
	MOV	HB_CDANUM,AX
	DELETEH_HB HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON,HB_MCANUM,HB_MAXY
	POP SI
	POP DI
	POPA
	RET

INCSH2HEALTH ENDP

INCSH1HEALTH PROC 
	
	PUSHA
	PUSH DI
	PUSH SI
	cmp sh1health,10
	jz  conthb
	inc sh1health
	call drawhelthsh1
	conthb:
	MOV	HB_CDANUM,AX
	DELETEH_HB HB_CA ,HB_CANUM,HB_MCA,HB_FLAG,HBL_fx,HBL_Ex,HB_fy,HB_LEN,HB_color,HBR_fx,HBR_Ex,HB_CDA,HB_MCDA,HB_CDANUM,HB_MCDANUM, HB_ON,HB_MCANUM,HB_MAXY
	POP SI
	POP DI
	POPA
	RET

INCSH1HEALTH ENDP
;*****************************************************
 Speed_UP_Sh1_Health Proc
	 PUSHA
	 PUSH DI
	 PUSH SI
	 
	 MOV	S_CDANUM,AX
	 DELETEH_HB S_CA,S_CANUM,S_MCA,S_FLAG,SL_fx,SL_Ex,S_fy,S_LEN,S_color,SR_fx,SR_Ex,S_CDA,S_MCDA,S_CDANUM,S_MCDANUM,S_ON,S_MCANUM,S_MAXY
	 inc Ship1_Speed
	 
	
	 POP SI
	 POP DI
	 POPA
	 RET
 Speed_UP_Sh1_Health ENDP
;************************************

;**********************************
Speed_UP_Sh2_Health PROC
	PUSHA
	PUSH DI
	PUSH SI
	inc Ship2_Speed
	MOV	S_CDANUM,AX
	DELETEH_HB S_CA,S_CANUM,S_MCA,S_FLAG,SL_fx,SL_Ex,S_fy,S_LEN,S_color,SR_fx,SR_Ex,S_CDA,S_MCDA,S_CDANUM,S_MCDANUM,S_ON,S_MCANUM,S_MAXY
	POP SI
	POP DI
	POPA
	RET
RET
Speed_UP_Sh2_Health ENDP
;***********************************************************************
DELAY_SPEED1 Proc
	PUSHA
	PUSH DI
	PUSH SI	 
	MOV	D_CDANUM,AX
	DELETEH_HB D_CA,D_CANUM,D_MCA,D_FLAG,DL_fx,DL_Ex,D_fy,D_LEN,D_color,DR_fx,DR_Ex,D_CDA,D_MCDA,D_CDANUM,D_MCDANUM,D_ON,D_MCANUM,D_MAXY
cmp Ship1_Speed,1
JBE exit_out
dec Ship1_Speed
exit_out:	
	POP SI
	POP DI
	POPA	
	RET
DELAY_SPEED1 ENDP
;**********************************************
DELAY_SPEED2 Proc
	PUSHA
	PUSH DI
	PUSH SI	 
	MOV	D_CDANUM,AX
	DELETEH_HB D_CA,D_CANUM,D_MCA,D_FLAG,DL_fx,DL_Ex,D_fy,D_LEN,D_color,DR_fx,DR_Ex,D_CDA,D_MCDA,D_CDANUM,D_MCDANUM,D_ON,D_MCANUM,D_MAXY
cmp Ship2_Speed,1
JBE exit_out1
dec Ship2_Speed
exit_out1:	
	POP SI
	POP DI
	POPA	
	RET
DELAY_SPEED2 ENDP


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

CLRMEMORY PROC
        ; Reset winner flag
        MOV IsThereAWinner, 00H
        ; Reset variable data of ship1
        MOV sh1p1fy,1D
        MOV sh1p2fy,12D
        ; Reset variable data of ship2
        MOV sh2p1fy,1D
        MOV sh2p2fy,12D
        ; Reset variable data of the reflector
        MOV REFfristY, 1D
        MOV REFflag, 1D
        MOV REFCTR, 0FFFH
        ; Reset bullets array
        CMP [DI], 0FEFEH
        JNE START_WITHOUT_INITIAL_DECREMENT
        SUB DI,4
START_WITHOUT_INITIAL_DECREMENT:
        MOV [DI], 0FFFFH
        MOV [DI+2], 0FFFFH
        CMP DI,offset bullPoses
        JE FINISHED_CLEANING_BULLS
        SUB DI,4
        JMP START_WITHOUT_INITIAL_DECREMENT
FINISHED_CLEANING_BULLS:
        ; Reset bullets counter
        MOV bullLCtr, bullLSpeed
        MOV bullRCtr, bullRSpeed
        ; Reset health
	MOV sh1health,10D
        MOV sh2health,10D  
        ; Check for any undeleted powerups and delete them
        MOV HB_ON,0H
        RET
CLRMEMORY ENDP
END	MAIN