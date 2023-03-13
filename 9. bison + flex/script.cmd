
rm bison.tab.c bison.tab.h
bison -d -t bison.y

rm lexer.c
flex lex.l

rm PRO.exe
gcc -g3 -O0 -ansi lexer.c bison.tab.c -o PRO.exe
