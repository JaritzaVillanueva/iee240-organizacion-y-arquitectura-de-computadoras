; Encuentra el valor máximo de un arreglo de enteros,
; convierte el resultado a decimal y lo muestra por consola.
section .data
    array dd 14, 7, 25, 9, 17, 36, 8, 42, 11
    array_size equ 9
    result dd 0
    digit db 0

section .text
    global _start

_start:
    ; r8 = puntero al inicio del arreglo
    ; ecx = cantidad de elementos
    mov r8, array
    mov ecx, array_size

find_max:
    ; Inicializar el máximo con el primer elemento
    mov eax, [r8]
    dec ecx

find_max_loop:
    ; Avanzar al siguiente elemento
    add r8, 4

    ; Comparar máximo actual con elemento actual
    cmp eax, [r8]
    jge next

    ; Actualizar máximo
    mov eax, [r8]

next:
    dec ecx
    jnz find_max_loop

    ; Guardar el máximo encontrado
    mov [result], eax

test:
    ; Convertir el número a decimal
    xor rcx, rcx
    mov r8, 10
    mov ecx, [result]
    xor rbx, rbx
    xor rdx, rdx

division:
    mov rax, rcx
    cmp rax, r8
    jl aux

    ; Dividir entre 10
    xor rdx, rdx
    div r8

    inc rbx
    push rdx

    mov rcx, rax
    jmp division

aux:
    push rax
    inc rbx

loopprint:
    ; imprimimos todos los dígitos?
    cmp rbx, 0
    je final

    dec rbx
    pop rcx

    ; Convertir dígito numérico a ASCII
    add rcx, '0'
    mov [digit], cl

    ; SYS_WRITE
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    jmp loopprint

final:
    ; SYS_EXIT
    mov rax, 60
    mov rdi, 0
    syscall