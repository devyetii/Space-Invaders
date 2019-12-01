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

dec_HBAL macro 
		local enddec_HBA
		local dec_2
		local dec_3
		local drow_BHL
		PUSHA
		PUSH DI
		PUSH SI
		
		cmp HBL_CA,0
		jz dec_2
		dec HBL_CA
		jmp enddec_HBA
		dec_2:
			CMP HBL_CANUM,0
			JZ drow_BHL
			DEC HBL_CANUM
			MOV HBL_CA,HBL_MCA
			JMP enddec_HBA
		drow_BHL:
		drow_thick_line HBL_fx,HBL_Ex,HBL_fy,8,HBL_color
		mov HBL_CDA,HBL_MCDA
		
		enddec_HBA:
		POP SI
		POP DI
		POPA
endm dec_HBAL


dec_HBDAL macro 
		local enddec_HBDA
		local delete_BHL
		
		PUSHA
		PUSH DI
		PUSH SI
		dec HBL_CDA
		cmp HBL_CDA,0
		jz delete_BHL
		jmp enddec_HBdA
		delete_BHL:
		drow_thick_line HBL_fx,HBL_Ex,HBL_fy,8,bgcolor
		mov HBL_CA,HBL_MCA
		mov HBL_CANUM,0FFH
		mov ax,HBL_fy
		add ax,HBL_yCH
		mov HBL_fy,ax
		enddec_HBDA:
		POP SI
		POP DI
		POPA
endm dec_HBDAL