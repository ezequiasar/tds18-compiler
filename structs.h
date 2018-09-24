#include <stdbool.h>

typedef struct var_struct {
  char *name;
  int value;
  struct var_struct *next;
}VarNode;

typedef struct expression_struct {
  int data;
  bool es_operador;
  struct expression_struct *hi;
  struct expression_struct *hd;
}ASTNode;
