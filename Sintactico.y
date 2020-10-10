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

start: programa {printf(" Compilacion Exitosa\n");
                guardar_variables_ts();
                }
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

print: PUT_T ID PUNTO_COMA | PUT_T CADENA PUNTO_COMA ;
scan:  GET_T ID PUNTO_COMA ;

lista_variable: ID 
            {
                crear_lista_variable($<str_val>1);
                printf("Paso lista variable ID, strval:%s\n",$1);
            }
            | lista_variable COMA ID 
            {   
                printf("Paso lista variable lista_variable COMA ID \n");
              if(crear_lista_variable($<str_val>3)==NOT_SUCCESS){
                printf("NO HAY MAS MEMORIA \n");
                yyerror();
                }
            }
            ;

tipo_variable: INTEGER_T 
                {
                printf("Paso tipo variable INTEGER\n");
            }
| FLOAT_T
       {
                printf("Paso tipo variable FLOAT\n");
            } | STRING_T
                   {
                printf("Paso tipo variable STRING\n");
            } ; 
lista_tipo:  tipo_variable 

       {
                printf("Paso lista tipo tipo variable\n");
            }


| lista_tipo COMA tipo_variable
       {
                printf("Paso lista tipo lista tipo COMA tipo_variable\n");
            }


 ;
tipo_numerico: ENTERO | REAL | HEXA | BINARIO ;
lista_numerica:  tipo_numerico | lista_numerica COMA tipo_numerico;
declaracion: DIM_T CORCHETE_A lista_variable CORCHETE_C AS_T CORCHETE_A lista_tipo CORCHETE_C 
{printf("Paso declaracion\n");}
;
contar: CONTAR_T PARENTESIS_A expresion PUNTO_COMA CORCHETE_A lista_numerica CORCHETE_C PARENTESIS_C ;
%%

int main(int argc,char *argv[])
{
  if ((yyin = fopen(argv[1], "rt")) == NULL){
	  printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else{
    crearTabla();
    {printf("Paso Crear Tabla\n");}
    array_nombres_variables = malloc(sizeof(char*)* INITIAL_CAPACITY);
    {printf("Paso Array nombres\n");}
    array_size = INITIAL_CAPACITY;
     {printf("Paso Array Size\n");}
    free(array_nombres_variables);
     {printf("Paso Array nombre variables\n");}
    yyparse();
     {printf("Paso yyparse\n");}
    guardar_ts();

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

