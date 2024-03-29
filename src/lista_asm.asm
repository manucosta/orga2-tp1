
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
	extern fopen
	extern fprintf
	extern fclose
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
	LF: DB 10 , 0	;puntero a salto de línea
	append: DB "a", 0 ;opción append para printf/fprintf
	vacia: DB "<oracionVacia>" , 0
	sinMD: DB "<sinMensajeDiabolico>" , 0

section .data

section .text


;/** FUNCIONES DE PALABRAS **/
;-----------------------------------------------------------

	; unsigned char palabraLongitud( char *p );
	palabraLongitud:
		xor al, al 			;Sólo devuelvo un byte, así que uso AL
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
		.ciclo:
			mov al, [rdi] 
			cmp al, [rsi]
			jg .falso
			jl .verdadero
			cmp al, 0 			;verifico que todavía no se acabó ninguna palabra
			jz .falso			;notar que si al==0, [rsi] tambien
			inc rdi
			inc rsi
			jmp .ciclo

		.falso:
		mov al, FALSE
		jmp .fin
		.verdadero:
		mov al, TRUE
		.fin:	
		ret


	; void palabraFormatear( char *p, void (*funcModificarString)(char*) );
	palabraFormatear:
		push rbp			;alíneo el stack
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

		cmp rdi, NULL	;si file==NULL,
		jz .fin 			;no hago nada
		mov r12, rsi 	;R12 = file	
		mov rsi, rdi 	;RSI = p
		mov rdi, r12	;RDI = file
		mov rax, 0		;no le paso floats a fprintf
		call fprintf
		mov rdi, r12 	;por convención c, R12 se preservó
		mov rsi, LF
		mov rax, 0
		call fprintf	;imprime el salto de línea
		
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

		mov r12, rdi 			;R12 = p
		call palabraLongitud	;el resultado está en AL
		xor rcx, rcx
		mov cl, al
		inc rcx 					;considero el char \0
		mov r13, rcx			;preservo RCX en R13
		mov rdi, rcx			
		call malloc				;RAX = (char*) copia
		mov rcx, r13			;restauro RCX
		xor r13, r13			;R13 pasa a ser un índice
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

		push rdi
		mov rdi, NODO_SIZE
		call malloc
		mov qword[rax + OFFSET_SIGUIENTE], NULL
		pop rdi
		mov [rax + OFFSET_PALABRA], rdi

		add rsp, 8
		pop rbp
		ret

	; void nodoBorrar( nodo *n );
	nodoBorrar:
		push rbp
		mov rbp, rsp
		sub rsp, 8

		push rdi
		mov rdi, [rdi + OFFSET_PALABRA]
		call free
		pop rdi
		call free

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

		push rdi 	 								;preservo la lista
		mov r12, [rdi + OFFSET_PRIMERO] 		;R12 = l->primero

		.ciclo:
			cmp r12, NULL
			jz .fin
			mov rdi, r12
			mov r12, [r12 + OFFSET_SIGUIENTE]	;R12 = nodoActual->siguiente
			call nodoBorrar
			jmp .ciclo

		.fin:
		pop rdi 		;recupero la lista
		sub rsp, 8	;alineo stack
		call free
		add rsp, 8

		pop r12
		pop rbp
		ret

	; void oracionImprimir( lista *l, char *archivo, void (*funcImprimirPalabra)(char*,FILE*) );
	oracionImprimir:
		push rbp
		mov rbp, rsp
		sub rsp, 8
		push r12
		push r13
		push r14

		mov r12, [rdi + OFFSET_PRIMERO] 		;R12 = l->primero
		mov r13, rdx								;R13 = funcImprimirPalabra
		mov rdi, rsi
		mov rsi, append 
		call fopen									;RAX = (FILE*) file 

		mov r14, rax 								;R14 = file
		cmp r12, NULL
		jnz .ciclo									;si l->primero != NULL, entrar al ciclo
		;caso lista vacía
		mov rdi, vacia
		mov rsi, r14
		call r13
		jmp .fin

		.ciclo:
			mov rdi, [r12 + OFFSET_PALABRA]
			mov rsi, r14
			call r13
			mov r12, [r12 + OFFSET_SIGUIENTE]
			cmp r12, NULL
			jnz .ciclo

		.fin:
		mov rdi, r14
		call fclose			;cierro file
		pop r14
		pop r13
		pop r12
		add rsp, 8
		pop rbp
		ret



;/** FUNCIONES AVANZADAS **/
;-----------------------------------------------------------

	; float longitudMedia( lista *l );
	longitudMedia:
		push rbp
		mov rbp, rsp
		sub rsp, 8
		push r12
		push r13
		push r14

		xor r12, r12     						;R12 es mi acumulador
		xor r13, r13	  						;R13 cuenta los elementos de la lista
		mov r14, [rdi + OFFSET_PRIMERO]  ;con R14 recorro la lista
		pxor xmm0, xmm0  						;en xmm0 voy a devolver el resultado
		cmp r14, NULL							;si l == NULL, devuelvo xmm0 = 0
		jz .fin 	
 		
 		.ciclo:
	 		mov rdi, [r14 + OFFSET_PALABRA]
	 		call palabraLongitud				;el resultado está en AL
	 		and rax, 0xff 						;extiendo el resultado a 64bits
	 		add r12, rax 
	 		inc r13
	 		mov r14, [r14 + OFFSET_SIGUIENTE]
	 		cmp r14, NULL
	 		jnz .ciclo

 		;Cálculo del promedio
 		cvtsi2ss xmm0, r12 
 		cvtsi2ss xmm1, r13
 		divss xmm0, xmm1

 		.fin:
 		pop r14
 		pop r13
 		pop r12
 		add rsp, 8
 		pop rbp
 		ret


	; void insertarOrdenado( lista *l, char *palabra, bool (*funcCompararPalabra)(char*,char*) );
	insertarOrdenado:
	;me queda pendiente refinar el codigo
	;de esta funcion
		push rbp
		mov rbp, rsp
		sub rsp, 8
		push rbx
		push r12
		push r13
		push r14
		push r15

		;Veo si l es vacia
		cmp qword[rdi + OFFSET_PRIMERO], NULL
		jnz .noVacia
		;Caso l vacia
		;RDI ya tiene l y RSI ya tiene palabra
		call insertarAtras
		jmp .fin

		;Caso l no vacia
		.noVacia:
			mov r12, rdi 							;R12 = l 
			mov r13, rdx 							;R13 = funcCompararPalabra
			mov rdi, rsi 							;RDI = palabra
			call nodoCrear
			mov rbx, rax 							;RBX = ptr nodo nuevo
			mov r14, NULL  						;R14 = ptr al nodo anterior
			mov r15, [r12 + OFFSET_PRIMERO]  ;R15 = ptr al nodo actual
		
			.ciclo:
				cmp r15, NULL
				jz .asignacion
				mov rdi, [r15 + OFFSET_PALABRA]
				mov rsi, [rbx + OFFSET_PALABRA]
				call r13 							;Resultado en AL
				cmp al, FALSE
				jz .asignacion
				mov r14, r15
				mov r15, [r15 + OFFSET_SIGUIENTE]
				jmp .ciclo

			.asignacion:
				mov [rbx + OFFSET_SIGUIENTE], r15
				cmp r14, NULL
				jz .agregarPrimero
				mov [r14 + OFFSET_SIGUIENTE], rbx
				jmp .fin

			.agregarPrimero:
			mov [r12 + OFFSET_PRIMERO], rbx

		.fin:
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		add rsp, 8
		pop rbp
		ret


	; void filtrarAltaLista( lista *l, bool (*funcCompararPalabra)(char*,char*), char *palabraCmp );
	filtrarPalabra:
		push rbp
		mov rbp, rsp
		sub rsp, 8
		push rbx
		push r12
		push r13
		push r14
		push r15

		mov rbx, rdi 						  ;RBX = l
		mov r12, rsi 						  ;R12 = funcComparar
		mov r13, rdx 						  ;R13 = palabraCmp
		mov r14, NULL						  ;R14 = (nodo*) anterior
		mov r15, [rbx + OFFSET_PRIMERO] ;R15 = (nodo*) actual
		.ciclo:
			cmp r15, NULL
			jz .finLoop
			mov rdi, [r15 + OFFSET_PALABRA]
			mov rsi, r13
			call r12
			cmp al, TRUE
			jnz .quitarNodo	
				cmp r14, NULL		;Caso funcComparar(actual, palabraCmp) == true
				jnz .avanzarPtrs
				mov [rbx + OFFSET_PRIMERO], r15 ;Si es el primer elemento que pasa el filtro, hacerlo l->primero
				.avanzarPtrs:
				mov r14, r15								;avanzo anterior
				mov r15, [r15 + OFFSET_SIGUIENTE]	;avanzo actual
				jmp .ciclo

				.quitarNodo:		;Caso funcComparar(actual, palabraCmp) == false
				cmp r14, NULL		
				jz .avanzoActual
				mov rdx, [r15 + OFFSET_SIGUIENTE]	;Si anterior != NULL, 
				mov [r14 + OFFSET_SIGUIENTE], rdx	;anterior = actual->siguiente
				.avanzoActual:
				mov rdi, r15						;guardo la ref a actual para borrarlo
				mov r15, [r15 + OFFSET_SIGUIENTE]  ;avanzo actual 
				call nodoBorrar
				jmp .ciclo

		.finLoop:
		cmp r14, NULL	;Si anterior == NULL, ningún elemento pasó el filtro
		jnz .fin 		
		mov qword[rbx + OFFSET_PRIMERO], NULL	;l->primero = NULL
		.fin:
		pop r15
		pop r14
		pop r13
		pop r12
		pop rbx
		add rsp, 8
		pop rbp
		ret


	; void descifrarMensajeDiabolico( lista *l, char *archivo, void (*funcImpPbr)(char*,FILE* ) );
	descifrarMensajeDiabolico:
		push rbp 		;Notar que el stack queda desalineado por lo que
		mov rbp, rsp	;debo alinearlo antes de llamar a cada función.
		push r12  		;El objetivo de esto es disminuir el número de
		push r13  		;operaciones a realizar dentro del cicloPop
		push r14	 		;(i.e. acoto por cte la cant de sub/add rsp, 8)

		mov r12, [rdi + OFFSET_PRIMERO] 	;R12 = l->primero
		mov r13, rdx 							;R13 = funcImpPbr 
		mov rdi, rsi 							;RDI = archivo
		mov rsi, append						;[RSI] = "a"
		sub rsp, 8								;alineo stack
		call fopen
		add rsp, 8
		mov r14, rax 							;R14 = (*FILE) file
		cmp r12, NULL
		jz .listaVacia
		xor rcx, rcx
		push rcx 		;aca alineo el stack
		.cicloPush:
			push r12
			mov r12, [r12 + OFFSET_SIGUIENTE]
			inc rcx									;RCX cuenta la cant de palabras de la oración == cant de push
			push rcx
			cmp r12, NULL
			jnz .cicloPush

		;Acá seguro esta alineado (pues hice una cantidad par de push's)
		pop rcx
		;Al hacer este pop deje la pila desalineada
		.cicloPop:
			pop r12		;alineo stack
			mov rdi, [r12 + OFFSET_PALABRA]
			mov rsi, r14
			call r13
			pop rcx 		;desalineo
			cmp rcx, 0
			jnz .cicloPop
			jmp .fin

		.listaVacia:
			mov rdi, sinMD
			mov rsi, r14
			sub rsp, 8
			call r13
			add rsp, 8

		.fin:
		sub rsp, 8		;alineo stack
		mov rdi, r14
		call fclose
		add rsp, 8
		pop r14
		pop r13
		pop r12
		pop rbp
		ret