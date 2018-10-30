#include <stdio.h>
#include <structs.h>

#define IF 'i'
#define IF_BODY 'i' + 'b'
#define IF_COND 'i' + 'c'
#define IF_THEN 'i' + 't'
#define IF_ELSE 'i' + 'e'
#define WHILE 'w'
#define WHILE_COND 'w' + 'c'
#define WHILE_BODY 'w' + 'b'
//////////////////////////////////////////
#define PLUS '+'
#define MINUS '-'
#define PROD '*'
#define DIV '/'
#define MOD '%'
/////////////////////////////////////////
#define ASSIGN '='
#define EQUALS 'e'
/////////////////////////////////////////
#define GRATER_THAN '>'
#define LESSER_THAN '<'
/////////////////////////////////////////
#define AND '&'
#define OR '|'
#define NOT '!'
/////////////////////////////////////////
#define RETURN 'r'
#define METH_CALL 'm' + 'c'

InstructionNode * head, *last;

void add_instruction(InstructionNode * node) {
  if (head != NULL && last != NULL) {
    last -> next = node;
    node -> back = last;
    last = node;
  }
  else {
    head = node;
    last = node;
  }
}

/*
	Recorre el cuerpo de una funcion y crea las instrucciones en codigo intermedio
*/
InstructionNode * generate_intermediate_code(ASTNode * root) {
	if (root != NULL) {
    add_instruction(create_instruction_from_ASTNode(root));
    InstructionNode * root_ins = last;
    InstructionNode * left_ins = generate_intermediate_code(root -> left_child);
    InstructionNode * right_ins = generate_intermediate_code(root -> right_child);

    switch(root_ins -> operation) {
      case IF:
        left_ins -> operation = IF_COND;
        break;
      case IF_BODY:
        left_ins -> operation = IF_THEN;
        if (right_ins != NULL)
          right_ins -> operation = IF_ELSE;
        break;
      case WHILE:
        left_ins -> operation = WHILE_COND;
        right_ins -> operation = WHILE_BODY;
        break;
    }

    if (left_ins != NULL)
      root_ins -> op1 = left_ins -> result;
    if (right_ins != NULL)
      root_ins -> op2 = right_ins -> result;
    return last;
  }
  return NULL;
}

/*
	Recorre el cuerpo de una funcion y crea las instrucciones en codigo intermedio
*/
InstructionNode * create_instruction_from_ASTNode(ASTNode * root) {
  InstructionNode * new_node = malloc(sizeof(InstructionNode));
  // in every case we need to set the new_node -> operation field.
  switch (root -> node_type) {
    case _if:
      new_node -> operation = IF;
      break;
    case _if_body:
      new_node -> operation = IF_BODY;
      break;
    case _while:
      new_node -> operation = WHILE;
      break;
    case _arith_op:
      if (root -> data == '+')
        new_node -> operation = PLUS;
      else if (root -> data == '-')
        new_node -> operation = MINUS;
      else if (root -> data == '*')
        new_node -> operation = PROD;
      else if (root -> data == '/')
        new_node -> operation = DIV;
      else //root -> data == '%'
        new_node -> operation = MOD;
      break;
    case _boolean_op:
      if (root -> data == '>')
        new_node -> operation = GRATER_THAN;
      else if (root -> data == '<')
        new_node -> operation = LESSER_THAN;
      else if (root -> data == 'e')
        new_node -> operation = EQUALS;
      else if (root -> data == '&')
        new_node -> operation = AND;
      else if (root -> data == '|')
        new_node -> operation = OR;
      else //root -> data == '!'
        new_node -> operation = NOT;
      break;
    case _assign:
      new_node -> operation = ASSIGN;
      break;
    case _method_call:
      new_node -> operation = METH_CALL;
      break;
    case _return:
      new_node -> operation = RETURN;
      break;
    default:
      new_node -> operation = -1;
      break;
  }
  new_node -> result = create_temporal("aca va el nombre del temporal");
  new_node -> back = NULL;
  new_node -> next = NULL;
  return new_node;
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