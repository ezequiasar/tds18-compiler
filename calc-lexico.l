%{
#include <stdlib.h>
#include <stdio.h>
#include "structs.h"
#include "calc-sintaxis.tab.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_RESET   "\x1b[0m"
%}

%option noyywrap
%option yylineno

letter [a-zA-z]
digit [0-9]
id {letter}({letter}|{digit})*

START "{"
END "}"
SIMPLE [^}]
COMPLEX [{|\n]

%%

program {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _PROGRAM_;
}
begin {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _BEGIN_;
}
end {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _END_;
}
void {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _VOID_;
}
if {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _IF_;
}
else {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _ELSE_;
}
then {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _THEN_;
}
integer {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _INTEGER_;
}
return {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _RETURN_;
}
main {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _MAIN_;
}
bool {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _BOOL_;
}
print {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _PRINT_;
}
true {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _TRUE_;
}
false {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _FALSE_;
}
while {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _WHILE_;
}
= {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _ASSIGNMENT_;
}
; {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _SEMICOLON_;
}
, {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _COMMA_;
}
\( {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _L_PARENTHESIS_;
}
\) {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _R_PARENTHESIS_;
}
\+ {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _PLUS_;
}
- {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _MINUS_;
}
\* {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _MULTIPLY_;
}
\/ {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _DIVIDE_;
}
% {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _MOD_;
}
> {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _GREATER_THAN_;
}
\< {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _LESSER_THAN_;
}
== {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _EQUALS_;
}
&& {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _AND_;
}
\|\| {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _OR_;
}
! {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _NOT_;
}
extern {
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	return _EXTERN_;
}

{digit}+ { 
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	yylval.i = atoi(yytext);
	return _INT_;
}

{id} { 
	yylloc.first_line = yylineno;
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
	yylval.s=(char *) malloc(sizeof(yytext)*yyleng);
	strcpy(yylval.s,yytext);
	return _ID_;
}

(\n)+ {
	yylloc.first_column = 1;
	yylloc.last_column = 1;
}

[ \t] {
	yylloc.first_column = yylloc.last_column;
	yylloc.last_column += yyleng;
}

"//".*\n  {
	yylloc.first_column = 1;
	yylloc.last_column = 1;
}

{START}({SIMPLE}|{COMPLEX})*{END}

. { 
	printf(ANSI_COLOR_RED "error!\n" ANSI_COLOR_RESET, yylineno);
	printf("\t" ANSI_COLOR_RED "'%s'" ANSI_COLOR_RESET " is not a valid / recognized input\n", yytext);
	yyterminate();
}

%%

void yyerror(const char *str) {
	fprintf(stderr,"Error | Line: %d\n%s\n",yylineno, str);
}

int main(int argc,char *argv[]) {
	++argv,--argc;
	if (argc > 0)
		yyin = fopen(argv[0],"r");
	else
		yyin = stdin;
	yyparse();
}
