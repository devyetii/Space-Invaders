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

dec_HBAL macro HBA ,HBANUM,HBMCA,HBFLAG,HBLfx,HBLEx,HBfy,HBLEN,HBcolor,HBRfx,HBREx,HBCDA,HBMCDA,HBCDANUM,HBMCDANUM, HBON
		local enddec_HBA
		local dec_2
		local dec_3
		local drow_BHL
		local drow_BHR
		local drow_BH
		LOCAL PREP
		PUSHA
		PUSH DI
		PUSH SI
		
		cmp HBA,0
		jz dec_2
		dec HBA
		jmp enddec_HBA
		dec_2:
			CMP HBANUM,0
			JZ drow_BH
			DEC HBANUM
			MOV HBA,HBMCA
			JMP enddec_HBA
		drow_BH:
		 CMP HBFLAG  ,1
		 JZ drow_BHL
		 JNZ drow_BHR
		drow_BHL:
		drow_thick_line HBLfx,HBLEx,HBfy,HBLEN,HBcolor
		JMP PREP
		drow_BHR:
		drow_thick_line HBRfx,HBREx,HBfy,HBLEN,HBcolor
		
		PREP:
		mov HBCDA,HBMCDA
		mov HBCDANUM,HBMCDANUM
		MOV HBON,1
		
		enddec_HBA:
		POP SI
		POP DI
		POPA
endm dec_HBAL


dec_HBDAL macro HBCA ,HBCANUM,HBMCA,HBFLAG,HBLfx,HBLEx,HBfy,HBLEN,HBcolor,HBRfx,HBREx,HBCDA,HBMCDA,HBCDANUM,HBMCDANUM, HBON,HBMCANUM,HBMAXY
		local enddec_HBDA
		local delete_BH
		local dec_num
		
		PUSHA
		PUSH DI
		PUSH SI
		
		dec HBCDA
		cmp HBCDA,0
		jz dec_NUM
		jmp enddec_HBDA
		dec_NUM:
			CMP HBCDANUM,0
			JZ delete_BH
			DEC HBCDANUM
			MOV HBCDA,HBMCDA
			JMP enddec_HBDA
			
		deletE_BH:
			DELETEH_HB HBCA ,HBCANUM,HBMCA,HBFLAG,HBLfx,HBLEx,HBfy,HBLEN,HBcolor,HBRfx,HBREx,HBCDA,HBMCDA,HBCDANUM,HBMCDANUM, HBON,HBMCANUM,HBMAXY
			
		enddec_HBDA:
		POP SI
		POP DI
		POPA
endm dec_HBDAL

DELETEH_HB MACRO  HBCA ,HBCANUM,HBMCA,HBFLAG,HBLfx,HBLEx,HBfy,HBLEN,HBcolor,HBRfx,HBREx,HBCDA,HBMCDA,HBCDANUM,HBMCDANUM, HBON,HBMCANUM,HBMAXY
				local delete_BHL
				local delete_BHR
				LOCAL PREPD
				LOCAL  ENDDEC
				LOCAL DO_ELSE
				
		 CMP HBFLAG  ,1
		 JZ dELETE_BHL
		 JNZ dELETE_BHR
		dELETE_BHL:
		drow_thick_line HBLfx,HBLEx,HBfy,HBLEN,BGCOLOR
		JMP PREPD
		dELETE_BHR:
		drow_thick_line HBRfx,HBREx,HBfy,HBLEN,BGCOLOR
		
		PREPD:
		mov HBCA,HBMCA
		mov HBCANUM,HBMCANUM
		XOR AX,AX
		MOV HBON ,AL
		
		mov HBCDA,AX
		mov HBCDANUM,AX
		
		XOR byte ptr HBFLAG,00000001B
		
		RANDOM0_1
		MOV BX,HBfy
		ADD BX,AX
		CMP BX,HBMAXY
		JA DO_ELSE
		MOV HBFY,BX
		JMP ENDDEC
		DO_ELSE:
			MOV HBFY,11H
			 ENDDEC:
ENDM DELETEH_HB

RANDOM0_1 MACRO
		xor ax,ax            ; xor register to itself same as zeroing register
		int 1ah              ; Int 1ah/ah=0 get timer ticks since midnight in CX:DX
		mov ax,dx            ; Use lower 16 bits (in DX) for random value

		xor dx,dx            ; Compute randval(DX) mod 10 to get num
		mov bx,10            ;     between 0 and 9
		div bx               ; Divide dx:ax by bx
		MOV BL,7						; DX = modulo from division ( 0 to 9)
        MOV Ax,DX  
		MUL BL
		
ENDM RANDOM0_1
