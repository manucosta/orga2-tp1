#include "lista.h"
#include <stdio.h>

int main (void){
	char p[] = "Hola";

	//Testeo palabraLongitud
	printf("La longitud de la palabra 'hola' es %d\n", palabraLongitud("hola"));
	printf("La longitud de la palabra 'assembler' es %d\n", palabraLongitud("assembler"));
	printf("La longitud de la palabra vacia es %d\n", palabraLongitud(""));

	//Testeo palabraMenor
	if( palabraMenor( "merced", "mercurio" ) ) printf( "TRUE\n" );
	else printf( "FALSE\n" );
	if( palabraMenor( "perro", "zorro" ) ) printf( "TRUE\n" );
	else printf( "FALSE\n" );
	if( palabraMenor( "senior", "seniora" ) ) printf( "TRUE\n" );
	else printf( "FALSE\n" );
	if( palabraMenor( "caZa", "casa" ) ) printf( "TRUE\n" );
	else printf( "FALSE\n" );
	if( palabraMenor( "hola", "hola" ) ) printf( "TRUE\n" );
	else printf( "FALSE\n" );

	//Testeo palabraFormatear
	palabraFormatear( p, nada);
	printf("%s\n", p);

	//Testeo palabraImprimir
	FILE * pfile = fopen("hola.txt", "w");
	palabraImprimir(p, pfile);
	fclose(pfile);
	pfile = fopen("hola.txt", "a");
	palabraImprimir("mundo", pfile);
	palabraImprimir("!", pfile);
	fclose(pfile);

	//Testeo palabraCopiar
	char *unaPalabra = palabraCopiar( "hola" );
	char *otraPalabra = palabraCopiar( unaPalabra );
	unaPalabra[1] = 'X';
	palabraImprimir( unaPalabra, stdout );
	palabraImprimir( otraPalabra, stdout );
	free( unaPalabra );
	free( otraPalabra );
	
	//Testeo crear y borrar nodods
	nodo *miNodo = nodoCrear( palabraCopiar("algunaPalabra") );
	printf( "Palabra del Nodo: %s\n", miNodo->palabra );
	nodoBorrar( miNodo );

	//Testeo crear, borrar e imprimir listas
	lista *miLista = oracionCrear();
	insertarAtras(miLista, palabraCopiar("Hola"));
	insertarAtras(miLista, palabraCopiar("mundo"));
	insertarAtras(miLista, palabraCopiar("version"));
	insertarAtras(miLista, palabraCopiar("lista"));
	oracionImprimir( miLista, "/dev/stdout", palabraImprimir );
	oracionBorrar( miLista );


	return 0;
}
