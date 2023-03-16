/************************************************************************************************[1]*/
/*** 1| DECLARATION SECTION ***/
/* C-stuff (headers, declarations, variables, etc.) */
%{

#define YY_NO_UNPUT

#include <stdio.h> 
#include <stdlib.h>
#include <string.h> /* strdup;*/

struct YYLTYPE;
extern int yyparse();
extern int yylex(void);
extern void yyerror(char *s);
extern int yywrap(void){return 1;};

#define TOSTRING(x) #x

int FLG = 0;
void f1(char* s);

void f2(int s);
%}
/****************************************************************************************************/

/************************************************************************************************[2]*/
/*** 2| DEFINITIONS SECTION ***/

%union {
    int int_val;
    char* op_val;
}

%start P_1 /*start from P_1*/

%token <int_val> CLASS 
%token <op_val> VAR
%token <int_val> LBRACE 
%token <int_val> RBRACE 
%token <int_val> COLON 
%token <int_val> SEMICOLON 
%token <int_val> PUBLIC
%token <int_val> PRIVATE
%token <int_val> PROTECTED
%token <op_val> T_VAR 

/* 2.2| regular expressions */

/***************************************************************************************************/

/***********************************************************************************************[3]*/
/*** 3| RULES SECTION **/
%%
	/* 1] <P_1>::= class VAR{<P_2>}; */
P_1	: CLASS VAR { printf("Class name: \033[1;32m%s\033[0m; \n", $2); } LBRACE  { FLG = 1; /*[1]*/} P_2 RBRACE SEMICOLON {  printf("Succsess!\n"); YYACCEPT; }
	;
	
	/* 2] <P_2>::= <M_V>:<P_2> | <T_V> VAR; <P_2> | E */
P_2	: M_V { FLG = 0;} COLON P_2 
	| T_V VAR {  printf("Attribute name: \033[1;31m%s\033[0m;\n", $2); } SEMICOLON P_2 	
	| /* EMPTY */
	;
	
	/* 3] <M_V>::= public | private | protected */
M_V	: PUBLIC 	{ f2($1); }
	| PRIVATE	{ f2($1); }
	| PROTECTED	{ f2($1); }
	; 
	
	/* 4] <T_V>::= int | VAR */
T_V	: T_VAR  { f1($1); printf("Attribute type: \033[1;33m %s\033[0m;\t", $1); }
	; 
%%
/***************************************************************************************************/

/***********************************************************************************************[4]*/
/*** 4| C-SUBPROGRAMMES OF SUPPORT ***/
/* 4.1| C functions (can be main or others) */

int main(void){
	
#ifdef YYDEBUG
	extern int yydebug;
	yydebug = 0; /* bison -d --debug -t bison.y*/
#endif	

	printf("\033[1;31mEnter a sentence: \033[0m");
	
	return yyparse();
}

void f1(char* s){
	if(FLG == 1){
		f2(0); /* default mark; */
		FLG == 0;
	}
}

void f2(int s){
	switch(s){
		case(PUBLIC):
			printf("Sight mark: \033[1;36m %s\033[0m;\t", TOSTRING(PUBLIC));
			break;
		case(PRIVATE):
			printf("Sight mark: \033[1;36m %s\033[0m;\t", TOSTRING(PRIVATE));
			break;
		case(PROTECTED):
			printf("Sight mark: \033[1;36m %s\033[0m;\t", TOSTRING(PROTECTED));
			break;
		default:
			printf("Sight mark: \033[1;36m %s\033[0m;\t", TOSTRING(PRIVATE));
			break;
	}
}

/**************************************************************************************************/

/**********************************************************************************************[5]*/
/*
Bison принимает на вход спецификацию контекстно-свободной грамматики и создаёт функцию на языке c, 
которая распознаёт правильные предложения этой грамматики. т. е. Bison осуществляет синтаксический анализ.

+ Имя входного файла грамматики Bison по соглашению заканчивается на '.y'.
+ секция %{ ... }% содержит код на C, который будет размещён выше остального сгенерированного кода.
+ секция %% ... %% содержит правила грамматики.

! Доп: https://ianfinlayson.net/class/cpsc401/notes/08-bison
! https://ipc.susu.ru/28181-4.html

[1]: Устанавливаем флаг в 1 и если после LBRACE сразу идет T_VAR, то выводим метку видимости по умолчанию и переключаем затем флаг в 0.
*/
/**************************************************************************************************/
