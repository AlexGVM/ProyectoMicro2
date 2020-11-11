Mapeo MACRO I,J
    ;Filas * 26 + Columnas 
    MOV AX, I
    MOV BL , 1AH
    MUL BL                  ; formula de mapeo
    ADD AX, J
    
    LEA ESI, Matriz
    ADD ESI, EAX
    MOV AL, [ESI]
    MOV letra,AL
    INVOKE StdOut, ADDR letra

ENDM


CRCIFRADO MACRO matrizaux,msgaux

        MOV CX,0                       ; CONTADOR
        LEA ESI, matrizaux			;indices CADENA TOTAL
        LEA EDI, msgaux			;indices CADENA TOTAL
        LeerCadena:
     
        MOV AL, [ESI]					;contenido [] lo muevo a AL
        CMP AL, 0						;solo compara con registro
        JE FinProc						;si se termina la cadena termina proc
        CMP AL, [EDI]					;se compara con subcadena, registro == indice
        JE CaracteresIguales			;son iguales
        JNE Pruebas                     ;no son iguales
       
        Pruebas:
        INC ESI							;se incrementa cadena total
        INC CX                         ; SE INCREMENTA CONTADOR
        JMP LeerCadena

        CaracteresIguales:
        MOV columnas, CX
     
        FinProc:
         print chr$(13,10)
         
  ;---------------------------------------------------------------------------
        LEA ESI, filaM			;indices CADENA TOTAL
        LEA EDI, claveV			;indices SUBCADENA
        MOV CX,0                        ; CONTADOR

        LeerCadena1:
        MOV AL, [ESI]					;contenido [] lo muevo a AL
        CMP AL, 0						;solo compara con registro
        JE FinProc1						;si se termina la cadena termina proc
        CMP AL, [EDI]					;se compara con subcadena, registro == indice
        JE CaracteresIguales1		;son iguales
        JNE Pruebas1                     ;no son iguales
       
        Pruebas1:
        INC ESI							;se incrementa cadena total
        INC CX                        ; SE INCREMENTA CONTADOR
        JMP LeerCadena1

        CaracteresIguales1:
        MOV filas, CX

        FinProc1:
        Mapeo filas,columnas
 
ENDM

CMCIFRADO MACRO

INVOKE StdOut, ADDR holamundo  ;Imprime el menu
JMP programa

ENDM


DCRCIFRADO  MACRO

INVOKE StdOut, ADDR holamundo  ;Imprime el menu
JMP programa

ENDM

DCMCIFRADO  MACRO

INVOKE StdOut, ADDR holamundo  ;Imprime el menu
JMP programa

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
holamundo DB "Hola Mundo",0
mensaje	DB "Ingrese mensaje a cifrado: ",0
clave DB "Ingrese clave para cifrar mensaje: ",0
linefeed db 13, 10, 0
filaM  db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
columnasM db "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
columnas DW 0,0
filas DW 0,0
contador DB 0

.DATA? 

mensajeV DB 100 dup (?)
claveV DB 100 dup (?)
cifrado DB 50 dup (?)
opcion DB 50 dup (?)
opcion2 DB 50 dup (?)
opcion3 DB 50 dup (?)
Matriz DB 676 DUP(?)
subcadena DB ?
letra DB ?

.CONST

.CODE

main:

    LEA ESI, Matriz
    MOV CX, 2A4h 
    MOV AL, 41h 
    MOV BL, 0      ;filas
    MOV BH, 0      ;caracteres alfabeto contador  
   
    MatrizLlena:
    MOV [ESI], AL
    INC ESI
    INC BH
    INC AL
    CMP BH, 1Ah
    JE NuevaFila
    CMP AL, 5Bh 
    JE ErrorCaracter
    JMP CLoop

    ErrorCaracter:
    MOV AL, 41h
    JMP CLoop

    NuevaFila:
    MOV BH, 0
    MOV AL, 41h 
    INC BL 
    ADD AL, BL

    CLoop:
    DEC CX
    CMP CX, 0
    JNE MatrizLlena

programa:

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

ClaveRepetida:
 INVOKE StdOut, ADDR mensaje
 INVOKE StdIn, ADDR mensajeV,97

 INVOKE StdOut, ADDR clave
 INVOKE StdIn, ADDR claveV,97
CRCIFRADO filaM,mensajeV
JMP programa
ClaveMensaje:
CMCIFRADO
JMP programa
DClaveRepetida:
DCRCIFRADO
JMP programa
DClaveMensaje:
DCMCIFRADO
JMP programa

Limpiar proc

 LOCAL hOutPut:DWORD
    LOCAL noc    :DWORD
    LOCAL cnt    :DWORD
    LOCAL sbi    :CONSOLE_SCREEN_BUFFER_INFO

    invoke GetStdHandle,STD_OUTPUT_HANDLE
    mov hOutPut, eax

    invoke GetConsoleScreenBufferInfo,hOutPut,ADDR sbi

    mov eax, sbi.dwSize

    push ax
    rol eax, 16
    mov cx, ax
    pop ax
    mul cx
    cwde
    mov cnt, eax

    invoke FillConsoleOutputCharacter,hOutPut,32,cnt,NULL,ADDR noc

    invoke locate,0,0
       ret
    Limpiar endp


Finalizar:
;Finalizar
INVOKE ExitProcess, 0


END main