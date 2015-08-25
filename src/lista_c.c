#include "lista.h"


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
void nada(char* p){}

/**
void palabraImprimir( char *p, FILE *file ){
  fprintf(file, p);
  fprintf(file, "\n");
}
**/

/**
char *palabraCopiar( char *p ){
   unsigned char n = palabraLongitud(p);
   char* buffer = (char*) malloc(n+1);
   for(int i = 0; i <= n; i++){
    buffer[i] = p[i];
  }

  return buffer;
}
**/

/**
nodo* nodoCrear( char *palabra ){
   nodo* pnodo = (nodo*) malloc(16);
   pnodo->siguiente = NULL;
   pnodo->palabra = palabra;
   return pnodo; 
}
**/

/**
void nodoBorrar( nodo *n ){
   free(n->palabra);
   n->palabra = NULL; //¿Es necesario?
   free(n);
   n = NULL; //¿Es necesario?
}
**/

/*
void oracionImprimir( lista *l, char *archivo, void (*funcImprimirPalabra)(char*,FILE*) ){
   FILE* file = fopen(archivo, "a");
   if(l->primero == NULL) {
      funcImprimirPalabra("<oracionVacia>",file);
   }
   else {
      nodo* aux = l->primero;
      while(aux != NULL) {
         funcImprimirPalabra(aux->palabra, file);
         aux = aux->siguiente;
      }
   }
   fclose(file);
}
*/