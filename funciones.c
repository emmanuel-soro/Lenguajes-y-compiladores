#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define TODO_OK 1
#define FALLO	2
#define CON_VALOR 3
#define SIN_VALOR 4
#define ES_STRING 5
#define BIN 6
#define HEXADECIMAL 7
#define FLOAT 8
#define INTEGER 9
#define STRING 10	
#define TABLA_SIMBOLOS "ts.txt"

typedef struct s_nodo{
	char* nombre;
	char* valor;
	char* tipo;
	struct s_nodo* siguiente;

}t_nodo;

typedef t_nodo *t_lista;

FILE * file;

int insertar_en_lista(char* , int ,t_lista*  );

int vaciar_lista(t_lista* lista);

void crear_lista(t_lista* lista);

void crear_puntero(t_lista* lista, t_lista* actual);

void eliminar_comilla (char* cadena);

int modificar_lista(t_lista* lista, int tipo, int cont);

////////////////////////////////////////////////////////////////

void crear_lista(t_lista* lista){
	*lista = NULL;
}
void crear_puntero(t_lista* lista, t_lista* actual){
	*actual = *lista;
}

int insertar_en_lista(char* nombre_var , int valor , t_lista* lista_simbolos){
	t_nodo* nuevo;
	t_lista *laux = lista_simbolos;
	int resultado = 0;
	nuevo = (t_nodo*) malloc(sizeof(t_nodo));
	if(nuevo == NULL){
		printf("Error, no hay memoria\n.");
		return FALLO;
	}
	if(valor == ES_STRING){
		nuevo->nombre = (char*) malloc(sizeof(char) * strlen(nombre_var) + 1);
		nuevo->valor = (char*) malloc(sizeof(char) * strlen(nombre_var) + 1);
		if(nuevo->nombre == NULL || nuevo->valor == NULL){
			printf("Error, no hay memoria\n.");
			return FALLO;
		}
		eliminar_comilla(nombre_var);
		strcpy(nuevo->nombre, "_");
		strcat(nuevo->nombre, nombre_var);
		strcpy(nuevo->valor, nombre_var);
	
	}else{
		nuevo->nombre = (char*) malloc(sizeof(char) * strlen(nombre_var) + 2);
		if(nuevo->nombre == NULL){
			printf("Error, no hay memoria\n.");
			return FALLO;
		}
		strcpy(nuevo->nombre,"_");
		strcat(nuevo->nombre, nombre_var);

		if(valor == CON_VALOR){
			nuevo->valor = (char*) malloc(sizeof(char) * strlen(nombre_var) + 1);
			if(!(nuevo->valor)){
				printf("Error, no hay memoria\n.");
				return FALLO;
			}
			strcpy(nuevo->valor, nombre_var);
			nuevo->tipo = NULL;
		}else{
			nuevo->tipo = (char*) malloc(sizeof(char) * 10);
			if(nuevo->tipo == NULL ){
				printf("Error, no hay memoria suficiente\n");
				return FALLO;
			}
			nuevo->valor = NULL;
		}
	}
	if(!*lista_simbolos){
		nuevo->siguiente = NULL;
		*lista_simbolos = nuevo;
		printf("%d\n", *lista_simbolos);
	}
	while((*laux)->siguiente){
		laux = &(*laux)->siguiente;
	}
	(*laux)->siguiente = nuevo;
	nuevo->siguiente = NULL;
	free(laux);
	return TODO_OK;
}

int vaciar_lista(t_lista* lista){
	t_nodo* anterior;
	file = fopen(TABLA_SIMBOLOS, "w+");
	if(!file){
		printf("Error al abrir el archivo.\n");
		return FALLO;
	}
 	fprintf(file,"%s\n","NOMBRE|TIPODATO|VALOR|LONGITUD");
 	while(*lista){
 		anterior = *lista;
 		*lista = anterior->siguiente;
 		fprintf(file, "%s|%s|%s|-\n", anterior->nombre,anterior->tipo, anterior->valor );
 		free(anterior);
 	}

  	fclose(file);
  	return TODO_OK;
}
void eliminar_comilla (char* cadena){
	char* caracter = cadena;
	char* caracter_sig = caracter;
	caracter_sig++;

	while(*caracter_sig != '"' ){
		*caracter = *caracter_sig;
		caracter++;
		caracter_sig++;		
	}
	*caracter_sig = '\0';
}

int modificar_lista(t_lista* lista, int tipo, int cont){
	t_lista* aux = lista;
	for(int i = 0; i < cont; i++){
		aux = &(*aux)->siguiente;
	}
	if(tipo == INTEGER){
		strcpy((*aux)->tipo,"Int");
	}else if(tipo == FLOAT){
		strcpy((*aux)->tipo,"Float");
	}
	else if(tipo == STRING ){
		strcpy((*aux)->tipo,"String");
	}
	else
	{
		return FALLO;
	}
	free(aux);
	return TODO_OK;

}