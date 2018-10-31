#include <stdio.h>
#include <stdlib.h>
#include "structs.h"

#define BEGIN_FUN 'b' + 'f'
#define END_FUN 'e' + 'f'
/////////////////////////////////////////
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

VarNode * create_temporal(char * id) {
  VarNode * new_node = malloc(sizeof(VarNode));
  new_node -> id = id;
  new_node -> next = NULL;
  return new_node;
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

/*
	Recorre el cuerpo de una funcion y crea las instrucciones en codigo intermedio
*/
InstructionNode * generate_intermediate_code(ASTNode * root) {
	if (root != NULL) {
    add_instruction(create_instruction_from_ASTNode(root));
    InstructionNode * root_ins = last;
    /****
      *
      * Si es un nodo de llamada a una funcion, entonces
      *   op1 debe ser un nodo que guarda el nombre de la funcion a llamar
      *   op2 debe ser una lista de los parametros actuales de la llamada
      *   LOS PARAMETROS ESTAN GUARDADOS COMO UNA LISTA AST EN EL ARBOL.- Ver ast_from_parameters_list en calc-sintaxis.y
      *
    */
    if (root_ins -> operation != METH_CALL) {
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
    }
    else {
      ASTNode * ast_aux = root;
      VarNode * varnode_aux;
      VarNode * op1 = create_temporal(root -> function_data -> id);
      root_ins -> op1 = op1;
      VarNode * op2 = NULL;
      while (ast_aux != NULL) {
        if (op2 == NULL) {
          op2 = ast_aux -> var_data;
          varnode_aux = op2;
        }
        else {
          varnode_aux -> next = ast_aux -> var_data;
          varnode_aux = varnode_aux -> next;
        }
        ast_aux = ast_aux -> right_child;
      }
    }
    return last;
  }
  return NULL;
}

InstructionNode * generate_fun_name_code(char * id) {
  InstructionNode * init_fun_ins = malloc(sizeof(InstructionNode));
  VarNode * fun_temp_varnode = create_temporal(id);
  init_fun_ins -> operation = BEGIN_FUN;
  init_fun_ins -> op1 = fun_temp_varnode;
  init_fun_ins -> op2 = NULL;
  init_fun_ins -> result = NULL;
  init_fun_ins -> back = NULL;
  init_fun_ins -> next = NULL;
  return init_fun_ins;

}

InstructionNode * generate_fun_name_end(VarNode * fun_temp_varnode) {
  InstructionNode * end_fun_ins = malloc(sizeof(InstructionNode));
  end_fun_ins -> operation = END_FUN;
  end_fun_ins -> op1 = fun_temp_varnode;
  end_fun_ins -> op2 = NULL;
  end_fun_ins -> result = NULL;
  end_fun_ins -> back = NULL;
  end_fun_ins -> next = NULL;
  return end_fun_ins;
}
/*
	Funcion que recorre la lista de funciones y para cada una:
		1) Crea el bloque de inicio de buncion INIT_FUN_<ID>
		2) Crea codigo intermedio del cuerpo de la funcion
		3) Cierra el bloque de funcion END_FUN_<ID>
**/
InstructionNode * generate_fun_code(FunctionNode * root) {
  FunctionNode * current_fun = root;
  while (current_fun != NULL) {
    InstructionNode * init_fun_ins = generate_fun_name_code(current_fun -> id);
    InstructionNode * end_fun_ins = generate_fun_name_end(init_fun_ins -> op1);
    add_instruction(init_fun_ins);
    generate_intermediate_code(current_fun -> body);
    add_instruction(end_fun_ins);
    current_fun = current_fun -> next;
  }
	return head;
}

void print_instruction(InstructionNode * i) {
  if (i -> op1 != NULL)
    printf("op1: %s\n", i -> op1);
  if (i -> op2 != NULL)
    printf("op2: %s\n", i -> op2);
  if (i -> result != NULL)
    printf("result: %s\n", i -> result);
}

void print_instructions() {
  InstructionNode * aux = head;
  int i = 0;
  while (aux != NULL) {
    printf("Instruction %d\n", i);
    print_instruction(aux);
    printf("----------------\n\n");
    aux = aux -> next;
  }
}