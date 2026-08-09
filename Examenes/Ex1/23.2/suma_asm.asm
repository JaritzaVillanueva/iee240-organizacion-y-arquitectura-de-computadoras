; rdi = arr
; rsi = num1
; rdx = num2
; rcx = inicio
; r8 = fin
    global sumDig_asm
section .text

sumDig_asm:
    xor r9, r9
    xor r10, r10
    xor r12, r12 ; rdx
    xor r13, r13 ; 2
    xor r14, r14 ; pos1
    xor r15, r15 ; x
    xor rbx, rbx ; pos2

    ; por si acaso
    mov r12, rdx ; num2

    mov r13, 2
    mov r15, rsi

    busqueda_binaria:
        mov r9, rcx ; inicio
        mov r10, r8 ; fin

        floop:
            cmp r9, r10
            ja salir

            xor rax, rax
            add rax, r10
            add rax, r9

            xor rdx, rdx
            div r13 ; rax = cociente , edx = residuo
            

            cmp r15, [rdi+4*rax]
            je return
            jb modifica_fin
            mov r9, rax
            inc r9
            jmp floop

        modifica_fin:
            mov r10, rax
            dec r10
            jmp floop


        return:
            cmp r14, 0
            je cargar_pos1
            mov rbx, r9 ; guardamos la direccion pos2
            jmp salir_pos

            cargar_pos1:
            mov r14, r9 ; guardamos la direccion pos1
        
    salir:
        xor r15, r15
        mov r15, [rdx]
        jmp busqueda_binaria
    
    salir_pos:
    xor r9, r9 ; menor
    xor r10, r10 ; mayor
        cmp r14, rbx
        jbe modi_may_men_1
        add r9, rbx
        add r10, r14
        jmp fin_cmp

        modi_may_men_1:
            add r9, r14
            add r10, rbx

    fin_cmp:
        xor rax, rax
        xor r15, r15
        add r15, 10
        add rax, 1 ; prod

        xor r12, r12
    
        bucle:
            cmp r9, r10
            ja salir_bucle
            mov r12, [rdi+4*r9]
            mul r12
            inc r9
            jmp bucle ; resultado en eax

        salir_bucle:
        xor r10, r10 ; sum
        
        suma:
            cmp rax, 0
            je fin_suma
            div r15 ; rax = cociente , edx = residuo
            add r10, rdx
            jmp suma

        fin_suma:
            xor rax, rax
            mov rax, r10
        ret
