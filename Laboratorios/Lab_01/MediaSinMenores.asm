section .data
	;Mensajes
    firstMsg db "Ingrese la cantidad de menores a quitar: " 
	lenf equ $ - firstMsg
	secondMsg db "La media calculada es: " 
	lens equ $ - secondMsg
    ;Variables
    arreglo dq 5, 3, 4, 8, 9, 7
    lenArr dq 6
    numMenores dq 0
    ;Auxiliares
	solution dq 0
    char dq 10 ;ASCII del cambio de linea
    
section .text          ;Code Segment
    global _start

_start:
    mov rax, 1
	mov rdi, 1
	mov rsi, firstMsg
	mov rdx, lenf
	syscall

    mov rax, 0
	mov rdi, 0
	mov rsi, numMenores
	mov rdx, 1
	syscall

    mov rax, 0
	mov rdi, 0
	mov rsi, char
	mov rdx, 1
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, secondMsg
	mov rdx, lens
	syscall

inicio:
    ; Limpiar los registros a utilizar
    xor rax,rax
    xor rbx,rbx
    xor rcx,rcx
    xor rdx,rdx

    ;********************
    ; INICIO DEL CÓDIGO
    ;********************
    

final:
    mov rax, 1
	mov rdi, 1
	mov rsi, char
	mov rdx, 1
	syscall

    mov rax, 60
	mov rdi, 0
	syscall
