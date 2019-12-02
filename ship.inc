; MVSH1UP : Move Ship1 UP
; SHOULD INCLUDE lib.inc
MVSH1UP MACRO
    LOCAL OUT_LP
	LOCAL cont
	push ax
	xor ax,ax
	mov ax,Ship1_Speed
	cont:
	CMP SH1P1FY,1  ;if it is in the upper possible y
    JZ OUT_LP
	push ax
    MOVEUP  sh1p1fy,ShipSizep1y,sh1p1fx,sh1p1ENDx,BGCOLOR,ship1color ;MOVE UP SHIP 1 PART 1 "MOVEUP" IS A MACRO
    MOVEUP  sh1p2fy,ShipSizep2y,sh1p2fx,sh1p2ENDx,BGCOLOR,ship1color ;MOVE UP SHIP 1 PART 2 "MOVEUP" IS A MACRO
	pop ax
	dec ax
	jnz cont
    OUT_LP: NOP
ENDM MVSH1UP

; MVSH1DOWN : Move Ship1 Down
; SHOULD INCLUDE lib.inc
MVSH1DOWN MACRO
 LOCAL OUT_LP
 LOCAL cont
	push ax
	xor ax,ax
	mov ax,Ship1_Speed
	cont:
    CMP SH1P1FY,115 ;if it is in the end possible y
    JZ OUT_LP
	push ax
    MOVEDOWN  sh1p1fy,ShipSizep1y,sh1p1fx,sh1p1ENDx,BGCOLOR,ship1color ;MOVE DOWN SHIP 1 PART 1 "MOVEDOWN" IS A MACRO
    MOVEDOWN  sh1p2fy,ShipSizep2y,sh1p2fx,sh1p2ENDx,BGCOLOR,ship1color ;MOVE DOWN SHIP 1 PART 2 "MOVEDOWN" IS A MACRO
	pop ax
	dec ax
	jnz cont
	OUT_LP: NOP
ENDM MVSH1DOWN

; MVSH2UP : Move Ship2 UP
; SHOULD INCLUDE lib.inc
MVSH2UP MACRO
    LOCAL OUT_LP
	LOCAL cont
	push ax
	xor ax,ax
	mov ax,Ship2_Speed
	cont:
	CMP SH2P1FY,1  ;if it is in the upper possible y
    JZ OUT_LP
	push ax
    MOVEUP  sh2p1fy,ShipSizep1y,sh2p1fx,sh2p1ENDx,BGCOLOR,ship2color ;MOVE  UP SHIP 2 PART 1 "MOVEUP" IS A MACRO
    MOVEUP  sh2p2fy,ShipSizep2y,sh2p2fx,sh2p2ENDx,BGCOLOR,ship2color ;MOVE  UP SHIP 2 PART 2 "MOVEUP" IS A MACRO
	pop ax
	dec ax
	jnz cont
OUT_LP: NOP
ENDM MVSH2UP

; MVSH2UP : Move Ship2 DOWN
; SHOULD INCLUDE lib.inc
MVSH2DOWN MACRO
    LOCAL OUT_LP
	LOCAL OUT_LP
	LOCAL cont
	push ax
	xor ax,ax
	mov ax,Ship2_Speed
	cont:
    CMP SH2P1FY,115  ;if it is in the end possible y
    JZ OUT_LP
	push ax
    MOVEDOWN  sh2p1fy,ShipSizep1y,sh2p1fx,sh2p1ENDx,BGCOLOR,ship2color ;MOVE DOWN SHIP 2 PART 1 "MOVEDOWN" IS A MACRO
    MOVEDOWN  sh2p2fy,ShipSizep2y,sh2p2fx,sh2p2ENDx,BGCOLOR,ship2color ;MOVE DOWN SHIP 2 PART 2 "MOVEDOWN" IS A MACRO
	pop ax
	dec ax
	jnz cont
OUT_LP: NOP
ENDM MVSH2UP

;//////////////////////////////////////////////////////////////////




