
		.MODEL SMALL
        .STACK 64

        .DATA
BYTEDATA DB 01


        .CODE
MAIN	PROC	FAR

        MOV	AX,@DATA
        MOV	DS,AX
LB:     XOR BYTEDATA, 01H
        JMP LB
        
        MOV AH,4CH
        INT 21H        
MAIN	ENDP

END		MAIN