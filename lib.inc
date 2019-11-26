;; JUST FIXING AN ERROR
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

; INT 10H LIBRARY
; 1- CLRS - Clear Screen
CLRS MACRO
    PUSHA
    MOV AX,0600H  ; ScrollUp fn. & N_LINES = 0 -> Entire Page
    MOV BH,07H  ; Normal Attr.
    MOV CX,0000H; Starting from (0,0)
    MOV DX,184FH; Ending at (4F,18)
    INT 10H
    POPA
ENDM CLRS

; 2- SCRLU - Scroll up N lines
SCRLU MACRO N
    PUSHA
    MOV AH,06H  ; ScrollUp fn.
    MOV AL,N      ; N_LINES = N
    MOV BH,07H  ; Normal Attr.
    MOV CX,0000H; Starting from (0,0)
    MOV DX,184FH; Ending at (4F,18)
    INT 10H
    POPA
ENDM SCRLU

; 2- SCRLD - Scroll down N lines
SCRLD MACRO N
    PUSHA
    MOV AH,07H  ; ScrollDown fn.
    MOV AL,N      ; N_LINES = N
    MOV BH,07H  ; Normal Attr.
    MOV CX,0000H; Starting from (0,0)
    MOV DX,184FH; Ending at (4F,18)
    INT 10H
    POPA
ENDM SCRLD

; 3- SETC(X, Y) - Set the cursor to a position
SETC MACRO X,Y
    PUSHA
    MOV AH,02H
    MOV BH,00H
    MOV DH,Y
    MOV DL,X
    INT 10H
    POPA
ENDM SETC

; 4- SETCL - Set cursor left coming row
SETCL MACRO
    PUSHA
    ; GET CURSOR Y-POS
    MOV AH,03H
    MOV BH,00H
    INT 10H
    ; CURSOR-YX STORED IN D
    MOV AH,02H
    MOV BH,00H
    ADD DH,01H
    MOV DL,00H
    INT 10H
    POPA
ENDM SETCL

; 5- SETCCNT - Set cursor to the center
SETCCNT MACRO
    PUSHA
    MOV AH,02H
    MOV BH,00H
    MOV DH,12D
    MOV DL,39D
    INT 10H
    POPA
ENDM SETCCNT

; INCC - Moves cursor 1 col left
INCC MACRO
    PUSHA
    ; GET CURSOR YX-POS
    MOV AH,03H
    MOV BH,00H
    INT 10H
    ; CURSOR-YX STORED IN DX
    MOV AH,02H
    MOV BH,00H
    ADD DL,01H
    INT 10H
    POPA
ENDM INCC

; 6- GETC - Get cursor position to DX
GETC MACRO
    PUSH AX
    PUSH BX
    MOV AH,03H
    MOV BH,00
    INT 10H
    POP BX
    POP AX
ENDM GETC

; 7- REPC - Repeat a char CHAR N times with color attr. CATTR
; CATTR VALUES [BACK,FORE] : 
    ; 0->BLACK  
    ; 1->BLUE
    ; 2->GREEN
    ; 3->CYAN
    ; 4->RED
    ; 5->MAGENTA
    ; 6->BROWN
    ; 7->WHITE
    ; 8:15->HIGH INTENSITY COLORS
REPC MACRO CHAR,N,CATTR
    PUSHA
    MOV AH,09H
    MOV BH,00       ; NO. PAGE
    MOV AL,CHAR     ; ASCII of the char
    MOV CX,N        ; NO. TIMES
    MOV BL,CATTR    ; DISPLAY ATTR
    INT 10H
    POPA
ENDM REPC

; PRTN1 - Print 1 digit !! CAUTION : CHANGES AX !!
PRTN1 MACRO D,CATTR
    PUSH AX
    MOV AL,30H
    ADD AL,D
    REPC AL,1,CATTR
    POP AX
ENDM PRTN1

; PRTN2 - Print 2 digit no. !! CAUTION : CHANGES AX AND USES [DS:200]!!
PRTN2 MACRO NUM2D,CATTR
    PUSH AX
    PUSH BX
    MOV AX,NUM2D
    MOV BL,10D
    DIV BL
    MOV BX,AX
    PRTN1 BL,CATTR
    INCC
    PRTN1 BH,CATTR
    POP BX
    POP AX
ENDM PRT2

; TOVID - Changes to video mode
TOVID MACRO
    ; PUSH AX
    MOV AH,00H
    MOV AL,13H
    INT 10H
    ; POP AX
ENDM TOVID

; DRWPX - Draw a pixel at X,Y with color C
DRWPX MACRO X,Y,C
    MOV AH,0CH
    INT 10H
ENDM DRWPX

;DELAY
DELAY MACRO
        MOV DX,20
LP_OUT: MOV CX,0FFFFH
        LP_IN: 
            LOOP LP_IN
        DEC DX
        JNZ LP_OUT
ENDM DELAY

PAUSE MACRO
    MOV AH,0
    INT 16H
ENDM PAUSE


;;;;;;;;;;;;;;;;;;;
;;INT 21H LIBRARY;;
;;;;;;;;;;;;;;;;;;;

; 1- PRTS - Print Statement
PRTS MACRO STAT
    PUSHA
    MOV DX, OFFSET STAT
    MOV AH,09H
    INT 21H
    POPA
ENDM PRTS