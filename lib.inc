;; JUST FIXING AN ERROR OF DOSBOX 
PUSHA MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
ENDM PUSHA

POPA MACRO
    POP DX
    POP CX
    POP BX
    POP AX
ENDM POPA

; PREP_BACKBROUND - Colors the whole background
; Params : (byte) BGCOLOR - Color code of the background 
PREP_BACKBROUND MACRO BGCOLOR
				MOV AH, 06h    ; Scroll up function
				XOR AL, AL     ; Clear entire screen
				XOR CX, CX     ; Upper left corner CH=row, CL=column
				MOV DX, 184FH  ; lower right corner DH=row, DL=column
				MOV BH, BGCOLOR    ; color
				INT 10H
ENDM PREP_BACKBROUND

; PRINTMESSAGE - to print message
; Params: (byte*) MyMessage - Pointer to the first byte of the message
PRINTMESSAGE MACRO MyMessage           ; to print message
                mov ah,9h
                mov dx,offset MyMessage
                int 21h 
                
ENDM PRINTMESSAGE 

; MOVE_CURSOR - macro to determine the location to write
; Params:   (byte) X - coloumn number
;           (byte) Y - row number
;           (byte) page_num - Page number (0 for graphics modes)
MOVE_CURSOR MACRO X,Y,page_num
	    mov dl, x ; Column
		mov dh, y ; Row
		mov bx, 0 ; Page number 0 for graphics modes
		mov ah, 2h
		int 10h
ENDM MOVE_CURSOR

; DETERMINE_MODE - Goes to a specific mode
; Params:   (byte) MODE_NUM - Mode Number according to the list of CGA Modes
;           (byte) page_num - Page number (0 for graphics modes)
DETERMINE_MODE MACRO MODE_NUM,PAGE_NUM
			mov ah,0                ;Change video mode (Graphical MODE)
			mov al,MODE_NUM        ;Max memory size 16KByte
			mov bx,PAGE_NUM
			int 10h
ENDM DETERMINE_mode

; TOVID - Changes to video mode
TOVID MACRO
    ; PUSH AX
    MOV AH,00H
    MOV AL,13H
    INT 10H
    ; POP AX
ENDM TOVID

; GETKEY - Get key pressed (Wait for a key-AH:scancode,AL:ASCII) 
GETKEY MACRO 
    MOV AH,0
    INT 16H
ENDM GETKEY

;GETKEY_NOWAIT - Get key pressed without waiting
GETKEY_NOWAIT MACRO
    MOV AH,1
    INT 16H
    clearkeyboardbuffer
ENDM GETKEY_NOWAIT

;--------------------------------------------------------------------------
; clears keyboard buffer
;--------------------------------------------------------------------------
clearkeyboardbuffer MACRO
	push	ax
	mov		ax, 0000h
	mov		es, ax
	mov		es:[041ah], 041eh
	mov		es:[041ch], 041eh				; Clears keyboard buffer
	pop		ax
endm  clearkeyboardbuffer


; COMPARE_KEY - Compares a keyboard key Stored in AH with a Given scan code and sets ZF if equal
; Params: (byte) KSCAN - Scan code for the compared key  
COMPARE_KEY MACRO KSCAN
    CMP AH, KSCAN
ENDM COMPARE_KEY

; COMPARE_KEY_ASCII - Compares a keyboard key Stored in AH with a Given scan code and sets ZF if equal
; Params: (byte) KASCII - ASCII code for the compared key  
COMPARE_KEY_ASCII MACRO KASCII
    CMP AL, KASCII
ENDM COMPARE_KEY_ASCII

; DRWPX - Draw a pixel at X,Y with color C
DRWPX MACRO C
    MOV AL,C
    MOV AH,0CH
    INT 10H
ENDM DRWPX

;DELAY
DELAY MACRO
		LOCAL LABELD1
       mov bh,05h ; sec num
		mov ah,2ch
		int 21h
		mov [di],dh
		labeld1:
			int 21h
			sub dh,[di]
			cmp dh,bh
		jb labeld1
ENDM DELAY

; CALL_PROC_IF_EQUAL - Calls a certain procedure if the ZF is set
; Params: PROCEDURE => (proc) Proc. to call
CALL_PROC_IF_EQUAL   MACRO    PROCEDURE
        LOCAL OUT_LP
        JNZ OUT_LP
        CALL PROCEDURE
OUT_LP: NOP
ENDM CALL_PROC_IF_EQUAL

; CALL_MACRO_IF_EQUAL - Calls a certain Macro if the ZF is set
; Params: MACROLBL => (MACRO) Macro to call
CALL_MACRO_IF_EQUAL MACRO MACROLBL
        LOCAL OUT_LP
        JNZ OUT_LP
        MACROLBL
OUT_LP: NOP
ENDM CALL_MACRO_IF_EQUAL

; drow_thick_line - Draw a thick line
; Params:   xf - first x,
;           xe - end x,
;           ysize - length,
;           yf - first y,color
drow_thick_line MACRO XF,XE,YF,YSIZE,COLOR
        LOCAL BACK
        LOCAL label1
        mov cx,XF
        label1: 
            mov DX, YF
            mov Bl,YSIZE
            mov al,color ;Pixel color
            mov ah,0ch ;Draw Pixel Command
            back:     
                int 10h
                add DX,1
                dec bl	
            jnz back
            inc cx
            cmp cx,XE
        jnz label1

ENDM drow_thick_line  

; MOVEUP - Moves a line vertically upward and updates its data
; Uses : AX
; Params:   LINEFY - YPos of Line's top
;           LENGTH - Length of the line
;           LINEFX - XPos of Line's top
;           LINEendX - XPos of Line's bottom
;           BGCOLOR - Background color
;           LINECOLOR - Color of the color
MOVEUP MACRO LINEFY,LENGTH,LINEFX,LINEendX,BGCOLOR,LINECOLOR ; macro to move line up "BGCOLOR" is aback ground color
			mov ax,LINEFY
			ADD AX,LENGTH-1
			DROWROW  LINEFX,LINEendX,AX,BGCOLOR
			mov ax,LINEFY
			sub ax,1
			mov LINEFY,ax
			DROWROW  LINEFX,LINEendX,LINEFY,LINECOLOR			
ENDM MOVEUP

MOVEDOWN MACRO LINEFY,LENGTH,LINEFX,LINEendX,BGCOLOR,LINECOLOR ; macro to move line down "BGCOLOR" is aback ground color
			DROWROW  LINEFX,LINEendX,LINEFY,bgcolor
			mov ax, LINEFY
			inc ax
			mov LINEFY,AX
			ADD AX,LENGTH-1
			DROWROW  LINEFX,LINEendX,AX,LINECOLOR			
ENDM MOVEDOWN     

DROWrow MACRO XF,XE,Y,COLOR  ;this a macro to draw one row with frist x "XF" ,end x "XE",y ,color
			LOCAL LAB
			MOV CX,XF
			MOV DX,Y
			mov al,color ;Pixel color
			mov ah,0ch ;Draw Pixel Command
			LAB:
			 INT 10H
			 INC CX
			CMP CX,XE
			JNZ LAB
ENDM DROWrow  

; PAUSE - Exits out if f1
PAUSE MACRO
        LOCAL OUT_LP
        LOCAL PAUSE_LP
PAUSE_LP:
        GETKEY
        COMPARE_KEY 03BH
        JE OUT_LP
        JMP PAUSE_LP
OUT_LP: NOP
ENDM PAUSE

HALT MACRO
        MOV AH,4CH
        INT 21H
ENDM HALT

read macro 

		mov ah,0AH        ;Read from keyboard
		mov dx,MyBuffer               
		int 21h
		
endm read

cursor_on macro  ; TO SHOW CURSOR
	   mov  ah, 1
	   mov  cx, 4         ;?¦¦ BIG CURSOR.
	   int  10h
endm	cursor_on 


DROWPRE_POWERUP MACRO
				LOCAL LABPROWER1
				PUSHA
				PUSH SI
				PUSH DI
				XOR byte ptr POWERUP_XFLAG ,00000001B
				RANDOM0_1 04H
				ADD AX,1
				MOV POWERUP_color,AL
				RANDOM0_1 30H
				MOV BX,POWERUP_fy
				ADD BX,AX
				CMP BX,POWERUP_MAXY 
				JB LABPROWER1
				MOV BX,11H
			LABPROWER1:
				MOV POWERUP_fy,BX
				drow_thick_line POWERUPR_fx,POWERUPR_ex,POWERUP_fy,POWERUP_LEN,POWERUP_coloR
				drow_thick_line POWERUPL_fx,POWERUPL_ex,POWERUP_fy,POWERUP_LEN,POWERUP_coloR
				MOV POWERUP_L_IS_DRAWN,1
				MOV POWERUP_R_IS_DRAWN,1
				MOV POWERUP_COUNTER,POWERUP_TODELETE
				MOV POWERUP_ON,1
				POP DI
				POP SI
				POPA
ENDM DROWPRE_POWERUP

DELETEP_POWERUP MACRO
				LOCAL FIND_IF_POWERUP_R_IS_DRAWN
				LOCAL NO_POWERUPS_ARE_DRAWN
				PUSHA
				PUSH SI
				PUSH DI
				CMP POWERUP_L_IS_DRAWN,1
				JNZ FIND_IF_POWERUP_R_IS_DRAWN
				drow_thick_line POWERUPL_fx,POWERUPL_ex,POWERUP_fy,POWERUP_LEN,00H
				MOV POWERUP_L_IS_DRAWN,0
FIND_IF_POWERUP_R_IS_DRAWN:
				CMP POWERUP_R_IS_DRAWN,1
				JNZ NO_POWERUPS_ARE_DRAWN
				drow_thick_line POWERUPR_fx,POWERUPR_ex,POWERUP_fy,POWERUP_LEN,00H
				MOV POWERUP_R_IS_DRAWN,0
NO_POWERUPS_ARE_DRAWN:
				MOV POWERUP_COUNTER,POWERUP_TODROW
				MOV POWERUP_ON,0
				POP DI
				POP SI
				POPA
ENDM DELETEP_POWERUP

DELETE_POWERUP_ONLY MACRO
	LOCAL DELETE_RIGHT_POWERUP
	LOCAL OUT_DELETE_POWERUP_ONLY
	PUSHA
	PUSH SI
	PUSH DI
	CMP POWERUP_XFLAG,0
	JNZ DELETE_RIGHT_POWERUP
	drow_thick_line POWERUPL_fx,POWERUPL_ex,POWERUP_fy,POWERUP_LEN,00H
	MOV POWERUP_L_IS_DRAWN,0
	JMP OUT_DELETE_POWERUP_ONLY
DELETE_RIGHT_POWERUP:
	drow_thick_line POWERUPR_fx,POWERUPR_ex,POWERUP_fy,POWERUP_LEN,00H
	MOV POWERUP_R_IS_DRAWN,0
OUT_DELETE_POWERUP_ONLY:
	POP DI
	POP SI
	POPA
ENDM DELETE_POWERUP_ONLY



DROWPRE_ROCKET MACRO
				LOCAL LABROCKET
				LOCAL DROW__LEFT
				LOCAL END_DROW_ROCKET
				PUSHA
				PUSH SI
				PUSH DI
				XOR byte ptr ROCKET_XFLAG ,00000001B
				RANDOM0_1 30H
				MOV BX,ROCKET_fy
				ADD BX,AX
				CMP BX,ROCKET_MAXY 
				JB LABROCKET
					MOV BX,11H
				LABROCKET:
					MOV ROCKET_fy,BX
					drow_thick_line ROCKETR_fx,ROCKETR_ex,ROCKET_fy,ROCKET_LEN,ROCKET_coloR
					drow_thick_line ROCKETL_fx,ROCKETL_ex,ROCKET_fy,ROCKET_LEN,ROCKET_coloR
					MOV ROCK_L_IS_DRAWN,1
					MOV ROCK_R_IS_DRAWN,1
				END_DROW_ROCKET:
					MOV ROCKET_COUNTER,ROCKET_TODELETE
					MOV ROCKET_ON,1
					POP DI
					POP SI
					POPA
ENDM DROWPRE_ROCKET

DELETEP_ROCKET MACRO
				LOCAL FIND_IF_ROCK_R_IS_DRAWN
				LOCAL NO_ROCKS_ARE_DRAWN	 
				PUSHA
				PUSH SI
				PUSH DI
				CMP ROCK_L_IS_DRAWN,0
				JZ FIND_IF_ROCK_R_IS_DRAWN
				drow_thick_line ROCKETL_fx,ROCKETL_ex,ROCKET_fy,ROCKET_LEN,00H
FIND_IF_ROCK_R_IS_DRAWN:
				CMP ROCK_R_IS_DRAWN,0
				JZ NO_ROCKS_ARE_DRAWN
				drow_thick_line ROCKETR_fx,ROCKETR_ex,ROCKET_fy,ROCKET_LEN,00H
NO_ROCKS_ARE_DRAWN:
				MOV ROCKET_COUNTER,ROCKET_TODROW
				MOV ROCKET_ON,0
				POP DI
				POP SI
				POPA
ENDM DELETEP_ROCKET

DELETE_ROCK_ONLY MACRO
	LOCAL DELETE_RIGHT_ROCK
	LOCAL OUT_DELETE
	PUSHA
	PUSH SI
	PUSH DI
	CMP ROCKET_XFLAG,0
	JNZ DELETE_RIGHT_ROCK
	drow_thick_line ROCKETL_fx,ROCKETL_ex,ROCKET_fy,ROCKET_LEN,00H
	MOV ROCK_L_IS_DRAWN,0
	JMP OUT_DELETE
DELETE_RIGHT_ROCK:
	drow_thick_line ROCKETR_fx,ROCKETR_ex,ROCKET_fy,ROCKET_LEN,00H
	MOV ROCK_R_IS_DRAWN,0
OUT_DELETE:
	POP DI
	POP SI
	POPA
ENDM DELETE_ROCK_ONLY

RANDOM0_1 MACRO NUM
		xor ax,ax            ; xor register to itself same as zeroing register
		int 1ah              ; Int 1ah/ah=0 get timer ticks since midnight in CX:DX
		mov ax,dx            ; Use lower 16 bits (in DX) for random value

		xor dx,dx            ; Compute randval(DX) mod 10 to get num
		mov bx,NUM            ;     between 0 and 9
		div bx               ; Divide dx:ax by bx
							; DX = modulo from division ( 0 to 9)
        MOV Ax,DX  
		
ENDM RANDOM0_1
