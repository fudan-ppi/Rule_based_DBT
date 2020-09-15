%{
open Ast
%}
                                                                                          
%token <int> INT
%token <string> ID
%token LPAREN
%token RPAREN
%token LSHIFT
%token NOT
%token OR
%token ADD
%token SUB
%token EOF
%left OR
%left ADD SUB
%left LSHIFT
%nonassoc NEG NOT
%start main
%type <Ast.expr> main
%%
main:
  | expr EOF { $1 }
  ;

expr:
  | INT                 { Ast.Int($1)         }
  | ID                  { Ast.Var($1)         }
  | NOT expr            { Ast.Not($2)         }
  | SUB expr %prec NEG  { Ast.Neg($2)         }
  | expr LSHIFT expr    { Ast.Lshift($1, $3)  }
  | expr OR expr        { Ast.Or($1, $3)      }
  | expr ADD expr       { Ast.Add($1, $3)     }
  | expr SUB expr       { Ast.Sub($1, $3)     }
  | LPAREN expr RPAREN  { $2                  }
  ;
