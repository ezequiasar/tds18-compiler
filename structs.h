#include <stdbool.h>

typedef struct var_struct {
  char *name;
  int value;
  struct var_struct *next;
}VarNode;

typedef struct ast_node_struct {
  int data;
  bool es_operador;
  struct ast_node_struct *hi;
  struct ast_node_struct *hd;
}ASTNode;
