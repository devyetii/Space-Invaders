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

; COMPARE_KEY - Compares a keyboard key Stored in AH with a Given scan code and sets ZF if equal
; Params: (byte) KSCAN - Scan code for the compared key  
COMPARE_KEY MACRO KSCAN
    CMP AH, KSCAN
ENDM COMPARE_KEY

; DRWPX - Draw a pixel at X,Y with color C
DRWPX MACRO C
    MOV AL,C
    MOV AH,0CH
    INT 10H
ENDM DRWPX

;DELAY
DELAY MACRO
        LOCAL LP_OUT
        LOCAL LP_IN
        MOV DX,0AH
LP_OUT: MOV CX,0FFFH
        LP_IN: 
            LOOP LP_IN
        DEC DX
        JNZ LP_OUT
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