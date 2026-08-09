section .data
    ; Definir las dimensiones de las matrices
    n equ 3  ; Cambia esto según las dimensiones de tus matrices

    ; Definir las matrices
    matrizA dd 1, 2, 3, 4, 5, 6, 7, 8, 9
    matrizB dd 9, 8, 7, 6, 5, 4, 3, 2, 1
    resultado dd n dup(0)  ; Inicializa un arreglo de n*n elementos a 0

section .text
    global _start

_start:
    lea rdi, [matrizA]
    lea rsi, [matrizB]
    lea rdx, [resultado]

    call multiplicar_matrices

    ; Puedes agregar código aquí para imprimir o procesar el resultado

    ; Termina el programa
    mov eax, 60         ; Código de salida del programa
    xor edi, edi        ; Sin errores
    syscall

multiplicar_matrices:
    ; Inicializar variables
    xor r8, r8          ; Inicializar el índice de fila de la matriz A
    mov r9, n           ; Número de filas/columnas
    mov r10, n          ; Número de iteraciones externas (filas de A)
    mov r11, n          ; Número de iteraciones internas (columnas de B)

    ; Bucle externo (filas de A)
    bucle_externo:
        ; Inicializar variables para la multiplicación
        xor r12, r12     ; Inicializar el índice de la columna de B
        xor r13, r13     ; Inicializar el índice de la fila de B

        ; Bucle interno (columnas de B)
        bucle_interno:
            ; Inicializar el acumulador para la posición actual en la matriz resultado
            movss xmm0, dword [rdx + r8*4 + r12*4]

            ; Bucle interno de multiplicación y acumulación
            mov r14, 0       ; Inicializar el índice de la columna de A
            bucle_multiplicacion:
                movss xmm1, dword [rdi + r8*4 + r14*4]  ; Cargar A[i][k] en xmm1
                movss xmm2, dword [rsi + r14*4 + r12*4]  ; Cargar B[k][j] en xmm2
                mulss xmm1, xmm2                           ; Multiplicar A[i][k] * B[k][j]
                addss xmm0, xmm1                           ; Acumular el resultado en xmm0
                inc r14                                    ; Incrementar el índice de columna de A
                cmp r14, r9                                ; Comparar con el número de filas/columnas
                jl bucle_multiplicacion

            ; Almacenar el resultado acumulado en la matriz resultado
            movss dword [rdx + r8*4 + r12*4], xmm0

            ; Actualizar índices
            inc r12           ; Incrementar el índice de columna de B
            cmp r12, r11      ; Comparar con el número de columnas de B
            jl bucle_interno

        ; Actualizar índices y comprobar el final del bucle externo
        inc r8               ; Incrementar el índice de fila de A
        cmp r8, r10          ; Comparar con el número de filas de A
        jl bucle_externo

    ret
Este código utiliza registros y SSE (Streaming SIMD Extensions) para realizar la multiplicación de matrices. Puedes ajustar el valor de n según las dimensiones de tus matrices. Recuerda que este código está diseñado para matrices cuadradas de tamaño n por n. Adaptar el código para matrices no cuadradas requeriría ajustes adicionales.

