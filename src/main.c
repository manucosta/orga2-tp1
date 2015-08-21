#include "lista.h"
#include <stdio.h>

int main (void){

	//Testeo palabraLongitud
	printf("La longitud de la palabra 'hola' es %d\n", palabraLongitud("hola"));
	printf("La longitud de la palabra 'assembler' es %d\n", palabraLongitud("assembler"));
	printf("La longitud de la palabra vacia es %d\n", palabraLongitud(""));

	//Testeo palabraMenor
	if( palabraMenor( "merced", "mercurio" ) ) printf( "TRUE\n" );else printf( "FALSE\n" );
	if( palabraMenor( "perro", "zorro" ) ) printf( "TRUE\n" );else printf( "FALSE\n" );
	if( palabraMenor( "senior", "seniora" ) ) printf( "TRUE\n" );else printf( "FALSE\n" );
	if( palabraMenor( "caZa", "casa" ) ) printf( "TRUE\n" );else printf( "FALSE\n" );
	if( palabraMenor( "hola", "hola" ) ) printf( "TRUE\n" );else printf( "FALSE\n" );

	//Testeo palabraFormatear
	char p[] = "Hola mundo!";
	palabraFormatear( p, mayus);
	printf("%s\n", p);

	return 0;
}
