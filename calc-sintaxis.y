%{
#include <stdlib.h> 
#include <stdio.h>
#include "structs.h"

EnviromentNode *symbol_table = (EnviromentNode *) NULL;    // stack that contains all the enviroments
FunctionNode *fun_list_head = (FunctionNode *) NULL;

void * add_var_to_table(char * varname, int value, bool is_boolean) {
  EnviromentNode * enviromentAuxNode = symbol_table;
  VarNode * varAuxNode;
  
  VarNode * new_var = (VarNode *) malloc(sizeof(VarNode));
  if (new_var == NULL)
    printf( "No hay memoria disponible!\n");

  //Load Var Info.
  new_var -> id = varname;
  new_var -> value = value;
  new_var -> is_boolean = is_boolean;
  new_var -> next = NULL;

  //Moving enviromentAuxNode to top of stack.-
  while (enviromentAuxNode -> next != NULL) {
    enviromentAuxNode = enviromentAuxNode -> next;
  }
  if (enviromentAuxNode -> variables == NULL) {
    enviromentAuxNode -> variables = new_var;
  }
  else {
    varAuxNode = enviromentAuxNode -> variables;

    //Moving to last_var position
    while (varAuxNode -> next != NULL) {
      varAuxNode = varAuxNode -> next;
    }
    varAuxNode -> next = new_var;
  }
}

void create_new_enviroment_level() {
  EnviromentNode * enviromentAuxNode = symbol_table;
  //Creating new level
  EnviromentNode * newLevel = (EnviromentNode *) malloc(sizeof(EnviromentNode));
  //Moving to last allocated level
  while (enviromentAuxNode -> next != NULL) {
    enviromentAuxNode = enviromentAuxNode -> next;
  }
  //Appending new level
  enviromentAuxNode -> next = newLevel;
}

VarNode * find_symbol_in_table(VarNode * head, char * varname) {
  VarNode * varAuxNode = head;
  VarNode * result;

  while (varAuxNode != NULL) {
    if (varAuxNode -> id == varname) {
      result = varAuxNode;
      return result;
    }
    else {
      varAuxNode = varAuxNode -> next;
    }
  }

  return result;
}

VarNode * find_symbol_in_stack(char * varname) {
  //Podemos hacer la lista doblemente encadenada y es mas eficiente la busqueda.

  EnviromentNode * enviromentAuxNode = symbol_table;
  EnviromentNode * lastLevelChecked;

  //Moving to last level.
  while (enviromentAuxNode -> next != NULL) {
    enviromentAuxNode = enviromentAuxNode -> next;
  }

  //Saving last checked level.
  lastLevelChecked = enviromentAuxNode;

  //Find varname in current level.
  VarNode * result = find_symbol_in_table(enviromentAuxNode -> variables, varname);

  //If not found -> find in previous level.
  while (result == NULL || lastLevelChecked == symbol_table) {
    //reseting aux node.
    enviromentAuxNode = symbol_table;
    //Moving to last not checked level.
    while (enviromentAuxNode -> next != lastLevelChecked) {
      enviromentAuxNode = enviromentAuxNode -> next;
    }
    
    //Saving last checked level.
    lastLevelChecked = enviromentAuxNode;

    //Find varname in current level.
    result = find_symbol_in_table(enviromentAuxNode -> variables, varname);
  }

  return result;
}

ASTNode * create_AST_leave_from_VarNode(VarNode * var_data) {
  ASTNode * new_leave = (ASTNode *) malloc(sizeof(ASTNode));
  new_leave -> data = var_data -> value;
  new_leave -> is_boolean = var_data -> is_boolean;
  new_leave -> is_if = false;
  new_leave -> is_while = false;
  new_leave -> var_data = var_data;
  new_leave -> left_child = NULL;
  new_leave -> right_child = NULL;
  return new_leave;
}

ASTNode * create_AST_leave_from_value(int value, bool is_boolean) {
  ASTNode * new_leave = (ASTNode *) malloc(sizeof(ASTNode));
  new_leave -> data = value;
  new_leave -> is_boolean = is_boolean;
  new_leave -> is_if = false;
  new_leave -> is_while = false;
  new_leave -> var_data = NULL;
  new_leave -> left_child = NULL;
  new_leave -> right_child = NULL;
}

ASTNode * create_AST_node(ASTNode * left_child, char op, ASTNode * right_child) {
  ASTNode * new_node = (ASTNode *) malloc(sizeof(ASTNode));
  new_node -> data = op;
  new_node -> is_boolean = false;
  if (op == 'i')
    new_node -> is_if = true;
  else
    new_node -> is_if = false;
  if (op == 'w')
    new_node -> is_while = true;
  else
    new_node -> is_while = false;
  new_node -> var_data = NULL;
  new_node -> left_child = left_child;
  new_node -> right_child = right_child;
  return new_node;
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


%type<node> method_call //method_call es tipo ASTNode porque forma parte del arbol.
%type<node> code_block //code_block es tipo ASTNode porque forma parte del arbol.
%type<node> code_block_body //code_block_body es tipo ASTNode porque forma parte del arbol.
%type<node> statements_block //statements_block es tipo ASTNode porque forma parte del arbol.
%type<node> statement //statement es tipo ASTNode porque forma parte del arbol.
%type<node> conditional_statement //conditional_statement es tipo ASTNode porque forma parte del arbol.
%type<node> expr //expr es tipo ASTNode porque forma parte del arbol.
%type<node> literal //literal es tipo ASTNode porque forma parte del arbol.
%type<node> integer_literal //integer_literal es tipo ASTNode porque forma parte del arbol.
%type<node> bool_literal //bool_literal es tipo ASTNode porque forma parte del arbol.
%type<i> type //type es tipo integer para el chequeo de tipos.

%%

prog: _PROGRAM_ _BEGIN_ prog_body _END_                                                   {printf("\nEncontre: prog");}
  ;

prog_body: vars_block methods_block main_decl
         | methods_block main_decl
         | main_decl
  ;

vars_block: type id_list _SEMICOLON_
    {
      
    }
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

code_block: _BEGIN_ code_block_body _END_
              {
                printf("\nEncontre: code_block");
                $$ = $2;
              }
  ;

code_block_body: vars_block statements_block
                  {
                    $$ = $2;
                  }
               | statements_block
                  {
                    $$ = $1;
                  }
               |  {
                    $$ = NULL;
                  }
  ;

statements_block: statement
                    {
                      printf("\nEncontre: statements_block");
                      $$ = $1;
                    }
                | statements_block statement
  ;

statement:  _ID_ _ASSIGNMENT_ expr _SEMICOLON_
              {
                printf("\nEncontre: asignacion en statement");
                $$ = create_AST_node($1, '=', $3);
              }
          | method_call _SEMICOLON_ 
              {
                printf("\nEncontre: llamado_a_metodo en statement");
                $$ = $1;
              }
          | conditional_statement                                                                        
              {
                printf("\nEncontre: conditional en statement");
                $$ = $1;
              }
          | _WHILE_ _L_PARENTHESIS_ expr _R_PARENTHESIS_ code_block                                      
              {
                printf("\nEncontre: while block en statement");
                //Lo dejo a criterio de mis compañeros porque es obvio (?) jajajaj
              }
          | _RETURN_ expr _SEMICOLON_                                                                    
              {
                printf("\nEncontre: return_expr_; en statement");
                //Lo dejo a criterio de mis compañeros porque es obvio (?) jajajaj
              }
          | _RETURN_ _SEMICOLON_                                                                         
              {
                printf("\nEncontre: return_; en statement");
                //Lo dejo a criterio de mis compañeros porque es obvio (?) jajajaj
              }
          | _SEMICOLON_                                                                                  
              {
                printf("\nEncontre: ; en statement");
                //Lo dejo a criterio de mis compañeros porque es obvio (?) jajajaj
              }
          | code_block                                                                                   
              {
                printf("\nEncontre: codeblock en statement");
                $$ = $1;
              }
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

type: _INTEGER_
    {
      printf("\nEncontre: type_INTEGER");
      $$ = 1;  
    }
  | _BOOL_
    {
      printf("\nEncontre: type_BOOL");
      $$ = 0;
    }
  ;

expr: _ID_ 
    {
      printf("\nEncontre: id_expr");
      char * var_name = $1;
      VarNode * var_data = get_var_data(var_name);
      if (var_data != NULL) {
        $$ = create_AST_leave_from_VarNode(var_data);
      }
      else {
        yyerror();
        return -1;
      }
    }
  | literal 
    {
      $$ = $1;
    }
  | method_call
    {
      printf("\nEncontre: llamado a metodo en expr");
      $$ = $1;
    }
  | expr _PLUS_ expr
    {
      printf("\nEncontre: expr + expr");
      $$ = create_AST_node($1, '+', $3);
    }
  | expr _MINUS_ expr         
    {
      printf("\nEncontre: expr - expr");
      $$ = create_AST_node($1, '-', $3);
    }
  | expr _MULTIPLY_ expr      
    {
      printf("\nEncontre: expr x expr");
      $$ = create_AST_node($1, '*', $3);
    }
  | expr _DIVIDE_ expr        
    {
      printf("\nEncontre: expr / expr");
      $$ = create_AST_node($1, '/', $3);
    }
  | expr _MOD_ expr           
    {
      printf("\nEncontre: expr MOD expr");
    $$ = create_AST_node($1, '%', $3);
    }
  | expr _LESSER_THAN_ expr   
    {
      printf("\nEncontre: expr < expr");
      $$ = create_AST_node($1, '<', $3);
    }
  | expr _GREATER_THAN_ expr  
    {
      printf("\nEncontre: expr > expr");
      $$ = create_AST_node($1, '>', $3);
    }
  | expr _EQUALS_ expr        
    {
      printf("\nEncontre: expr == expr");
      $$ = create_AST_node($1, 'e', $3);
    }
  | expr _AND_ expr           
    {
      printf("\nEncontre: expr && expr");
      $$ = create_AST_node($1, '&', $3);
    }
  | expr _OR_ expr            
    {
      printf("\nEncontre: expr || expr");
      $$ = create_AST_node($1, '|', $3);
    }
  | _MINUS_ expr %prec NEG
    {
      printf("\nEncontre: -expr");
      $$ = create_AST_node(NULL, '-', $2);
    }
  | _NOT_ expr %prec NEG
    {
      printf("\nEncontre: !expr");
      $$ = create_AST_node(NULL, '!', $2);
    }
  | _L_PARENTHESIS_ expr _R_PARENTHESIS_
    {
      printf("\nEncontre: (expr)");
      $$ = $1;
    }
;

literal: integer_literal
    {
      printf("\nEncontre: literal_integer");
      $$ = $1;
    }
  | bool_literal
    {
      printf("\nEncontre: literal_bool");
      $$ = $1;
    }
;

bool_literal: _TRUE_
    {
      printf("\nEncontre: un literal_bool TRUE");
      $$ = create_AST_leave_from_value(1, true);
    }
  | _FALSE_
    {
      printf("\nEncontre: un literal_bool FALSE");
      $$ = create_AST_leave_from_value(0, true);
    }
;

integer_literal: _INT_                                                                                   
    {
      printf("\nEncontre: un literal_integer");
      $$ = create_AST_leave_from_value($1, false);
    }
;

%%
