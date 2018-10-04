#include <stdbool.h>

typedef enum return_types {
	boolean, 
  integer, 
  vid
} ReturnType;

typedef enum posible_types {
	bln, 
  intgr
} Type;

typedef struct var_struct {
  char *name;
  int value;
  bool is_boolean;
  struct var_struct *next;
}VarNode;

typedef struct parameter_struct {
  char *id;
  Type type;
  struct parameter_struct *next;
} Parameter;

typedef struct functions_struct {
  char *id;
  ReturnType type;
  Parameter parameters;
  VarNode *enviroment;
  struct functions_struct *next;
}FunctionNode;

typedef struct ast_node_struct {
  int token;
  bool is_operador;
  bool is_if_cond;
  bool is_while_cond;
  VarNode *var_data;
  struct ast_node_struct *left_child;
  struct ast_node_struct *right_child;
}ASTNode;

typedef struct enviroment_stack {
	VarNode *variables;
	struct enviroment_stack *next;
} EnviromentNode;

