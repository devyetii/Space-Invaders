include mymacros.inc
.model small
	.stack 64
	.data
		st0 db ' to end game click f4 & TO PAUSE F1 $'
		st1 db 'To Start Chatting Press F1',10,13,10,13,'       TO Start Playing Game Press F2',10,13,10,13,'       To End The Programe Press Esc',10,13,10,13,'$'
		st2 db 'press Enter to back to main menu',10,13,10,13,'$'
		st3 db 'screen for chatting ',10,13,10,13,'$'
		st4 db 'screen for playing ',10,13,10,13,'$'
		st5 db 'screen for Exiting ',10,13,10,13,'$'
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
		ShipSizep1y     equ  30  ; part 1 in ship length
		ShipSizep2Y     equ  8   ; part 2 in ship length
		PLAYER_SC_pY    EQU 13H  ;player score position y
		PLAYER1_SC_pX   EQU 01H  ;player 1 score position x
        PLAYER2_SC_pX   EQU 14H  ;player 2 score position y
		PLAYER1_msg_py  EQU 15H  ;player 1 message position y
        PLAYER2_msg_py  EQU 18H  ;player 2 message position y
		;*********************************SHIP 1
		sh1p1fy   DW 1
		sh1p2fy   DW 16
		sh1p1fx   EQU 5
		sh1p1ENDx equ 15
		sh1p2fx   EQU 16
		sh1p2ENDx equ 21
		;**********************************ship 2
		sh2p1fy   DW   1
		sh2p2fy   DW   16
		sh2p1fx   EQU 620
		sh2p1ENDx equ 630
		sh2p2fx   EQU 614
		sh2p2ENDx equ 619
        ;*********************************** REFLECTOR 1
        REFfristY DW    1
		REFfristX EQU  471
		REFendX   EQU  476
		REFflag   dw    0             ; it take one or two  to detrmine if it move up "if 1" or move down "if 0"
		REFSPEED  DW   0fffh                  ;It is the counter when equal zero the reflector step & it control speed of reflector
		;*********************************players
		player1_sc db   'Player1 score: 0$'
		player2_sc db   'Player2 score: 0$'
		player1_ms db   'Player1: $'
		player2_ms db   'Player2: $'

	.code
		main proc far
		mov ax ,@data
		mov ds,ax
;****************************
		DETERMINE_mode 13H ,00H ; VIDEO MODE
		LABLE4:
			PREP_BACKBROUND BGCOLOR ; TO PREPARE BACKGROUD COLOR & QUALITIES
			MOVE_CURSOR 7H,7H,0 ;to write in the middle of screen
			PRINTMESSAGE st1   ;Print 3 cases
;********************************************
			mov ah,0
			int 16h
			mov ah,0    ;Get key pressed (Wait for a key-AH:scancode,AL:ASCII)
			int 16h  
			cmp ah,3bh   ;compare key pressed with F1 & scan code of F1 IS "3BH"
		jz clean1    ;jump to chatting screen if F1 presssed
		jnz nxt1  ;check for F2
;***********************************************
		clean1:   ;chatting screen
			PREP_BACKBROUND BGCOLOR  ; TO PREPARE BACKGROUD COLOR & QUALITIES
			MOVE_CURSOR 1,1,00H  ;to write at the top of screen
			PRINTMESSAGE st2     ;Display ST2
			PRINTMESSAGE st3     ;Display ST3
			tack_keyboard:
				mov ah,0
				int 16h
				mov ah,0
				int 16h   
				cmp ah,1ch ;compare key with ENTER 
		jz LABLE4  ;jump to main menu ; "ask"
		jnz tack_keyboard
;*******************
		nxt1:
			cmp ah,3ch;scan code of F2=3c
		jz clean2  ;jump to playing screen if F2 presssed
		jnz nxt2   ;else check for ESC
				
		clean2: ;playing screen
			call level_one
			cmp dx,1
		jnz clean3
		jz LABLE4

		NXT2:
		cmp ah,01h;scan code of ESC
		;#return to TEXT mode if ESC pressed#;
		jz clean3
		jnz nxt3
		clean3:
		
			DETERMINE_mode 03H,00H  ;Change video mode (Text MODE)
			PRINTMESSAGE ST5   ; 
			
		nxt3:
		mov ah ,4ch
		int 21h   ;TO END PROGRAMM
	MAIN    ENDP
	

;********************************
 level_one PROC
;****************************** to play mode
		DETERMINE_mode 13H, 00H;
;*******************to make background color
		PREP_BACKBROUND BGCOLOR
;*************************************************DROWWING
		drow_thick_line BOARDER1FX,BOARDER1EX ,BOARDER1FY,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW UPPER BOARD
		drow_thick_line BOARDER1FX,BOARDER1EX,BOARDER1FY+15,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW MIDLE BOARD
		drow_thick_line BOARDER1FX,BOARDER1EX ,BOARDER1FY+32,BOARDERTHICK,BOARDSCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW down BOARD
		;*************************************print  strings
		MOVE_CURSOR  PLAYER1_SC_pX,PLAYER_SC_pY,0
		PRINTMESSAGE player1_sc
		MOVE_CURSOR  PLAYER2_SC_pX,PLAYER_SC_pY,0
		PRINTMESSAGE player2_sc
		 ;*************
		MOVE_CURSOR  PLAYER1_SC_pX,PLAYER1_msg_py,0
		PRINTMESSAGE player1_ms
		MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py-1,0
		PRINTMESSAGE player2_ms
		MOVE_CURSOR  PLAYER1_SC_pX,PLAYER2_msg_py,0
		PRINTMESSAGE st0
;**********************************************REFLECTOR
		drow_thick_line REFfristX,REFendX,REFfristY,REFLECTORlen,REFLECTORCOLOR  ; "dROW_THICK_line" IS MACRO TO DRAW REFLECTOR
;************************************************* to draw ships
		drow_thick_line  sh1p1fx,sh1p1ENDx,sh1p1fy,ShipSizep1y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 1
		drow_thick_line  sh1p2fx,sh1p2ENDx,sh1p2fy,ShipSizep2y,ship1color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 1 PART 2
		drow_thick_line  sh2p1fx,sh2p1ENDx,sh2p1fy,ShipSizep1y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 1
		drow_thick_line  sh2p2fx,sh2p2ENDx,sh2p2fy,ShipSizep2y,ship2color  ; "dROW_THICK_line" IS MACRO TO DRAW SHIP 2 PART 2
;*************************************************REFLECTOR ONE
		REFMOVE:        ; TO MOVE REFLECTOR
		CMP REFSPEED ,0 ; WHEN REFSPEED =0 IT WILL MOVE
		JNZ CHECK1
		MOV AX,  0fffh  ; fill counter again 
		MOV REFSPEED,AX
		CMP REFflag,1    ; if move up else move down
		JZ REFMOVEUP
		JNZ REFMOVEDOWN
		
;********
		REFMOVEDOWN:
			MOVEDOWN REFfristY,REFLECTORlen,REFfristX,REFendX,BGCOLOR,REFLECTORCOLOR ;MOVE DOWN REFLECTOR "MOVEDOWN" IS A MACRO
			CMP REFfristY,84   ;if it is in the end possible y  
		JZ SETFLAG
		JNZ CHECK1
;**************
		CHECK1:
		JMP CHECK
;***************
		REFMOVEUP:
			MOVEUP REFfristY,REFLECTORlen,REFfristX,REFendX,BGCOLOR,REFLECTORCOLOR  ;MOVE UP REFLECTOR "MOVEDOWN" IS A MACRO
			CMP REFfristY,1    ;if it is in the upper possible y
		JZ RESETFLAG
		JNZ CHECK1
;******************
		REFMOVE1:
		JMP REFMOVE
;******************
		RESETFLAG:                  ; TO MAKE FLAG MOVE DOWN
			MOV AX,0
			MOV REFflag ,AX
		JMP CHECK
;**********
		SETFLAG:                   ;TO MAKE FLAG MOVE UP
			MOV AX,1
			MOV REFflag ,AX
		JMP CHECK
;*************************************************
		CHECK:                    ; check keyboard                            
		MOV AX, REFSPEED
		DEC AX  ; DEC REFSPEED TO decrease counter to MAKE THE REFLECTOR MOVE 
		MOV REFSPEED, AX
		mov ah,1
		int 16h
		JZ REFMOVE1
		JNZ LAB1  
		;*****************TO PREPARE TAKE OTHER CLICK
		ReadKey2:
			mov ah,0
			int 16h
		jmp REFMOVE1
;****************************************************** CHECK MOVE KEYBOARD BUTTON
		LAB1:
			cmp al,87                        ; IF W CAPITAL THE KEY TO MOVE UP FOR SHIP2
		jz moveupsh2
			cmp al,119                       ; IF w small THE KEY TO MOVE UP FOR SHIP2
		jz moveupsh2
		JNZ LAB0
;**************
		moveupsh2:
		   CMP SH2P1FY,1 ;if it is in the upper possible y
		   jZ ReadKey3
		   MOVEUP  sh2p1fy,ShipSizep1y,sh2p1fx,sh2p1ENDx,BGCOLOR,ship2color ;MOVE  UP SHIP 2 PART 1 "MOVEUP" IS A MACRO
		   MOVEUP  sh2p2fy,ShipSizep2y,sh2p2fx,sh2p2ENDx,BGCOLOR,ship2color ;MOVE  UP SHIP 2 PART 2 "MOVEUP" IS A MACRO
		jmp ReadKey3
;******************TO PREPARE TAKE OTHER CLICK
		ReadKey3:
			mov ah,0
			int 16h
		jmp REFMOVE1
;****************
		LAB0:
		    cmp ah,72                        ;iF UP ARROW  TO MOVE UP FOR SHIP1
		jz moveupsh1
		JNZ LAB2
;***************
		moveupsh1:
		   CMP SH1P1FY,1  ;if it is in the upper possible y
		   jZ ReadKey1
		   MOVEUP  sh1p1fy,ShipSizep1y,sh1p1fx,sh1p1ENDx,BGCOLOR,ship1color ;MOVE UP SHIP 1 PART 1 "MOVEUP" IS A MACRO
		   MOVEUP  sh1p2fy,ShipSizep2y,sh1p2fx,sh1p2ENDx,BGCOLOR,ship1color ;MOVE UP SHIP 1 PART 2 "MOVEUP" IS A MACRO
		jmp ReadKey1
;****************
		LAB2:
			cmp ah,80                        ;iF down ARROW  TO MOVE down FOR SHIP1
	    jz movedownsh1
		JNZ LAB3
;*****************
		ReadKey1:
			mov ah,0
			int 16h
		jmp REFMOVE1
;****************
		movedownsh1:
		   CMP SH1P1FY,115 ;if it is in the end possible y
		   jZ ReadKey1
		   MOVEDOWN  sh1p1fy,ShipSizep1y,sh1p1fx,sh1p1ENDx,BGCOLOR,ship1color ;MOVE DOWN SHIP 1 PART 1 "MOVEDOWN" IS A MACRO
		   MOVEDOWN  sh1p2fy,ShipSizep2y,sh1p2fx,sh1p2ENDx,BGCOLOR,ship1color ;MOVE DOWN SHIP 1 PART 2 "MOVEDOWN" IS A MACRO
		jmp ReadKey
;*****************
		LAB3:
			cmp al,83                        ; IF S CAPITAL THE KEY TO MOVE DOWN FOR SHIP2
		jz movedownsh2
			cmp al,115                        ; IF s SMALL THE KEY TO MOVE DOWN FOR SHIP2
		jz movedownsh2
		jnz lab4
;***************
		movedownsh2:
		    CMP SH2P1FY,115  ;if it is in the end possible y
 			jZ ReadKey
			MOVEDOWN  sh2p1fy,ShipSizep1y,sh2p1fx,sh2p1ENDx,BGCOLOR,ship2color ;MOVE DOWN SHIP 2 PART 1 "MOVEDOWN" IS A MACRO
			MOVEDOWN  sh2p2fy,ShipSizep2y,sh2p2fx,sh2p2ENDx,BGCOLOR,ship2color ;MOVE DOWN SHIP 2 PART 2 "MOVEDOWN" IS A MACRO
		jmp ReadKey

;********************************TO PREPARE TAKE OTHER CLICK
		ReadKey:
			mov ah,0
			int 16h
		jmp REFMOVE1
;*********************************to end
		lab4:
			cmp ah,3eh
		jz exit1
		jnz ask_pause
;******************************to ask pause
		ask_pause:
			cmp ah,3bh
		jz pause1
		jnz ReadKey
;****************************to pause
		pause1:
			mov dx,1
			jmp endlevel
;**************************to exit
		exit1:
			mov dx,0
			jmp endlevel
;****************************** to go back
		endlevel:	
			ret
level_one ENDP
END MAIN