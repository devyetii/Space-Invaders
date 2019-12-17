CHAT_MODE1 MACRO
		LOCAL MAIN_LP
		LOCAL DONT_EXIT
		LOCAL CHECK_BACKSPACE1_LB
		LOCAL PRINT_CHAR_1
		LOCAL SEND_THEN_END
		LOCAL END_CHAT_TRANSIT
		LOCAL CURE_JUMP_OUT_OF_RANGE
		LOCAL SEND_LB
		LOCAL START_RECIEVE
		LOCAL CHECK_BACKSPACE2_LB
		LOCAL PRINT_CHAR_2
		LOCAL END_CHAT
			CONFIG
	        CLRS
         DRWLINECENTER
		 MOVE_CURSOR 0,12,0 
		PRINTMESSAGE playership1
		MOVE_CURSOR 0,24,0 
		PRINTMESSAGE playership2
        SETCURSOR 0,CURSOR1_Y
MAIN_LP:
        SETCURSOR CURSOR1_CUR_X,CURSOR1_Y
        CHECKKEY
        JZ START_RECIEVE        ; Means that the sender didn't press any key so go to recieve
        GETKEY1                 ; If the user clicked a button so we get it and store it in CHAR1
        COMPARE_KEY 3DH        ; If ESC is clicked, Send it then end the program 
        JZ SEND_THEN_END
DONT_EXIT:
        COMPARE_KEY_ASCII 0DH             ; ASCII of ENTER
        JNZ CHECK_BACKSPACE1_LB     ; If not, go check BACKSPACE
        SCROLLUP1                   ; If ENTER, Scroll one line up
        MOV CURSOR1_CUR_X,0         ; Reset cursor1_cur_x which holds the current cursor position of sender
        SETCURSOR CURSOR1_CUR_X,CURSOR1_Y ; Reset the cursor to the left  of the screen
        JMP SEND_LB
CHECK_BACKSPACE1_LB:
        COMPARE_KEY_ASCII 08H         ; ASCII of backspace
        JNZ PRINT_CHAR_1        ; If not, then it's a character, go print it ! 
         HANDLEBS1          ; If yes, Call the function that handles BS for sender
        JMP SEND_LB
PRINT_CHAR_1:
        SETCURSOR CURSOR1_CUR_X,CURSOR1_Y   ; Set the cursor to the proper printing position
         PRTCHAR1                       ; Print the entered character in this position
        JMP SEND_LB                         

SEND_THEN_END:
		MOV CHAR1,0FFH
         SENDMSG        ; We come here in case of ESC so as to send it to the reciever before exit
END_CHAT_TRANSIT:           ; Dummy branch for resolving jump out of range issue, Ends the program
        JMP END_CHAT        
CURE_JUMP_OUT_OF_RANGE:     ; Dummy branch for resolving jump out of range issue, Returns to the start of the loop
        JMP MAIN_LP

SEND_LB:                        
        SENDMSG        ; Function to send CHAR1 to the reciever 
START_RECIEVE:
         RECMSG         ; Function to recieve a byte, stores ASCII in AH, if nothing is set, it puts CHAR2=0
        CMP CHAR2,0         ; Means nothing to recieve
        JZ CURE_JUMP_OUT_OF_RANGE   ; Go to the top of the loop
        COMPARE_KEY_ASCII 0FFH           ; If ESC is clicked, end the program 
        JZ END_CHAT
        COMPARE_KEY_ASCII 0DH             ; ASCII for ENTER
        JNZ CHECK_BACKSPACE2_LB     ; If not ENTER, go check BS
        SCROLLUP2                   ; Scroll the bottom screen up 1 line
        MOV CURSOR2_CUR_X,0         ; Reset CURSOR2_CUR_X 
        JMP CURE_JUMP_OUT_OF_RANGE  ; Go to the top of the loop
CHECK_BACKSPACE2_LB:
        COMPARE_KEY_ASCII 08H             ; ASCII of BS
        JNZ PRINT_CHAR_2            ; If not, then it's a character, go print it ! 
        HANDLEBS2              ; If yes, Call the function that handles BS for reciever
        JMP CURE_JUMP_OUT_OF_RANGE  ; Go to the top of the loop
PRINT_CHAR_2:
        SETCURSOR CURSOR2_CUR_X,CURSOR2_Y   ; Set the cursor to the proper printing position
         PRTCHAR2                       ; Print the entered character in this position
        JMP CURE_JUMP_OUT_OF_RANGE          ; Go to the top of the loop
        PAUSE1
END_CHAT:
		MOV CHAT_FLAG1,0
		MOV CHAT_FLAG2,0
		mov CURSOR1_CUR_X , 0
		mov CURSOR2_CUR_X , 0
ENDM CHAT

CONFIG MACRO
    ; Access the control bit
    MOV DX, 03FBH
    MOV AL,80H
    OUT DX,AL
    ; Set the divisor LSB
    MOV DX,3F8H			
    MOV AL,0CH			
    OUT DX,AL
    ; Set the divisor MSB
    MOV DX,3F9H			
    MOV AL,00H			
    OUT DX,AL
    ; Set port config
    ; d7:Access to Receiver buffer, Transmitter buffer
    ; d6:Set Break disabled
    ; d5d4d3:Even Parity
    ; d2:One Stop Bit
    ; d1d0:8bits
    MOV DX,3FBH
    MOV AL, 00011011B
    OUT DX,AL

ENDM CONFIG 

SENDMSG MACRO
	LOCAL AGAINC
	LOCAL OUT_LB1
    MOV DX,03FDH
AGAINC:
    IN AL,DX            ; Line status register
    TEST AL,00100000B   ; Means NOT EMPTY
    JZ AGAINC
    MOV DX,3F8H         ; If empty, send CHAR1
    MOV AL,CHAR1
    OUT DX,AL
OUT_LB1:
    
ENDM SENDMSG 

RECMSG  MACRO
		LOCAL CHK
		LOCAL RECEIVE_LB
		LOCAL OUT_LB2
    MOV DX,03FDH    ; Check data is ready
CHK:
    IN AL,DX        
    TEST AL,1       ; Means READY
    JNZ RECEIVE_LB
    MOV CHAR2,0
    JMP OUT_LB2
RECEIVE_LB:
    MOV DX,03F8H    ; If ready, recieve
    IN AL,DX
    MOV CHAR2,AL    ; Save the recieved char in CHAR2           
OUT_LB2:
                
ENDM RECMSG 

PRTCHAR1 MACRO
		LOCAL INC_CURSOR1_X
		LOCAL END_UPDATE_CURSOR1
    PRTCHAR 1,CHAR1,0AH
    GETCURSOR
    INC DL
    CMP DL, 80D
    JNZ INC_CURSOR1_X
    SCROLLUP1
    MOV CURSOR1_CUR_X,0
    JMP END_UPDATE_CURSOR1
INC_CURSOR1_X:
    MOV CURSOR1_CUR_X,DL
END_UPDATE_CURSOR1:
    
ENDM PRTCHAR1

PRTCHAR2 MACRO
		LOCAL INC_CURSOR2_X
		LOCAL END_UPDATE_CURSOR2
    PRTCHAR 1,CHAR2,0BH
    GETCURSOR
    INC DL
    CMP DL, 80D
    JNZ INC_CURSOR2_X
    SCROLLUP2
    MOV CURSOR2_CUR_X,0
    JMP END_UPDATE_CURSOR2
INC_CURSOR2_X:
    MOV CURSOR2_CUR_X,DL
END_UPDATE_CURSOR2:
    
ENDM PRTCHAR2 

DRWLINECENTER MACRO
    SETCURSOR 0,13D
    PRTCHAR 80,"=",0FH
    
ENDM DRWLINECENTER 
 

HANDLEBS1   MACRO
			LOCAL NO_SCROLL_DOWN1
			LOCAL END_HANDLEBS1
			
	  CMP CURSOR1_CUR_X, 0    ; If BACKSPACE, see if the cursor ia already at the left of the screen i.e. empty line
    JNZ NO_SCROLL_DOWN1
    SCROLLDOWN1
    MOV CURSOR1_CUR_X, 79D
    SETCURSOR CURSOR1_CUR_X, CURSOR1_Y
    JMP END_HANDLEBS1
NO_SCROLL_DOWN1:
    DEC CURSOR1_CUR_X
    SETCURSOR CURSOR1_CUR_X,CURSOR1_Y
    PRTCHAR 1,' ',0FH

END_HANDLEBS1:
    
ENDM HANDLEBS1 

HANDLEBS2   MACRO
			LOCAL NO_SCROLL_DOWN2
			LOCAL END_HANDLEBS2
    CMP CURSOR2_CUR_X, 0    ; If BACKSPACE, see if the cursor ia already at the left of the screen i.e. empty line
    JNZ NO_SCROLL_DOWN2
    SCROLLDOWN2
    MOV CURSOR2_CUR_X, 79D
    SETCURSOR CURSOR2_CUR_X, CURSOR2_Y
    JMP END_HANDLEBS2
NO_SCROLL_DOWN2:
    DEC CURSOR2_CUR_X
    SETCURSOR CURSOR2_CUR_X,CURSOR2_Y
    PRTCHAR 1,' ',0FH
END_HANDLEBS2:
    
ENDM HANDLEBS2 


; GETCURSOR - Get cursor pos., X=>DL & Y=>DH
GETCURSOR MACRO
    MOV AH,03H
    MOV BH,00H
    INT 10H
ENDM GETCURSOR

; SETCURSOR - Set cursor X and Y
; Params: X,Y 
SETCURSOR MACRO X,Y
    MOV AH,02H
    MOV BH,00H
    MOV DL,X
    MOV DH,Y
    INT 10H
ENDM SETCURSOR

CHECKKEY MACRO
    MOV AH,01H
    INT 16H
ENDM CHECKKEY


; GETKEY - Get key pressed (Wait for a key-AH:scancode,AL:ASCII) 
GETKEY1 MACRO
    GETKEY
    MOV CHAR1,AL
ENDM GETKEY
; GETKEY - Get key pressed (Wait for a key-AH:scancode,AL:ASCII) 
GETKEY2 MACRO 
    GETKEY
    MOV CHAR2,AL
ENDM GETKEY



; PRTCHAR - Print a char with a color
PRTCHAR MACRO NTIMES, CHAR_ASCII, COLOR 
    MOV AH,09H
    MOV BH,0
    MOV AL,CHAR_ASCII
    MOV CX,NTIMES ; No of times
    MOV BL,COLOR
    INT 10H
ENDM PRTCHAR

; PRINTMSG - Print message 
; Params: MSG - (byte[]1) message to print
PRINTMSG MACRO MSG
    MOV AX,09H
    MOV DX,offset MSG
    INT 21H
ENDM PRINTMSG

 

; SCROLL: Scroll up no of lines in a specific window
; Params:   NLINES - no. of lines
;           X1 - x of upper left corner
;           Y1 - y of upper left corner
;           X2 - x of lower right corner
;           Y2 - y of lower right corner
; USES : AX,BX,CX,DX
SCROLL MACRO NLINES,X1,Y1,X2,Y2 
    MOV AH,06H
    MOV AL,NLINES
    MOV BH,07H  ; Normal video attribute
    MOV CH,Y1
    MOV CL,X1
    MOV DH,Y2
    MOV DL,X2
    INT 10H
ENDM SCROLL

; SCROLLDOWN: Scroll down no of lines in a specific window
; Params:   NLINES - no. of lines
;           X1 - x of upper left corner
;           Y1 - y of upper left corner
;           X2 - x of lower right corner
;           Y2 - y of lower right corner
; USES : AX,BX,CX,DX
SCROLLDOWN MACRO NLINES,X1,Y1,X2,Y2 
    MOV AH,07H
    MOV AL,NLINES
    MOV BH,07H  ; Normal video attribute
    MOV CH,Y1
    MOV CL,X1
    MOV DH,Y2
    MOV DL,X2
    INT 10H
ENDM SCROLLDOWN


SCROLLUP1 MACRO
    SCROLL 1,0,0,79D,11D
ENDM SCROLLUP1

SCROLLUP2 MACRO
    SCROLL 1,0,14D,79D,23D
ENDM SCROLLUP2

SCROLLDOWN1 MACRO
    SCROLLDOWN 1,0,0,79D,11D
ENDM SCROLLDOWN1

SCROLLDOWN2 MACRO
    SCROLLDOWN 1,0,14D,79D,23D
ENDM SCROLLDOWN2


CLRS MACRO
    MOV AX,0600H
    MOV BH,07H
    MOV CX,0
    MOV DX,184FH
    INT 10H
ENDM CLRS

PAUSE1 MACRO
LB: JMP LB
ENDM PAUSE1