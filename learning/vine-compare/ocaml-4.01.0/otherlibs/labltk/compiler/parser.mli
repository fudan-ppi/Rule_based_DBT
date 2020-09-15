type token =
  | IDENT of (string)
  | STRING of (string)
  | EOF
  | LPAREN
  | RPAREN
  | COMMA
  | SEMICOLON
  | COLON
  | QUESTION
  | LBRACKET
  | RBRACKET
  | LBRACE
  | RBRACE
  | SLASH
  | TYINT
  | TYFLOAT
  | TYBOOL
  | TYCHAR
  | TYSTRING
  | LIST
  | AS
  | VARIANT
  | WIDGET
  | OPTION
  | TYPE
  | SEQUENCE
  | SUBTYPE
  | FUNCTION
  | MODULE
  | EXTERNAL
  | UNSAFE

val entry :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> unit
