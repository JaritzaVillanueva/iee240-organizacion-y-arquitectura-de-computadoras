    global matriz_vector_asm
    section .text

matriz_vector_asm:
; rdi<-A*
; rsi<-x*
; rdx<-b*
; rcx<-N*

    xorpd xmm0,xmm0
    xorpd xmm1,xmm1
    xorpd xmm2,xmm2
    xor r8,r8
    xor r9,r9
    xor r10,r10
    xor r13,r13
    xor r14,r14
    xor r15,r15
    
    mov r15, rcx

for_j:
    mov r13, rcx
    mov r10, rdi
    add r10, r14
    mov r9, rsi

    xorpd xmm0,xmm0
    for_i:
        movsd xmm1, [r10] ; A
        movsd xmm2, [r9] ; X
        mulsd xmm1, xmm2
        addsd xmm0, xmm1
        add r10, 8
        add r9, 8
        dec r13
        jnz for_i
    movsd [rdx], xmm0
    add rdx, 8
    
    mov r8 ,rdx
    xor rdx,rdx
    mov rax, 8
    mul rcx
    add r14,rax
    xor rax,rax
    mov rdx,r8
    dec r15
    jnz for_j

done:
    ret
