%{
#include <stdlib.h> 
#include <stdio.h>
#include "structs.h"

VarNode *var_list_head = (VarNode *) NULL, *var_list_last = (VarNode *) NULL;
FunctionNode *fun_list_head = (FunctionNode *) NULL, *fun_list_last = (FunctionNode *) NULL;
ASTNode *tree_root = (ASTNode *) NULL, *tree_last = (ASTNode *) NULL;


// Adds a variable into the symbol table
void add_var(char *n, int v, bool is_boolean) {
  VarNode *new_node = (VarNode *) malloc (sizeof(VarNode));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  new_node->name = n;
  new_node->value = v;
  new_node->is_boolean = is_boolean;
  new_node->next = NULL;
  if (var_list_head == NULL) {
    var_list_head = new_node;
    var_list_last = new_node;
  }
  else {
    var_list_last->next = new_node;
    var_list_last = new_node;
  }
}

// Prints the list of variables
void list_vars() {
  VarNode *aux = var_list_head;
  int i = 0;
  printf("\n\nLista de Variables:\n");
  while (aux!=NULL) {
    if (aux->is_boolean) {
      printf( "name: %s, value: %s", aux->name, aux->value ? "true" : "false"); //Cero = false; !Cero = true
    }
    else {
      printf( "name: %s, value: %d", aux->name, aux->value);
    }

    aux = aux->next;
    i++;
  }
  if (i == 0)
    printf( "\nLa lista está vacía!!\n" );
}

// Adds a variable into the symbol table
void add_function(char *name, ReturnType type, VarNode *enviroment_head) {
  FunctionNode *new_node = (FunctionNode *) malloc (sizeof(FunctionNode));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  new_node->id = name;
  new_node->type = type;
  new_node->enviroment = enviroment_head;
  new_node->next = NULL;
  if (fun_list_head==NULL) {
    fun_list_head = new_node;
    fun_list_last = new_node;
  }
  else {
    fun_list_last->next = new_node;
    fun_list_last = new_node;
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
%token<i> _ID_
%token<i> _EXTERN_

%start prog

%nonassoc _ASSIGNMENT_
%left _AND_ _OR_
%nonassoc _EQUALS_ _GREATER_THAN_ _LESSER_THAN_
%left _PLUS_ _MINUS_
%left _MULTIPLY_ _DIVIDE_ _MOD_
%right NEG

%%

prog: _PROGRAM_ _BEGIN_ prog_body _END_                                                   {printf("\nEncontre: prog");}
  ;

prog_body: vars_block methods_block main_decl
         | methods_block main_decl
         | main_decl
  ;

vars_block: type id_list _SEMICOLON_
          | vars_block type id_list _SEMICOLON_
  ;

id_list: _ID_
        | id_list _COMMA_ _ID_                                                                               {printf("\nEncontre: Declaracion de Variable");}
  ;

methods_block: method_decl
             | methods_block method_decl
  ;

method_decl: type _ID_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block                         {printf("\nEncontre: declaracion de un metodo");}
           | type _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block                                    {printf("\nEncontre: declaracion de un metodo");}
           | _VOID_ _ID_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block                {printf("\nEncontre: declaracion de un metodo");}
           | _VOID_ _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block                           {printf("\nEncontre: declaracion de un metodo");}
           | type _ID_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ _EXTERN_
           | type _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block _EXTERN_
           | _VOID_ _ID_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ _EXTERN_
           | _VOID_ _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_ _EXTERN_
  ;

main_decl: type _MAIN_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block                         {printf("\nEncontre: declaracion de main");}
         | type _MAIN_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block                                    {printf("\nEncontre: declaracion de main");}
         | _VOID_ _MAIN_ _L_PARENTHESIS_ params_def _R_PARENTHESIS_ code_block                {printf("\nEncontre: declaracion de main");}
         | _VOID_ _MAIN_ _L_PARENTHESIS_ _R_PARENTHESIS_ code_block                           {printf("\nEncontre: declaracion de main");}
 ;

code_block: _BEGIN_ code_block_body _END_                                                    {printf("\nEncontre: code_block");}
  ;

code_block_body: vars_block statements_block
               | statements_block
               | 
  ;

statements_block: statement                                                                              {printf("\nEncontre: statements_block");}
                | statements_block statement
  ;

statement:  _ID_ _ASSIGNMENT_ expr _SEMICOLON_                                                           {printf("\nEncontre: asignacion en statement");}
          | method_call _SEMICOLON_                                                                      {printf("\nEncontre: llamado_a_metodo en statement");}
          | conditional_statement                                                                        {printf("\nEncontre: conditional en statement");}
          | _WHILE_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ code_block                                      {printf("\nEncontre: while block en statement");}
          | _RETURN_ expr _SEMICOLON_                                                                    {printf("\nEncontre: return_expr_; en statement");}
          | _RETURN_ _SEMICOLON_                                                                         {printf("\nEncontre: return_; en statement");}
          | _SEMICOLON_                                                                                  {printf("\nEncontre: ; en statement");}
          | code_block                                                                                   {printf("\nEncontre: codeblock en statement");}
  ;

conditional_statement: _IF_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ _THEN_ code_block                       {printf("\nEncontre: if-then block\n");}
                     | _IF_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ _THEN_ code_block _ELSE_ code_block     {printf("\nEncontre: if-then-else block\n");}
  ;

method_call: _ID_ _L_PARENTHESIS_ params_call _R_PARENTHESIS_                                            {printf("\nEncontre: llamado a metodo\n");}
           | _ID_ _L_PARENTHESIS_ _R_PARENTHESIS_                                                        {printf("\nEncontre: llamado a metodo\n");}
  ;

params_call: expr
           | params_call _COMMA_ expr                                                                    {printf("\nEncontre: parametros de llamada");}
  ;

params_def: type _ID_                                                                                    {printf("\nEncontre: Parametros de definicion");}
          | params_def _COMMA_ type _ID_
  ;

type: _INTEGER_                                                                                          {printf("\nEncontre: type_INTEGER");}
    | _BOOL_                                                                                             {printf("\nEncontre: type_BOOL");}
  ;

expr: _ID_                                                                                               {printf("\nEncontre: id_expr");}
    | method_call                                                                                        {printf("\nEncontre: llamado a metodo en expr");}
    | literal                                                                                            {printf("\nEncontre: literal expr");}
    | expr _PLUS_ expr                                                                                   {printf("\nEncontre: expr + expr");}
    | expr _MINUS_ expr                                                                                  {printf("\nEncontre: expr - expr");}
    | expr _MULTIPLY_ expr                                                                               {printf("\nEncontre: expr x expr");}
    | expr _DIVIDE_ expr                                                                                 {printf("\nEncontre: expr / expr");}
    | expr _MOD_ expr                                                                                    {printf("\nEncontre: expr MOD expr");}
    | expr _LESSER_THAN_ expr                                                                            {printf("\nEncontre: expr < expr");}
    | expr _GREATER_THAN_ expr                                                                           {printf("\nEncontre: expr > expr");}
    | expr _EQUALS_ expr                                                                                 {printf("\nEncontre: expr == expr");}
    | expr _AND_ expr                                                                                    {printf("\nEncontre: expr && expr");}
    | expr _OR_ expr                                                                                     {printf("\nEncontre: expr || expr");}
    | _MINUS_ expr %prec NEG                                                                           {printf("\nEncontre: -expr");}
    | _NOT_ expr %prec NEG                                                                                    {printf("\nEncontre: !expr");}
    | _L_PARENTHESIS_ expr _R_PARENTHESIS_                                                               {printf("\nEncontre: (expr)");}
  ;

literal: integer_literal                                                                                 {printf("\nEncontre: literal_integer");}
       | bool_literal                                                                                    {printf("\nEncontre: literal_bool");}
  ;

bool_literal: _TRUE_                                                                                     {printf("\nEncontre: literal_bool true");}
            | _FALSE_                                                                                    {printf("\nEncontre: literal_bool false");}
  ;

integer_literal: _INT_                                                                                   {printf("\nEncontre: un literal_integer");}
  ;

%%
