.MODEL SMALL
        .STACK 64
        .DATA
		ShipSize equ 49
		ShipSize2 equ 17
		sh1p1y DW ShipSize dup(2)                   
		sh2P1Y dw ShipSize dup(2)  
		sh1P2Y dw ShipSize2 dup(21) 
		sh2P2Y dw ShipSize2 dup(21)

.code 
MAIN    PROC FAR         
        MOV AX,@DATA
        MOV DS,AX  
mov ah,0
mov al,13h
int 10h  

mov CX,0
mov BX,0
fill:        ;fill part 1 y 
add sh1p1Y[BX],CX
add sh2P1Y[BX],CX
add BX,2         
inc cx
cmp cx,ShipSize-1
jnz fill


mov CX,0
mov BX,0
fill1:  ;fill part 2 y
add sh1p2Y[BX],CX
add sh2P2Y[BX],CX
add BX,2         
inc cx
cmp cx,ShipSize2-1
jnz fill1


call ship1Part1
call ship1Part2
call ship2Part1
call ship2Part2

CHECK: mov ah,1 ; check keyboard 
int 16h          
jz CHECK

cmp ah,72
jz shipUp1

cmp ah,80
jz shipDown1

ReadKey:
mov ah,0
int 16h  
call ship1Part1
call ship1Part2
jmp CHECK

shipUp1: 
mov SI,offset sh1P2Y
mov DI,offset sh1p1Y 
call Shiftshipup1
mov SI,offset sh1P2Y
mov DI,offset sh1p1Y
jmp moveup



shipDown1:
mov SI,offset sh1P2Y
mov DI,offset sh1p1Y
call Shiftshipdw1
mov SI,offset sh1P2Y[ShipSize2*2-2]
mov DI,offset sh1p1Y[ShipSize*2-2]
jmp movedown

movedown:
mov BX,[SI-2]
inc BX
mov [SI],BX
mov BX,[DI-2]
inc BX
mov [DI],BX
jmp ReadKey

moveup:
mov BX,[SI+2]
dec BX
mov [SI],BX
mov BX,[DI+2]
dec BX
mov [DI],BX
jmp ReadKey








mov ah ,4ch
int 21h
MAIN    ENDP 
;********************************
ship1Part1 PROC
mov cx,5
label1: 
mov DI,offset sh1p1Y
mov Bl,ShipSize
mov al,33h ;Pixel color
mov ah,0ch ;Draw Pixel Command
back: 
mov dx,[DI] ;Row      
int 10h
add DI,2
dec bl
jnz back
 inc cx
cmp cx,15
jnz label1
ret
ship1Part1 Endp
;********************************
ship1Part2 PROC
mov cx,16
label2: 
mov DI,offset sh1p2Y
mov Bl,ShipSize2
mov al,33h ;Pixel color
mov ah,0ch ;Draw Pixel Command
back1: 
mov dx,[DI] ;Row      
int 10h
add DI,2
dec bl
jnz back1
 inc cx
cmp cx,21
jnz label2
ret
ship1Part2 Endp
;********************************
ship2Part1 PROC
mov cx,620      ;Column
label3: 
mov DI,offset sh1p1Y
mov Bl,ShipSize
mov al,33h ;Pixel color
mov ah,0ch ;Draw Pixel Command
back2: 
mov dx,[DI] ;Row      
int 10h
add DI,2
dec bl
jnz back2
 inc cx
cmp cx, 630
jnz label3
ret
ship2Part1 ENDP
;*********************************
ship2Part2 PROC
mov cx, 613   ;Column
label4: 
mov DI,offset sh1p2Y
mov Bl,ShipSize2
mov al,33h ;Pixel color
mov ah,0ch ;Draw Pixel Command
back3: 
mov dx,[DI] ;Row      
int 10h
add DI,2
dec bl
jnz back3
 inc cx
cmp cx,619
jnz label4
ret
ship2Part2 ENDP
;************************************************

Shiftshipup1 proc 
    push AX
    mov al,0 ;Pixel color
    mov ah,0ch ;Draw Pixel Command 
	
    ;mov cx,[SI+ShipSize2*2-2] ;Column
	
    mov cx,5
	shilopp1:
	mov dx,[DI+ShipSize*2-2] ;Row      
    int 10h
    inc cx
	cmp cx,15
	jnz shilopp1
	
	 mov cx,16
	shilop1:
	mov dx,[SI+ShipSize2*2-2] ;Row      
    int 10h
    inc cx
	cmp cx,21
	jnz shilop1
	
    add SI,ShipSize2*2-2
    add DI,ShipSize*2-2
    mov cx,ShipSize2-1
 shft:    
         mov bx,[SI-2] 
         mov [SI],bx 
         SUB SI,2      
    loop shft 
	mov cx,ShipSize-1 
 shft1:     
         mov dx,[DI-2] 
         mov [DI],dx
         SUB DI,2      
    loop shft1 

pop AX 
ret        
Shiftshipup1 endp    
;************************************************
Shiftshipdw1 proc 
    push AX
    
    mov al,0 ;Pixel color
    mov ah,0ch ;Draw Pixel Command 
	
    mov cx,5
	shilopp2:
	mov dx,[DI] ;Row      
    int 10h
    inc cx
	cmp cx,15
	jnz shilopp2
	
	mov cx,16
	shilop2:
	mov dx,[SI] ;Row      
    int 10h
    inc cx
	cmp cx,21
	jnz shilop2
	
	mov cx,ShipSize2-1
 shfdwt:    
         mov bx,[SI+2] 
         mov [SI],bx 
         add SI,2      
    loop shfdwt 
	
	mov cx,ShipSize-1 
 shftdw1:     
         mov dx,[DI+2] 
         mov [DI],dx
         add DI,2      
    loop shftdw1 
    
	pop AX 
ret        
Shiftshipdw1 endp    
;****************************************************



 END MAIN