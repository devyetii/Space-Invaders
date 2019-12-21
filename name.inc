
		name_Page macro 
		local labn4
		local labn5
		local labn6
		local labn7
		local labn9
		;***********************
		 NAMEPAGE   ;*****************TO TACK NAME OF THE PLAYER SHIP 1
		;***********************TO MOVE DATA FROM BUFFER TO OWNER SHIP NAME
		nameloop:
			mov SI,offset BufferData
			mov DI,offset playership1
		labn6:
				mov cL,ActualSize   
				XOR CH,CH
				REP MOVSB;Copies the first ActualSize  BYTE from SI to DI
				mov DI,offset playership1
				MOV AL,ActualSize
				MOV CHAR1,AL
				SENDMSG
		
		;*************************
		endm name_Page 
		

	
	cursor1 macro  ; TO SET CURSOR
		;mov dl, x ; Column
		;mov dh, y ; Row
		mov bx, 0 ; Page number 0 for graphics modes
		mov ah, 2h
		int 10h 
		
	ENDm cursor1 
	
	cursor1_on macro  ; TO SHOW CURSOR
	   mov  ah, 1
	   mov  cx, 4         ;?¦¦ BIG CURSOR.
	   int  10h
	endm cursor1_on 
	
	read1 macro ; TO READ MESSAGE
		mov ah,0AH        ;Read from keyboard
		mov dx,offset MyBuffer                  
		int 21h
	
	endm read1 
	
	NAMEPAGE macro   ; THE PAGE TO TAKE NAME
		local ENTERN1
		local labn1
		local labn2
		local labn3
		local ENDNAME
		local endag
		local endag1
		local cont
			ENTERN1:
			PREP_BACKBROUND word_color
			mov dl, 07H
			mov dh, 6H
			 CURSOR1
			PRINTMESSAGE MESSHIP1
			labn3:
			mov dl, 07H
			mov dh, 0AH
			 CURSOR1
			PRINTMESSAGE MES
			mov dl, 0AH
			mov dh, 8H
			 CURSOR1
			 cursor1_on
			 READ1 
			CMP BufferData,'$' ; TO CHECK IF PLAYER ENTER NOTHING .
			JB ENTERN1 
			CMP BufferData,'A' ; TO CHECK THE FIRST CHAR (No digits or special characters).
			JB ENTERN1
			CMP BufferData,'Z'
			JBE ENDNAME
			CMP BufferData,'a'
			JB ENTERN1
			CMP BufferData,'z'
			JA ENTERN1
			ENDNAME:
				CMP ActualSize,15 ; TO CHECK NAME NOT BIG THAN 15
			JA  ENTERN1
			
		ENDm NAMEPAGE 
		
		
		
		;*************************************
		
		
		