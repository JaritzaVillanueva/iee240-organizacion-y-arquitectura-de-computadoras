; Calcula 2! + 3! + 4!
; El resultado final se almacena en r12d y se imprime por consola.

section .data
    result db 0
    newline db 10

section .text
global _start

_start:
    ; Calcular 2!
    mov ecx, 2
    call calcular_factorial

    ; Guardar 2!
    mov r12d, eax

    ; Calcular 3!
    mov ecx, 3
    call calcular_factorial

    ; Sumar 3!
    add r12d, eax

    ; Calcular 4!
    mov ecx, 4
    call calcular_factorial

    ; Sumar 4!
    add r12d, eax

    ; Convertir resultado a decimal
    mov eax, r12d
    mov ebx, 10
    xor r8, r8

convertir:
    xor edx, edx
    div ebx

    add dl, '0'
    push rdx
    inc r8

    test eax, eax
    jnz convertir

imprimir:
    pop rdx
    mov [result], dl

    mov rax, 1              ; SYS_WRITE
    mov rdi, 1              ; stdout
    mov rsi, result
    mov rdx, 1
    syscall

    dec r8
    jnz imprimir

    ; Salto de línea
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Salir
    mov rax, 60
    xor rdi, rdi
    syscall


calcular_factorial:
    ; Entrada: ecx = número
    ; Salida: eax = factorial

    mov eax, 1

factorial_loop:
    mul ecx
    loop factorial_loop

    ret