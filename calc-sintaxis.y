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
  printf("\n\nLista de Variables:\n");
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
    printf("\n%d", root->data);
  if ((char) root->data == '+') {
    printf("\n(");
    printTree(root->hi);
    printf("\n+");
    printTree(root->hd);
    printf("\n)");
  }
  else if ((char) root->data == '*') {
    printf("\n(");
    printTree(root->hi);
    printf("\n*");
    printTree(root->hd);
    printf("\n)");
  }
}

%}
 
%union { int i; char *s; ASTNode *node; }
 
%token<i> _PROGRAM_
%token<i> _BEGIN_
%token<i> _END_
%token<i> _VOID_
%token<i> _IF_
%token<i> _ELSE_
%token<i> _INT_
%token<i> _INTEGER_
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
 
%%

prog: _PROGRAM_ _BEGIN_ vars_block methods_block _END_                                                  {printf("\nEntontre: prog");}
  ;

methods_block: method_decl methods_block
             | type _MAIN_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block                        {printf("\nEntontre: declaracion de main");}
             | type _MAIN_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block                                   {printf("\nEntontre: declaracion de main");}
  ;

method_decl: meth_type _ID_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block                       {printf("\nEntontre: declaracion de metodo");}
           | meth_type _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block
  ;


vars_block: var_decl
          | vars_block _SEMICOLON_ var_decl
  ;

var_decl: type _ID_                                                                                     {printf("\nEntontre: Declaracion de Variable");}
        | var_decl _COMMA_ _ID_
  ;

code_block: _BEGIN_ vars_block statements_block _END_                                                   {printf("\nEntontre: code_block");}
  ;

statements_block: statement                                                                             {printf("\nEntontre: statements_block");}
                | statements_block statement
  ;

statement:  _ID_ _ASSIGNMENT_ expr _SEMICOLON_                                                          {printf("\nEntontre: asignacion en statement");}
          | method_call _SEMICOLON_                                                                     {printf("\nEntontre: llamado_a_metodo en statement");}
          | conditional_statement                                                                       {printf("\nEntontre: conditional en statement");}
          | _WHILE_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ code_block                                     {printf("\nEntontre: while block en statement");}
          | _RETURN_ expr _SEMICOLON_                                                                   {printf("\nEntontre: return_expr_; en statement");}
          | _RETURN_ _SEMICOLON_                                                                        {printf("\nEntontre: return_; en statement");}
          | _SEMICOLON_                                                                                 {printf("\nEntontre: ; en statement");}
          | code_block                                                                                  {printf("\nEntontre: codeblock en statement");}
  ;

conditional_statement: _IF_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ _THEN_ code_block _ELSE_ code_block    {printf("\nEntontre: if-then-else blocok\n");}
                     | _IF_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ _THEN_ code_block                      {printf("\nEntontre: if-then block\n");}
  ;

method_call: _ID_ _L_PARENTHESIS_ params_call _R_PARENTHESIS_                                           {printf("\nEntontre: llamado a metodo\n");}
           | _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_                                                       {printf("\nEntontre: llamado a metodo\n");}
  ;

params_call: expr
           | params_call _COMMA_ expr                                                                   {printf("\nEntontre: parametros de llamada");}
  ;

params_def: type _ID_                                                                                   {printf("\nEntontre: Parametros de definicion");}
          | params_def _COMMA_ _ID_
  ;

meth_type: _VOID_
         | type

type: _INTEGER_                                                                                         {printf("\nEntontre: type_INTEGER");}
    | _BOOL_                                                                                            {printf("\nEntontre: type_BOOL");}
  ;

expr: _ID_                                                                                              {printf("\nEntontre: id_expr");}
    | method_call                                                                                       {printf("\nEntontre: llamado a metodo en expr");}
    | literal                                                                                           {printf("\nEntontre: literal expr");}
    | expr _PLUS_ expr                                                                                  {printf("\nEntontre: expr + expr");}
    | expr _MINUS_ expr                                                                                 {printf("\nEntontre: expr - expr");}
    | expr _MULTIPLY_ expr                                                                              {printf("\nEntontre: expr x expr");}
    | expr _DIVIDE_ expr                                                                                {printf("\nEntontre: expr / expr");}
    | expr _MOD_ expr                                                                                   {printf("\nEntontre: expr \% expr");}
    | expr _LESSER_THAN_ expr                                                                           {printf("\nEntontre: expr < expr");}
    | expr _GREATER_THAN_ expr                                                                          {printf("\nEntontre: expr > expr");}
    | expr _EQUALS_ expr                                                                                {printf("\nEntontre: expr == expr");}
    | expr _AND_ expr                                                                                   {printf("\nEntontre: expr && expr");}
    | expr _OR_ expr                                                                                    {printf("\nEntontre: expr || expr");}
    | _MINUS_ expr                                                                                      {printf("\nEntontre: -expr");}
    | _NOT_ expr                                                                                        {printf("\nEntontre: !expr");}
    | _L_PARENTHESIS_ expr _R_PARENTHESIS_                                                              {printf("\nEntontre: (expr)");}
  ;

literal: integer_literal                                                                                {printf("\nEntontre: literal_integer");}
       | bool_literal                                                                                   {printf("\nEntontre: literal_bool");}
  ;

bool_literal: _TRUE_                                                                                    {printf("\nEntontre: literal_bool true");}
            | _FALSE_                                                                                   {printf("\nEntontre: literal_bool false");}
  ;

integer_literal: _INT_                                                                                  {printf("\nEntontre: un literal_integer");}
  ;
  
%%