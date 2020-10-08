%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <float.h>
#include "y.tab.h"
#define MaxCadena 32
#define MaxID 32
#define MaxEntero 32767
FILE  *yyin;
int yylval;
char *yytext;


int show_error(char*);

%}
%option noyywrap  
%option yylineno 


ELSE_T		"else"|"ELSE"
IF_T		"IF"|"if"
WHILE_T		"WHILE"|"while"
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
IGNORA		    ( |\t|\n|\r)
COMENTARIO         ({LETRA}|{DIGITO}|{IGNORA})*
COMENTARIO_P    	({COMENTARIO_A}{COMENTARIO}?{COMENTARIO_C})
COMENTARIO_S    	({COMENTARIO_A}{COMENTARIO}?{COMENTARIO_P}{COMENTARIO}?{COMENTARIO_C})
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



{ID}			{ printf("ID: %s\n", yytext);return ID;}
{ENTERO}	    { printf("ENTERO: %s\n", yytext);return ENTERO;}
{REAL}          { printf("REAL: %s\n", yytext);return REAL;}
{CADENA}        { printf("CADENA: %s\n", yytext);return CADENA;}
{BINARIO}		{ printf("BINARIO: %s\n", yytext);return BINARIO;}
{HEXA}			{ printf("HEXA: %s\n", yytext);return HEXA;}


{IGNORA}       
{COMENTARIO_P}
{COMENTARIO_S}       
.               
%%



