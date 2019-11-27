INCLUDE lib.inc
	.MODEL SMALL
        .STACK 64

        .DATA
buW     equ     20
bullPoses dw      50 dup(0FFFFH)       ; Left  Bullets Positions Array
bulrPoses dw      50 dup(0FFFFH)       ; Right Bullets Positions Array

        .CODE
MAIN	PROC	FAR
        MOV	AX,@DATA
        MOV	DS,AX
        
        ; Set to the video mode
        TOVID
        
        ; Make DI a pointer to the nearest free byte in the bullets array for efficient storing
        ; WARNING  : IT MUST BE KEPT UNCHANGED OUTSIDE OF THE BULLET INITIALIZER !
        MOV DI, offset bullPoses

        ; Draw bullets
        MOV CX, 5
        MOV DX, 5
        CALL INITBULL
        MOV CX, 10
        MOV DX, 10
        CALL INITBULL
        MOV CX, 15
        MOV DX, 15
        CALL INITBULL
        MOV CX, 20
        MOV DX, 20
        CALL INITBULL

        ; Beta Version of the Game Loop MAIN_LP
MAIN_LP : 
        ; Move the two bullets to the end simultenously
        ; 1: Use SI to point to the start of the array
        DELAY
        MOV SI, offset bullPoses
        ; 2: At the beginning of the loop check if SI points to bullet data
BULL_LP: 
        CMP SI, DI        ; this means we reached the last stored bullet
        JE  MAIN_LP
        ; We also check if no data here and if so we move to another one
        CMP [SI],0FFFFH
        JE  E_BULL_LP
        ; 3: Put the initial position of X and Y of the current bullet to CX, DX
        MOV CX, [SI]
        MOV DX, [SI+2]
        ; 4: Check if the bullet is now at the end, if so, delete it
        CMP [SI], 300D
        JE  DEL_BUL
        ; 4: Call MVBULL1, it moves the bullet and stores the new position in [SI]
        ; Note that SI is kept at the X position so as for MVBULL1 to store the new X position in
        CALL MVBULL

        ; Branch of finalization
E_BULL_LP:        
        ; 6: Increment SI by 4 to get a new bullet position
        ADD SI,4
        JMP BULL_LP

        ; Branch of Bullet Deletion
DEL_BUL: 
        CALL DELBUL
        JMP E_BULL_LP

EXIT:   PAUSE         
MAIN	ENDP

;****************************************
; **** INITIALIZE BULLET FUNCTION ****
; * Also stores positions in memory 
; * USES : CX , DX, SI, AL, AH
; * PARAMS : X_START => CX, Y_START => DX
; ;****************************************
INITBULL PROC
        MOV [DI], CX    ; Stores X position
        ADD DI,2
        MOV [DI], DX    ; Stores Y position
        ADD DI,2
        MOV SI,CX
        ADD SI,buW
DRW_L:  DRWPX 0FH     ;DRAW PIXEL ON LINE ONE
        INC DX              ;GO DOWN A LINE
        DRWPX 0FH     ;DRAW PIXEL ON LINE TWO
        INC DX              ;GO DOWN A LINE
        DRWPX 0FH     ;DRAW PIXEL ON LINE TWO
        SUB DX,2
        INC CX              
        CMP CX,SI
        JNE DRW_L
        RET
INITBULL ENDP

;*******************************************
; **** MOVE  LEFT BULLET FUNCTION ***************
; **** Also saves the new position to memory
; * USES : CX , DX, DI
; * PARAMS : X_START => CX, Y_START => DX, 
;          : X_Store => DI     
; *****************************************
MVBULL PROC
        ; Black the first coloumn of the bullet
        DRWPX 00H        
        INC DX
        DRWPX 00H
        INC DX
        DRWPX 00H
        ; Save the new buX in memory
        INC CX
        MOV [SI],CX
        ; Set the position after the end of the bullet
        ADD CX,13H
        ;  White a new column after the end
        DRWPX 0FH        
        DEC DX
        DRWPX 0FH
        DEC DX
        DRWPX 0FH
        RET
MVBULL ENDP

;*******************************************
; **** MOVE RIGHT BULLET FUNCTION ***************
; **** Also saves the new position to memory
; * USES : CX , DX, DI
; * PARAMS : X_END => CX, Y_END => DX, 
;          : X_Store => DI     
; *****************************************
MVBULR PROC
        ; Save the new buX in memory
        DEC CX
        MOV [SI],CX
        ;  White a new coloumn before the start
        DRWPX 0FH        
        DEC DX
        DRWPX 0FH
        DEC DX
        DRWPX 0FH
        ; Set the position at the end of the bullet
        ADD CX,15H
        ; Black the last column of the bullet
        DRWPX 00H        
        INC DX
        DRWPX 00H
        INC DX
        DRWPX 00H
        RET
MVBULR ENDP

;*************************************************
; **** DELETE BULLET FUNCTION ****
; * USES : CX, DX, SI
; * PARAMS :  CX => Start_X, DX => Start_Y, SI => Store_X
; ************************************************
DELBUL  PROC
        MOV [SI],0FFFFH
        MOV [SI+2], 0FFFFH
        PUSH SI         ; We will use it for looping, however, we still need it to complete the bullet loop
        MOV SI,CX
        ADD SI,buW
UNDRW_L:  
        DRWPX 00H     ;DRAW PIXEL ON LINE ONE
        INC DX              ;GO DOWN A LINE
        DRWPX 00H     ;DRAW PIXEL ON LINE TWO
        INC DX              ;GO DOWN A LINE
        DRWPX 00H     ;DRAW PIXEL ON LINE TWO
        SUB DX,2
        INC CX              
        CMP CX,SI
        JNE UNDRW_L
        POP SI
        RET
DELBUL  ENDP

END MAIN