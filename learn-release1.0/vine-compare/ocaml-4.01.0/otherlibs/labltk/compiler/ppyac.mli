type token =
  | IFDEF of (string)
  | IFNDEF of (string)
  | ELSE
  | ENDIF
  | DEFINE of (string)
  | UNDEF of (string)
  | OTHER of (string)
  | EOF

val code_list :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Code.code list
