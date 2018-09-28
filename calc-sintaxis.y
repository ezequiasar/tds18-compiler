%{
#include <stdlib.h>
#include <stdio.h>
#include "structs.h"
 
VarNode *head = (VarNode *) NULL, *last = (VarNode *) NULL;
ASTNode *expr_root = (ASTNode *) NULL, *expr_last = (ASTNode *) NULL;

// Adds a variable into the symbol table  
void add_var(char *n, int v) {
  VarNode *new_node = (VarNode *) malloc (sizeof(VarNode));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  new_node->name = n;
  new_node->value = v;
  new_node->next = NULL;
  if (head==NULL) {
    head = new_node;
    last = new_node;
  }
  else {
    last->next = new_node;
    last = new_node;
  }
}

// Prints the list of variables
void list_vars() {
  VarNode *aux = head;
  int i = 0;
  printf("\nLista de Variables:\n");
  while (aux!=NULL) {
    printf( "name: %s, value: %d\n",
      aux->name,aux->value);
    aux = aux->next;
    i++;
  }
  if (i == 0)
    printf( "\nLa lista está vacía!!\n" );
}

// Searchs for a variable, if it exist it returns the node, cc  it returns null
VarNode *find_var(char *var_name) {
  VarNode *aux = head;
  while (aux != NULL) {
    if (strcmp(aux->name, var_name) == 0) {
      return aux;
    }
    aux = aux -> next;
  }
  return aux;
}

// Adds a new leave into the AST
ASTNode *add_leave(int v) {
  ASTNode *new_node = (ASTNode *) malloc (sizeof(ASTNode));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  new_node->data = v;
  new_node->es_operador = false;
  new_node->hi = NULL;
  new_node->hd = NULL;
  return new_node;
}

// Adds a new leave into the AST
ASTNode *add_node(ASTNode *hi, char op, ASTNode *hd) {
  ASTNode *new_node = (ASTNode *) malloc (sizeof(ASTNode));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  new_node->data = op;
  new_node->es_operador = true;
  new_node->hi = hi;
  new_node->hd = hd;
  return new_node;
}

// Evaluates an expression
int eval(ASTNode *root) {
  if (root->hi == NULL && root->hd == NULL) 
    return root->data;
  if ((char) root->data == '+')
    return eval(root->hi) + eval(root->hd);
  else if ((char) root->data == '*')
    return eval(root->hi) * eval(root->hd);
}

// Prints the AST
void printTree(ASTNode *root) {
  if (root->hi == NULL && root->hd == NULL)
    printf("%d", root->data);
  if ((char) root->data == '+') {
    printf("(");
    printTree(root->hi);
    printf("+");
    printTree(root->hd);
    printf(")");
  }
  else if ((char) root->data == '*') {
    printf("(");
    printTree(root->hi);
    printf("*");
    printTree(root->hd);
    printf(")");
  }
}

%}
 
%union { int i; char *s; ASTNode *node; }
 
%token<i> _PROGRAM_
%token<i> _FUNCTION_
%token<i> _BEGIN_
%token<i> _END_
%token<i> _VOID_
%token<i> _IF_
%token<i> _ELSE_
%token<i> _INT_
%token<i> _BOOL_
%token<i> _RETURN_
%token<i> _MAIN_
%token<i> _PRINT_
%token<i> _THEN_
%token<i> _SEMICOLON_
%token<i> _COMMA_
%token<i> _L_PARENTHESIS_
%token<i> _R_PARENTHESIS_
%token<i> _PLUS_
%token<i> _MINUS_
%token<i> _MULTIPLY_
%token<i> _DIVIDE_
%token<i> _MOD_
%token<i> _GREATER_THAN_
%token<i> _LESSER_THAN_
%token<i> _EQUALS_
%token<i> _AND_
%token<i> _OR_
%token<i> _NOT_
%token<i> _ASSIGNMENT_
%token<i> _WHILE_
%token<i> _TRUE_
%token<i> _FALSE_
%token<s> _ID_

%start prog


%right '='
%left '+' 
%left '*'
 
%%

prog: _PROGRAM_ _BEGIN_ vars_block methods_block _END_ 
  ;

vars_block: var_decl vars_block
          |
  ;

var_decl: type _ID_ another_var_decl _SEMICOLON_
  ;

another_var_decl: _COMMA_ _ID_ another_var_decl
                |
  ;

methods_block: method_decl methods_block
             | type _MAIN_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block
  ;

method_decl: type _ID_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block
  ;

code_block: _BEGIN_ vars_block statements_block _END_
  ;

statements_block: statement statements_block
                | 
  ;

statement:  _ID_ _ASSIGNMENT_ expr _SEMICOLON_
          | method_call _SEMICOLON_
          | conditional_statement
          | _WHILE_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ code_block
          | _RETURN_ expr _SEMICOLON_
          | _RETURN_ _SEMICOLON_
          | _SEMICOLON_
          | code_block
  ;

conditional_statement: _IF_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ _THEN_ code_block
                     | _IF_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ _THEN_ code_block _ELSE_ code_block
  ;

method_call: _ID_ _L_PARENTHESIS_ params_call _R_PARENTHESIS_
  ;

params_call: expr _COMMA_ params_call
           | expr
           |
  ;

params_def: type _ID_ _COMMA_ params_def
          | type _ID_
          | 
  ;

type: _INT_
    | _BOOL_
  ;

expr: _ID_
    | method_call
    | literal
    | expr _PLUS_ expr
    | expr _MINUS_ expr
    | expr _MULTIPLY_ expr
    | expr _DIVIDE_ expr
    | expr _MOD_ expr
    | expr _LESSER_THAN_ expr
    | expr _GREATER_THAN_ expr
    | expr _EQUALS_ expr
    | expr _AND_ expr
    | expr _OR_ expr
    | _MINUS_ expr
    | _NOT_ expr
    | _L_PARENTHESIS_ expr _R_PARENTHESIS_
  ;

literal: integer_literal
       | bool_literal
  ;

bool_literal: _TRUE_
            | _FALSE_
  ;

integer_literal: _INT_
  ;
  
%%