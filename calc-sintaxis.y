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
 
%token<i> PROGRAM
%token<i> FUNCTION
%token<i> BEGIN
%token<i> END
%token<i> VOID
%token<i> IF
%token<i> ELSE
%token<i> INT
%token<i> BOOL
%token<i> RETURN
%token<i> MAIN
%token<i> PRINT
%token<s> ID
%token<s> VAR

%start prog

%type<node> expr
%type<node> def
 
%right '='
%left '+' 
%left '*'
 
%%

prog: PROGRAM BEGIN vars_block methods_block END  
  ;

vars_block: var_decl vars_block
          |
  ;

var_decl: return_type ID another_var_decl SEMICOLON
  ;

another_var_decl: COMMA ID another_var_decl
                |
  ;

methods_block: method_decl methods_block
             | return_type MAIN L_PARENTHESIS params_def R_PARENTHESIS code_block
  ;

method_decl: return_type ID L_PARENTHESIS params_def R_PARENTHESIS code_block
  ;

code_block: BEGIN vars_block statements_block END
  ;

statements_block: statement statements_block
                | 
  ;

statement:  ID = expr SEMICOLON
          | method_call SEMICOLON
          | conditional_statement
          | WHILE L_PARENTHESIS expr R_PARENTHESIS code_block
          | RETURN expr SEMICOLON
          | RETURN SEMICOLON
          | SEMICOLON
          | code_block
  ;

method_call: ID L_PARENTHESIS params_call R_PARENTHESIS
  ;

params_call: expr COMMA params_call
           | expr
           |
  ;

params_def: type ID COMMA params_def
          | type ID
          | 
  ;

type: INT
    | BOOL
  ;

expr: ID
    | method_call
    | literal
    | expr PLUS expr
    | expr MINUS expr
    | expr MULTIPLY expr
    | expr DIVIDE expr
    | expr MOD expr
    | expr LESS_THAN expr
    | expr GREATER_THAN expr
    | expr EQUALS expr
    | expr AND expr
    | expr OR expr
    | MINUS expr
    | NOT expr
    | L_PARENTHESIS expr R_PARENTHESIS
  ;
%%