section .data
    array_size equ 4
    array dd 16, 19, 13, 10  ; arreglo
    result dd 0

section .text
    global _start

_start:
    mov r8, array      ; Puntero al inicio del arreglo
    mov ecx, array_size ; Tamaño del arreglo
    mov eax, 0          ; Inicializar la suma

    ; Bucle para sumar todos los elementos del arreglo
    sum_loop:
        add eax, [r8]  ; Sumar el elemento actual al acumulador
        add r8, 4      ; Mover el puntero al siguiente elemento (suponiendo enteros de 4 bytes)
        loop sum_loop   ; Repetir hasta que ecx sea 0

    ; Calcular la media
    mov ebx, array_size  ; Guardar el tamaño del arreglo en ebx
    cdq                  ; Extender el signo de eax a edx (para la división) d -> q
    idiv ebx             ; Dividir eax (suma) por ebx (tamaño del arreglo)
    mov [result], eax   ; Almacenar la media en la variable 'average'

    ; En este punto, [average] contiene el resultado (la media del arreglo)

    ; Puedes agregar aquí la lógica para imprimir la media si lo deseas

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
