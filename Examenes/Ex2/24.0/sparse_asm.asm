; rdi = *datos
; rsi = *colum
; rdx = *ptrRow
; rcx = *vector
; r8 = n
; r9 = *result

    global matriz_vector_SIMD
    section .text
matriz_vector_SIMD:
    mov r13, rdi ;datos
    mov r14, rsi ; colum
    mov r12, rcx ; v

    xor r10, r10 ; i
    

    for_i;
        cmp r10, r8 ;compara el valor de i
        je end_i

        xor r11, r11 ; j inicio
        xor rax, rax ; j final
        xor r15, r15 ; 

        xorpd xmm0, xmm0

        mov r11, [rdx+r10*4] ; i
        inc r10 ; se incrementa +1
        mov rax, [rdx+r10*4] ; i+1
        ;sub rax, r11 ; numero de elementos

        for_j:
            cmp r11, rax
            je end_j
            

            mov rbx, r11
            shl rbx, 3
            add r13, rbx ; nuevo rdi

            ;modificar vector
            xor rbx, rbx

            ; el problema seria en pasar los valores del vector.
            ; una opcion era usar la funcion para chocolatear el vector.
            ; otra opcion era usar la funcion de reconstruir matriz y luego realizar el procedimiento
            ; usual de multiplicacion de matriz x vector
            movapd xmm1, [r13]
            ; codigo para el vector[c]
            haddpd xmm1, xmm1
            haddpd xmm1, xmm1
            
            addsd xmm3, xmm1; resultado de la suma

            add r13, 16; avanza 4 elementos
            add r11, 2 ; avanza en 2 en 2
            inc r11

            movsd[r9], xmm3
            add r9, 8 ; siguiente double
            jmp for_j

        end_j:
        inc r10
        jmp for_i

    end_i:
