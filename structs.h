#include <stdbool.h>

// return types
typedef enum return_types {
	boolean, 
  integer, 
  vid
} ReturnType;

// Struct that holds variables data
typedef struct var_struct {
  char *id;
  int value;
  bool is_boolean;
  struct var_struct *next;
} VarNode;

// Struct that holds parameter information
typedef struct parameter_struct {
  char *id;
  bool is_boolean;
  struct parameter_struct *next;
} Parameter;

// Node of the AST
typedef struct ast_node_struct {
  int data;
  bool is_boolean;
  bool is_if;
  bool is_while;
  VarNode *var_data;
  struct ast_node_struct *left_child;
  struct ast_node_struct *right_child;
}ASTNode;

// Function Node: Represents a function of the program
typedef struct functions_struct {
  char *id;
  ReturnType type;
  Parameter *parameters;
  VarNode *enviroment;
  ASTNode *body;
  struct functions_struct *next;
}FunctionNode;

// Envitoment list, it holds all the head pointers of the diferent enviroment levels.
typedef struct enviroment_stack {
	VarNode *variables;
	struct enviroment_stack *next;
} EnviromentNode;

