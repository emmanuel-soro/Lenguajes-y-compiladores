%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yystopparser=0;
FILE *yyin;

    int yyerror();
    int yylex();
    char* yytext;
    int yylineno;

%}

%token ELSE_T	
%token IF_T
%token WHILE_T
%token INTEGER_T
%token FLOAT_T
%token PUT_T
%token GET_T
%token DIM_T
%token AS_T
%token STRING_T
%token AND_T
%token OR_T
%token NOT_T
%token CONTAR_T
%token DIGITO
%token LETRA
%token BINARIO
%token HEXA
%token REAL
%token ENTERO
%token CADENA
%token ID	
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

start: programa {printf(" Compilacion Exitosa\n");};

programa: sentencia  | programa sentencia ;
sentencia: asignacion | iteracion | seleccion | print | scan | declaracion ;
asignacion: ID OP_ASIG expresion PUNTO_COMA ; 
seleccion:  IF_T PARENTESIS_A condicion PARENTESIS_C LLAVE_A programa LLAVE_C ELSE_T LLAVE_A programa LLAVE_C 
         |  IF_T PARENTESIS_A condicion PARENTESIS_C LLAVE_A programa LLAVE_C
         |  IF_T PARENTESIS_A condicion PARENTESIS_C asignacion
         |  IF_T PARENTESIS_A condicion PARENTESIS_C print
         |  IF_T PARENTESIS_A condicion PARENTESIS_C scan
         ;
         
iteracion:   WHILE_T  PARENTESIS_A condicion PARENTESIS_C LLAVE_A programa LLAVE_C ;
condicion:   comparacion | condicion AND_T comparacion | condicion OR_T comparacion ;
comparacion: expresion comparador expresion ;
comparador:   OP_MAYOR_IGUAL | OP_MENOR_IGUAL | OP_MENOR | OP_MAYOR | OP_IGUAL;

expresion:  expresion OP_SUMA termino | expresion OP_RESTA termino | termino;

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
    | contar
    ;

print: PUT_T ID PUNTO_COMA | PUT_T CADENA PUNTO_COMA ;
scan:  GET_T ID PUNTO_COMA ;
lista_variable: ID | lista_variable COMA ID ;
tipo_variable: INTEGER_T | FLOAT_T | STRING_T ; 
lista_tipo:  tipo_variable | lista_tipo COMA tipo_variable ;
tipo_numerico: ENTERO | REAL | HEXA | BINARIO ;
lista_numerica:  tipo_numerico | lista_numerica COMA tipo_numerico;
declaracion: DIM_T CORCHETE_A lista_variable CORCHETE_C AS_T CORCHETE_A lista_tipo CORCHETE_C ;
contar: CONTAR_T PARENTESIS_A expresion PUNTO_COMA CORCHETE_A lista_numerica CORCHETE_C PARENTESIS_C ;
%%

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

int yyerror(void)
{
   printf("Error Sintactico\n"); 
   exit(1); 
}

