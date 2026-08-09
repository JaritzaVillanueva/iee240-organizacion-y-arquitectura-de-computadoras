section .data
	num db "241"            		;Tenemos el numero en formato string
	len_num equ $ - num     		;Longitud del numero
	b equ 7             		    ;Tenemos la base que queremos en formato decimal
	
section .bss
	Cociente resb 8 				;Usamos el numero 8 ya que el numero maximo de digitos que podemos tener es en el sistema binario y son 8 bits
	Residuo  resb 8 				;Usamos el numero 8 ya que el numero maximo de digitos que podemos tener es en el sistema binario y son 8 bits
	Cambio_b resb 8 				;Usamos el numero 8 ya que el numero maximo de digitos que podemos tener es en el sistema binario y son 8 bits

section .text
	global _start
 
_start:
	xor rax, rax                    ;Limpiamos el registro rax
	xor rbx, rbx                    ;Limpiamos el registro rbx
	xor rcx, rcx                    ;Limpiamos el registro rcx
	xor r8, r8                      ;Limpiamos el registro r8
	xor r9, r9                      ;Limpiamos el registro r9
	xor r10, r10                    ;Limpiamos el registro r10
	; Se carga el bit menos significativo para poder calcularlo
	mov rbx, num				    ;rbx <- num _ (<mem_adress> de num), le estamos dando la direccion de memoria al registro rbx
	mov rcx, len_num				;rcx <- 3   le damos la longitud del numero a rcx
	add rbx, rcx					;rbx <- num + len_num (en este caso 3)   QUEREMOS OBTENER EL NUMERO MENOS SIGNIFICATIVO POR LO QUE AVANZAMOS HASTA LA POSICION 3
	dec rbx							;rbx <- num + 1   DECREMENTO DE 1 PORQUE SINO NOS IRIAMOS DEL TAMANO DEL ARREGLO
	mov r9, 1						; r9 tiene el valor de 1
	mov r8, 0						; r8 almacenara el peso correspondiente a cada digito
	mov r10, 10						; r10 almacena la constante 10 para generar pesos de los digitos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_get_num:
	mov al, byte [rbx]				; Le damos al registro al el valor del byte menos significativo de rbx
	sub rax, 0x30					; restando el ASSCI de '0' para "convertir" el char en numero
	mul r9							; rdx:rax <- rax*r9 = 7*1    R9 obtenemos el valor de la multiplicacion 
	add r8, rax						; r8 <- r9 + rax = 0 + 7*1   R8 nos permite almacenar la suma parcial
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_next_pow:
	dec rcx							; rcx <- 3-1 
	cmp rcx, 0						; ¿rcx = 0?
	jz  Reiniciar_Registros 		; Salta hacia la otra bandera en que caso sea 0
	mov rax, r9     				; Movemos el valor a rax de r9
	mul r10         				; r10 se multiplica con rax
	mov r9, rax    					; Movemos el valor de rax a r9
	dec rbx;        				; Decrementa en 1 rbx
	jmp _get_num    				; Salto de nuevo hacia la etiqueta
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Reiniciar_Registros:
	xor rax, rax                    ; Limpiamos el registro rax
	xor rbx, rbx                    ; Limpiamos el registro rbx
	xor rcx, rcx                    ; Limpiamos el registro rcx
	xor r9, r9                      ; Limpiamos el registro r9
	xor r10, r10	                ; Limpiamos el registro r10
	;Iniciamos el valor de la division
	mov rax, r8          			; Pasamos el valor del numero a ax
	mov r9, 0       				; Contador del puntero
	mov r10, len_num      			; Contador de la longitud del numero
	mov r11, 0                      ; Cargamos r11 a 0
 	mov cx, b     					; Pasamos el valor de b al cx un registro de 16 bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Cambio_base:
	div cx                          ; Dividimos ax/cx, y el valor nos queda el registro en AX tenemos el cociente y en DX el residuo
	mov [Cociente + r9], ax         ; Guardamos el valor del cociente en el segmento bss correspondiente
	mov [Residuo + r9], dx          ; Guardamos el valor del cociente en el segmento bss correspondiente
	xor rdx, rdx                    ; Limpiamos rdx ya que recordemos que la division agarra los registros RDX:RAX para dividir por lo que tenemos que ponerlo a 0
	inc r9                          ; Incrementa en 1 el registro r9
	cmp ax, cx                      ; Si el valor de ax es menor con cx, es decir que el cociente nos va a resultar 0 termina el programa y guardamos el ultimo valor
	jl Ultimo_Guardado_Residuo      ; Ultimo guardado de la iteracion del bucle
	jmp Cambio_base                 ; Repite el bucle
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Ultimo_Guardado_Residuo:
	mov [Residuo + r9], ax          ; Guardamos el ultimo valor de residuo 
    mov r11, 0                      ; Reiniciamos el r11 para poder voltear el arreglo en el proximo segmento
	jmp Obtener_Numero_Arreglo      ; Saltamos a la siguiente etiqueta

Obtener_Numero_Arreglo:
	mov bl, [Residuo + r9]          ; Obtenemos el ultimo valor de Residuo y lo guardamos en bl
	mov [Cambio_b + r11], bl        ; El valor guardado en bl lo guardamos en el valor menos significativo del Cambio_b
	inc r11                         ; Incrementamos r11
	cmp r9, 0                       ; Comparamos r9 con 0 para terminar el bucle
    dec r9                          ; Decrementamos r9
	je Guardar_Ultimo_Valor         ; Si pasa eso se va a guardar el ultimo valor como en el paso previo
	jmp Obtener_Numero_Arreglo      ; Repite la etiqueta

Guardar_Ultimo_Valor:
    mov bl, [Residuo + r9]          ; Se guarda el ultimo valor en bl
    mov [Cambio_b + r11], bl        ; Lo guardamos finalmente
    xor bl, bl                      ; Limpiamos el registro bl
    mov r13, r11                    ; Movemos la posicion a r11
    mov [Residuo + r13], bl         ; Limpiamos el ultimo residuo 
    inc r11                         ; Estimado Jefe de Practica utilice este registro para cuando muestre en el segmento bss los bits NECESARIOS para el número convertido
                                    ; En el caso de Cociente y Residuo restele uno a r11 seria x/x(r11-1)xb &Residuo
                                    ; Por ejemplo x/r11xb &Cambio_b .Con esto mostraria el numero convertido con los bits suficientes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_end:
	mov rax, 60                     ;Termino del programa
	mov rdi, 0
	syscall
