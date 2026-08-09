; rdi = x , xmm0 = precision
; calcularRaiz_Asm(int x, double precision);

    global calcularRaiz_Asm
section .text

calcularRaiz_Asm:
    xorpd xmm1, xmm1 ; guessN = 1.0
    xorpd xmm2, xmm2 ; guessNi 
    xorpd xmm3, xmm3 ; resta
    xorpd xmm4, xmm4 ; 2

    xorpd xmm6, xmm6 ; 0
    xorpd xmm7, xmm7 ; -1


    xor r8, r8 ; 2
    xor r9, r9 ; 1.0
    xor r10, r10 ; 99
    xor r11, r11 ; -1

    mov r8, 2
    mov r9, 1
    mov r10, 99
    mov r11, -1
    
    ;dar valores

    cvtsi2sd xmm1, r9 ; 1.0
    cvtsi2sd xmm4, r8 ; 2
    cvtsi2sd xmm3, r10 ; 99
    cvtsi2sd xmm7, r11 ; -1


    bucle:
        xorpd xmm5, xmm5 ; x
        cvtsi2sd xmm5, rdi

        ucomisd xmm3, xmm0
        jb fin
        
        divsd xmm5, xmm1
        addsd xmm5, xmm1
        ; addsd xmm2, xmm4
        divsd xmm5, xmm4 ; se obtiene el nuevo valor de guessNi xmm2
        movsd xmm2, xmm5
        subsd xmm1, xmm2
        movsd xmm3, xmm1 ; resta

        ucomisd xmm3, xmm6
        jb valor_Absoluto
        regresa:
        movsd xmm1, xmm2
        jmp bucle
        
    valor_Absoluto:
        mulsd xmm3, xmm7
        jmp regresa

    fin:
        movsd xmm0, xmm2
ret
