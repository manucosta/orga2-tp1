
; PALABRA
	global palabraLongitud
	global palabraMenor
	global palabraFormatear
	global palabraImprimir
	global palabraCopiar
	
; LISTA y NODO
	global nodoCrear
	global nodoBorrar
	global oracionCrear
	global oracionBorrar
	global oracionImprimir

; AVANZADAS
	global longitudMedia
	global insertarOrdenado
	global filtrarPalabra
	global descifrarMensajeDiabolico

; YA IMPLEMENTADAS EN C
	extern palabraIgual
	extern insertarAtras
	extern fprintf
	extern malloc
	extern free

; /** DEFINES **/    >> SE RECOMIENDA COMPLETAR LOS DEFINES CON LOS VALORES CORRECTOS
	%define NULL 		0
	%define TRUE 		1
	%define FALSE 		0

	%define LISTA_SIZE 	    	 8
	%define OFFSET_PRIMERO 		 0

	%define NODO_SIZE     		 16
	%define OFFSET_SIGUIENTE    0
	%define OFFSET_PALABRA 		 8


section .rodata
	LF: DB 10 		;puntero a string salto de línea

section .data


section .text


;/** FUNCIONES DE PALABRAS **/
;-----------------------------------------------------------

	; unsigned char palabraLongitud( char *p );
	palabraLongitud:
		;RDI = p
		xor al, al ;AL son los 8bits menos significativos de RAX
		cmp byte [rdi], 0
		je .fin
		.ciclo:
		inc al
		inc rdi
		cmp byte [rdi], 0
		jnz .ciclo
		.fin:
		ret

	; bool palabraMenor( char *p1, char *p2 );
	palabraMenor:
		;RDI = p1
		;RSI = p2
		mov al, byte[rdi] 
		cmp al, [rsi]
		jg .falso
		jl .verdadero
		cmp al, 0 			;verifico que todavia no se acabo ninguna palabra
		jz .falso			;notar que si al==0, [rsi] tambien
		.ciclo:
		inc rdi
		inc rsi
		mov al, byte[rdi] 
		cmp al, [rsi]
		jg .falso
		jl .verdadero
		cmp al, 0 			;verifico que todavia no se acabo ninguna palabra
		jnz .ciclo			;notar que si al==0, [rsi] tambien
		.falso:
		mov al, FALSE
		jmp .fin
		.verdadero:
		mov al, TRUE
		.fin:	
		ret



	; void palabraFormatear( char *p, void (*funcModificarString)(char*) );
	palabraFormatear:
		push rbp					;alineo el stack
		mov rbp, rsp
		call rsi
		pop rbp
		ret

	; void palabraImprimir( char *p, FILE *file );
	palabraImprimir:
		push rbp			
		mov rbp, rsp
		sub rsp, 8		;para alinear el stack
		push r12

		cmp rdi, NULL	;si file==NULL, no hago nada
		jz .fin
		mov r12, rsi 	;preservo file en r12	
		mov rsi, rdi
		mov rdi, r12
		mov rax, 0
		call fprintf
		mov rdi, r12 	;por convención c, r12 se preservó
		mov rsi, LF
		mov rax, 0
		call fprintf
		.fin:
		pop r12
		add rsp, 8
		pop rbp
		ret	

	;char *palabraCopiar( char *p );
	palabraCopiar:
		push rbp
		mov rbp, rsp
		push r12
		push r13

		mov r12, rdi 			;preservo p en R12
		call palabraLongitud	;el resultado está en AL
		xor rcx, rcx
		mov cl, al
		inc rcx 					;considero el char \0
		mov r13, rcx			;preservo rcx en r13
		mov rdi, rcx			
		call malloc				;el resultado está en RAX
		mov rcx, r13
		xor r13, r13
		.ciclo:
		mov dl, byte[r12]
		mov byte[rax + r13], dl
		inc r12
		inc r13
		loop .ciclo
		
		.fin:
		pop r13
		pop r12
		pop rbp
		ret



;/** FUNCIONES DE LISTA Y NODO **/
;-----------------------------------------------------------

	; nodo *nodoCrear( char *palabra );
	nodoCrear:
		push rbp
		mov rbp, rsp
		sub rsp, 8
		push r12

		mov r12, rdi
		mov rdi, NODO_SIZE
		call malloc
		mov qword[rax + OFFSET_SIGUIENTE], NULL
		mov [rax + OFFSET_PALABRA], r12

		pop r12
		add rsp, 8
		pop rbp
		ret

	; void nodoBorrar( nodo *n );
	nodoBorrar:
		;Sólo funciona si la palabra que recibió
		;nodoCrear fue alojada con malloc
		push rbp
		mov rbp, rsp
		sub rsp, 8
		push r12

		mov r12, rdi
		mov rdi, [r12 + OFFSET_PALABRA]
		call free
		mov rdi, r12
		call free

		pop r12
		add rsp, 8
		pop rbp
		ret



	; lista *oracionCrear( void );
	oracionCrear:
		push rbp
		mov rbp, rsp

		mov rdi, LISTA_SIZE
		call malloc
		mov qword[rax + OFFSET_PRIMERO], NULL

		pop rbp
		ret


	; void oracionBorrar( lista *l );
	oracionBorrar:
		push rbp
		mov rbp, rsp
		push r12
		push r13

		mov r13, rdi 	;Preservo la lista
		mov r12, [rdi + OFFSET_PRIMERO] ;R12 = l->primero

		.ciclo:
		cmp r12, NULL
		jz .fin
		mov rdi, r12
		mov r12, [r12 + OFFSET_SIGUIENTE];Preservo el siguiente nodo en r12
		call nodoBorrar
		jmp .ciclo

		.fin:
		mov rdi, r13	;Hago free a la lista
		call free

		pop r13
		pop r12
		pop rbp
		ret

	; void oracionImprimir( lista *l, char *archivo, void (*funcImprimirPalabra)(char*,FILE*) );
	;oracionImprimir:
		; COMPLETAR AQUI EL CODIGO


;/** FUNCIONES AVANZADAS **/
;-----------------------------------------------------------

	; float longitudMedia( lista *l );
	longitudMedia:
		; COMPLETAR AQUI EL CODIGO

	; void insertarOrdenado( lista *l, char *palabra, bool (*funcCompararPalabra)(char*,char*) );
	insertarOrdenado:
		; COMPLETAR AQUI EL CODIGO

	; void filtrarAltaLista( lista *l, bool (*funcCompararPalabra)(char*,char*), char *palabraCmp );
	filtrarPalabra:
		; COMPLETAR AQUI EL CODIGO

	; void descifrarMensajeDiabolico( lista *l, char *archivo, void (*funcImpPbr)(char*,FILE* ) );
	descifrarMensajeDiabolico:
		; COMPLETAR AQUI EL CODIGO
