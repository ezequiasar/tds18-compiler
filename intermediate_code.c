#include <stdio.h>
#include <structs.h>

#define IF 'i'
#define IF_COND 'i' + 'c'
#define IF_THEN 'i' + 't'
#define IF_ELSE 'i' + 'e'
#define WHILE 'w'
#define WHILE_COND 'w' + 'c'
//////////////////////////////////////////
#define PLUS '+'
#define MUNUS '-'
#define PROD '*'
#define DIV '/'
#define MOD '%'
/////////////////////////////////////////
#define ASSIGN '='
#define EQUALS '=' + '='
/////////////////////////////////////////
#define GRATER_THAN '>'
#define LESSER_THAN '<'
/////////////////////////////////////////
#define AND '&' + '&'
#define OR '|' + '|'

CodeNode * head, *last;

/*
	Recorre el cuerpo de una funcion y crea las instrucciones en codigo intermedio
**/
void generate_intermediate_code(ASTNode * root) {

}

void generate_fun_name_code(char * id) {

}

void generate_fun_name_end(char * id) {

}
/*
	Funcion que recorre la lista de funciones y para cada una:
		1) Crea el bloque de inicio de buncion INIT_FUN_<ID>
		2) Crea codigo intermedio del cuerpo de la funcion
		3) Cierra el bloque de funcion END_FUN_<ID>
**/
CodeNode * generate_fun_code(FunctionNode * root) {
	generate_fun_name_code(root -> id);
	generate_intermediate_code(root -> body);
	generate_fun_name_end(root -> id);

	return NULL;
}

int main(int argc, char const *argv[])
{
	/* code */
	return 0;
}