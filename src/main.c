#include "lista.h"
#include <stdio.h>

int main (void){
	char p[] = "Hola";

	//Testeo palabraLongitud
	printf("TESTEO palabraLongitud\n");
	printf("La longitud de la palabra 'hola' es %d\n", palabraLongitud("hola"));
	printf("La longitud de la palabra 'assembler' es %d\n", palabraLongitud("assembler"));
	printf("La longitud de la palabra vacia es %d\n", palabraLongitud(""));

	//Testeo palabraMenor
	printf("\nTESTEO palabraMenor\n");
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
	printf("TESTEO palabraFormatear\n");
	palabraFormatear( p, nada);
	printf("%s\n", p);

	//Testeo palabraImprimir
	printf("\nTESTEO palabraImprimir\n");
	FILE * pfile = fopen("hola.txt", "w");
	palabraImprimir(p, pfile);
	fclose(pfile);
	pfile = fopen("hola.txt", "a");
	palabraImprimir("mundo", pfile);
	palabraImprimir("!", pfile);
	fclose(pfile);

	//Testeo palabraCopiar
	printf("\nTESTEO palabraCopiar\n");
	char *unaPalabra = palabraCopiar( "hola" );
	char *otraPalabra = palabraCopiar( unaPalabra );
	unaPalabra[1] = 'X';
	palabraImprimir( unaPalabra, stdout );
	palabraImprimir( otraPalabra, stdout );
	free( unaPalabra );
	free( otraPalabra );

	//Testeo crear y borrar nodods
	printf("\nTESTEO CREAR Y BORRAR NODOS\n");
	nodo *miNodo = nodoCrear( palabraCopiar("algunaPalabra") );
	printf( "Palabra del Nodo: %s\n", miNodo->palabra );
	nodoBorrar( miNodo );

	//Testeo crear, borrar e imprimir listas
	printf("\nTESTEO CREAR; BORRAR E IMPRIMIR LISTAS\n");
	lista *miLista = oracionCrear();
	insertarAtras(miLista, palabraCopiar("Hola"));
	insertarAtras(miLista, palabraCopiar("mundo"));
	insertarAtras(miLista, palabraCopiar("version"));
	insertarAtras(miLista, palabraCopiar("lista"));
	oracionImprimir( miLista, "/dev/stdout", palabraImprimir );
	oracionBorrar( miLista );

	//Testeo longitudMedia
	printf("\nTESTEO longitudMedia\n");
	lista *miLista2 = oracionCrear();
	insertarAtras(miLista2, palabraCopiar("cinco"));
	insertarAtras(miLista2, palabraCopiar(""));
	insertarAtras(miLista2, palabraCopiar("tengodiezz"));
	printf( "LongMedia = %2.5f\n", longitudMedia(miLista2));
	oracionBorrar(miLista2);

	return 0;
}
