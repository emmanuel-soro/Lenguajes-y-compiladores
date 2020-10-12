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
	char nombre[32];
	char valor [30];
	char tipo [9];
	char longitud [2];
	struct s_nodo* siguiente;

}t_nodo;

typedef t_nodo *t_lista;

FILE * file;

int insertar_en_lista(char* , int ,t_lista*  );

int insertar_entero(int nombre_var, t_lista* lista_simbolos);

int insertar_real(float cte, t_lista* lista_simbolos);

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
int insertar_entero(int cte, t_lista* lista_simbolos){
	char nombre[20];
	t_nodo* nuevo;
	t_lista *laux = lista_simbolos;
	nuevo = (t_nodo*) malloc(sizeof(t_nodo));
	if(nuevo == NULL){
		printf("Error, no hay memoria\n.");
		return FALLO;
	}

	itoa(cte, nombre, 10);

	strcpy(nuevo->valor, nombre);
	strcpy(nuevo->tipo, "-");
	strcpy(nuevo->longitud,"-");
	strcpy(nuevo->nombre,"_");
	strcat(nuevo->nombre, nombre);
	
	if(!*lista_simbolos){
		nuevo->siguiente = NULL;
		*lista_simbolos = nuevo;
	}
	while((*laux)->siguiente){
		laux = &(*laux)->siguiente;
	}
	(*laux)->siguiente = nuevo;
	nuevo->siguiente = NULL;
	free(laux);
	return TODO_OK;
}

int insertar_real(float cte, t_lista* lista_simbolos){
	char nombre[20];
	t_nodo* nuevo;
	t_lista *laux = lista_simbolos;
	nuevo = (t_nodo*) malloc(sizeof(t_nodo));
	if(nuevo == NULL){
		printf("Error, no hay memoria\n.");
		return FALLO;
	}

	sprintf(nombre, "%.4f", cte);

	strcpy(nuevo->valor, nombre);
	strcpy(nuevo->tipo,"-");
	strcpy(nuevo->longitud,"-");
	strcpy(nuevo->nombre,"_");
	strcat(nuevo->nombre, nombre);
	
	if(!*lista_simbolos){
		nuevo->siguiente = NULL;
		*lista_simbolos = nuevo;
	}
	while((*laux)->siguiente){
		laux = &(*laux)->siguiente;
	}
	(*laux)->siguiente = nuevo;
	nuevo->siguiente = NULL;
	free(laux);
	return TODO_OK;
}

int insertar_en_lista(char* nombre_var , int valor , t_lista* lista_simbolos){
	t_nodo* nuevo;
	t_lista* laux = lista_simbolos;
	char longitud [2];
	nuevo = (t_nodo*) malloc(sizeof(t_nodo));
	if(nuevo == NULL){
		printf("Error, no hay memoria\n.");
		return FALLO;
	}


	if(valor == ES_STRING){
		eliminar_comilla(nombre_var);
		itoa(strlen(nombre_var), longitud,10);
		strcpy(nuevo->longitud,longitud);
		strcpy(nuevo->nombre, "_");
		strcat(nuevo->nombre, nombre_var);
		strcpy(nuevo->valor, nombre_var);
		strcpy(nuevo->tipo,"-");
	}else if(valor == CON_VALOR){
		strcpy(nuevo->nombre, "_");
		strcat(nuevo->nombre, nombre_var);
		strcpy(nuevo->valor, nombre_var);
		strcpy(nuevo->tipo,"-");
		strcpy(nuevo->longitud,"-");
	}else{
		strcpy(nuevo->nombre, "_");
		strcat(nuevo->nombre, nombre_var);
		strcpy(nuevo->tipo,"-");
		strcpy(nuevo->valor,"-");
		strcpy(nuevo->longitud,"-");
	}

	if(!*lista_simbolos){
		nuevo->siguiente = NULL;
		*lista_simbolos = nuevo;
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
 		fprintf(file, "%s|%s|%s|%s\n", anterior->nombre,anterior->tipo, anterior->valor, anterior->longitud );
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
	int i;
	for(i = 0; i < cont; i++){
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
	else if(tipo == HEXADECIMAL ){
		strcpy((*aux)->tipo,"Hexa");
	}
	else if(tipo == BIN ){
		strcpy((*aux)->tipo,"Binario");
	}
	else
	{
		return FALLO;
	}
	free(aux);
	return TODO_OK;

}
int existe_simbolo(char* simbolo, t_lista* lista){
	t_lista* laux = lista;
	char aux[32] = "_";
	strcat(aux,simbolo);
	while((*laux)->siguiente){
		if(strcmp(aux,(*laux)->nombre)==0)
			return TODO_OK;
		laux = &(*laux)->siguiente;
	}
	if(strcmp(aux,(*laux)->nombre)==0)
			return TODO_OK;
	return FALLO;
}