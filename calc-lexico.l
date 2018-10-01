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

program {
	return _PROGRAM_;
}
begin {
	return _BEGIN_;
}
end {
	return _END_;
}
void {
	return _VOID_;
}
if {
	return _IF_;
}
else {
	return _ELSE_;
}
then {
	return _THEN_;
}
integer {
	return _INTEGER_;
}
return {
	return _RETURN_;
}
main {
	return _MAIN_;
}
bool {
	return _BOOL_;
}
print {
	return _PRINT_;
}
true {
	return _TRUE_;
}
false {
	return _FALSE_;
}
while {
	return _WHILE_;
}
= {
	return _ASSIGNMENT_;
}
; {
	return _SEMICOLON_;
}
, {
	return _COMMA_;
}
\( {
	return _L_PARENTHESIS_;
}
\) {
	return _R_PARENTHESIS_;
}
\+ {
	return _PLUS_;
}
- {
	return _MINUS_;
}
\* {
	return _MULTIPLY_;
}
\/ {
	return _DIVIDE_;
}
% {
	return _MOD_;
}
> {
	return _GREATER_THAN_;
}
\< {
	return _LESSER_THAN_;
}
== {
	return _EQUALS_;
}
&& {
	return _AND_;
}
\|\| {
	return _OR_;
}
! {
	return _NOT_;
}

{digit}+      { 
	            yylval.i = atoi(yytext);
	            return _INT_;
              }

{id}          { 
	            	yylval.s=(char *) malloc(sizeof(yytext)*yyleng);
	            strcpy(yylval.s,yytext);
	            return _ID_;
              }

(\n)+                         {}

[ \t]                         {}

"//".*\n                      {}
"{"[.|\b|\n]*"}"			  {} 

.                             { error("Unrecognized input");
                                yyterminate();};

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
