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

; ; MVBULLS - Main bullet movement logic 
; MVBULLS MACRO
;         ; 1: Use SI to point to the start of the array
;         MOV SI, offset bullPoses
; BUL_START_LB:   
;         ; 2: At the beginning of the loop check if SI points to bullet data
;         ; We also check if no data here or reached the mark of the end and if so we break the loop to outside
;         CMP [SI],0FFFFH
;         JE  BULL_OUT_LB
;         CMP [SI],0FEFEH
;         JE  BULL_OUT_LB
;         ; 3: Put the initial position of X and Y of the current bullet to CX, DX
;         MOV CX, [SI]
;         MOV DX, [SI+2]
;         ; Note that SI is kept at the X position so as for MVBULL1 to store the new X position in
;         ; To call the right function according to the type of the bullet, we know that the type of the bullet
;         ; is stored in the MSB of YPos of the bullet, 1 if right and 0 if left, Ok ?
;         ; This means that if the bullet is left, YPos will be less than 8000H
;         ; We can use this piece of information to make condition on the type
;         ; Recall that : CMP dist,src : if dist<src, CF is set (=1)
;         CMP [SI+2],8000H
;         JNC R_MV        ; No carry means YPos > 8000H i.e. Right Bullet
;         ; 5.1: Call MVBULL, it moves the left bullet and stores the new position in [SI]
;         MVBULL
;         JMP  END_BUL_LP
; R_MV:   
;         ; Don't forget that we store the type of the bullet in the MSB of YPos 
;         ; but we don't want this to affect our drawing
;         ; so we must make sure it's 0 before drawing or deleting
;         AND DX, 7FFFH   
;         ; 4.2: Check if the right bullet is now at the very start. if so, delete it
;         CMP word ptr [SI], 00D
;         JE  DEL_BUL
;         ; JE INV_BULR
;         ; 5.1: Call MVBULR, it moves the left bullet and stores the new position in [SI]
;         MVBULR

;         ; 6: Increment SI by 4 to get a new bullet position
; END_BUL_LP:        
;         ADD SI,4
;         ; 7: Sometimes we don't need to increment SI, e.g. after deleting a bullet due to the way we do deletion by shifting
; END_BUL_LP_WITHOUT_INC:
;         JMP BUL_START_LB

;         ; Branch of Bullet Deletion
; DEL_BUL: 
;         DELBUL
;         JMP END_BUL_LP_WITHOUT_INC

;         ; Invert Left Bullet Branch
; INV_BULL:
;         INVBUL
;         MVBULR
;         JMP END_BUL_LP

;         ; Invert Right Bullet Branch
; INV_BULR:
;         INVBUL
;         MVBULL
;         JMP END_BUL_LP

; BULL_OUT_LB: NOP
; ENDM MVBULLS

; ;*******************************************
; ; **** MOVE  LEFT BULLET MACRO *************
; ; **** Also saves the new position to memory
; ; * USES : CX , DX, DI
; ; * PARAMS : X_START => CX, Y_START => DX, 
; ;          : X_Store => DI
; ; *****************************************
; MVBULL MACRO
;         ; Black the first coloumn of the bullet
;         DRWPX 00H        
;         INC DX
;         DRWPX 00H
;         INC DX
;         DRWPX 00H
;         ; Save the new buX in memory
;         INC CX
;         MOV [SI],CX
;         ; Set the position after the end of the bullet
;         ADD CX,13H
;         ;  White a new column after the end
;         DRWPX 0FH        
;         DEC DX
;         DRWPX 0FH
;         DEC DX
;         DRWPX 0FH
; ENDM MVBULL

; ;*******************************************
; ; **** MOVE RIGHT BULLET MACRO ***************
; ; **** Also saves the new position to memory
; ; * USES : CX , DX, DI
; ; * PARAMS : X_END => CX, Y_END => DX, 
; ;          : X_Store => DI     
; ; *****************************************
; MVBULR MACRO
;         ; Save the new buX in memory
;         DEC CX
;         MOV [SI],CX
;         ;  White a new coloumn before the start
;         DRWPX 0FH        
;         INC DX
;         DRWPX 0FH
;         INC DX
;         DRWPX 0FH
;         ; Set the position at the end of the bullet
;         ADD CX,15H
;         ; Black the last column of the bullet
;         DRWPX 00H        
;         DEC DX
;         DRWPX 00H
;         DEC DX
;         DRWPX 00H
; ENDM MVBULR

; ;*************************************************
; ; **** INVERT BULLET MACRO ****
; ; * USES : SI
; ; * PARAMS :  SI => Store_X
; ; ************************************************
; INVBUL  MACRO
;         XOR [SI+2],8000H
;         MOV DX, [SI+2]
;         AND DX,7FFFH
; ENDM INVBUL

; ;*************************************************
; ; **** DELETE BULLET FUNCTION ****
; ; * USES : CX, DX, SI
; ; * PARAMS :  CX => Start_X, DX => Start_Y, SI => Store_X
; ; ************************************************
; DELBUL  MACRO
;         ; OK, know we need to apply the best property of our array, shifted deletion !
;         ; That is, if some bullet data is to be deleted, we move it at the end of the array and move the last element to its position
;         ; This is valid because our array is a bag and we don't care about the order
;         ; Our data to be deleted is in [SI],[SI+2]; and the last element is at [DI-4], [DI-2], so lets move it 
;         PUSH [DI-4]
;         POP  [SI]
;         PUSH [DI-2]
;         POP  [SI+2]
;         ; Then we move DI backward in the array
;         SUB  DI,4
;         ; And we delete the last element data
;         MOV  [DI], 0FFFFH
;         MOV  [DI+2],0FFFFH
;         PUSH SI         ; We will use it for looping, however, we still need it to complete the bullet loop
;         MOV SI,CX
;         ADD SI,buW
;         INC SI        ; Fixing an error in deleting the right bullet
;         ; Don't forget to correct YPos of the bullet to delete the effect of the type bit
;         AND DX,7FFFH
; UNDRW_L:  
;         DRWPX 00H     ;DRAW PIXEL ON LINE ONE
;         INC DX              ;GO DOWN A LINE
;         DRWPX 00H     ;DRAW PIXEL ON LINE TWO
;         INC DX              ;GO DOWN A LINE
;         DRWPX 00H     ;DRAW PIXEL ON LINE TWO
;         SUB DX,2
;         INC CX              
;         CMP CX,SI
;         JNE UNDRW_L
;         POP SI
; ENDM    DELBUL
