; Calcula la media de un arreglo eliminando previamente
; una cantidad indicada de sus valores menores.

section .data
    ; Mensajes
    firstMsg db "Ingrese la cantidad de menores a quitar: "
    lenf equ $ - firstMsg

    secondMsg db "La media calculada es: "
    lens equ $ - secondMsg

    ; Arreglo
    arreglo dq 5, 3, 4, 8, 9, 7
    lenArr equ 6

    ; Variables
    numMenores dq 0
    solution dq 0

    ; Entrada y salida
    input db 0
    newline db 10
    digit db 0

section .text
global _start

_start:
    ; Mostrar mensaje
    mov rax, 1
    mov rdi, 1
    mov rsi, firstMsg
    mov rdx, lenf
    syscall

    ; Leer cantidad de menores
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 1
    syscall

    ; Convertir ASCII a número
    movzx rax, byte [input]
    sub rax, '0'
    mov [numMenores], rax

    ; Eliminar los valores menores
    mov r14, [numMenores]

quitar_menor:
    cmp r14, 0
    je preparar_suma

    ; Buscar el menor valor
    mov r8, arreglo
    mov r9, lenArr
    mov r10, -1          ; Índice del menor
    mov r11, 0           ; Índice actual

buscar_minimo:
    cmp r9, 0
    je eliminar_minimo

    mov rax, [r8]

    ; -1 significa que este elemento ya fue eliminado
    cmp rax, -1
    je siguiente_elemento

    ; Si todavía no tenemos mínimo
    cmp r10, -1
    je guardar_minimo

    ; Comparar con el mínimo actual
    mov rdx, [arreglo + r10*8]
    cmp rax, rdx
    jge siguiente_elemento

guardar_minimo:
    mov r10, r11

siguiente_elemento:
    add r8, 8
    inc r11
    dec r9
    jmp buscar_minimo

eliminar_minimo:
    ; Marcar el menor como eliminado
    mov qword [arreglo + r10*8], -1

    dec r14
    jmp quitar_menor

; Calcular suma de los elementos restantes
preparar_suma:
    xor r12, r12         ; Suma
    xor r13, r13         ; Cantidad de elementos restantes
    mov r8, arreglo
    mov r9, lenArr

sumar:
    cmp r9, 0
    je calcular_media

    mov rax, [r8]

    ; Ignorar elementos eliminados
    cmp rax, -1
    je no_sumar

    add r12, rax
    inc r13

no_sumar:
    add r8, 8
    dec r9
    jmp sumar

; Calcular media
calcular_media:
    mov rax, r12
    xor rdx, rdx
    mov rbx, r13
    div rbx

    mov [solution], rax

    ; Mostrar mensaje
    mov rax, 1
    mov rdi, 1
    mov rsi, secondMsg
    mov rdx, lens
    syscall

    ; Convertir resultado a decimal
    mov rax, [solution]
    mov rbx, 10
    xor r8, r8

convertir:
    xor rdx, rdx
    div rbx

    add dl, '0'
    push rdx
    inc r8

    cmp rax, 0
    jne convertir

imprimir:
    cmp r8, 0
    je imprimir_salto

    pop rdx
    mov [digit], dl

    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall

    dec r8
    jmp imprimir

imprimir_salto:
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

final:
    mov rax, 60
    xor rdi, rdi
    syscall