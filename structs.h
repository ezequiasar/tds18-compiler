#include <stdbool.h>

// return types of functions
typedef enum return_types {
	_boolean,
  _integer,
  _void
} ReturnType;

// possible types of ASTNodes
typedef enum type_of_node {
	_if,
  _if_body,
  _while,
  _arith_op,
  _boolean_op,
  _assign,
  _return,
  _method_call,
  _id,
  _literal
} TypeNode;

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
} FunctionNode;

// Node of the AST
typedef struct ast_node_struct {
  int data;
  bool is_boolean;
  TypeNode node_type;
  int line_num;
  int col_num;
  VarNode *var_data;
  struct functions_struct *function_data;
  struct ast_node_struct *next_statement;
  struct ast_node_struct *left_child;
  struct ast_node_struct *right_child;
} ASTNode;

// Envitoment list, it holds all the head pointers of the diferent enviroment levels.
typedef struct enviroment_stack {
	VarNode *variables;
	struct enviroment_stack *next;
} EnviromentNode;