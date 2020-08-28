type token =
  | AMPER
  | AMPERAMPER
  | BANG
  | BANGEQUAL
  | BAR
  | BARBAR
  | BOOLEAN
  | BYTE
  | CARET
  | CASE
  | CHAR
  | CHARACTER of (char)
  | COLON
  | COMMA
  | CONST
  | CPP_QUOTE
  | DEFAULT
  | DOT
  | DOUBLE
  | ENUM
  | EOF
  | EQUAL
  | EQUALEQUAL
  | FALSE
  | FLOAT
  | GREATER
  | GREATEREQUAL
  | GREATERGREATER
  | GREATERGREATERGREATER
  | HANDLE_T
  | HYPER
  | IDENT of (string)
  | IMPORT
  | INT
  | INT64
  | INTERFACE
  | INTEGER of (int64)
  | LBRACE
  | LBRACKET
  | LESS
  | LESSEQUAL
  | LESSLESS
  | LONG
  | LPAREN
  | MINUS
  | NULL
  | PERCENT
  | PLUS
  | QUESTIONMARK
  | QUOTE
  | RBRACE
  | RBRACKET
  | RPAREN
  | SEMI
  | SHORT
  | SIGNED
  | SIZEOF
  | SLASH
  | SMALL
  | STAR
  | STRING of (string)
  | STRUCT
  | SWITCH
  | TILDE
  | TRUE
  | TYPEDEF
  | TYPEIDENT of (string)
  | UNION
  | UNSIGNED
  | UUID of (string)
  | VOID
  | WCHAR_T

val file :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> File.components
