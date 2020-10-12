%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <float.h>
#include "y.tab.h"
#define MAX_CADENA 50


FILE  *yyin;


int show_error(char*);

%}
%option noyywrap  
%option yylineno 


ELSE_T		"else"|"ELSE"|"Else"
IF_T		"IF"|"if"|"If"
WHILE_T		"WHILE"|"while"|"While"
INTEGER_T	"INTEGER"|"integer"|"Integer"
FLOAT_T		"Float"|"float"|"FLOAT"
PUT_T		"PUT"|"put"|"Put"
GET_T		"GET"|"get"|"Get"
DIM_T		"DIM"|"dim"|"Dim"
AS_T		"AS"|"As"|"as"
STRING_T	"String"|"string"|"STRING"
AND_T		"And"|"and"|"AND"
OR_T		"Or"|"or"|"OR"
NOT_T		"Not"|"not"|"NOT"
CONTAR_T	"Contar"|"contar"|"CONTAR"

DIGITO		[0-9]
LETRA		[a-zA-Z]
BINARIO		0[bB][01]+
HEXA		0[xX][0-9A-Fa-f]+

COMENTARIO_A       \*\-
COMENTARIO_C       \-\*
COMENTARIO      [^\*\-\n\r]*

COMENTARIO_CERO  {COMENTARIO_A}{COMENTARIO}{COMENTARIO_C}
COMENTARIO_UNO {COMENTARIO_A}({COMENTARIO}*{COMENTARIO_CERO})*{COMENTARIO}({COMENTARIO_CERO})*{COMENTARIO}({COMENTARIO_CERO})*{COMENTARIO}*{COMENTARIO_C}
COMENTARIO_DOS {COMENTARIO_A}{COMENTARIO}*{COMENTARIO_UNO}{COMENTARIO}*{COMENTARIO_C}

REAL     	({DIGITO}*"."{DIGITO}+)|({DIGITO}+"."{DIGITO}*)
ENTERO      {DIGITO}+
CADENA      \"(\\.|[^\"])*\"
ID			{LETRA}({LETRA}|{DIGITO}|_)*

%%

","         	{ return COMA;}
";"         	{ return PUNTO_COMA;}
"["         	{ return CORCHETE_A;}
"]"         	{ return CORCHETE_C;}

":="		    { return OP_ASIG;}
"+"				{ printf("OP_SUMA: %s\n", yytext); return OP_SUMA;}
"-"				{ printf("OP_RESTA: %s\n", yytext); return OP_RESTA;}
"*"				{ return OP_MUL;}
"/"				{ return OP_DIV;}

"("				{ return PARENTESIS_A;}
")"				{ return PARENTESIS_C;}
"{"         	{ return LLAVE_A;}
"}"        		{ return LLAVE_C;}
">"         	{ return OP_MAYOR;}  //GREATER_THAN
"<"         	{ return OP_MENOR;}  //LESS_THAN
">="        	{ return OP_MAYOR_IGUAL;} //GREATER_EQUAL_THAN
"<="        	{ return OP_MENOR_IGUAL;} //LESS_EQUAL_THAN
"=="       	 	{ return OP_IGUAL;}   //EQUAL
"<>"        	{ return OP_DISTINTO;}

{WHILE_T}       {return WHILE_T;}
{IF_T}          {return IF_T;}
{DIM_T}         {return DIM_T;}
{AS_T}          {return AS_T;}
{PUT_T}         {return PUT_T;}
{GET_T}         {return GET_T;}
{INTEGER_T}     {return INTEGER_T;}
{STRING_T}      {return STRING_T;}
{FLOAT_T}       {return FLOAT_T;}
{ELSE_T}        {return ELSE_T;}
{CONTAR_T}      { return CONTAR_T;}
{OR_T}          { return OR_T;}
{AND_T}         { return AND_T;}
{NOT_T}         { return NOT_T;}


{ID}			{ printf("ID: %s\n", yytext);

            if(yyleng <= 30){ 
                        yylval.str_val = strdup(yytext);
                        return ID;
                    }
                    show_error("ERROR LEXICO. NOMBRE DE VARIABLE MAYOR a 30 caracteres\n");

          }
{ENTERO}	{ 
            if(atoi( yytext ) <= 32767 /*&& atoi( yytext ) >= -32768*/){
                yylval.int_val = atoi(yytext);
                printf("ENTERO: %s\n", yytext);return ENTERO;}
              show_error("ERROR LEXICO. ENTERO FUERA DE RANGO\n");
            }

{REAL}    {
            if(atof( yytext ) < FLT_MAX && atof( yytext ) > FLT_MIN ){
              yylval.real_val = atof(yytext);
              printf("REAL: %s\n", yytext);return REAL;}
              show_error("ERROR LEXICO. REAL FUERA DE RANGO\n");
          }

{CADENA}        { if(yyleng <= MAX_CADENA ){ 
                        yylval.str_val = strdup(yytext);
                      printf("CADENA: %s\n", yytext);return CADENA;
                                 } 
                   /* show_error("ERROR LEXICO. CADENA MAYOR a 32 caracteres\n");*/
                }
{BINARIO}		{ printf("BINARIO: %s\n", yytext);
              yylval.str_val = strdup(yytext);
              return BINARIO;
            }
{HEXA}			{ printf("HEXA: %s\n", yytext);
              yylval.str_val = strdup(yytext);
              return HEXA;
            }


{COMENTARIO_CERO} {}
{COMENTARIO_UNO} {}
{COMENTARIO_DOS} { yyerror(); }
. {}              
%%

int show_error (char* texto)
{
 printf("%s", texto); 
 exit(1); 
}

