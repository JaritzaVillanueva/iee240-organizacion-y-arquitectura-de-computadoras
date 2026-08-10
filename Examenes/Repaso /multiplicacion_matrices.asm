; Multiplicación de dos matrices cuadradas de tamaño n x n.
; El resultado se almacena en la matriz "resultado".
; Se utilizan instrucciones SSE para las operaciones de punto flotante.

section .data
    n equ 3

    ; Matriz A
    matrizA dd 1.0, 2.0, 3.0
            dd 4.0, 5.0, 6.0
            dd 7.0, 8.0, 9.0

    ; Matriz B
    matrizB dd 9.0, 8.0, 7.0
            dd 6.0, 5.0, 4.0
            dd 3.0, 2.0, 1.0

    ; Matriz resultado: n*n elementos
    resultado times n*n dd 0.0

    espacio db " "
    newline db 10

section .text

global _start

_start:
    ; RDI = dirección de matriz A
    ; RSI = dirección de matriz B
    ; RDX = dirección de matriz resultado

    lea rdi, [matrizA]
    lea rsi, [matrizB]
    lea rdx, [resultado]

    call multiplicar_matrices

    ; Imprimir matriz resultado
    lea rdi, [resultado]
    call imprimir_matriz

    ; Finalizar programa
    mov rax, 60
    xor rdi, rdi
    syscall

multiplicar_matrices:

    xor r8, r8 ; i = 0

bucle_filas:
    cmp r8, n
    jge fin_multiplicacion

    xor r9, r9 ; j = 0

bucle_columnas:
    cmp r9, n
    jge siguiente_fila

    ; xmm0 = acumulador
    pxor xmm0, xmm0

    xor r10, r10 ; k = 0

bucle_multiplicacion:
    cmp r10, n
    jge guardar_resultado

    ; Obtener A[i][k]
    ; índice = i*n + k

    mov r11, r8
    imul r11, n
    add r11, r10

    movss xmm1, [rdi + r11*4]

    ; Obtener B[k][j]
    ; índice = k*n + j

    mov r11, r10
    imul r11, n
    add r11, r9

    movss xmm2, [rsi + r11*4]

    ; A[i][k] * B[k][j]

    mulss xmm1, xmm2

    ; Acumular
    addss xmm0, xmm1

    inc r10
    jmp bucle_multiplicacion


guardar_resultado:
    ; Guardar C[i][j]
    ; índice = i*n + j

    mov r11, r8
    imul r11, n
    add r11, r9

    movss [rdx + r11*4], xmm0

    inc r9
    jmp bucle_columnas


siguiente_fila:

    inc r8
    jmp bucle_filas


fin_multiplicacion:
    ret

imprimir_matriz:
    xor r8, r8 ; índice = 0

imprimir_loop:
    cmp r8, n*n
    jge fin_imprimir

    ; Cargar float
    movss xmm0, [rdi + r8*4]

    ; Convertir float a entero
    cvttss2si rax, xmm0

    ; Imprimir entero
    push rdi
    push r8

    call imprimir_entero

    pop r8
    pop rdi

    ; Determinar si debemos imprimir espacio o salto
    mov rax, r8
    inc rax
    xor rdx, rdx
    mov r9, n
    div r9

    cmp rdx, 0
    je imprimir_salto

    ; Imprimir espacio
    mov rax, 1
    mov rsi, espacio
    mov rdx, 1
    mov rdi, 1
    syscall

    inc r8
    jmp imprimir_loop


imprimir_salto:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r8
    jmp imprimir_loop


fin_imprimir:
    ret

imprimir_entero:
    ; Caso negativo
    cmp rax, 0
    jge entero_positivo

    push rax

    mov byte [digit], '-'

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    pop rax
    neg rax


entero_positivo:
    ; Caso 0
    cmp rax, 0
    jne convertir_entero

    mov byte [digit], '0'

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    ret


convertir_entero:
    xor r8, r8
    mov rbx, 10


conversion_loop:
    xor rdx, rdx
    div rbx

    add dl, '0'
    push rdx

    inc r8

    cmp rax, 0
    jne conversion_loop


impresion_digitos:
    cmp r8, 0
    je fin_entero

    pop rdx

    mov [digit], dl

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    dec r8
    jmp impresion_digitos


fin_entero:
    ret


section .bss
    digit resb 1


section .note.GNU-stack noalloc noexec nowrite progbits