; Programa que permite ingresar dos números y seleccionar una operación:
; 0: suma, 1: resta, 2: multiplicación, 3: división.
; El resultado se muestra por consola.

section .data
    msg_num1 db "Ingrese el primer numero: "
    len_num1 equ $ - msg_num1

    msg_num2 db "Ingrese el segundo numero: "
    len_num2 equ $ - msg_num2

    msg_operation db "Seleccione la operacion (0: suma, 1: resta, 2: multiplicacion, 3: division): "
    len_operation equ $ - msg_operation

    msg_result db "El resultado es: "
    len_result equ $ - msg_result

    msg_error db "Error: division entre cero.", 10
    len_error equ $ - msg_error

    newline db 10

section .bss
    input1 resb 32
    input2 resb 32
    input_operation resb 2
    num1 resq 1
    num2 resq 1
    result resq 1
    digit resb 1

section .text
global _start

_start:

    ; Solicitar primer número
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num1
    mov rdx, len_num1
    syscall

    ; Leer primer número
    mov rax, 0
    mov rdi, 0
    mov rsi, input1
    mov rdx, 32
    syscall

    ; Convertir ASCII a entero
    mov rsi, input1
    call ascii_to_int
    mov [num1], rax

    ; Solicitar segundo número
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_num2
    mov rdx, len_num2
    syscall

    ; Leer segundo número
    mov rax, 0
    mov rdi, 0
    mov rsi, input2
    mov rdx, 32
    syscall

    ; Convertir ASCII a entero
    mov rsi, input2
    call ascii_to_int
    mov [num2], rax

    ; Solicitar operación
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_operation
    mov rdx, len_operation
    syscall

    ; Leer operación
    mov rax, 0
    mov rdi, 0
    mov rsi, input_operation
    mov rdx, 2
    syscall

    ; Convertir ASCII a número
    movzx rax, byte [input_operation]
    sub rax, '0'

    ; Seleccionar operación
    cmp rax, 0
    je suma

    cmp rax, 1
    je resta

    cmp rax, 2
    je multiplicacion

    cmp rax, 3
    je division


    ; Si la operación no es válida
    jmp final

; SUMA

suma:
    mov rax, [num1]
    add rax, [num2]
    mov [result], rax
    jmp mostrar_resultado

; RESTA

resta:
    mov rax, [num1]
    sub rax, [num2]
    mov [result], rax
    jmp mostrar_resultado

; MULTIPLICACIÓN

multiplicacion:
    mov rax, [num1]
    imul rax, [num2]
    mov [result], rax
    jmp mostrar_resultado

; DIVISIÓN

division:
    ; Comprobar división entre cero
    cmp qword [num2], 0
    je division_cero

    mov rax, [num1]
    cqo
    idiv qword [num2]

    mov [result], rax
    jmp mostrar_resultado

; ERROR: DIVISIÓN ENTRE CERO

division_cero:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_error
    mov rdx, len_error
    syscall

    jmp final

; MOSTRAR RESULTADO

mostrar_resultado:

    ; Mostrar mensaje
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_result
    mov rdx, len_result
    syscall

    ; Mostrar número
    mov rax, [result]
    call print_int

    ; Salto de línea
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    jmp final

ascii_to_int:
    xor rax, rax
    xor rcx, rcx

    ; Comprobar si es negativo
    cmp byte [rsi], '-'
    jne convertir_numero

    mov r8, 1
    inc rsi
    jmp convertir_digitos

convertir_numero:
    xor r8, r8

convertir_digitos:
    movzx rdx, byte [rsi]

    ; Final de entrada
    cmp dl, 10
    je conversion_final

    ; Convertir ASCII a número
    sub dl, '0'

    ; RAX = RAX * 10 + dígito
    imul rax, rax, 10
    add rax, rdx

    inc rsi
    jmp convertir_digitos

conversion_final:
    ; Si era negativo
    cmp r8, 1
    jne conversion_exit

    neg rax

conversion_exit:
    ret

print_int:

    ; Comprobar si es negativo
    cmp rax, 0
    jge positivo

    ; Imprimir '-'
    push rax

    mov byte [digit], '-'

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    pop rax
    neg rax


positivo:
    ; Caso especial: número 0
    cmp rax, 0
    jne convertir_salida

    mov byte [digit], '0'

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall
    ret

convertir_salida:
    xor r8, r8
    mov rbx, 10

convertir_loop:
    xor rdx, rdx
    div rbx

    add dl, '0'
    push rdx
    inc r8

    cmp rax, 0
    jne convertir_loop


imprimir_loop:
    cmp r8, 0
    je imprimir_fin

    pop rdx
    mov [digit], dl

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    dec r8
    jmp imprimir_loop


imprimir_fin:
    ret

final:
    mov rax, 60
    xor rdi, rdi
    syscall