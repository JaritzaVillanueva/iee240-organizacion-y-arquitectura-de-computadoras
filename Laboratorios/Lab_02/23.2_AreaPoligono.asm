section .text
    global calcularAreaGauss

calcularAreaGauss:
    movsd xmm1, qword [rdi]          ; x en xmm1
    movsd xmm2, qword [rsi]          ; y en xmm2
    mov eax, dword [rdx]              ; vertices en eax

    movsd xmm0, qword 0.0            ; Inicializar área en xmm0

    mov ecx, 0                        ; Inicializar índice del bucle en ecx

bucle_inicio:
    cmp ecx, eax                      ; Comparar índice con vertices
    jge bucle_fin                     ; Si índice >= vertices, salir del bucle

    movsd xmm3, qword [xmm1 + ecx*8]  ; Cargar x[i] en xmm3
    movsd xmm4, qword [xmm2 + ecx*8]  ; Cargar y[i] en xmm4

    movsd xmm5, qword [xmm1 + (ecx+1)*8] ; Cargar x[i+1] en xmm5
    movsd xmm6, qword [xmm2 + (ecx+1)*8] ; Cargar y[i+1] en xmm6

    movsd xmm7, xmm3                  ; x[i] en xmm7
    mulsd xmm7, xmm6                  ; x[i] * y[i+1]
    
    movsd xmm8, xmm5                  ; x[i+1] en xmm8
    mulsd xmm8, xmm4                  ; x[i+1] * y[i]

    subsd xmm0, xmm7                  ; Restar x[i] * y[i+1]
    addsd xmm0, xmm8                  ; Sumar x[i+1] * y[i]

    inc ecx                           ; Incrementar índice del bucle
    jmp bucle_inicio                  ; Saltar al inicio del bucle

bucle_fin:
    movsd xmm3, qword [xmm1 + (eax-1)*8] ; Cargar x[vertices-1] en xmm3
    movsd xmm4, qword [xmm2 + (eax-1)*8] ; Cargar y[vertices-1] en xmm4

    movsd xmm5, qword [xmm1]         ; Cargar x[0] en xmm5
    movsd xmm6, qword [xmm2]         ; Cargar y[0] en xmm6

    movsd xmm7, xmm3                  ; x[vertices-1] en xmm7
    mulsd xmm7, xmm6                  ; x[vertices-1] * y[0]

    movsd xmm8, xmm5                  ; x[0] en xmm8
    mulsd xmm8, xmm4                  ; x[0] * y[vertices-1]

    subsd xmm0, xmm7                  ; Restar x[vertices-1] * y[0]
    addsd xmm0, xmm8                  ; Sumar x[0] * y[vertices-1]

    movsd xmm1, qword 0.5            ; Factor 0.5 en xmm1
    mulsd xmm0, xmm1                  ; Multiplicar área por 0.5

    ret
