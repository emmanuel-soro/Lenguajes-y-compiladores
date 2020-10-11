%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
#include "funciones.c"


int yystopparser=0;
FILE *yyin;

    int yyerror();
    int yylex();
    char* yytext;
    int yylineno;

    t_lista pl;
    t_lista actual;
%}

%union {
      int int_val;
      float real_val;
      char* str_val;
      }

%token ELSE_T	
%token IF_T
%token WHILE_T
%token <str_val> INTEGER_T
%token <str_val> FLOAT_T
%token PUT_T
%token GET_T
%token DIM_T
%token AS_T
%token <str_val> STRING_T
%token AND_T
%token OR_T
%token NOT_T
%token CONTAR_T
%token DIGITO
%token LETRA
%token BINARIO
%token HEXA
%token <real_val> REAL
%token <int_val> ENTERO
%token <str_val> CADENA
%token <str_val> ID	
%token COMA
%token PUNTO_COMA 
%token CORCHETE_A   	
%token CORCHETE_C
%token OP_ASIG
%token OP_SUMA
%token OP_RESTA
%token OP_MUL
%token OP_DIV
%token PARENTESIS_A
%token PARENTESIS_C
%token LLAVE_A
%token LLAVE_C
%token OP_MAYOR
%token OP_MENOR
%token OP_MAYOR_IGUAL
%token OP_MENOR_IGUAL
%token OP_IGUAL
%token OP_DISTINTO

%%

start: programa {printf(" Compilacion Exitosa\n");}
      ;

programa: sentencia  | programa sentencia ;
sentencia: asignacion | iteracion | seleccion | print | scan | declaracion ;
asignacion: ID OP_ASIG expresion PUNTO_COMA ; 
seleccion:  IF_T PARENTESIS_A condicion PARENTESIS_C LLAVE_A programa LLAVE_C ELSE_T LLAVE_A programa LLAVE_C  
            {printf(" Seleccion es if ( Condicion) { Programa } else { programa} \n");}
         |  IF_T PARENTESIS_A condicion PARENTESIS_C LLAVE_A programa LLAVE_C
             {printf(" Seleccion es if ( Condicion) { Programa } \n");}
         |  IF_T PARENTESIS_A condicion PARENTESIS_C asignacion
             {printf(" Seleccion es if ( Condicion) Asignacion \n");}
         |  IF_T PARENTESIS_A condicion PARENTESIS_C print
             {printf(" Seleccion es if ( Condicion) print \n");}
         |  IF_T PARENTESIS_A condicion PARENTESIS_C scan
             {printf(" Seleccion es if ( Condicion) scan \n");}
         ;
         
iteracion:   WHILE_T  PARENTESIS_A condicion PARENTESIS_C LLAVE_A programa LLAVE_C 
        {printf(" Iteracion es WHILE ( Condicion ) { Programa}\n");}
        ;
condicion:   comparacion {printf(" Condicion es Comparacion\n");} 
        | condicion AND_T comparacion {printf(" Condicion es Condicion AND Comparacion\n");}
        | condicion OR_T comparacion {printf(" Condicion es Condicion OR Comparacion\n");} 
        | NOT_T comparacion {printf(" Condicion NOT Comparacion \n");}
        ;
comparacion: expresion comparador expresion {printf(" Comparacion es Expresion Comparador Expresion\n");} 
            ;
comparador:   OP_MAYOR_IGUAL {printf(" Comparador es >=\n");} 
        | OP_MENOR_IGUAL {printf(" Comparador es <=\n");}  
        | OP_MENOR {printf(" Comparador es <\n");}
        | OP_MAYOR {printf(" Comparador es >\n");}
        | OP_IGUAL {printf(" Comparador es =\n");}
        | OP_DISTINTO {printf(" Comparador es <>\n");} 
        ;

expresion:  expresion OP_SUMA termino {printf("   Expresion + Termino\n");} 
        | expresion OP_RESTA termino {printf("   Expresion - Termino\n");} 
        | termino {printf("   Expresion es Termino\n");};

termino:
        factor {printf("   Factor es Termino\n");}
    |termino OP_MUL factor {printf("   Termino*Factor es Termino\n");}
    |termino OP_DIV factor {printf("   Termino/Factor es Termino\n");}
    ;
factor:
        ID {printf("    ID es Factor\n");}
    |ENTERO {printf("  ENTERO es Factor\n");}
    |REAL {printf("  REAL es Factor\n");}
    |BINARIO {printf("  BINARIO es Factor\n");}
    |HEXA {printf("  HEXA es Factor\n");}
    | PARENTESIS_A expresion PARENTESIS_C {printf("  Expresion entre parentesis es Factor\n");}
    | contar {printf("  Contar es Factor\n");}
    ;

print: PUT_T ID PUNTO_COMA 
            | PUT_T CADENA PUNTO_COMA 
              {  

                if(insertar_en_lista($2, ES_STRING, &pl) == FALLO){
                  printf("No hay memoria, no se puede agregar la cadena a la lista de variables. \n");
                  yyerror();
                }
              }
            ;
scan:  GET_T ID PUNTO_COMA ;

lista_variable: ID 
              {
                if(insertar_en_lista($1, SIN_VALOR, &pl) == FALLO){
                  printf("No hay memoria, no se puede agregar la variable. \n");
                  yyerror();
                }
                actual=pl;
              }
            | lista_variable COMA ID 
              {   
                if(insertar_en_lista($3, SIN_VALOR, &pl) == FALLO){
                  printf("NO HAY MAS MEMORIA \n");
                  yyerror();
                }
              }
            ;

tipo_variable: INTEGER_T 
              {
                if(modificar_lista(&actual, INTEGER)==FALLO)
                  printf("Error. No se pudo actualizar\n");
               
                printf("Paso tipo variable INTEGER\n");
              }
            |FLOAT_T
              {
                 if(modificar_lista(&actual, FLOAT)==FALLO)
                  printf("Error. No se pudo actualizar\n");
                printf("Paso tipo variable FLOAT\n");
              } 
            | STRING_T
              {
                if(modificar_lista(&actual, STRING)==FALLO)
                   printf("Error. No se pudo actualizar\n");
                printf("Paso tipo variable STRING\n");
              }
            ; 
lista_tipo:  tipo_variable 
              {
                printf("Paso lista tipo tipo variable\n");
              }
            ;
            | lista_tipo COMA tipo_variable
              {
                printf("Paso lista tipo lista tipo COMA tipo_variable\n");
              }
            ;
tipo_numerico: ENTERO | REAL | HEXA | BINARIO ;
lista_numerica:  tipo_numerico | lista_numerica COMA tipo_numerico;
declaracion: DIM_T CORCHETE_A lista_variable CORCHETE_C AS_T CORCHETE_A lista_tipo CORCHETE_C 
            {
              printf("Paso declaracion\n");
            }
            ;
contar: CONTAR_T PARENTESIS_A expresion PUNTO_COMA CORCHETE_A lista_numerica CORCHETE_C PARENTESIS_C ;

%%

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL){
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else{
    crear_lista(&pl);
    yyparse();
    vaciar_lista(&pl);

  }
  fclose(yyin);
  return 0;
}

int yyerror(void)
{
   printf("Error Sintactico, Linea Num %d \n", yylineno); 
   exit(1); 
}



/*
int main (int argc, char *argv[])
{
    if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo; %s\n", argv[1]);
    }
    else
    {
        yyparse();
    }
    fclose(yyin);
        return 0;
}
*/

