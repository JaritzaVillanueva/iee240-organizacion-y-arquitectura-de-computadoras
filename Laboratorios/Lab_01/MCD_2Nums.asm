section .data
    number1 dd 10       ; Primer número 
    number2 dd 9       ; Segundo número 
    result dd 0         ; Variable para almacenar el resultado

section .text
    global _start

_start:
    ; Cargar los números en registros
    mov eax, [number1]
    mov ebx, [number2]

    ; En este punto, [result] contiene el MCD

find_gcd:
    ; Algoritmo de Euclides para encontrar el MCD
    ; Entradas: eax - Primer número, ebx - Segundo número
    ; Salidas: eax - Resultado (MCD)

    gcd_loop:
        cmp ebx, 0      ; Comprobar si el segundo número es cero
        je gcd_done     ; Si es cero, el MCD es el primer número

        ; Calcular el residuo y actualizar los registros
        xor edx, edx    ; Limpiar edx para la división
        div ebx         ; eax = eax / ebx, edx = eax % ebx
        mov eax, ebx    ; Mover el divisor al registro eax
        mov ebx, edx    ; Mover el residuo al registro ebx
        jmp gcd_loop    ; Repetir el bucle

gcd_done:
      add [result], eax ; Almacenar el resultado en la variable 'result'

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
    
