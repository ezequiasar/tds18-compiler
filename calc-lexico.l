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

"program"     {return PROGRAM; }
"function"    {return FUNCTION; }
"begin"       {return BEGIN; }
"end"         {return END; }
"void"        {return VOID; }
"if"          {return IF; }
"else"        {return ELSE; }
"then"        {return THEN; }
"int"         {return INT; }
"return"      {return RETURN; }
"main"        {return MAIN; }
"bool"        {return BOOL; }
"print"       {return PRINT; }
"true"        {return TRUE; }
"false"       {return FALSE; }
"while"       {return WHILE; }
"="           {return ASSIGNMENT; }
";"           {return SEMICOLON; }
","           {return COMMA; }
"("           {return L_PARENTHESIS; }
")"           {return R_PARENTHESIS; }
"+"           {return PLUS; }
"-"           {return MINUS; }
"*"           {return MULTIPLY; }
"/"           {return DIVIDE; }
"%"           {return MOD; }
">"           {return GREATER_THAN; }
"<"           {return LESSER_THAN; }
"=="          {return EQUALS; }
"&&"          {return AND; }
"||"          {return OR; }
"!"           {return NOT; }

{digit}+      { 
	            yylval.i = atoi(yytext);
	            return INT;
              }

{id}          { 
	            yylval.s=(char *) malloc(sizeof(yytext)*yyleng);
	            strcpy(yylval.s,yytext);
	            return ID;
              }

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
