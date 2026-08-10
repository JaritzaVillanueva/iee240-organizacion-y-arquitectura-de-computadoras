global sumaCifras_asm

section .text

sumaCifras_asm:
    ; RBX es un registro que debe preservarse
    push rbx

    ; Limpiar registros auxiliares
    xor r9, r9
    xor r10, r10
    xor r11, r11
    xor r12, r12
    xor r13, r13
    xor r14, r14
    xor r15, r15

    ; Guardar parámetros
    mov r15, rdx
    mov rax, rsi

    ; Divisor = 2
    mov r8, 2

    ; RSI / 2
    xor rdx, rdx
    div r8

    mov r10, rax
    mov r11, rsi

    ; Máscara para obtener los bits inferiores
    mov rbx, 0xFF

; PRIMERA BÚSQUEDA

bucle_primero:
    mov r12, [rdi + 4*r10]
    and r12, rbx

    cmp r15, r12
    jge cota1

    mov r11, r10
    jmp luego1

cota1:
    mov r9, r10

luego1:
    mov rax, r9
    add rax, r11

    xor rdx, rdx
    div r8

    mov r10, rax

    cmp r10, r9
    jne bucle_primero

; REINICIO

reinicio:
    mov r13, r10

    xor r9, r9
    mov r11, rsi

    mov rax, rsi
    xor rdx, rdx
    div r8

    mov r10, rax

; SEGUNDA BÚSQUEDA

bucle_segundo:
    mov r12, [rdi + 4*r10]
    and r12, rbx

    cmp rcx, r12
    jge cota2

    mov r11, r10
    jmp luego2

cota2:
    mov r9, r10

luego2:
    mov rax, r9
    add rax, r11

    xor rdx, rdx
    div r8

    mov r10, rax

    cmp r10, r9
    jne bucle_segundo

; ORDENAR LOS LÍMITES

ordenando:
    mov r14, r10

    mov rax, 1
    mov r10, 0
    mov r11, 10

    cmp r13, r14
    jle multi

    mov r9, r13
    mov r13, r14
    mov r14, r9

    jmp go

; MULTIPLICACIÓN

multi:
    inc r13

go:
    mov r9, [rdi + 4*r13]
    and r9, rbx

    ; RAX contiene el producto acumulado
    mul r9

    cmp r13, r14
    jne multi

; SUMA DE CIFRAS

sumar:
    xor rdx, rdx
    div r11

    ; RDX contiene el residuo, es decir, la cifra
    add r10, rdx

    cmp rax, 0
    jg sumar

; RESULTADO
    mov rax, r10
    ; Restaurar RBX
    pop rbx
    ret