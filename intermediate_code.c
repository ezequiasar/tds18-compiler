#include <stdio.h>
#include <stdlib.h>
#include "structs.h"

#define BEGIN_FUN 'b' + 'f'
#define END_FUN 'e' + 'd'
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
#define GREATER_THAN '>'
#define LESSER_THAN '<'
/////////////////////////////////////////
#define AND '&'
#define OR '|'
#define NOT '!'
/////////////////////////////////////////
#define RETURN 'r'
#define METH_CALL 'm' + 'c'

#define TEMP 't'

InstructionNode * head, *last;
int temp_quantity = 0;

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
  Creates a new instruction.
*/
InstructionNode * create_instructionNode(int operation, VarNode * result) {
  InstructionNode * new_node = malloc(sizeof(InstructionNode));
  new_node -> operation = operation;
  new_node -> op1 = NULL;
  new_node -> op2 = NULL;
  new_node -> result = result;
  new_node -> next= NULL;
  new_node -> back= NULL;
  return new_node;
}

VarNode * create_temporal() {
  char temp_name[128];
  sprintf(temp_name, "temp%d\0", temp_quantity);
  char * res = malloc(strlen(temp_name));
  sprintf(res, temp_name);
  //printf("%s\n", res);
  VarNode * new_node = malloc(sizeof(VarNode));
  new_node -> id = res;
  new_node -> is_defined = false;
  new_node -> next = NULL;
  temp_quantity++;
  return new_node;
}

VarNode * create_temporal_with_value(int value, bool is_boolean) {
  char temp_name[128];
  sprintf(temp_name, "temp%d\0", temp_quantity);
  char * res = malloc(strlen(temp_name));
  sprintf(res, temp_name);
  //printf("%s\n", res);
  VarNode * new_node = malloc(sizeof(VarNode));
  new_node -> id = res;
  new_node -> value = value;
  new_node -> is_boolean = is_boolean;
  new_node -> is_defined = true;
  new_node -> next = NULL;
  temp_quantity++;
  return new_node;
}


/*
  Returns the operation of an ASTNode.
*/
int get_operation(ASTNode * node) {
  switch (node -> node_type) {
    case _if: return IF;
    case _if_body: return IF_BODY;
    case _while: return WHILE;
    case _arith_op: return node -> data;
    case _boolean_op: return node -> data;
    case _assign: return ASSIGN;
    case _method_call: return METH_CALL;
    case _return: return RETURN;
    case _id: return TEMP;
    case _literal: return TEMP;
    default: printf("gran cagada entra por el default \n");;
  }
}

/*
  Recorre el cuerpo de una funcion y crea las instrucciones en codigo intermedio
*/
InstructionNode * create_instruction_from_ASTNode(ASTNode * root) {
  return create_instructionNode(get_operation(root), NULL);
}

ASTNode * get_next_statement(ASTNode * statement) {
  return statement -> next_statement;
}

/*
  Creates and returns a new VarNode.
*/
VarNode * create_varn(char * id) {
  VarNode * new_node = malloc(sizeof(VarNode));
  new_node -> id = id;
  new_node -> is_defined = false;
  new_node -> next = NULL;
  return new_node;
}

InstructionNode * create_temporal_instruction(VarNode * var_data) {
  if (var_data -> is_defined) {
    InstructionNode * new_ins = create_instructionNode(TEMP, var_data);
    new_ins -> op1 = create_varn(var_data -> id);
  }
  else {
    return create_instructionNode(TEMP, var_data);
  }
}

InstructionNode * create_statement_instructions(ASTNode * root) {
  if (root != NULL) {
    InstructionNode * new_ins = create_instruction_from_ASTNode(root);
    switch (root -> node_type) {
      case _if: break;
      case _if_body: break;
      case _while: break;
      case _arith_op:
        //printf("encuentra un operador aritmetico \n");
        new_ins -> op1 = create_statement_instructions(root -> left_child) -> result;
        new_ins -> op2 = create_statement_instructions(root -> right_child) -> result;
        new_ins -> result = create_temporal();
        add_instruction(create_temporal_instruction(new_ins -> result));
        add_instruction(new_ins);
        return new_ins;
      case _boolean_op:
        //printf("encuentra un operador booleano  \n");
        new_ins -> op1 = create_statement_instructions(root -> left_child) -> result;
        new_ins -> op2 = create_statement_instructions(root -> right_child) -> result;
        new_ins -> result = create_temporal();
        add_instruction(create_temporal_instruction(new_ins -> result));
        add_instruction(new_ins);
        return new_ins;
      case _assign:
        //printf("encuentra un assign \n");
        new_ins -> op1 = create_statement_instructions(root -> left_child) -> result;
        new_ins -> op2 = create_statement_instructions(root -> right_child) -> result;
        //new_ins -> result = create_temporal();
        new_ins -> result = NULL;
        //add_instruction(create_temporal_instruction(new_ins -> result));
        add_instruction(new_ins);
        return new_ins;
      case _method_call:
      case _return:
      case _id:
        return create_temporal_instruction(root -> var_data);
      case _literal:
        //printf("encuentra un literal \n");
        new_ins = create_temporal_instruction(create_temporal_with_value(root -> data, root -> is_boolean));
        add_instruction(new_ins);
        return new_ins;
      default: 
        printf("ERORRRRRRRRR");
        return NULL;
    }
  }
  return NULL;
}

void generate_intermediate_code(ASTNode * root) {
  ASTNode * aux = root;
  while (aux != NULL) {
    create_statement_instructions(aux);
    aux = get_next_statement(aux);
  }
}

char * get_operation_string(InstructionNode * i) {
  switch (i -> operation) {
    case PLUS:   return "PLUS";
    case PROD:   return "PROD";
    case MOD:    return "MOD";
    case DIV:    return "DIV";
    case MINUS:  return "MINUS";
    case EQUALS: return "EQUL";
    case OR:     return "OR";
    case AND:    return "AND";
    case GREATER_THAN: return "GREATER";
    case LESSER_THAN:  return "LESSER";
  }
}

char * get_temporal_string(VarNode * temp) {
  if (temp -> is_defined) {
    if (temp -> is_boolean) {
      if (temp -> value == 0)
        return "false";
      else
        return "true";
    }
    else {
      int i = temp -> value;
      char str[8];
      sprintf(str, "%d", i);
      char * ret = str;
      return ret;
    }
  }
  return temp -> id;
}

void print_instruction(InstructionNode * i) {
  switch (i -> operation) {
    case TEMP:
      if (i -> op1 == NULL)
        printf("TEMP     %s\n",i -> result -> id);
      else 
        printf("TEMP     %s  %s\n",i -> op1 -> id, get_temporal_string(i -> result));
      break;
    case PLUS: case PROD: case DIV: case MOD: case EQUALS: case OR: case AND: case GREATER_THAN: case LESSER_THAN:
      printf("%s     %s  %s  %s\n", get_operation_string(i), i -> op1 -> id, i -> op2 -> id, i -> result -> id);
      break;
    case ASSIGN: 
      printf("ASSIGN   %s  %s\n", i -> op1 -> id, i -> op2 -> id);
      break;
  }
}

void print_instructions() {
  InstructionNode * aux = head;
  while (aux != NULL) {
    print_instruction(aux);
    aux = aux -> next;
  }
}

void generate_fun_code(FunctionNode * head) {
  FunctionNode * aux = head;
  while (aux != NULL) {
    printf("\n\n\n =================  CODIGO INTERMEDIO DE: %s  ================= \n\n\n", aux -> id);
    generate_intermediate_code(aux -> body);
    print_instructions();
    aux = aux -> next;
    printf("\n\n\n");
  }
}