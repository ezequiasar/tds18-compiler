#include <stdbool.h>

typedef enum posible_types {
	boolean, integer, voidd
}FunType;

typedef struct var_struct {
  char *name;
  int value;
  bool is_boolean;
  struct var_struct *next;
}VarNode;

typedef struct ambient_list {
	VarNode *ambient_vars;
	struct ambient_list *next;
}AmbientNode;

typedef struct functions_struct {
  char *name;
  FunType type;
  VarNode *function_ambient;
  struct var_struct *next;
}FunctionNode;

typedef struct ast_node_struct {
  int data;
  bool is_operador;
  bool is_if_cond;
  bool is_while_cond;
  VarNode *var_data;
  struct ast_node_struct *brother_node;
  struct ast_node_struct *son_node;
}ASTNode;