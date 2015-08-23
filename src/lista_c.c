#include "lista.h"

#include <ctype.h> //agregada para testear formato




/** Funciones Auxiliares ya implementadas en C **/
						
bool palabraIgual( char *p1, char *p2 ){
   int i = 0;
   while( p1[i] == p2[i] ){
      if( p1[i] == 0 || p2[i] == 0 )
         break;
      i++;
   }
   if( p1[i] == 0 && p2[i] == 0 )
      return true;
   else
      return false;
}

void insertarAtras( lista *l, char *palabra ){
    nodo *nuevoNodo = nodoCrear( palabra );
    nodo *nodoActual = l->primero;
    if( nodoActual == NULL ){
        l->primero = nuevoNodo;
        return;
	}
    while( nodoActual->siguiente != NULL )
		nodoActual = nodoActual->siguiente;
	nodoActual->siguiente = nuevoNodo;
}

/**Mis auxiliares**/
void mayus(char* p){
  int i = 0;
  while(p[i] != 0){
    p[i] = toupper(p[i]);
    i++;
  }
}

/**
void palabraImprimir( char *p, FILE *file ){
  fprintf(file, p);
  fprintf(file, "\n");
}
**/