INCLUDE lib.inc
INCLUDE refl.inc
		.MODEL SMALL
        .STACK 64

        .DATA

; Reflector Variables
;****************************************************
BGCOLOR         EQU 0H   ; background color
REFLECTORCOLOR  EQU 56H  ; reflector color
REFLECTORlen    EQU  60  ;reflector length
REFfristY DW    1
REFfristX EQU  471
REFendX   EQU  476
REFflag   db    01             ; it take one or two  to detrmine if it move up "if 1" or move down "if 0"
REFSPEED  EQU   0fffh          ;It is the counter when equal zero the reflector step & it control speed of reflector
REFCTR    dw    0fffh


        .CODE
MAIN	PROC	FAR

        MOV	AX,@DATA
        MOV	DS,AX
        DETERMINE_MODE 13H,00H
        CALL DRWREFL
        
MAIN_LB:
        CMP REFCTR,0
        JE MV_LB
DEC_LB:
        DEC REFCTR
        JMP MAIN_LB
MV_LB:  MVREFL
        JMP DEC_LB
        PAUSE
        HALT        
MAIN	ENDP


;*************************************************
; ****  DRWREFL - Draws the reflector ****
; * USES :  AX, BX, CX, DX
; * PARAMS :  NONE
; ************************************************
DRWREFL PROC
        drow_thick_line REFfristX,REFendX,REFfristY,REFLECTORlen,REFLECTORCOLOR 
        RET
DRWREFL ENDP

END		MAIN