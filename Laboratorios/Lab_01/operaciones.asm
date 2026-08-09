; falta terminar sueño
section .data
    result_msg db "El resultado es: ", 10
    leng equ $ - input_msg
    input_msg db "Ingrese el primer numero: "
    lenf equ $ - input_msg
    input_msg2 db "Ingrese el segundo numero: "
    lenh equ $ - input_msg
    operation_msg db "Seleccione la operacion (0: suma, 1: resta, 2: multiplicacion, 3: division): "
    leni equ $ - input_msg

section .bss
    num1 resd 1
    num2 resd 1
    operation resb 1

section .text
    global _start

_start:
	; SYS_WRITE				; impresion del primer mensaje de ingreso
	mov rax, 1
	mov rdi, 1
	mov rsi, input_msg
	mov rdx, lenf
	syscall
 
    ; Solicitar el primer número
    ; SYS_READ				; lectura del numero
	mov rax, 0
	mov rdi, 0
	mov rsi, num1
	mov rdx, 1
	syscall

	; SYS_WRITE_2				; impresion del segundo mensaje de ingreso
	mov rax, 1
	mov rdi, 1
	mov rsi, input_msg2
	mov rdx, lenh
	syscall
 
    mov rcx, [num1]
	sub rcx, 30H	; se le resta 48 para que detecte el numero y no el ASCII



    ; Leer el primer número
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 4
    int 0x80

    ; Solicitar el segundo número
    mov eax, 4
    mov ebx, 1
    mov ecx, input_msg2
    mov edx, 28
    int 0x80

    ; Leer el segundo número
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 4
    int 0x80

    ; Solicitar la operación
    mov eax, 4
    mov ebx, 1
    mov ecx, operation_msg
    mov edx, 52
    int 0x80

    ; Leer la operación
    mov eax, 3
    mov ebx, 0
    mov ecx, operation
    mov edx, 1
    int 0x80

    ; Convertir el valor de la operación de ASCII a entero
    sub byte [operation], '0'

    ; Realizar la operación según el valor de la operación
    mov eax, 0
    mov ebx, [num1]
    mov ecx, [num2]
    cmp byte [operation], 0
    je suma
    cmp byte [operation], 1
    je resta
    cmp byte [operation], 2
    je multiplicacion
    cmp byte [operation], 3
    je division

    ; Salir del programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

suma:
    add ebx, ecx
    jmp mostrar_resultado

resta:
    cmp ebx, ecx
    jl resta_negativa
    sub ebx, ecx
    jmp mostrar_resultado

resta_negativa:
    sub ecx, ebx
    mov ebx, ecx
    jmp mostrar_resultado

multiplicacion:
    imul ebx, ecx
    jmp mostrar_resultado

division:
    xor edx, edx
    idiv ecx
    jmp mostrar_resultado

mostrar_resultado:
    ; Imprimir el resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 17
    int 0x80

    ; Imprimir el valor de ebx (resultado)
    mov eax, 1
    mov ebx, [ebx]
    mov ecx, result_msg
    mov edx, 17
    int 0x80

test:				; pushea en pila el resultado
	xor rcx, rcx
	mov r8, 10	
	mov rcx, [result]	
	mov rbx, 0
	xor rdx, rdx

division:
	mov rax, rcx
	cmp rax, r8 
	jl aux

	div r8 ;rdx residuo rax cociente
	inc rbx
	push rdx

	mov rcx, rax
	jmp division

aux:
	push rax
	inc rbx

loopprint:			; popea e imprime cad dígito
	cmp rbx,0
	je final
	dec rbx
	pop rcx
	
	add rcx, 30H
	mov [result], rcx

	mov rax, 1
	mov rdi, 1
	mov rsi, result
	mov rdx, 1
	syscall
	jmp loopprint
 
final:			; sale del programa de forma exitosa 
; SYS_EXIT
	mov rax, 60
	mov rdi, 0
	syscall 
