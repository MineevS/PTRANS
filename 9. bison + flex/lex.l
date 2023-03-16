
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
extern int yyerror(char* s);
enum yytokentype yyval;

int yylineno;         /* tentative definition */
int yylineno = 1;     /* definition */

extern char *strdup( const char *src );

%}
%option outfile="lexer.c"
%option noyywrap


/** DEFINITIONS SECTION **/
/* definition */


/* regular expressions */
var		([a-zA-Z])+


/** RULES SECTION **/
%%
[ \r\n\t]		{/*Пропустить значки тобуляции, пропуски, пробелы.*/}
"class"			{yyval = CLASS; 				return CLASS;}
"{"			{yyval = LBRACE; 				return LBRACE;}
"}"			{yyval = RBRACE; 				return RBRACE;}
":"			{yyval = COLON; 				return COLON;}
";"			{yyval = SEMICOLON; 				return SEMICOLON;}
"public"		{yyval = PUBLIC;  	yylval.int_val = yyval; return PUBLIC;}
"private"		{yyval = PRIVATE; 	yylval.int_val = yyval; return PRIVATE;}
"protected"		{yyval = PROTECTED; yylval.int_val = yyval; return PROTECTED;}
{var}			{yyval = ( yyval == COLON || yyval == SEMICOLON || yyval == LBRACE ? T_VAR : VAR ); 
							yylval.op_val = strdup(yytext); return yyval;}
.				{yyerror("Error: EMPTY\n");}
%%


/** C-SUBPROGRAMMES OF SUPPORT **/
/* C functions (can be main or others) */

int yyerror(char* msg){
	printf("%s\n", msg);
	exit(-1);
}

/*int yywrap(){return(1);}*/
