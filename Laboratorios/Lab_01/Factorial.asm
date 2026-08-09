; Implemente un programa en assembler que calcule el resultado de 2! + 3! + 4!.
; El resultado debe quedar almacenado en r20

section .text
    global _start

_start:
    ; Calcular 2!
    mov eax, 1
    mov ecx, 2
    call calcular_factorial

    ; Almacenar el resultado en r20
    mov r20, eax

    ; Calcular 3!
    mov eax, 1
    mov ecx, 3
    call calcular_factorial

    ; Sumar el resultado al valor en r20
    add r20, eax

    ; Calcular 4!
    mov eax, 1
    mov ecx, 4
    call calcular_factorial

    ; Sumar el resultado al valor en r20
    add r20, eax

    ; Puedes agregar aquí la lógica para imprimir el resultado si lo deseas

    ; Salir del programa
    mov eax, 1          ; Número de la syscall 'exit'
    xor ebx, ebx        ; Código de salida 0
    int 0x80            ; Realizar la syscall

calcular_factorial:
    ; Entrada: ecx = número para el cual se calculará el factorial
    ; Salida: eax = resultado del factorial

    mov eax, 1          ; Inicializar el resultado en 1

    factorial_loop:
        mul ecx         ; Multiplicar eax por ecx
        loop factorial_loop ; Decrementar ecx y repetir el bucle hasta que ecx sea 0

    ret
