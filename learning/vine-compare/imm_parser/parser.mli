type token =
  | INT of (int)
  | ID of (string)
  | LPAREN
  | RPAREN
  | LSHIFT
  | NOT
  | OR
  | ADD
  | SUB
  | EOF

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
