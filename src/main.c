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
	printf( "LongMedia = %2.5f\n", longitudMedia(miLista2));
	insertarAtras(miLista2, palabraCopiar("cinco"));
	insertarAtras(miLista2, palabraCopiar(""));
	insertarAtras(miLista2, palabraCopiar("tengodiezz"));
	printf( "LongMedia = %2.5f\n", longitudMedia(miLista2));
	oracionBorrar(miLista2);

	//Testeo insertarOrdenada
	printf("\nTESTEO insertarOrdenada\n");
	lista *miLista3 = oracionCrear();
	insertarOrdenado( miLista3, palabraCopiar( "palabra2" ), palabraMenor );
	insertarOrdenado( miLista3, palabraCopiar( "palabra1" ), palabraMenor );//se rompe al agregar el segundo elemento
	insertarOrdenado( miLista3, palabraCopiar( "palabra4" ), palabraMenor );
	insertarOrdenado( miLista3, palabraCopiar( "palabra2" ), palabraMenor );
	insertarOrdenado( miLista3, palabraCopiar( "palabra3" ), palabraMenor );
	oracionImprimir( miLista3, "/dev/stdout", palabraImprimir );
	oracionBorrar(miLista3);

	//Testeo filtrarPalabra
	printf("\nTESTEO filtrarPalabra\n");
	lista *miLista4 = oracionCrear();
	insertarOrdenado( miLista4, palabraCopiar( "palabra1" ), palabraMenor);
	insertarOrdenado( miLista4, palabraCopiar( "palabra2" ), palabraMenor);
	insertarOrdenado( miLista4, palabraCopiar( "palabra1" ), palabraMenor);
	insertarOrdenado( miLista4, palabraCopiar( "palabra3" ), palabraMenor);
	insertarOrdenado( miLista4, palabraCopiar( "Palabra8" ), palabraMenor);

	filtrarPalabra( miLista4, palabraMenor, "palabra3" );
	printf("Filtrar menores que palabra3:\n");
	oracionImprimir( miLista4, "/dev/stdout", palabraImprimir);

	filtrarPalabra( miLista4, palabraIgual, "palabra1" );
	printf("Filtrar iguales que palabra1:\n");
	oracionImprimir( miLista4, "/dev/stdout", palabraImprimir);

	filtrarPalabra( miLista4, palabraIgual, "palabra4" );
	printf("Filtrar iguales que palabra4:\n");
	oracionImprimir( miLista4, "/dev/stdout", palabraImprimir);

	filtrarPalabra( miLista4, palabraMenor, "palabra4" );
	printf("Filtrar menores que palabra4:\n");
	oracionImprimir( miLista4, "/dev/stdout", palabraImprimir);

	oracionBorrar(miLista4);

	//Testeo descifrarMensajeDiabolico
	printf("\nTESTEO descifrarMensajeDiabolico\n");
	
	printf("Descifrar lista vacía:\n");
	lista *listaVacia = oracionCrear();
	descifrarMensajeDiabolico(listaVacia, "/dev/stdout", palabraImprimir);
	
	printf("Descifrar lista corta:\n");
	lista *unico = oracionCrear();
	insertarOrdenado( unico, palabraCopiar( "palabra1" ), palabraMenor);
	descifrarMensajeDiabolico(unico, "/dev/stdout", palabraImprimir);

	printf("Descifrar lista mediana:\n");
	lista *miLista5 = oracionCrear();
	insertarOrdenado( miLista5, palabraCopiar( "palabra1" ), palabraMenor);
	insertarOrdenado( miLista5, palabraCopiar( "palabra2" ), palabraMenor);
	insertarOrdenado( miLista5, palabraCopiar( "palabra1" ), palabraMenor);
	insertarOrdenado( miLista5, palabraCopiar( "palabra3" ), palabraMenor);
	insertarOrdenado( miLista5, palabraCopiar( "Palabra8" ), palabraMenor);

	descifrarMensajeDiabolico(miLista5, "/dev/stdout", palabraImprimir);

	oracionBorrar(listaVacia);
	oracionBorrar(unico);
	oracionBorrar(miLista5);

	return 0;
}
