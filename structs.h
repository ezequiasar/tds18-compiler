#include <stdbool.h>

// return types
typedef enum return_types {
	boolean,
  integer,
  vid
} ReturnType;

typedef enum type_of_node {
	_if,
  _if_body,
  _while,
  _arith_op,
  _boolean_op,
  _assign,
  _return,
  _method_call,
  _none
} TypeNode;

// Struct that holds variables data
typedef struct var_struct {
  char *id;
  int value;
  bool is_boolean;
  bool is_defined;
  struct var_struct *next;
} VarNode;

// Struct that holds parameter information
typedef struct parameter_struct {
  char *id;
  int value; // is this really needed?
  bool is_boolean;
  struct parameter_struct *next;
} Parameter;

struct functions_struct;
struct ast_node_struct;

// Function Node: Represents a function of the program
typedef struct functions_struct {
  char *id;
  ReturnType type;
  Parameter *parameters;
  VarNode *enviroment;
  struct ast_node_struct *body;
  struct functions_struct *next;
}FunctionNode;

// Node of the AST
typedef struct ast_node_struct {
  int data;
  bool is_boolean;
  TypeNode node_type;
  VarNode *var_data;
  struct functions_struct *function_data;
  struct ast_node_struct *next_statement;
  struct ast_node_struct *left_child;
  struct ast_node_struct *right_child;
}ASTNode;

// Envitoment list, it holds all the head pointers of the diferent enviroment levels.
typedef struct enviroment_stack {
	VarNode *variables;
	struct enviroment_stack *next;
} EnviromentNode;