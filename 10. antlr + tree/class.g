header{
#include <string.h>
}

options {
	language="Cpp";
}

class ClassParser extends Parser;
options {
	genHashLines = true;		// include line number information
	buildAST = true;			// uses CommonAST by default
}

/** 
1| Нетерминалы правил парсера должны быть всегда в нижнем регистре! 
2| ! - указывает парсеру, что терминал слева должен быть исключен из синтаксического дерева при построении AST.
3| ^ - указывает парсеру, что терминал слева должен быть взят в качестве корня куста(дерева) при построении AST.

*/

expr returns [std::string r]
{
	r = "";
	std::string b = "";
}   : CLASS^ b = var {r = "Class Name: \033[1;32m" + b + "\033[0m\n";} LBRACE! b = mexpr { r += b; } RBRACE! SEMICOLON
	;

mexpr returns [std::string r]{
	r = "";
	std::string b = "";
}   : b = mvar { r += "Sight mark: \033[1;36m" + b + "\033[0m;\t"; } COLON^ b = mexpr  { r += b + "\n"; }
	| b = tvar { r = "Attribute type: \033[1;33m " + b + "\033[0m;\t"; }  b = var { r += "Attribute name: \033[1;31m" + b + "\033[0m;\n"; } SEMICOLON^ b = mexpr { r += b; }
	| /*EMPTY*/
	;
	
mvar returns [std::string r]{
	r = "";
}   : p_1:PUBLIC 	{ r = p_1->getText(); }
	| p_2:PRIVATE	{ r = p_2->getText(); }
	| p_3:PROTECTED { r = p_3->getText(); }
	;
	
tvar returns [std::string r]{
	r = "";
	std::string b = "";
}   : i:INT { r = i->getText(); }
	| b = var { r = b; }
	;
	
var returns [std::string r]
{
	r = "";
}   : s:VAR { r = s->getText(); }
	;

class ClassLexer extends Lexer;
WS_	:	(' ' | '\t' | '\n' | '\r') { _ttype = ANTLR_USE_NAMESPACE(antlr)Token::SKIP; } 
	;
	
LBRACE:	'{' 
	;

RBRACE:	'}' 
	;

COLON: ':' 
	;
	
SEMICOLON:	';' 
	;
	
protected
IDENTIFIER:	('a'..'z'|'A'..'Z')+
	;
	
VAR:  ("class") => "class"		{ _ttype = CLASS; }
	| ("int") => "int"		{ _ttype = INT; }
	| ("public") => "public" 	{ _ttype = PUBLIC; }
	| ("private") => "private" 	{ _ttype = PRIVATE; }
	| ("protected") => "protected" 	{ _ttype = PROTECTED; }
	| IDENTIFIER
	;

class ClassTreeWalker extends TreeParser;
expr returns [char* r]
{
	r="";
}
	:  { r = "\033[1;32mSuccess!\033[0m"; }
	;
