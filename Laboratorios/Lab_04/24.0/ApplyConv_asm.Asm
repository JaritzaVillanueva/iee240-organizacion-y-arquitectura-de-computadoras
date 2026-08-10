; rdi = *x -> direccion
; rsi = *k -> direccion
; rdx = *y -> direccion
; rcx = long_y -> int
; r8 = long_k -> int

    global applyConv_asm
    section .text

applyConv_asm:
    mov r13, rdx ; *y
    xor r9, r9 ; i

    first_for:
        mov rbx, rsi ; recuperamos rsi, porque j ira iterando
        mov r14, rdi 
        cmp r9, rcx
        je done
        xorpd xmm3, xmm3 ; suma

        xor r11, r11 ; j
        second_for:
            cmp r11, r8 ; verificar si llego a la longitud k
            je end_second ; es igual, salta a la etiqueta

            
            movups xmm1, [r14]
            movups xmm2, [rbx]
            mulps xmm1, xmm2

            haddps xmm1, xmm1
            haddps xmm1, xmm1 ;suma de los elementos del vector

            addss xmm3, xmm1 ; se guarda un valor flotante de suma
            
            add r14, 16 ; avanza 4 elementos
            add rbx, 16 ; avanza 4 elementos
            add r11, 4 ; el j avanza en 4 en 4
            jmp second_for

        end_second:

        movss [r13], xmm3 ; se guarda la suma en el arreglo y
        add r13, 4 ; se avanza a la siguiente direccion (float)
        inc r9 ; aumenta i
        add rdi, 4 ; pasa a la siguiente direccion
        jmp first_for
        
done:
    ret