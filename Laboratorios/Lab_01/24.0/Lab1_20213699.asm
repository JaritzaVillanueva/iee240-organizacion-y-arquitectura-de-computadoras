section .data
    num1 dq 25
    num2 dq 50
    num3 dq 100
    temporal dq 0
    result dq 0

    message db "El mcd es "
    lenf equ $ - message

section .text
    global _start

_start:
    ;cargar los numeros en registros
    mov eax, [num1]
    mov ebx, [num2]

    ;inicio del proceso

    mcd:
    ; Algoritmo de Euclides para encontrar el MCD. Se usa para 2 numeros

    ; MCD para 2 primeros numeros
    loop:
        cmp ebx, 0      ; Comprobar si num2 es cero
        je terminar_1     ; Si es cero, el MCD es el primer número

        ; Calcular residuo y actualizar registros
        xor edx, edx    ; Limpiar edx 
        div ebx         ; eax = eax / ebx, edx = residuo
        mov eax, ebx    ; Mover el divisor al registro eax
        mov ebx, edx    ; Mover el residuo al registro ebx
        jmp loop    ; Repetir el bucle

    terminar_1:
        cmp eax, 0
        jne final
        add [temporal], eax ; Almacenar el primer resultado temporal

    ; verificacion de temporal y num3
    xor eax, eax ; limpiar eax
    xor ebx, ebx ; limpiar ebx

    mov eax, [temporal] ; se guarda temporal en eax
    mov ebx, [num3] ; se pasa num3 a ebx
    jmp loop

    final:
        add [result], eax ; Almacena el resultado final


    ;Seccion impresion

    ;SYS_ WRITE
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, lenf
    syscall

    ; impresion del resultado

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
        je exit
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

; SYS_EXIT
exit:
    mov rax, 60
    mov rdi, 0
    syscall
