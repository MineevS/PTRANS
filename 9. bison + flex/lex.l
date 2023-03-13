
/** DECLARATION SECTION **/
/* C-stuff (headers, declarations, variables, etc.) */
%{
/*#define YY_NO_UNPUT*/

#include <stdio.h>
#include "bison.tab.h"

#ifndef YYSTYPE
/* #define YYSTYPE char* */
#endif



extern int yylex(void);
/*int yylex();*/
extern int yyerror(char* s);
enum yytokentype yyval;
/*enum yytokentype yylval;*/
enum yytokentype pre_yyval;

int yylineno;         /* tentative definition */
int yylineno = 1;     /* definition */

extern char *strdup( const char *src );

int TVAR();
int PVAR();
int SEMICOLONVAL();
int RBRACEVAL();

/*enum TOKEN{
	LBRACE = 1,
	RBRACE,
	COLON ,
	SEMICOLON,
	CLASS,
	M_VAR,
	T_VAR,
	VAR,
	EMPTY
};*/


%}
%option outfile="lexer.c"
/*%defines*/
%option noyywrap


/** DEFINITIONS SECTION **/
/* definition */
public		"public"
private		"private"
protected	"protected"
var		([a-zA-Z])+

/* regular expressions */


/** RULES SECTION **/
%%
[ \r\n\t]		{/*Пропустить значки тобуляции, пропуски, пробелы.*/}
"class"			{yyval = CLASS; return CLASS;}
"{"				{pre_yyval = yyval; yyval = LBRACE; return LBRACE;}
"}"				{pre_yyval = yyval; return RBRACEVAL();}
":"				{pre_yyval = yyval; yyval = COLON; return COLON;}
";"				{pre_yyval = yyval; yyval = SEMICOLON; return SEMICOLON;}
{public}		{pre_yyval = yyval; yyval = PUBLIC; yylval.int_val = yyval; return M_VAR;}
{private}		{pre_yyval = yyval; yyval = PRIVATE; yylval.int_val = yyval; return M_VAR;}
{protected}		{pre_yyval = yyval; yyval = PROTECTED; yylval.int_val = yyval; return M_VAR;}
{var}			{return (yyval == COLON || yyval == SEMICOLON || yyval == LBRACE ? TVAR() : PVAR());}
.				{yyerror("Error: EMPTY\n");}
%%


/** C-SUBPROGRAMMES OF SUPPORT **/
/* C functions (can be main or others) */

/*int yylex(){

	return yyval;
}*/

int RBRACEVAL(){
	if(pre_yyval == EMPTY){
		yyval = RBRACE;	
		/*printf("%s\n", "+RBRACE");*/
		return RBRACE;
	}else{
		yyval = EMPTY; 
		/*printf("%s\n", "+EMPTY");*/
		unput('}'); /* Возвращаем символ в поток!;*/
		/*ngetc('}', yyin);*/
		return ' ';
	}
}

int TVAR(){
	pre_yyval = yyval;
	yylval.op_val = strdup(yytext);	
	/*printf("TV: %s\n", yytext);*/
	/*printf("%s\n", "+T_VAR");*/
	return yyval = T_VAR;
}

/*
int SEMICOLONVAL(){
	if(pre_yyval != RBRACE){
		return SEMICOLON;
	}else{
		return EOF;
	}
}*/

int PVAR(){
	pre_yyval = yyval;
	yylval.op_val = strdup(yytext);
	/*printf("%s\n", "+VAR");*/
	return yyval = VAR;
}

int yyerror(char* msg){
	printf("%s\n", msg);
	exit(1);
}

/*int yywrap(){return(1);}*/
