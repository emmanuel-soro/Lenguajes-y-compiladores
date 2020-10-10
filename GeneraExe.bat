c:\GnuWin32\bin\flex Lexico_CR.l

c:\GnuWin32\bin\bison -dyv Sintactico.y

c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c -o Compilador.exe

Compilador.exe Prueba2.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del Compilador.exe

