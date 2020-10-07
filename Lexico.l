%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <float.h>
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

COM_A       \*\-
COM_C       \-\*
IGNORA		( |\t|\n|\r)
COM         ({LETRA}|{DIGITO}|{IGNORA})*
COM_P    	{COM_A}{COM}?{COM_C}
COM_S    	{COM_A}{COM}?{COM_P}{COM}?{COM_C}


REAL     	({DIGITO}*"."{DIGITO}+)|({DIGITO}+"."{DIGITO}*)
ENTERO      {DIGITO}+
CADENA      \"(\\.|[^\"])*\"
ID			{LETRA}({LETRA}|{DIGITO}|_)*


%%

","         printf(" %s\n", yytext);
";"         printf(" %s\n", yytext);
"["         printf(" %s\n", yytext);
"]"         printf(" %s\n", yytext);

":="		printf(" %s\n", yytext);
"+"			printf(" %s\n", yytext);
"-"			printf(" %s\n", yytext);
"*"			printf(" %s\n", yytext);
"/"			printf(" %s\n", yytext);

"("			printf(" %s\n", yytext);
")"			printf(" %s\n", yytext);
"{"         printf(" %s\n", yytext);
"}"         printf(" %s\n", yytext);


{WHILE_T}     { printf("Palabra Reservada: %s\n", yytext);}
{IF_T}        { printf("Palabra Reservada: %s\n", yytext);}
{DIM_T}    { printf("Palabra Reservada: %s\n", yytext);}
{AS_T}    { printf("Palabra Reservada: %s\n", yytext);}
{PUT_T}   { printf("Palabra Reservada: %s\n", yytext);}
{GET_T}       { printf("Palabra Reservada: %s\n", yytext);}
{INTEGER_T}       { printf("Palabra Reservada: %s\n", yytext);}
{STRING_T}    { printf("Palabra Reservada: %s\n", yytext);}
{FLOAT_T}     { printf("Palabra Reservada: %s\n", yytext);}
{ELSE_T}     { printf("Palabra Reservada: %s\n", yytext);}
{CONTAR_T}     { printf("Palabra Reservada: %s\n", yytext);}


">"         printf(" %s\n", yytext);
"<"         printf(" %s\n", yytext);
">="        printf(" %s\n", yytext);
"<="        printf(" %s\n", yytext);
"=="        printf(" %s\n", yytext);
"<>"        printf(" %s\n", yytext);
{OR_T}      printf(" %s\n", yytext);
{AND_T}     printf(" %s\n", yytext);
{NOT_T}     printf(" %s\n", yytext);



{ID}			{ printf("ID: %s\n", yytext);}

{ENTERO}	     { printf("ENTERO: %s\n", yytext);}

{REAL}          { printf("REAL: %s\n", yytext);}

{CADENA}        { printf("CADENA: %s\n", yytext);}

{BINARIO}		{ printf("BINARIO: %s\n", yytext);}

{HEXA}			{ printf("HEXA: %s\n", yytext);}


{IGNORA}        
{COM_P}	    { printf("COM_P: %s\n", yytext);}
{COM_S}	    { printf("COM_S: %s\n", yytext);}
.               
%%

int main(int argc, char *argv[]){
	if((yyin = fopen(argv[1], "rt")) == NULL){
		printf("\nNo se pudo abrir el archivo: %s\n", argv[1]);
	}else{
		yylex();
	}
	fclose(yyin);
	return 0;
}

int show_error(char* mensaje) {
	printf("\nError lexico en linea %d: %s\n", yylineno, mensaje);
	system("Pause");
	exit(1);
}


