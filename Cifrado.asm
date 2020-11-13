Mapeo MACRO
    ;Filas * 26 + Columnas 
        XOR EAX, EAX		;se limpia los registros
		MOV AX, filas		;se mueve a un registro lo que se tiene en filas
		MOV BL, 1Ah			; se mueve a BL el valor de 26 que en hex es 1AH
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
menu DB "Seleccione opcion, 1 = Cifrar , 2 = Descifrar , 3 = Salir: ",0
menuCifrado DB "Seleccione opcion, 1 = Cifrado Clave Repetida, 2 = Cifrado Clave-Mensaje: ",0
menuDescifrado DB "Seleccione opcion, 1 = Descifrado Clave Repetida, 2 = Descifrado Clave-Mensaje: ",0
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
contadorDD DD 0
contador DB 0
mensajeCifrado DB 0,0
mensajeDescifrado DB 0,0
mensajeV DB 100 dup (0)
claveV DB 100 dup (0)
claveDD DB 100 dup (0)
TxtMensajeCifrado DB "Mensaje Cifrado: ",0
TxtMensajeDecifrado DB "Mensaje Cifrado: ",0

.DATA? 

opcion DB 50 dup (?)
opcion2 DB 50 dup (?)
opcion3 DB 50 dup (?)
Matriz DB 676 DUP(?)
subcadena DB ?
columnas DW ?
filas DW ?
datos DD ?


.CONST

.CODE

main:

    LEA ESI, Matriz
    MOV CX, 2A4h	;676 es 26*26
    MOV AL, 41h	  ;se guarda en AL el valor de A
    MOV BL, 0      ;filas
    MOV BH, 0      ;caracteres alfabeto contador  
   
    MatrizLlena:
    MOV [ESI], AL	;contenido de AL a matriz
    INC ESI			;se incrementa ya que se agrego en la matri
    INC BH			;incrementa contador de alfabetos
    INC AL			;ingrementa valor que entrara a matriz
    CMP BH, 1Ah		; se compara si ya se lleno una fila
    JE NuevaFila	;salta si esta es igual a 26
    CMP AL, 5Bh		;salta si es un caracter no deseado 
    JE ErrorCaracter	; salta si este encuentra un caracter no deseado
    JMP CLoop			; salta a CLoop para modificar contadores

    ErrorCaracter:
    MOV AL, 41h			; se reinicia el alfabeto si se encuentra un caracter no deseado
    JMP CLoop

    NuevaFila:
    MOV BH, 0			; se reinicia el carecter
    MOV AL, 41h			; se reinicia el alfabeto
    INC BL				; se incrementa fila ya que se lleno otra 
    ADD AL, BL			; se suma el valor de alfabeto mas uno de las filas para que se mueva a la izq

    CLoop:
    DEC CX				; se decrementa contador de posiciones vacias en matriz
    CMP CX, 0			; si el contador es igual a 0, significa que ya termino de llenar la matriz
    JNE MatrizLlena

programa:
call Limpiar
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

CMP opcion3,32h
JE DClaveMensaje

ClaveRepetida:

	  INVOKE StdOut, ADDR mensaje
      INVOKE StdIn, ADDR mensajeV,97
      INVOKE StdOut, ADDR clave
      INVOKE StdIn, ADDR claveV,97
	  INVOKE StdOut, ADDR TxtMensajeCifrado

      MOV contadorMensaje,0
      MOV contadorLlave,0

     CadenaCifrada:
        ; se calcula el valor de columnas que esta el mensaje que se quiere cifrar
        XOR AX, AX
		LEA ESI, mensajeV
		ADD ESI, contadorMensaje
		MOV AL, [ESI]
		CMP AL, 20h ;Evalúa espacio en blanco.
		JE EspacioBlanco
		CMP AL, 41h		; si es negativo quiere decir que es un caracter no valido
		JS ColumnasIg
		CMP AL, 5Bh   ;se compara si ya se recorrio todo el abecedario
		JNS ColumnasIg
		MOV columnas, AX	; se guarda el valor en columnas
		SUB columnas, 41h	; se le resta 41h ya que se quiere saber el valor no la letra
		JMP FinProcJ

		EspacioBlanco:
		MOV columnas, 1Fh		;31d espacio en blanco
		JMP FinProcJ

		ColumnasIg:
		MOV columnas, 1Eh ;30d

		FinProcJ:
		INC contadorMensaje			;incrementa el mensaje para saber el siguiente caracter que se tiene que cifrar


	    CMP columnas, 1Fh ;Evalúa espacio en blanco.
	    JNE IndiceInc 
	    print chr$(" ")
	    MOV columnas, 1Eh		;Separador

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
	    Mapeo
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
		JMP programa

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

	;------------------------------------------------------------------

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
		MOV filas, 1Eh ;30d

		FinCM:
		INC contadorLlave
        ;Llama a macro de mapeo para saber el valor en el cual se va a cifrar
	    Mapeo
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
		JMP programa

DClaveRepetida:

		    INVOKE StdOut, ADDR mensajeD 
			INVOKE StdIn, ADDR mensajeV, 100
			INVOKE StdOut, ADDR clave
			INVOKE StdIn, ADDR claveV, 100
			INVOKE StdOut, ADDR TxtMensajeDecifrado
			MOV contadorMensaje, 0
			MOV contadorLlave, 0
			MOV contadorD, 0

		DecipherLoop:
        ;calcular la posicion del caracter de palabra clave en la matriz
			BuscarFilaD:
			XOR AX, AX
			LEA EDI, claveV					;contenido de clave
			ADD EDI, contadorLlave			;contenido de contador
			MOV AL, [EDI]
			CMP AL, 0						;si ya se recorrio todo
			JE LlaveCopiaD					;se repite la clave
			CMP AL, 41h						;Si AL es menor a 41h quiere decir que no esta en el alfabeto
			JS FilasIgnorarD					
			CMP AL, 5Bh						;se compara con 5Bh ya que nos dice si ya termino de recorrer el alfabeto
			JNS FilasIgnorarD				
			MOV filas, AX					;se guardar el dato en filas
			SUB filas, 41h					;se resta con 41h ya que se necesita saber un valor no letra
			JMP FinProcFilasD

			LlaveCopiaD:
			MOV contadorLlave, 0			;se reincia la clave, para volver a correr la clave
			JMP BuscarFilaD					; se repite el proceso con diferentes caracteres

			FilasIgnorarD:
			MOV filas, 1Eh ;30d				; se agrega el dato de filas ya que este tambien se cuenta como un simbolo

			FinProcFilasD:
			INC contadorLlave				; se incrementa el contador para ver el siguiente caracter de la clave

			CMP filas, 1Eh ;Evalúa caracter a ignorar.
			JE DecipherLoop
			MOV columnas, 0

	     BusquedaMapeo:
			Mapeo						;Se llama al mapeo para saber el valor de la fila en la columna 0
			LEA ESI, Matriz
			ADD ESI, EAX				
			LEA EDI, mensajeV 
			ADD EDI, contadorD
			MOV BL, [EDI]
			CMP BL, 20h
			JE EvaluaEspacio
			CMP BL, 41h ;"A"
			JS IngColumnasD
			CMP BL, 5Bh ;"["
			JNS IngColumnasD
			MOV AL, [ESI]
			CMP AL, [EDI]
			JE NoColumnas
			INC columnas
			JMP BusquedaMapeo

			EvaluaEspacio:
			print chr$(" ")

			IngColumnasD:
			INC contadorD
			JMP BusquedaMapeo

			NoColumnas:
			INC contadorD
			MOV filas, 0
			Mapeo
			LEA ESI, Matriz
			ADD ESI, EAX						;se usa el mapeo para saber la letra en el cual se cifro
			MOV AL, [ESI]
			MOV mensajeDescifrado, AL
			INVOKE StdOut, ADDR mensajeDescifrado
			LEA ESI, mensajeV
			ADD ESI, contadorD
			MOV AL, [ESI]
			CMP AL, 0
			JNE DecipherLoop
			print chr$(13,10)

			JMP programa

DClaveMensaje:

		    INVOKE StdOut, ADDR mensajeD 
			INVOKE StdIn, ADDR mensajeV, 100
			INVOKE StdOut, ADDR clave
			INVOKE StdIn, ADDR claveV, 100
			INVOKE StdOut, ADDR TxtMensajeDecifrado
			MOV contadorMensaje, 0
			MOV contadorLlave, 0
			MOV contadorDD, 0

		DecipherLoopD:
        ;calcular la posicion del caracter de palabra clave en la matriz
			BuscarFilaDD:
			XOR AX, AX
			LEA EDI, claveV					;contenido de clave
			ADD EDI, contadorLlave			;contenido de contador
			MOV AL, [EDI]
			CMP AL, 0						;si ya se recorrio todo
			JE LlaveCopiaDD				;se repite la clave
			CMP AL, 41h						;Si AL es menor a 41h quiere decir que no esta en el alfabeto
			JS FilasIgnorarDD					
			CMP AL, 5Bh						;se compara con 5Bh ya que nos dice si ya termino de recorrer el alfabeto
			JNS FilasIgnorarDD				
			MOV filas, AX					;se guardar el dato en filas
			SUB filas, 41h					;se resta con 41h ya que se necesita saber un valor no letra
			JMP FinProcFilasDD

			LlaveCopiaDD:
			MOV contadorLlave, 0			;se reincia la clave, para volver a correr la clave
			JMP BuscarFilaDD					; se repite el proceso con diferentes caracteres

			FilasIgnorarDD:
			MOV filas, 1Eh ;30d				; se agrega el dato de filas ya que este tambien se cuenta como un simbolo

			FinProcFilasDD:
			INC contadorLlave				; se incrementa el contador para ver el siguiente caracter de la clave

			CMP filas, 1Eh ;Evalúa caracter a ignorar.
			JE DecipherLoopD
			MOV columnas, 0

	     BusquedaMapeoD:
			Mapeo						;Se llama al mapeo para saber el valor de la fila en la columna 0
			LEA ESI, Matriz
			ADD ESI, EAX				
			LEA EDI, mensajeV 
			ADD EDI, contadorD
			MOV BL, [EDI]
			CMP BL, 20h
			JE EvaluaEspacioD
			CMP BL, 41h 
			JS IngColumnasDD
			CMP BL, 5Bh 
			JNS IngColumnasDD
			MOV AL, [ESI]
			CMP AL, [EDI]
			JE NoColumnasD
			INC columnas
			JMP BusquedaMapeoD

			EvaluaEspacioD:
			print chr$(" ")

			IngColumnasDD:
			INC contadorD
			JMP BusquedaMapeo

			NoColumnasD:
			INC contadorD
			MOV filas, 0
			Mapeo
			LEA ESI, Matriz
			ADD ESI, EAX						;se usa el mapeo para saber la letra en el cual se cifro
			MOV AL, [ESI]
			MOV mensajeDescifrado, AL
			INVOKE StdOut, ADDR mensajeDescifrado
			MOV AL,mensajeDescifrado
			LEA EDI, claveDD
			ADD EDI,contadorDD
			MOV [EDI],AL
			LEA ESI, mensajeV
			ADD ESI, contadorD
			MOV AL, [ESI]
			CMP AL, 0
			MOV contadorDD,0
			JNE DecipherLoop
			print chr$(13,10)

			JMP programa

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


Finalizar:
;Finalizar
INVOKE ExitProcess, 0
END main