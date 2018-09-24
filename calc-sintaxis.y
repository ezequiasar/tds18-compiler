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
 
%token<i> INT
%token<s> ID
%token<s> VAR

%start prog

%type<node> expr
%type<node> def
 
%right '='
%left '+' 
%left '*'
 
%%

prog: def ';' prog
    | expr ';'          {
                          printf("\n%s %d\n", "Resultado de la expresion:", eval($1));
                        }
    ;
    
expr: INT               {
                          $$ = $1;
                          $$ = add_leave($1);
                        }
    | ID                {
                          char *var_name = $1;
                          VarNode *searchResult = find_var(var_name);
                          if (searchResult != NULL) {
                            $$ = add_leave(searchResult->value);
                          }
                          else {
                            yyerror();
                            return -1;
                          }
                        }
    | expr '+' expr     {
                          $$ = add_node($1, '+', $3);
                        }
    | expr '*' expr     {
                          $$ = add_node($1, '*', $3);
                        }
    | '(' expr ')'      {
                          $$ =  $2;
                        }
    ;

def: VAR ID '=' expr    {
                          add_var($2, eval($4));
                        }
    ;
    
%%