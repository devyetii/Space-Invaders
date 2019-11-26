INCLUDE lib.inc
		.MODEL SMALL
        .STACK 64

        .DATA
INITX   equ     100
INITY   equ     100
buW     equ     20
buH     equ     5
        .CODE
MAIN	PROC	FAR
        MOV	AX,@DATA
        MOV	DS,AX
        
        ; Set to the video mode
        TOVID

        ; Draw one bullet
        MOV CX, INITX
        MOV DX, INITY
        MOV AL, 0FH
        CALL DRWBULL

        ;DELAY
        DELAY

        ;OMIT THE BULLET
        MOV CX, INITX
        MOV DX, INITY
        MOV AL, 00H
        CALL DRWBULL

        ;CHANGE START_Y AND START_X
        SUB CX,buW
        ADD CX,20
        ADD DX,3
        MOV AL,0FH
        CALL DRWBULL

        PAUSE 
        
        
MAIN	ENDP
;*******************************
; **** DRAW BULLET FUNCTION ****
; * USES : CX , DX, SI, AL, AH
; * PARAMS : X_START => CX, Y_START => DX, AL => COLOR
; ******************************
DRWBULL PROC
        MOV SI,CX
        ADD SI,buW
DRW_L:  DRWPX CX,DX,0FH     ;DRAW PIXEL ON LINE ONE
        INC DX              ;GO DOWN A LINE
        DRWPX CX,DX,0FH     ;DRAW PIXEL ON LINE TWO
        INC DX              ;GO DOWN A LINE
        DRWPX CX,DX,0FH     ;DRAW PIXEL ON LINE TWO
        SUB DX,2
        INC CX              
        CMP CX,SI
        JNE DRW_L
        RET
DRWBULL ENDP

END		MAIN