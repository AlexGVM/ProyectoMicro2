MatrizLlenado MACRO
   
    MOV BL, 0      ;filas
    MOV BH, 0      ;caracteres alfabeto contador 
    LEA ESI, Matriz
    MOV CX, 676d	
 
    MatrizLlena:
	MOV AL,letra1
    MOV [ESI], AL	;contenido de AL a matriz
    INC BH			;incrementa contador de alfabetos
    INC letra1		;ingrementa valor que entrara a matriz
	INC ESI			;se incrementa ya que se agrego en la matri
    CMP BH, 26d		; se compara si ya se lleno una fila
    JE NuevaFila	;salta si esta es igual a 26
    CMP letra1, 91d		;salta si es un caracter no deseado 
    JE ErrorCaracter	; salta si este encuentra un caracter no deseado
    JMP ContadorL			

    NuevaFila:
    MOV BH, 0			; se reinicia el carecter
    MOV letra1, 41h		; se reinicia el alfabeto
    INC BL				; se incrementa fila ya que se lleno otra 
    ADD letra1, BL			; se suma el valor de alfabeto mas uno de las filas para que se mueva a la izq
	JMP ContadorL

	ErrorCaracter:
    MOV letra1, "A"			; se reinicia el alfabeto si se encuentra un caracter no deseado
    JMP ContadorL

    ContadorL:
    DEC CX				; se decrementa contador de posiciones vacias en matriz
    CMP CX, 0			; si el contador es igual a 0, significa que ya termino de llenar la matriz
    JNE MatrizLlena

ENDM

Mapeo MACRO
   
    XOR EAX, EAX		;se limpia los registros
	MOV AX, filas		;se mueve a un registro lo que se tiene en filas
    MOV BL, 26d			; se mueve a BL el valor de 26 que en hex es 1AH
	MUL BL				; se multiplica y resultado se guarda en AL				
	ADD AX, columnas    ; y se suma con la cantidad que se obtiene en columnas	

ENDM

.386
.model flat, stdcall

option casemap: none

INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc

locate PROTO :DWORD,:DWORD

.DATA 
proyectointro DB "------------------------------------------------PROYECTO CIFRADO------------------------------------------------------- ",0
respuesta2 DB "Bienvenido a la carrera de ",0
menu DB "Seleccione opcion, 1 = Cifrar , 2 = Descifrar , 3 Predecir las letras de un cifrado, 4 = Salir: ",0
menuCifrado DB "Seleccione opcion, 1 = Cifrado Clave Repetida, 2 = Cifrado Clave-Mensaje: ",0
menuDescifrado DB "Seleccione opcion, 1 = Descifrado Clave Repetida ",0
textoingreso DB "Ingrese una opcion: ",0
mensaje	DB "Ingrese mensaje para cifrado: ",0
mensajeD DB "Ingrese mensaje para descifrado: ",0
clave DB "Ingrese clave para cifrar mensaje: ",0
linefeed db 13, 10, 0
filaM  db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
columnasM db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
contadorLlave DD 0
contadorMensaje DD 0
contadorD DD 0
contadorDescifrado DD 0
contadorDD DD 0,0
contador DB 0
mensajeCifrado DB 0,0
mensajeDescifrado DB 0,0
mensajeV DB 100 dup (0)
claveV DB 100 dup (0)
claveDD DB 100 dup (0)
TxtMensajeCifrado DB "Mensaje Cifrado completo: ",0
TxtMensajeDecifrado DB "Mensaje Descifrado completo : ",0
pedirnumeros3 db 3 dup ("Ingrese tres numeros","0"),0
num db 10
pedircriptograma db "Ingrese el criptograma a predecir: ",0
abcdariov db "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",0
numabcdario db "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",0
abcdarios db "|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|","|",0
abcdariorep db "E","A","O","S","R","N","I","D","L","C","T","U","M","P","B","G","V","Y","Q","H","F","Z","J","X","K","W",0
letra db 0,0
letra1 db 41h
contador1 db 0,0
contarA db 0h,0
contarB db 0h,0
contarC db 0h,0
contarD db 0h,0
contarE db 0h,0
contarF db 0h,0
contarG db 0h,0
contarH db 0h,0
contarI db 0h,0
contarJ db 0h,0
contarK db 0h,0
contarL db 0h,0
contarM db 0h,0
contarN db 0h,0
contarO db 0h,0
contarP db 0h,0
contarQ db 0h,0
contarR db 0h,0
contarS db 0h,0
contarT db 0h,0
contarU db 0h,0
contarV db 0h,0
contarW db 0h,0
contarX db 0h,0
contarY db 0h,0
contarZ db 0h,0
barrita db "|",0
esigual db "Es igual",0
noesigual db "No es igual",0
total db 0,0
contarletra db 0,0
espacio db " ",0
posicion1 db 1,0
posicion2 db 0,0
guardarletra db 0,0
guardarposicion1 db 0,0
valormayor db 0,0
prueba db 3,0
mensajeog db "El Mensaje original:",0
mensafepred db "El mensaje sustituido es:",0

.DATA? 
opcion DB 50 dup (?)
opcion2 DB 50 dup (?)
opcion3 DB 50 dup (?)
Matriz DB 676 DUP(?)
criptogramapredecir db ?
subcadena DB ?
columnas DW ?
filas DW ?
datos DD ?

.CONST

.CODE
programa:
MatrizLlenado
Proyecto:
INVOKE StdOut, ADDR  proyectointro ;Imprime para que ingrese el nombre
INVOKE StdOut, ADDR linefeed  ;salto de linea

INVOKE StdOut, ADDR menu  ;Imprime el menu
INVOKE StdOut, ADDR linefeed  ;salto de linea
INVOKE StdOut, ADDR textoingreso  ;texto de ingreso
INVOKE StdIn, ADDR opcion,25  ;nombre a leer

CMP opcion,31h
JE Cifrado
CMP opcion,32h
JE Descifrado
CMP opcion,33h
JZ PredecirLetras
CMP opcion,34h
JE Finalizar

Cifrado:
call Limpiar
INVOKE StdOut, ADDR menuCifrado  ;Imprime el menu
INVOKE StdOut, ADDR linefeed  ;salto de linea
INVOKE StdOut, ADDR textoingreso  ;texto de ingreso
INVOKE StdIn, ADDR opcion2,25  ;nombre a leer

CMP opcion2,31h
JE ClaveRepetida

CMP opcion2,32h
JE ClaveMensaje

Descifrado:
INVOKE StdOut, ADDR menuDescifrado  ;Imprime el menu
INVOKE StdOut, ADDR linefeed  ;salto de linea
INVOKE StdOut, ADDR textoingreso  ;texto de ingreso
INVOKE StdIn, ADDR opcion3,25  ;nombre a leer

CMP opcion3,31h
JE DClaveRepetida

ClaveRepetida:

	MOV contadorMensaje,0
      MOV contadorLlave,0

	  INVOKE StdOut, ADDR mensaje
      INVOKE StdIn, ADDR mensajeV,97
      INVOKE StdOut, ADDR clave
      INVOKE StdIn, ADDR claveV,97
	  INVOKE StdOut, ADDR TxtMensajeCifrado


     CadenaCifrada:
        XOR AX, AX
		LEA ESI, mensajeV
		ADD ESI, contadorMensaje
		MOV AL, [ESI]

		CMP AL, 41h		; si es negativo quiere decir que es un caracter no valido
		JS ColumnasIg
		CMP AL, 5Bh   ;se compara si ya se recorrio todo el abecedario
		JNS ColumnasIg
		MOV columnas, AX	; se guarda el valor en columnas
		SUB columnas, 41h	; se le resta 41h ya que se quiere saber el valor no la letra
		JMP FinProcJ

		ColumnasIg:
		MOV columnas, 30d ;30d

		FinProcJ:
		INC contadorMensaje			;incrementa el mensaje para saber el siguiente caracter que se tiene que cifrar


	    CMP columnas, 31d ;Evalúa espacio en blanco.
	    JNE IndiceInc 
	    MOV columnas, 30d		;Separador

	    IndiceInc:
	    CMP columnas, 1Eh ;Evalúa caracter a ignorar.
	    JE CadenaCifrada

	Fila:
        ;calcular la posicion del caracter de palabra clave en la matriz

			BuscarFila:
			XOR AX, AX
			LEA EDI, claveV					;contenido de clave
			ADD EDI, contadorLlave			;contenido de contador
			MOV AL, [EDI]
			CMP AL, 0						;si ya se recorrio todo
			JE LlaveCopia					;se repite la clave
			CMP AL, 41h						;Si AL es menor a 41h quiere decir que no esta en el alfabeto
			JS FilasIgnorar					
			CMP AL, 5Bh						;se compara con 5Bh ya que nos dice si ya termino de recorrer el alfabeto
			JNS FilasIgnorar				
			MOV filas, AX					;se guardar el dato en filas
			SUB filas, 41h					;se resta con 41h ya que se necesita saber un valor no letra
			JMP FinProcFilas

			LlaveCopia:
			MOV contadorLlave, 0			;se reincia la clave, para volver a correr la clave
			JMP BuscarFila					; se repite el proceso con diferentes caracteres

			FilasIgnorar:
			MOV filas, 1Eh ;30d				; se agrega el dato de filas ya que este tambien se cuenta como un simbolo

			FinProcFilas:
			INC contadorLlave				; se incrementa el contador para ver el siguiente caracter de la clave

			CMP filas, 1Eh ;Evalúa caracter a ignorar.
			JE Fila

        ;Llama a macro de mapeo para saber el valor en el cual se va a cifrar
	  
		CALL ProcCFinal
		JMP Proyecto

 ClaveMensaje:

	  INVOKE StdOut, ADDR mensaje
      INVOKE StdIn, ADDR mensajeV,97
      INVOKE StdOut, ADDR clave
      INVOKE StdIn, ADDR claveV,97
	  INVOKE StdOut, ADDR TxtMensajeCifrado

      MOV contadorMensaje,0
      MOV contadorLlave,0
	  MOV contador,0				; me ayudará para saber si la clave ya termino de recorrer todo

	CifradoCM:
   ; se calcula el valor de columnas que esta el mensaje que se quiere cifrar
        XOR AX, AX
		LEA ESI, mensajeV
		ADD ESI, contadorMensaje
		MOV AL, [ESI]
		CMP AL, 20h			 ;Evalúa espacio en blanco.
		JE EspacioBlanco1
		CMP AL, 41h				;si es menor quiere decir que no es un alfabeto
		JS ColumnasIg1
		CMP AL, 5Bh				; si compara para ver si ya se termino de leer todo el alfabeto
		JNS ColumnasIg1
		MOV columnas, AX		;Se guarda el dato en columnas
		SUB columnas, 41h		;se necesita saber el valor no la letra
		JMP FinProcJ1

		EspacioBlanco1:
		MOV columnas, 1Fh ;31d tambien cuenta el valor de los espacios
		JMP FinProcJ1

		ColumnasIg1:
		MOV columnas, 1Eh ;30d tambien cuenta el valor de los espacios

		FinProcJ1:
		INC contadorMensaje ;incrementar contador para leer el siguiente caracter
	

	    CMP columnas, 1Fh ;Evalúa espacio en blanco.
	    JNE IndiceInc1
	    print chr$(" ")
	    MOV columnas, 1Eh

	    IndiceInc1:
	    CMP columnas, 1Eh ;Evalúa caracter a ignorar.
	    JE CadenaCifrada

	FilaCM:
        ;calcular la posicion del caracter de palabra clave en la matriz junto al mensaje

		BuscarCM:
		XOR AX, AX
		CMP contador, 1 
		JNE ClaveInicial
		LEA EDI, mensajeV
		JMP ClaveMensaje1

		ClaveInicial:
		LEA EDI, claveV

		ClaveMensaje1:
		ADD EDI, contadorLlave
		MOV AL, [EDI]
		CMP AL, 0
		JE ReiniciarClave 
		CMP AL, 41h 
		JS IgnorarCaracteres
		CMP AL, 5Bh 
		JNS IgnorarCaracteres
		MOV filas, AX
		SUB filas, 41h
		JMP FinCM

		ReiniciarClave:
		MOV contadorLlave, 0
		MOV contador, 1
		JMP BuscarCM

		IgnorarCaracteres:
		MOV filas, 1Eh 

		FinCM:
		INC contadorLlave
  
	    CALL ProcCVFinal
		JMP Proyecto


DClaveRepetida:

			MOV contadorMensaje, 0
			MOV contadorLlave, 0
			MOV contadorD, 0

		    INVOKE StdOut, ADDR mensajeD 
			INVOKE StdIn, ADDR mensajeV, 100
			INVOKE StdOut, ADDR clave
			INVOKE StdIn, ADDR claveV, 100
			INVOKE StdOut, ADDR TxtMensajeDecifrado
			
		CicloDes:
        ;calcular la posicion del caracter de palabra clave en la matriz
			BuscarFilaD:
			XOR AX, AX
			LEA EDI, claveV					;contenido de clave
			ADD EDI, contadorLlave			;contenido de contador
			MOV AL, [EDI]
			CMP AL, 0						;si ya se recorrio todo
			JE LlaveCopiaD					;se repite la clave
			CMP AL, "A"						;Si AL es menor a 41h quiere decir que no esta en el alfabeto
			JS FilasIgnorarD					
			CMP AL, "["						;se compara con 5Bh ya que nos dice si ya termino de recorrer el alfabeto
			JNS FilasIgnorarD				
			MOV filas, AX					;se guardar el dato en filas
			SUB filas, "A"					;se resta con 41h ya que se necesita saber un valor no letra
			JMP FinProcFilasD

			LlaveCopiaD:
			MOV contadorLlave, 0			;se reincia la clave, para volver a correr la clave
			JMP BuscarFilaD					; se repite el proceso con diferentes caracteres

			FilasIgnorarD:
			MOV filas, 30d				

			FinProcFilasD:
			INC contadorLlave				; se incrementa el contador para ver el siguiente caracter de la clave

			CMP filas, 30d ;Evalúa caracter a ignorar.
			JE CicloDes
			MOV columnas, 0

			CALL MapeoBusqueda
			CALL ProcDFinal 
			JMP Proyecto

PredecirLetras:

			
			mov contarA,0
			mov contarB,0
			mov contarC,0
			mov contarD,0
			mov contarE,0
			mov contarF,0
			mov contarG,0
			mov contarH,0
			mov contarI,0
			mov contarJ,0
			mov contarK,0
			mov contarL,0
			mov contarM,0
			mov contarN,0
			mov contarO,0
			mov contarP,0
			mov contarQ,0
			mov contarR,0
			mov contarS,0
			mov contarT,0
			mov contarU,0
			mov contarV,0
			mov contarW,0
			mov contarX,0
			mov contarY,0
			mov contarZ,0
	
			INVOKE StdOut, ADDR pedircriptograma
			print chr$(13,10)

			INVOKE StdIn, ADDR criptogramapredecir,1000d 
	
			LEA ESI,criptogramapredecir
	
			;#region ;endregion 
			CONTARLETRAS:
			MOV AL,[ESI]
			CMP AL,41h
			jz INCREMENTARA
			CMP AL,42h
			jz INCREMENTARB
			CMP AL,43h
			jz INCREMENTARC
			CMP AL,44h
			jz INCREMENTARD
			CMP AL,45h
			jz INCREMENTARE
			CMP AL,46h
			jz INCREMENTARF
			CMP AL,47h
			jz INCREMENTARG
			CMP AL,48h
			jz INCREMENTARH
			CMP AL,49h
			jz INCREMENTARI
			CMP AL,4AH
			jz INCREMENTARJ
			CMP AL,4BH
			jz INCREMENTARK
			CMP AL,4CH
			jz INCREMENTARL
			CMP AL,4DH
			jz INCREMENTARM
			CMP AL,4Eh
			jz INCREMENTARN
			CMP AL,4Fh
			jz INCREMENTARO
			CMP AL,50h
			jz INCREMENTARP
			CMP AL,51h
			jz INCREMENTARQ
			CMP AL,52h
			jz INCREMENTARR
			CMP AL,53h
			jz INCREMENTARS
			CMP AL,54h
			jz INCREMENTART
			CMP AL,55h
			jz INCREMENTARU
			CMP AL,56h
			jz INCREMENTARV
			CMP AL,57h
			jz INCREMENTARW
			CMP AL,58h
			jz INCREMENTARX
			CMP AL,59h
			jz INCREMENTARY
			CMP AL,5Ah
			jz INCREMENTARZ
			CMP AL,20h
			jz INCREMENTARESPACIO	
			jmp TERMINAR		
			INCREMENTARA:
			ADD contarA,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARB:
			ADD contarB,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARC:
			ADD contarC,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARD:
			ADD contarD,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARE:
			ADD contarE,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARF:
			ADD contarF,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARG:
			ADD contarG,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARH:
			ADD contarH,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARI:
			ADD contarI,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARJ:
			ADD contarJ,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARK:
			ADD contarK,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARL:
			ADD contarL,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARM:
			ADD contarM,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARN:
			ADD contarN,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARO:
			ADD contarO,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARP:
			ADD contarP,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARQ:
			ADD contarQ,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARR:
			ADD contarR,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARS:
			ADD contarS,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTART:
			ADD contarT,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARU:
			ADD contarU,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARV:
			ADD contarV,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARW:
			ADD contarW,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARX:
			ADD contarX,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARY:
			ADD contarY,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARZ:
			ADD contarZ,1
			INC ESI
			jmp CONTARLETRAS
			INCREMENTARESPACIO:
			INC ESI
			JMP CONTARLETRAS
			TERMINAR:
	

			lea EDI, numabcdario

	
			XOR AL,AL
			MOV AL,contarA
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarB
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarC
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarD
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarE
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarF
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarG
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarH
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarI
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarJ
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarK
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarL
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarM
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarN
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarO
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarP
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarQ
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarR
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarS
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarT
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarU
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarV
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarW
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarX
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarY
			MOV [EDI],AL
			INC EDI

			XOR AL,AL
			MOV AL,contarZ
			MOV [EDI],AL
			INC EDI

			print chr$(13,10)
			print chr$(13,10)
			INVOKE StdOut, ADDR abcdariov
			print chr$(13,10)

			LEA ESI, numabcdario
			CICLOIMPRESION1:
			MOV AL,[ESI]
			print str$(AL)
			ADD contador1,1
			INVOKE StdOut, ADDR barrita
			inc ESI
			mov BL,contador1
			cmp BL, 26
			jnz CICLOIMPRESION1

	
			LEA ESI, numabcdario
			inc ESI
			LEA EDI, numabcdario


			BUSCARMAYOR:
			COMPARAR:
			XOR AX,AX
			MOV AH,[EDI]
			MOV AL,[ESI]
			CMP AH,AL
			JC MOVEREDI
			JMP SUMARESI	

			MOVEREDI:
			MOV EDI,ESI
			mov BL,posicion1
			mov guardarposicion1,bl

			SUMARESI:	
			INC ESI 
			add posicion1,1
			cmp posicion1,26
			jnz BUSCARMAYOR	

			mov AL,[EDI]
			MOV valormayor,al

			print chr$(13,10)
	
	
	
			MOV posicion1,0
			LEA ESI, numabcdario


			RECORRECONTEO:
			XOR AX,AX
			XOR BX,BX
			XOR CX,CX
			XOR DX,DX

			MOV AL,[ESI]
			CMP AL,valormayor
			jz SUSTITUIR
			INC ESI
			ADD posicion1,1
			mov cl,posicion1
			CMP cl,26
			jz REINICIARCONTEO	
			JNZ RECORRECONTEO	

			REINICIARCONTEO:
			XOR AX,AX
			XOR BX,BX
			XOR CX,CX
			XOR DX,DX

			MOV posicion1,0
			SUB valormayor,1
			MOV BL,valormayor
			cmp bl,0
			lea ESI,numabcdario
			jz TERMINARSUSTITUCION
			JMP RECORRECONTEO


			SUSTITUIR:
			XOR AX,AX
			XOR BX,BX
			XOR CX,CX
			XOR DX,DX

	
			LEA EDI,abcdariorep
			MOV DH, posicion2
			POSICIONARAPUNTADOR1:
			CMP DH,0
			JZ CONTINUAR1	
			INC EDI
			SUB DH,1
			JMP POSICIONARAPUNTADOR1
			CONTINUAR1:
			MOV CL,[EDI]
			MOV guardarletra,CL
	
	
			LEA EDI, abcdarios
			MOV dl,posicion1

			POSICIONARAPUNTADOR2:
			CMP DL,0
			JZ CONTINUAR2
			INC EDI
			SUB DL,1
			JMP POSICIONARAPUNTADOR2	
			CONTINUAR2:
			mov bh,guardarletra
			MOV [EDI],bh
			ADD posicion2,1
			INC ESI
			ADD posicion1,1
			mov ch,posicion1
			cmp ch,26
			jz REINICIARCONTEO	
			JMP RECORRECONTEO	


			TERMINARSUSTITUCION:


			print chr$(13,10)
			INVOKE StdOut, ADDR abcdariov
			print chr$(13,10)
			INVOKE StdOut, ADDR abcdarios

			print chr$(13,10)
			print chr$(13,10)
			INVOKE StdOut, ADDR mensajeog
			print chr$(13,10)
			INVOKE StdOut, ADDR criptogramapredecir
			print chr$(13,10)



			LEA ESI,criptogramapredecir
			mov posicion1,0

			RECORREMENSAJE:
			XOR AX,AX
			XOR BX,BX
			XOR CX,CX
			XOR DX,DX

			MOV AL,[ESI]
			MOV guardarletra,AL
			MOV AL,guardarletra
			CMP AL,20H
			JZ SALTARESPACIO	
			CMP AL,41H
			JC	TERMINARPROCESO	
			CMP AL,5BH
			JNC	TERMINARPROCESO	
			LEA EDI,abcdariov
			JMP BUSCARLETRAPOS	
		
			SALTARESPACIO:
			INC ESI
			JMP RECORREMENSAJE	

			BUSCARLETRAPOS:
			mov BL,[EDI]
			MOV Bh,guardarletra
			CMP BL,bh
			JZ GUARDARPOSICION	
			INC EDI
			ADD posicion1,1
			JMP BUSCARLETRAPOS	

			GUARDARPOSICION:
			mov cl,posicion1
			LEA EDI,abcdarios
	
			MOVERAPUNTADOR:
			cmp cl,0
			jz APUNTADORPOSICION
			INC EDI
			SUB CL,1
			JMP MOVERAPUNTADOR	
	
			APUNTADORPOSICION:
			MOV dl,[EDI]
			MOV [ESI],dl
			inc ESI
			LEA EDI,abcdariov
			MOV posicion1,0
			jmp RECORREMENSAJE	

			TERMINARPROCESO:

			INVOKE StdOut, ADDR mensafepred
			print chr$(13,10)
			INVOKE StdOut, ADDR criptogramapredecir
			print chr$(13,10)
			jmp Proyecto	


Limpiar proc

 LOCAL hOutPut:DWORD
    LOCAL noc    :DWORD
    LOCAL cnt    :DWORD
    LOCAL sbi    :CONSOLE_SCREEN_BUFFER_INFO

    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov hOutPut, eax

    invoke GetConsoleScreenBufferInfo,hOutPut,ADDR sbi

    mov EAX, sbi.dwSize

    push AX
    rol EAX, 16
    mov CX, AX
    pop AX
    mul CX
    cwde
    mov cnt, EAX

    invoke FillConsoleOutputCharacter,hOutPut,32,cnt,NULL,ADDR noc

    invoke locate,0,0
       ret
    Limpiar endp

ProcCFinal proc

	    XOR EAX, EAX		;se limpia los registros
		MOV AX, filas		;se mueve a un registro lo que se tiene en filas
		MOV BL, 26d			; se mueve a BL el valor de 26 que en hex es 1AH
		MUL BL				; se multiplica y resultado se guarda en AL				
		ADD AX, columnas    ; y se suma con la cantidad que se obtiene en columnas
		LEA ESI, Matriz
	    ADD ESI, EAX
	    MOV AL, [ESI]
	    MOV mensajeCifrado, AL ;se hace la suma a la matriz para poder saber el valor en el cual se va a cifrar
	    INVOKE StdOut, ADDR mensajeCifrado
	    LEA ESI, mensajeV				; Se vuelve a ingresar el mensaje
	    ADD ESI, contadorMensaje		;se le suma el contador a ESI para que pase al siguiente caracter
	    MOV AL, [ESI]
	    CMP AL, 0						; si ya termino la cadena, imprime el mensaje cifrado
	    JNE CadenaCifrada
		print chr$(13,10)

	ret

ProcCFinal endp

ProcCVFinal proc

	    XOR EAX, EAX		;se limpia los registros
		MOV AX, filas		;se mueve a un registro lo que se tiene en filas
		MOV BL, 26d			; se mueve a BL el valor de 26 que en hex es 1AH
		MUL BL				; se multiplica y resultado se guarda en AL				
		ADD AX, columnas    ; y se suma con la cantidad que se obtiene en columnas	
	    LEA ESI, Matriz
	    ADD ESI, EAX
	    MOV AL, [ESI]
	    MOV mensajeCifrado, AL ;se hace la suma a la matriz para poder saber el valor en el cual se va a cifrar
	    INVOKE StdOut, ADDR mensajeCifrado
	    LEA ESI, mensajeV
	    ADD ESI, contadorMensaje 	;se le suma el contador a ESI para que pase al siguiente caracter
	    MOV AL, [ESI]
	    CMP AL, 0 ; si ya termino la cadena, imprime el mensaje cifrado
	    JNE CifradoCM
		print chr$(13,10)

	ret

ProcCVFinal endp


ProcDFinal proc

	  
			XOR EAX, EAX		;se limpia los registros
			MOV AX, filas		;se mueve a un registro lo que se tiene en filas
			MOV BL, 26d			; se mueve a BL el valor de 26 que en hex es 1AH
			MUL BL				; se multiplica y resultado se guarda en AL				
			ADD AX, columnas    ; y se suma con la cantidad que se obtiene en columnas	


			LEA ESI, Matriz
			ADD ESI, EAX						;se usa el mapeo para saber la letra en el cual se cifro
			MOV AL, [ESI]
			MOV mensajeDescifrado, AL
			INVOKE StdOut, ADDR mensajeDescifrado
			LEA ESI, mensajeV
			ADD ESI, contadorD
			MOV AL, [ESI]
			CMP AL, 0
			JNE CicloDes
			print chr$(13,10)
			

	ret

ProcDFinal endp

MapeoBusqueda proc

	  
	     BusquedaMapeo:
		
			XOR EAX, EAX		;se limpia los registros
			MOV AX, filas		;se mueve a un registro lo que se tiene en filas
			MOV BL, 26d			; se mueve a BL el valor de 26 que en hex es 1AH
			MUL BL				; se multiplica y resultado se guarda en AL				
			ADD AX, columnas    ; y se suma con la cantidad que se obtiene en columnas	
			
			LEA ESI, Matriz
			ADD ESI, EAX				
			LEA EDI, mensajeV 
			ADD EDI, contadorD
			MOV BL, [EDI]
			CMP BL, "A" 
			JS IngColumnasD
			CMP BL, "[" 
			JNS IngColumnasD
			MOV AL, [ESI]
			CMP AL, [EDI]
			JE NoColumnas
			INC columnas
			JMP BusquedaMapeo

			IngColumnasD:
			INC contadorD
			JMP BusquedaMapeo

			NoColumnas:
			INC contadorD
			MOV filas, 0

	ret

MapeoBusqueda endp
  
Finalizar:
;Finalizar
INVOKE ExitProcess, 0
END programa