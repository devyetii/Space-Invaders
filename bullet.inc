; **************************************
; **** ADD LEFT BULLET MACRO ********
; * Increments count and moves pointer and calls INITBUL 
; * USES : AX, BX, CX, DX, SI, DI
; * PARAMS : DI => *First_Empty_Byte
; ****************************************
ADDBULL MACRO 
        LOCAL NOADDL
        CMP [DI],0FEFEH  ; Reached the end of the array then no drawing
        JE  NOADDL
        MOV CX,sh1p2ENDx
        MOV DX,sh1p2fy
        INC CX
        ADD DX,2
        CMP p1_bulls,25D      ; If the bullet count reached the maximum, then no draw
        JE  NOADDL
        INC p1_bulls          ; Passed all checks !! Which means we can draw left bullet
        INITBUL
        ; This is equivalent to a binary with all ones except the MSB and this sets the type to Left
        ; I then store it in the first bit of YPos of this bullet
        AND [DI+2], 7FFFH
        ADD DI,4
NOADDL: NOP
ENDM    ADDBULL


; **************************************
; **** ADD RIGHT BULLET FUNCTION ********
; * Increments count, calls INITBUL, sets bulType bit - MSB of XPos - and MOVES DI 
; * USES : AX, BX, CX, DX, SI, DI
; * PARAMS : DI => *First_Empty_Byte
; ****************************************
ADDBULR MACRO
        LOCAL NOADDR
        CMP [DI],0FEFEH  ; Reached the end of the array then no drawing
        JE  NOADDR
        MOV CX,sh2p2fx
        MOV DX,sh2p2fy
        SUB CX,buW
        DEC CX
        ADD DX,2
        CMP p2_bulls,25D      ; If the bullet count reached the maximum, then no draw
        JE  NOADDR
        INC p2_bulls         ; Passed all checks !! Which means we can draw right bullet
        INITBUL
        ; This is equivalent to a binary with all Zeros except the MSB and this sets the type to Right
        ; I then store it in the first bit of YPos of this bullet
        OR  [DI+2], 8000H
        ADD DI,4        ; Move the array storage pointer
NOADDR: NOP
ENDM ADDBULR 


;****************************************
; **** INITIALIZE BULLET MACRO ****
; * Also stores positions in memory 
; * Please note it's the same for R and L Bullet, so you have to be careful when passing CX and DX so as to get the right position
; * USES : CX , DX, SI, AL, AH
; * PARAMS : X_START => CX, Y_START => DX, DI => *First_Empty_Byte
; ;****************************************
INITBUL MACRO
        LOCAL DRW_L
        MOV [DI], CX    ; Stores X position
        MOV [DI+2], DX    ; Stores Y position
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
ENDM    INITBUL
