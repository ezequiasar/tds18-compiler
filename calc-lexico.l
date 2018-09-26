%{
#include <stdlib.h>
#include <stdio.h>
#include "structs.h"
#include "calc-sintaxis.tab.h"
%}

%option noyywrap
%option yylineno

letter [a-zA-z]
digit [0-9]
id {letter}({letter}|{digit})*

%%

var
	return VAR;

program
	return PROGRAM;

function
	return FUNCTION;

begin
	return BEGIN;

end
	return END;

void
	return VOID;

if
	return IF;

else
	return ELSE;

int
	return INT;

return
	return RETURN;

main
	return MAIN;

bool
	return BOOL;

print
	return PRINT;

true
	return TRUE;

false 
	return FALSE;



{digit}+ { 
	yylval.i = atoi(yytext);
	return INT;
}

{id} { 
	yylval.s=(char *) malloc(sizeof(yytext)*yyleng);
	strcpy(yylval.s,yytext);
	return ID;
}

[+*;()=] return *yytext;

.|\n ;

%%

void yyerror() {
	printf("%s%d\n","-> ERROR Sintactico en la linea: ",yylineno);
}

int main(int argc,char *argv[]) {
	++argv,--argc;
	if (argc > 0)
		yyin = fopen(argv[0],"r");
	else
		yyin = stdin;
	yyparse();
}
