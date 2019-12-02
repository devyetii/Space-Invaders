;****************MACROS************

drow_thick_line MACRO XF,XE,YF,YSIZE,COLOR  ; this is macro to draw a vertix line with frist x "xf", end x "xe" , length "ysize", frist y "yf",color
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
;**************************************
DETERMINE_mode MACRO MODE_NUM,PAGE_NUM
			mov ah,0          ;Change video mode (Graphical MODE)
			mov al,MODE_NUM        ;Max memory size 16KByte
			mov bx,PAGE_NUM
			int 10h
ENDM DETERMINE_mode
;**********************************
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
;*************************************
MOVEUP MACRO LINEFY,LENGTH,LINEFX,LINEendX,BGCOLOR,LINECOLOR ; macro to move line up "BGCOLOR" is aback ground color
			mov ax,LINEFY
			ADD AX,LENGTH-1
			DROWROW  LINEFX,LINEendX,AX,BGCOLOR
			mov ax,LINEFY
			sub ax,1
			mov LINEFY,ax
			DROWROW  LINEFX,LINEendX,LINEFY,LINECOLOR			

ENDM MOVEUP
;*************************************
MOVEDOWN MACRO LINEFY,LENGTH,LINEFX,LINEendX,BGCOLOR,LINECOLOR ; macro to move line down "BGCOLOR" is aback ground color
			DROWROW  LINEFX,LINEendX,LINEFY,bgcolor
			mov ax, LINEFY
			inc ax
			mov LINEFY,AX
			ADD AX,LENGTH-1
			DROWROW  LINEFX,LINEendX,AX,LINECOLOR			

ENDM MOVEDOWN     
;***********************************
 MOVE_CURSOR MACRO X,Y,page_num  ; macro to determine the location to write
	    mov dl, x ; Column
		mov dh, y ; Row
		mov bx, 0 ; Page number 0 for graphics modes
		mov ah, 2h
		int 10h

ENDM MOVE_CURSOR
;***********************************
clrscr macro      ; marco to clear vedio screen & make new one
		mov ax,0003h   ; clear screen & general mode
		int 10h 
		video_mode 00H
ENDM  clrscr
;*********************************
PRINTMESSAGE MACRO MyMessage           ; to print message
                mov ah,9h
                mov dx,offset MyMessage
                int 21h 
                
ENDM PRINTMESSAGE 
;********************************
PREP_BACKBROUND MACRO BGCOLOR
				MOV AH, 06h    ; Scroll up function
				XOR AL, AL     ; Clear entire screen
				XOR CX, CX     ; Upper left corner CH=row, CL=column
				MOV DX, 184FH  ; lower right corner DH=row, DL=column
				MOV BH, BGCOLOR    ; color
				INT 10H
ENDM PREP_BACKBROUND
;**************************
