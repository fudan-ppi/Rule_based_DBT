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

open Parsing;;
let _ = parse_error;;
# 20 "parser.mly"

open Tables

# 41 "parser.ml"
let yytransl_const = [|
    0 (* EOF *);
  259 (* LPAREN *);
  260 (* RPAREN *);
  261 (* COMMA *);
  262 (* SEMICOLON *);
  263 (* COLON *);
  264 (* QUESTION *);
  265 (* LBRACKET *);
  266 (* RBRACKET *);
  267 (* LBRACE *);
  268 (* RBRACE *);
  269 (* SLASH *);
  270 (* TYINT *);
  271 (* TYFLOAT *);
  272 (* TYBOOL *);
  273 (* TYCHAR *);
  274 (* TYSTRING *);
  275 (* LIST *);
  276 (* AS *);
  277 (* VARIANT *);
  278 (* WIDGET *);
  279 (* OPTION *);
  280 (* TYPE *);
  281 (* SEQUENCE *);
  282 (* SUBTYPE *);
  283 (* FUNCTION *);
  284 (* MODULE *);
  285 (* EXTERNAL *);
  286 (* UNSAFE *);
    0|]

let yytransl_block = [|
  257 (* IDENT *);
  258 (* STRING *);
    0|]

let yylhs = "\255\255\
\002\000\002\000\003\000\003\000\003\000\003\000\003\000\003\000\
\004\000\004\000\005\000\005\000\005\000\005\000\005\000\005\000\
\007\000\007\000\008\000\008\000\006\000\006\000\009\000\009\000\
\010\000\010\000\010\000\011\000\011\000\012\000\012\000\013\000\
\013\000\013\000\013\000\013\000\013\000\013\000\013\000\013\000\
\014\000\014\000\017\000\017\000\015\000\016\000\018\000\018\000\
\019\000\019\000\020\000\020\000\021\000\021\000\022\000\022\000\
\023\000\024\000\025\000\025\000\025\000\026\000\026\000\026\000\
\026\000\027\000\027\000\027\000\028\000\028\000\001\000\001\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\000\000"

let yylen = "\002\000\
\001\000\001\000\001\000\001\000\001\000\001\000\001\000\001\000\
\003\000\001\000\001\000\004\000\004\000\004\000\003\000\003\000\
\001\000\002\000\001\000\003\000\003\000\001\000\003\000\001\000\
\002\000\003\000\003\000\001\000\002\000\001\000\001\000\001\000\
\001\000\003\000\007\000\007\000\006\000\006\000\003\000\001\000\
\003\000\001\000\003\000\001\000\005\000\003\000\002\000\005\000\
\001\000\001\000\002\000\001\000\002\000\001\000\000\000\001\000\
\005\000\004\000\003\000\006\000\002\000\000\000\002\000\002\000\
\002\000\000\000\002\000\002\000\000\000\001\000\006\000\007\000\
\004\000\009\000\009\000\001\000\005\000\005\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\079\000\000\000\000\000\000\000\000\000\000\000\
\056\000\080\000\000\000\076\000\000\000\000\000\070\000\000\000\
\000\000\000\000\000\000\000\000\000\000\001\000\002\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\073\000\000\000\000\000\
\000\000\000\000\000\000\000\000\025\000\000\000\003\000\004\000\
\005\000\006\000\007\000\000\000\000\000\000\000\000\000\011\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\063\000\065\000\064\000\077\000\000\000\000\000\000\000\000\000\
\000\000\067\000\068\000\078\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\026\000\018\000\000\000\027\000\
\000\000\057\000\000\000\000\000\059\000\000\000\000\000\047\000\
\051\000\071\000\000\000\000\000\000\000\016\000\000\000\000\000\
\000\000\000\000\008\000\009\000\015\000\000\000\023\000\000\000\
\032\000\000\000\000\000\000\000\000\000\033\000\000\000\040\000\
\000\000\072\000\000\000\058\000\000\000\000\000\000\000\021\000\
\013\000\014\000\012\000\000\000\000\000\000\000\000\000\029\000\
\000\000\046\000\000\000\000\000\000\000\049\000\000\000\000\000\
\000\000\034\000\000\000\000\000\039\000\043\000\060\000\048\000\
\053\000\074\000\075\000\000\000\000\000\030\000\031\000\000\000\
\000\000\000\000\000\000\000\000\000\000\041\000\000\000\035\000\
\036\000\000\000\000\000\000\000\045\000"

let yydgoto = "\002\000\
\010\000\054\000\055\000\056\000\057\000\078\000\117\000\059\000\
\060\000\029\000\118\000\160\000\119\000\161\000\168\000\120\000\
\121\000\070\000\143\000\071\000\144\000\032\000\033\000\034\000\
\035\000\036\000\043\000\016\000"

let yysindex = "\028\000\
\001\000\000\000\000\000\024\255\068\255\061\255\061\255\104\255\
\000\000\000\000\090\255\000\000\061\255\132\255\000\000\014\255\
\010\255\147\255\165\255\014\255\252\254\000\000\000\000\001\255\
\169\255\175\255\150\255\112\255\186\255\181\255\193\255\113\255\
\252\254\252\254\252\254\185\255\203\255\000\000\204\255\205\255\
\150\255\150\255\196\255\191\255\000\000\130\255\000\000\000\000\
\000\000\000\000\000\000\212\255\216\255\223\255\198\255\000\000\
\202\255\083\255\225\255\228\255\236\255\203\255\059\255\232\255\
\000\000\000\000\000\000\000\000\109\255\203\255\235\255\242\255\
\244\255\000\000\000\000\000\000\130\255\240\255\009\255\252\255\
\253\255\254\255\159\255\255\255\000\000\000\000\148\255\000\000\
\074\255\000\000\246\255\002\000\000\000\003\000\005\000\000\000\
\000\000\000\000\245\255\249\255\247\255\000\000\130\255\007\000\
\008\000\009\000\000\000\000\000\000\000\247\255\000\000\010\000\
\000\000\021\255\097\255\165\255\247\255\000\000\012\000\000\000\
\006\000\000\000\011\000\000\000\015\000\013\000\013\000\000\000\
\000\000\000\000\000\000\092\255\014\000\017\000\092\255\000\000\
\074\255\000\000\236\255\236\255\109\255\000\000\013\000\251\255\
\016\000\000\000\021\000\023\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\036\255\036\255\000\000\000\000\020\000\
\024\000\025\000\036\255\027\000\027\000\000\000\022\000\000\000\
\000\000\074\255\026\000\029\000\000\000"

let yyrindex = "\000\000\
\237\255\000\000\000\000\000\000\000\000\022\255\017\255\000\000\
\000\000\000\000\000\000\000\000\022\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\044\255\000\000\000\000\000\000\
\000\000\000\000\045\255\000\000\000\000\000\000\000\000\000\000\
\044\255\044\255\044\255\000\000\000\000\000\000\000\000\000\000\
\045\255\045\255\000\000\180\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\197\255\000\000\208\255\219\255\000\000\
\230\255\032\000\036\000\000\000\000\000\000\000\037\255\000\000\
\000\000\000\000\000\000\000\000\000\000\030\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\031\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\016\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\120\255\000\000\176\255\
\000\000\000\000\231\255\000\000\126\255\000\000\157\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\015\255\000\000\033\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\034\000\
\000\000\000\000\000\000\127\255\144\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\243\255\182\000\000\000\000\000\173\000\234\255\000\000\
\210\000\186\000\134\255\000\000\000\000\250\255\138\000\195\255\
\128\255\224\255\000\000\211\255\190\255\047\001\004\000\057\000\
\000\000\087\000\149\000\148\000"

let yytablesize = 304
let yytable = "\090\000\
\003\000\093\000\024\000\026\000\012\000\058\000\030\000\096\000\
\150\000\146\000\022\000\037\000\149\000\103\000\022\000\050\000\
\091\000\069\000\031\000\020\000\020\000\133\000\069\000\079\000\
\097\000\009\000\050\000\086\000\001\000\038\000\041\000\023\000\
\025\000\159\000\159\000\023\000\022\000\158\000\069\000\069\000\
\159\000\171\000\134\000\069\000\041\000\041\000\046\000\013\000\
\061\000\047\000\048\000\049\000\050\000\051\000\101\000\062\000\
\066\000\052\000\053\000\061\000\145\000\092\000\116\000\061\000\
\110\000\061\000\061\000\089\000\014\000\107\000\055\000\055\000\
\055\000\055\000\112\000\113\000\153\000\151\000\152\000\096\000\
\079\000\114\000\089\000\042\000\046\000\015\000\085\000\047\000\
\048\000\049\000\050\000\051\000\022\000\142\000\142\000\115\000\
\053\000\042\000\042\000\080\000\116\000\086\000\046\000\135\000\
\018\000\047\000\048\000\049\000\050\000\051\000\142\000\095\000\
\044\000\052\000\053\000\045\000\019\000\089\000\116\000\065\000\
\066\000\067\000\046\000\019\000\019\000\047\000\048\000\049\000\
\050\000\051\000\022\000\028\000\037\000\052\000\053\000\028\000\
\037\000\028\000\037\000\019\000\046\000\064\000\021\000\047\000\
\048\000\049\000\050\000\051\000\044\000\038\000\162\000\052\000\
\053\000\038\000\017\000\038\000\166\000\027\000\046\000\022\000\
\020\000\047\000\048\000\049\000\050\000\051\000\044\000\028\000\
\044\000\052\000\053\000\039\000\047\000\048\000\049\000\050\000\
\051\000\040\000\001\000\009\000\023\000\001\000\001\000\001\000\
\001\000\001\000\061\000\001\000\001\000\074\000\075\000\062\000\
\001\000\063\000\001\000\001\000\068\000\077\000\001\000\001\000\
\002\000\002\000\002\000\069\000\072\000\073\000\002\000\076\000\
\002\000\002\000\083\000\008\000\008\000\008\000\080\000\002\000\
\002\000\008\000\081\000\008\000\008\000\084\000\010\000\010\000\
\010\000\082\000\008\000\008\000\010\000\087\000\010\000\088\000\
\094\000\017\000\017\000\017\000\002\000\010\000\010\000\017\000\
\002\000\017\000\002\000\002\000\089\000\099\000\098\000\100\000\
\017\000\002\000\002\000\102\000\104\000\105\000\106\000\126\000\
\109\000\122\000\123\000\127\000\124\000\125\000\154\000\055\000\
\108\000\086\000\129\000\130\000\131\000\141\000\139\000\138\000\
\132\000\137\000\140\000\128\000\147\000\004\000\005\000\148\000\
\006\000\163\000\007\000\155\000\008\000\156\000\009\000\157\000\
\170\000\164\000\165\000\167\000\019\000\172\000\173\000\024\000\
\111\000\052\000\022\000\042\000\054\000\136\000\169\000\011\000"

let yycheck = "\061\000\
\000\000\063\000\016\000\017\000\001\000\028\000\020\000\069\000\
\137\000\132\000\001\001\011\001\135\000\005\001\001\001\001\001\
\062\000\001\001\023\001\004\001\005\001\001\001\001\001\046\000\
\070\000\030\001\012\001\019\001\001\000\029\001\027\000\022\001\
\023\001\156\000\157\000\022\001\001\001\002\001\022\001\023\001\
\163\000\170\000\022\001\022\001\041\000\042\000\011\001\024\001\
\012\001\014\001\015\001\016\001\017\001\018\001\077\000\012\001\
\012\001\022\001\023\001\023\001\127\000\003\001\027\001\027\001\
\087\000\029\001\030\001\009\001\001\001\083\000\027\001\027\001\
\029\001\029\001\001\001\002\001\143\000\139\000\140\000\141\000\
\103\000\008\001\009\001\027\000\011\001\025\001\004\001\014\001\
\015\001\016\001\017\001\018\001\001\001\126\000\127\000\022\001\
\023\001\041\000\042\000\003\001\027\001\019\001\011\001\007\001\
\001\001\014\001\015\001\016\001\017\001\018\001\143\000\003\001\
\001\001\022\001\023\001\004\001\027\001\009\001\027\001\033\000\
\034\000\035\000\011\001\004\001\005\001\014\001\015\001\016\001\
\017\001\018\001\001\001\006\001\006\001\022\001\023\001\010\001\
\010\001\012\001\012\001\027\001\011\001\029\001\011\001\014\001\
\015\001\016\001\017\001\018\001\001\001\006\001\157\000\022\001\
\023\001\010\001\007\000\012\001\163\000\011\001\011\001\001\001\
\013\000\014\001\015\001\016\001\017\001\018\001\010\001\003\001\
\012\001\022\001\023\001\003\001\014\001\015\001\016\001\017\001\
\018\001\003\001\003\001\030\001\022\001\006\001\003\001\004\001\
\005\001\010\001\001\001\012\001\013\001\041\000\042\000\011\001\
\013\001\001\001\019\001\020\001\012\001\007\001\019\001\020\001\
\004\001\005\001\006\001\001\001\001\001\001\001\010\001\012\001\
\012\001\013\001\013\001\004\001\005\001\006\001\003\001\019\001\
\020\001\010\001\003\001\012\001\013\001\020\001\004\001\005\001\
\006\001\003\001\019\001\020\001\010\001\005\001\012\001\004\001\
\001\001\004\001\005\001\006\001\006\001\019\001\020\001\010\001\
\010\001\012\001\012\001\013\001\009\001\004\001\012\001\004\001\
\019\001\019\001\020\001\012\001\001\001\001\001\001\001\011\001\
\002\001\012\001\001\001\011\001\002\001\001\001\012\001\027\001\
\083\000\019\001\004\001\004\001\004\001\001\001\004\001\010\001\
\007\001\006\001\004\001\103\000\007\001\021\001\022\001\007\001\
\024\001\006\001\026\001\012\001\028\001\009\001\030\001\009\001\
\011\001\010\001\010\001\009\001\005\001\012\001\010\001\004\001\
\087\000\012\001\012\001\010\001\012\001\116\000\165\000\001\000"

let yynames_const = "\
  EOF\000\
  LPAREN\000\
  RPAREN\000\
  COMMA\000\
  SEMICOLON\000\
  COLON\000\
  QUESTION\000\
  LBRACKET\000\
  RBRACKET\000\
  LBRACE\000\
  RBRACE\000\
  SLASH\000\
  TYINT\000\
  TYFLOAT\000\
  TYBOOL\000\
  TYCHAR\000\
  TYSTRING\000\
  LIST\000\
  AS\000\
  VARIANT\000\
  WIDGET\000\
  OPTION\000\
  TYPE\000\
  SEQUENCE\000\
  SUBTYPE\000\
  FUNCTION\000\
  MODULE\000\
  EXTERNAL\000\
  UNSAFE\000\
  "

let yynames_block = "\
  IDENT\000\
  STRING\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 66 "parser.mly"
         ( String.uncapitalize _1 )
# 312 "parser.ml"
               : 'TypeName))
; (fun __caml_parser_env ->
    Obj.repr(
# 67 "parser.mly"
          ( "widget" )
# 318 "parser.ml"
               : 'TypeName))
; (fun __caml_parser_env ->
    Obj.repr(
# 73 "parser.mly"
      ( Int )
# 324 "parser.ml"
               : 'Type0))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "parser.mly"
      ( Float )
# 330 "parser.ml"
               : 'Type0))
; (fun __caml_parser_env ->
    Obj.repr(
# 77 "parser.mly"
      ( Bool )
# 336 "parser.ml"
               : 'Type0))
; (fun __caml_parser_env ->
    Obj.repr(
# 79 "parser.mly"
      ( Char )
# 342 "parser.ml"
               : 'Type0))
; (fun __caml_parser_env ->
    Obj.repr(
# 81 "parser.mly"
      ( String )
# 348 "parser.ml"
               : 'Type0))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'TypeName) in
    Obj.repr(
# 83 "parser.mly"
      ( UserDefined _1 )
# 355 "parser.ml"
               : 'Type0))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Type0) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type0) in
    Obj.repr(
# 88 "parser.mly"
                      ( if !Flags.camltk then _1 else _3 )
# 363 "parser.ml"
               : 'Type0_5))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type0) in
    Obj.repr(
# 89 "parser.mly"
          ( _1 )
# 370 "parser.ml"
               : 'Type0_5))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type0_5) in
    Obj.repr(
# 95 "parser.mly"
      ( _1 )
# 377 "parser.ml"
               : 'Type1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'TypeName) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 97 "parser.mly"
     ( Subtype (_1, _3) )
# 385 "parser.ml"
               : 'Type1))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 99 "parser.mly"
     ( Subtype ("widget", _3) )
# 392 "parser.ml"
               : 'Type1))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 101 "parser.mly"
     ( Subtype ("options", _3) )
# 399 "parser.ml"
               : 'Type1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Type1) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 103 "parser.mly"
     ( As (_1, _3) )
# 407 "parser.ml"
               : 'Type1))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Type_list) in
    Obj.repr(
# 105 "parser.mly"
      ( Product _2 )
# 414 "parser.ml"
               : 'Type1))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type1) in
    Obj.repr(
# 111 "parser.mly"
     ( _1 )
# 421 "parser.ml"
               : 'Type2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'Type2) in
    Obj.repr(
# 113 "parser.mly"
     ( List _1 )
# 428 "parser.ml"
               : 'Type2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type2) in
    Obj.repr(
# 118 "parser.mly"
      ( "", _1 )
# 435 "parser.ml"
               : 'Labeled_type2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type2) in
    Obj.repr(
# 120 "parser.mly"
      ( _1, _3 )
# 443 "parser.ml"
               : 'Labeled_type2))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Type2) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type_list) in
    Obj.repr(
# 126 "parser.mly"
      ( _1 :: _3 )
# 451 "parser.ml"
               : 'Type_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type2) in
    Obj.repr(
# 128 "parser.mly"
      ( [_1] )
# 458 "parser.ml"
               : 'Type_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Labeled_type2) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type_record) in
    Obj.repr(
# 134 "parser.mly"
      ( _1 :: _3 )
# 466 "parser.ml"
               : 'Type_record))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Labeled_type2) in
    Obj.repr(
# 136 "parser.mly"
      ( [_1] )
# 473 "parser.ml"
               : 'Type_record))
; (fun __caml_parser_env ->
    Obj.repr(
# 142 "parser.mly"
      ( Unit )
# 479 "parser.ml"
               : 'FType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Type2) in
    Obj.repr(
# 144 "parser.mly"
      ( _2 )
# 486 "parser.ml"
               : 'FType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'Type_record) in
    Obj.repr(
# 146 "parser.mly"
      ( Record _2 )
# 493 "parser.ml"
               : 'FType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type2) in
    Obj.repr(
# 151 "parser.mly"
      ( _1 )
# 500 "parser.ml"
               : 'Type))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'FType) in
    Obj.repr(
# 153 "parser.mly"
      ( Function _2 )
# 507 "parser.ml"
               : 'Type))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 160 "parser.mly"
      (StringArg _1)
# 514 "parser.ml"
               : 'SimpleArg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 162 "parser.mly"
      (TypeArg ("", _1) )
# 521 "parser.ml"
               : 'SimpleArg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 167 "parser.mly"
      (StringArg _1)
# 528 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 169 "parser.mly"
      (TypeArg ("", _1) )
# 535 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 171 "parser.mly"
      (TypeArg (_1, _3))
# 543 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'SimpleArgList) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'DefaultList) in
    Obj.repr(
# 173 "parser.mly"
      (OptionalArgs ( _2, _5, _7 ))
# 552 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'SimpleArgList) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'DefaultList) in
    Obj.repr(
# 175 "parser.mly"
      (OptionalArgs ( "widget", _5, _7 ))
# 560 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'SimpleArgList) in
    Obj.repr(
# 177 "parser.mly"
      (OptionalArgs ( _2, _5, [] ))
# 568 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'SimpleArgList) in
    Obj.repr(
# 179 "parser.mly"
      (OptionalArgs ( "widget", _5, [] ))
# 575 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Type) in
    Obj.repr(
# 181 "parser.mly"
      (TypeArg ("widget", _3))
# 582 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Template) in
    Obj.repr(
# 183 "parser.mly"
      ( _1 )
# 589 "parser.ml"
               : 'Arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'SimpleArg) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'SimpleArgList) in
    Obj.repr(
# 188 "parser.mly"
       ( _1 :: _3)
# 597 "parser.ml"
               : 'SimpleArgList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'SimpleArg) in
    Obj.repr(
# 190 "parser.mly"
      ( [_1] )
# 604 "parser.ml"
               : 'SimpleArgList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Arg) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ArgList) in
    Obj.repr(
# 195 "parser.mly"
       ( _1 :: _3)
# 612 "parser.ml"
               : 'ArgList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Arg) in
    Obj.repr(
# 197 "parser.mly"
      ( [_1] )
# 619 "parser.ml"
               : 'ArgList))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'ArgList) in
    Obj.repr(
# 203 "parser.mly"
      (_3)
# 626 "parser.ml"
               : 'DefaultList))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'ArgList) in
    Obj.repr(
# 208 "parser.mly"
      ( ListArg _2 )
# 633 "parser.ml"
               : 'Template))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Template) in
    Obj.repr(
# 215 "parser.mly"
      ({ component = Constructor;
         ml_name = _1;
         var_name = getvarname _1 _2;
         template = _2;
         result = Unit;
         safe = true })
# 646 "parser.ml"
               : 'Constructor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'Template) in
    Obj.repr(
# 222 "parser.mly"
      ({ component = Constructor;
         ml_name = _1;
         var_name = _3;
         template = _5;
         result = Unit;
         safe = true })
# 660 "parser.ml"
               : 'Constructor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Constructor) in
    Obj.repr(
# 232 "parser.mly"
      ( Full _1 )
# 667 "parser.ml"
               : 'AbbrevConstructor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 234 "parser.mly"
      ( Abbrev _1 )
# 674 "parser.ml"
               : 'AbbrevConstructor))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'Constructor) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'Constructors) in
    Obj.repr(
# 239 "parser.mly"
   ( _1 :: _2 )
# 682 "parser.ml"
               : 'Constructors))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Constructor) in
    Obj.repr(
# 241 "parser.mly"
   ( [_1] )
# 689 "parser.ml"
               : 'Constructors))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'AbbrevConstructor) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'AbbrevConstructors) in
    Obj.repr(
# 246 "parser.mly"
   ( _1 :: _2 )
# 697 "parser.ml"
               : 'AbbrevConstructors))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'AbbrevConstructor) in
    Obj.repr(
# 248 "parser.mly"
   ( [_1] )
# 704 "parser.ml"
               : 'AbbrevConstructors))
; (fun __caml_parser_env ->
    Obj.repr(
# 253 "parser.mly"
  ( true )
# 710 "parser.ml"
               : 'Safe))
; (fun __caml_parser_env ->
    Obj.repr(
# 255 "parser.mly"
  ( false )
# 716 "parser.ml"
               : 'Safe))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'Safe) in
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'FType) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'Template) in
    Obj.repr(
# 259 "parser.mly"
     ({component = Command; ml_name = _4; var_name = "";
       template = _5; result = _3; safe = _1 })
# 727 "parser.ml"
               : 'Command))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'Safe) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 265 "parser.mly"
     ({component = External; ml_name = _3; var_name = "";
       template = StringArg _4; result = Unit; safe = _1})
# 737 "parser.ml"
               : 'External))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'Template) in
    Obj.repr(
# 271 "parser.mly"
     ({component = Constructor; ml_name = _2; var_name = getvarname _2 _3;
       template = _3; result = Unit; safe = true })
# 746 "parser.ml"
               : 'Option))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'Template) in
    Obj.repr(
# 275 "parser.mly"
     ({component = Constructor; ml_name = _2; var_name = _4;
       template = _6; result = Unit; safe = true })
# 756 "parser.ml"
               : 'Option))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 279 "parser.mly"
     ( retrieve_option _2 )
# 763 "parser.ml"
               : 'Option))
; (fun __caml_parser_env ->
    Obj.repr(
# 284 "parser.mly"
  ( [] )
# 769 "parser.ml"
               : 'WidgetComponents))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'Command) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'WidgetComponents) in
    Obj.repr(
# 286 "parser.mly"
  ( _1 :: _2 )
# 777 "parser.ml"
               : 'WidgetComponents))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'Option) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'WidgetComponents) in
    Obj.repr(
# 288 "parser.mly"
  ( _1 :: _2 )
# 785 "parser.ml"
               : 'WidgetComponents))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'External) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'WidgetComponents) in
    Obj.repr(
# 290 "parser.mly"
  ( _1 :: _2 )
# 793 "parser.ml"
               : 'WidgetComponents))
; (fun __caml_parser_env ->
    Obj.repr(
# 295 "parser.mly"
  ( [] )
# 799 "parser.ml"
               : 'ModuleComponents))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'Command) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ModuleComponents) in
    Obj.repr(
# 297 "parser.mly"
  ( _1 :: _2 )
# 807 "parser.ml"
               : 'ModuleComponents))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'External) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ModuleComponents) in
    Obj.repr(
# 299 "parser.mly"
  ( _1 :: _2 )
# 815 "parser.ml"
               : 'ModuleComponents))
; (fun __caml_parser_env ->
    Obj.repr(
# 304 "parser.mly"
  ( OneToken )
# 821 "parser.ml"
               : 'ParserArity))
; (fun __caml_parser_env ->
    Obj.repr(
# 306 "parser.mly"
  ( MultipleToken )
# 827 "parser.ml"
               : 'ParserArity))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'ParserArity) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'TypeName) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'Constructors) in
    Obj.repr(
# 313 "parser.mly"
    ( enter_type _3 _2 _5 )
# 836 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'ParserArity) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'TypeName) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'Constructors) in
    Obj.repr(
# 315 "parser.mly"
    ( enter_type _4 _3 _6 ~variant: true )
# 845 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'ParserArity) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'TypeName) in
    Obj.repr(
# 317 "parser.mly"
    ( enter_external_type _3 _2 )
# 853 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 7 : 'ParserArity) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _8 = (Parsing.peek_val __caml_parser_env 1 : 'AbbrevConstructors) in
    Obj.repr(
# 319 "parser.mly"
    ( enter_subtype "options" _2 _5 _8 )
# 862 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 7 : 'ParserArity) in
    let _3 = (Parsing.peek_val __caml_parser_env 6 : 'TypeName) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _8 = (Parsing.peek_val __caml_parser_env 1 : 'AbbrevConstructors) in
    Obj.repr(
# 321 "parser.mly"
    ( enter_subtype _3 _2 _5 _8 )
# 872 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Command) in
    Obj.repr(
# 323 "parser.mly"
    ( enter_function _1 )
# 879 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'WidgetComponents) in
    Obj.repr(
# 325 "parser.mly"
    ( enter_widget _2 _4 )
# 887 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'ModuleComponents) in
    Obj.repr(
# 327 "parser.mly"
    ( enter_module (String.uncapitalize _2) _4 )
# 895 "parser.ml"
               : unit))
; (fun __caml_parser_env ->
    Obj.repr(
# 329 "parser.mly"
    ( raise End_of_file )
# 901 "parser.ml"
               : unit))
(* Entry entry *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let entry (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : unit)
