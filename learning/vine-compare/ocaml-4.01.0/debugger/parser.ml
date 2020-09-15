type token =
  | ARGUMENT of (string)
  | LIDENT of (string)
  | UIDENT of (string)
  | OPERATOR of (string)
  | INTEGER of (int64)
  | STAR
  | MINUS
  | DOT
  | SHARP
  | AT
  | DOLLAR
  | BANG
  | LPAREN
  | RPAREN
  | LBRACKET
  | RBRACKET
  | EOL

open Parsing;;
let _ = parse_error;;
# 15 "parser.mly"

open Int64ops
open Input_handling
open Longident
open Parser_aux

# 30 "parser.ml"
let yytransl_const = [|
  262 (* STAR *);
  263 (* MINUS *);
  264 (* DOT *);
  265 (* SHARP *);
  266 (* AT *);
  267 (* DOLLAR *);
  268 (* BANG *);
  269 (* LPAREN *);
  270 (* RPAREN *);
  271 (* LBRACKET *);
  272 (* RBRACKET *);
  273 (* EOL *);
    0|]

let yytransl_block = [|
  257 (* ARGUMENT *);
  258 (* LIDENT *);
  259 (* UIDENT *);
  260 (* OPERATOR *);
  261 (* INTEGER *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\003\000\003\000\004\000\005\000\006\000\
\007\000\007\000\022\000\022\000\008\000\008\000\009\000\009\000\
\023\000\023\000\023\000\023\000\023\000\024\000\024\000\019\000\
\020\000\020\000\020\000\020\000\021\000\010\000\010\000\011\000\
\012\000\012\000\013\000\013\000\014\000\025\000\025\000\025\000\
\025\000\025\000\025\000\025\000\025\000\025\000\015\000\015\000\
\016\000\016\000\016\000\016\000\016\000\017\000\017\000\018\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000"

let yylen = "\002\000\
\002\000\001\000\002\000\002\000\001\000\002\000\002\000\001\000\
\002\000\001\000\002\000\001\000\002\000\001\000\002\000\001\000\
\001\000\003\000\001\000\003\000\005\000\001\000\003\000\002\000\
\001\000\001\000\003\000\000\000\002\000\001\000\001\000\002\000\
\001\000\001\000\001\000\000\000\002\000\001\000\001\000\002\000\
\003\000\005\000\005\000\003\000\002\000\003\000\002\000\001\000\
\001\000\001\000\002\000\004\000\004\000\003\000\001\000\001\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\056\000\
\057\000\002\000\000\000\058\000\000\000\059\000\005\000\000\000\
\060\000\000\000\061\000\008\000\062\000\000\000\063\000\010\000\
\000\000\014\000\064\000\000\000\000\000\065\000\012\000\016\000\
\030\000\031\000\066\000\000\000\067\000\033\000\068\000\034\000\
\035\000\069\000\000\000\070\000\017\000\022\000\019\000\039\000\
\000\000\000\000\000\000\071\000\048\000\038\000\000\000\000\000\
\000\000\050\000\072\000\049\000\000\000\026\000\000\000\073\000\
\000\000\055\000\000\000\074\000\075\000\000\000\076\000\000\000\
\077\000\001\000\003\000\004\000\006\000\007\000\009\000\013\000\
\011\000\015\000\032\000\037\000\040\000\045\000\000\000\000\000\
\000\000\047\000\000\000\051\000\000\000\029\000\000\000\024\000\
\046\000\018\000\023\000\020\000\000\000\044\000\041\000\000\000\
\000\000\000\000\000\000\054\000\000\000\000\000\000\000\000\000\
\052\000\053\000\021\000\043\000\042\000"

let yydgoto = "\022\000\
\025\000\028\000\030\000\033\000\035\000\037\000\039\000\043\000\
\046\000\057\000\053\000\055\000\058\000\060\000\068\000\075\000\
\080\000\040\000\085\000\081\000\082\000\048\000\070\000\071\000\
\072\000"

let yysindex = "\114\000\
\008\255\004\255\025\255\007\255\045\255\048\255\035\255\019\255\
\024\255\058\255\058\255\016\255\058\255\058\255\134\255\068\255\
\093\255\052\255\102\255\093\255\093\255\000\000\008\255\000\000\
\000\000\000\000\052\255\000\000\025\255\000\000\000\000\052\255\
\000\000\052\255\000\000\000\000\000\000\052\255\000\000\000\000\
\007\255\000\000\000\000\052\255\045\255\000\000\000\000\000\000\
\000\000\000\000\000\000\052\255\000\000\000\000\000\000\000\000\
\000\000\000\000\052\255\000\000\000\000\000\000\000\000\000\000\
\070\255\146\255\146\255\000\000\000\000\000\000\076\255\086\255\
\093\255\000\000\000\000\000\000\005\255\000\000\000\000\000\000\
\039\255\000\000\092\255\000\000\000\000\052\255\000\000\052\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\037\255\063\255\
\033\255\000\000\053\255\000\000\035\255\000\000\099\255\000\000\
\000\000\000\000\000\000\000\000\103\255\000\000\000\000\108\255\
\136\255\035\255\007\255\000\000\000\000\094\255\125\255\126\255\
\000\000\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\143\000\127\255\000\000\000\000\
\042\255\000\000\000\000\153\000\137\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\078\255\000\000\000\000\000\000\000\000\000\000\001\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\003\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\132\000\000\000\127\000\242\255\115\000\080\000\248\255\000\000\
\000\000\100\000\000\000\000\000\148\000\000\000\091\000\000\000\
\000\000\005\000\000\000\251\255\144\000\000\000\145\000\246\255\
\244\255"

let yytablesize = 276
let yytable = "\042\000\
\025\000\074\000\027\000\077\000\027\000\026\000\083\000\031\000\
\023\000\083\000\083\000\032\000\105\000\047\000\087\000\088\000\
\056\000\049\000\050\000\069\000\076\000\024\000\084\000\038\000\
\024\000\041\000\096\000\026\000\044\000\029\000\045\000\091\000\
\024\000\031\000\118\000\024\000\093\000\119\000\094\000\038\000\
\024\000\024\000\095\000\036\000\105\000\120\000\028\000\121\000\
\097\000\034\000\113\000\024\000\036\000\102\000\103\000\024\000\
\099\000\122\000\028\000\049\000\050\000\123\000\083\000\100\000\
\114\000\115\000\116\000\107\000\024\000\061\000\062\000\063\000\
\032\000\064\000\101\000\117\000\069\000\073\000\065\000\066\000\
\067\000\108\000\028\000\104\000\024\000\110\000\028\000\061\000\
\062\000\063\000\112\000\064\000\110\000\105\000\078\000\079\000\
\065\000\066\000\067\000\111\000\124\000\125\000\024\000\061\000\
\062\000\063\000\126\000\131\000\130\000\051\000\052\000\054\000\
\127\000\129\000\001\000\002\000\003\000\004\000\005\000\006\000\
\007\000\008\000\009\000\010\000\011\000\012\000\013\000\014\000\
\015\000\016\000\017\000\018\000\019\000\020\000\021\000\061\000\
\062\000\063\000\132\000\064\000\128\000\133\000\036\000\036\000\
\065\000\066\000\067\000\061\000\062\000\063\000\024\000\064\000\
\028\000\028\000\090\000\092\000\065\000\066\000\067\000\098\000\
\109\000\059\000\106\000\086\000\089\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\025\000\000\000\027\000\
\022\000\025\000\023\000\027\000\000\000\000\000\000\000\000\000\
\000\000\025\000\000\000\027\000"

let yycheck = "\008\000\
\000\000\016\000\000\000\016\000\001\001\001\000\017\000\003\000\
\001\001\020\000\021\000\005\001\008\001\009\000\020\000\021\000\
\012\000\002\001\003\001\015\000\016\000\017\001\018\000\005\001\
\017\001\007\001\041\000\023\000\005\001\005\001\007\001\027\000\
\017\001\029\000\002\001\017\001\032\000\005\001\034\000\005\001\
\017\001\017\001\038\000\005\001\008\001\013\001\005\001\015\001\
\044\000\005\001\014\001\017\001\005\001\066\000\067\000\017\001\
\052\000\005\001\017\001\002\001\003\001\009\001\073\000\059\000\
\002\001\003\001\004\001\073\000\017\001\002\001\003\001\004\001\
\005\001\006\001\005\001\013\001\072\000\010\001\011\001\012\001\
\013\001\077\000\005\001\008\001\017\001\081\000\009\001\002\001\
\003\001\004\001\086\000\006\001\088\000\008\001\002\001\003\001\
\011\001\012\001\013\001\008\001\109\000\003\001\017\001\002\001\
\003\001\004\001\004\001\014\001\123\000\010\000\011\000\012\000\
\005\001\122\000\001\000\002\000\003\000\004\000\005\000\006\000\
\007\000\008\000\009\000\010\000\011\000\012\000\013\000\014\000\
\015\000\016\000\017\000\018\000\019\000\020\000\021\000\002\001\
\003\001\004\001\014\001\006\001\005\001\016\001\000\000\017\001\
\011\001\012\001\013\001\002\001\003\001\004\001\017\001\006\001\
\000\000\017\001\023\000\029\000\011\001\012\001\013\001\045\000\
\081\000\014\000\072\000\019\000\021\000\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\005\001\255\255\005\001\
\008\001\009\001\008\001\009\001\255\255\255\255\255\255\255\255\
\255\255\017\001\255\255\017\001"

let yynames_const = "\
  STAR\000\
  MINUS\000\
  DOT\000\
  SHARP\000\
  AT\000\
  DOLLAR\000\
  BANG\000\
  LPAREN\000\
  RPAREN\000\
  LBRACKET\000\
  RBRACKET\000\
  EOL\000\
  "

let yynames_block = "\
  ARGUMENT\000\
  LIDENT\000\
  UIDENT\000\
  OPERATOR\000\
  INTEGER\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string list) in
    Obj.repr(
# 113 "parser.mly"
      ( _1::_2 )
# 253 "parser.ml"
               : string list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 115 "parser.mly"
      ( [] )
# 260 "parser.ml"
               : string list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 119 "parser.mly"
      ( _1 )
# 268 "parser.ml"
               : string))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int list) in
    Obj.repr(
# 125 "parser.mly"
      ( (to_int _1) :: _2 )
# 276 "parser.ml"
               : int list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 127 "parser.mly"
      ( [] )
# 283 "parser.ml"
               : int list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 131 "parser.mly"
      ( to_int _1 )
# 291 "parser.ml"
               : int))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 135 "parser.mly"
      ( _1 )
# 299 "parser.ml"
               : int64))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int64) in
    Obj.repr(
# 139 "parser.mly"
      ( to_int _1 )
# 306 "parser.ml"
               : int))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 143 "parser.mly"
      ( Some (to_int _1) )
# 314 "parser.ml"
               : int option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 145 "parser.mly"
      ( None )
# 321 "parser.ml"
               : int option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 149 "parser.mly"
      ( Some _1 )
# 329 "parser.ml"
               : 'opt_int64_eol))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 151 "parser.mly"
      ( None )
# 336 "parser.ml"
               : 'opt_int64_eol))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 155 "parser.mly"
      ( Some (- _2) )
# 343 "parser.ml"
               : int option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int option) in
    Obj.repr(
# 157 "parser.mly"
      ( _1 )
# 350 "parser.ml"
               : int option))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int64) in
    Obj.repr(
# 161 "parser.mly"
      ( Some (Int64.neg _2) )
# 357 "parser.ml"
               : int64 option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'opt_int64_eol) in
    Obj.repr(
# 163 "parser.mly"
      ( _1 )
# 364 "parser.ml"
               : int64 option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 168 "parser.mly"
                                ( Lident _1 )
# 371 "parser.ml"
               : 'longident))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'module_path) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 169 "parser.mly"
                                ( Ldot(_1, _3) )
# 379 "parser.ml"
               : 'longident))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 170 "parser.mly"
                                ( Lident _1 )
# 386 "parser.ml"
               : 'longident))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'module_path) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 171 "parser.mly"
                                ( Ldot(_1, _3) )
# 394 "parser.ml"
               : 'longident))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'module_path) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : string) in
    Obj.repr(
# 172 "parser.mly"
                                           ( Ldot(_1, _4) )
# 402 "parser.ml"
               : 'longident))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 176 "parser.mly"
                                ( Lident _1 )
# 409 "parser.ml"
               : 'module_path))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'module_path) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 177 "parser.mly"
                                ( Ldot(_1, _3) )
# 417 "parser.ml"
               : 'module_path))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'longident) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 181 "parser.mly"
                                ( _1 )
# 425 "parser.ml"
               : Longident.t))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 184 "parser.mly"
                                ( Some (Lident _1) )
# 432 "parser.ml"
               : Longident.t option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 185 "parser.mly"
                                ( Some (Lident _1) )
# 439 "parser.ml"
               : Longident.t option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'module_path) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 186 "parser.mly"
                                ( Some (Ldot(_1, _3)) )
# 447 "parser.ml"
               : Longident.t option))
; (fun __caml_parser_env ->
    Obj.repr(
# 187 "parser.mly"
                                ( None )
# 453 "parser.ml"
               : Longident.t option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Longident.t option) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 190 "parser.mly"
                                ( _1 )
# 461 "parser.ml"
               : Longident.t option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 193 "parser.mly"
                                ( _1 )
# 468 "parser.ml"
               : string))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 194 "parser.mly"
                                ( _1 )
# 475 "parser.ml"
               : string))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 197 "parser.mly"
                                ( _1 )
# 483 "parser.ml"
               : string))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 200 "parser.mly"
                                ( Some _1 )
# 490 "parser.ml"
               : string option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 201 "parser.mly"
                                ( None )
# 497 "parser.ml"
               : string option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 204 "parser.mly"
                                ( Some _1 )
# 504 "parser.ml"
               : string option))
; (fun __caml_parser_env ->
    Obj.repr(
# 205 "parser.mly"
                                ( None )
# 510 "parser.ml"
               : string option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string option) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 208 "parser.mly"
                                ( _1 )
# 518 "parser.ml"
               : string option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'longident) in
    Obj.repr(
# 213 "parser.mly"
                                               ( E_ident _1 )
# 525 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    Obj.repr(
# 214 "parser.mly"
                                                ( E_result )
# 531 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int64) in
    Obj.repr(
# 215 "parser.mly"
                                                ( E_name (to_int _2) )
# 538 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int64) in
    Obj.repr(
# 216 "parser.mly"
                                                ( E_item(_1, (to_int _3)) )
# 546 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'expression) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    Obj.repr(
# 217 "parser.mly"
                                                ( E_item(_1, (to_int _4)) )
# 554 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 4 : 'expression) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    Obj.repr(
# 218 "parser.mly"
                                                ( E_item(_1, (to_int _4)) )
# 562 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expression) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 219 "parser.mly"
                                                ( E_field(_1, _3) )
# 570 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'expression) in
    Obj.repr(
# 220 "parser.mly"
                                                ( E_field(_2, "contents") )
# 577 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expression) in
    Obj.repr(
# 221 "parser.mly"
                                                ( _2 )
# 584 "parser.ml"
               : 'expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expression) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Parser_aux.expression list) in
    Obj.repr(
# 227 "parser.mly"
                                                ( _1::_2 )
# 592 "parser.ml"
               : Parser_aux.expression list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 228 "parser.mly"
                                                ( [] )
# 599 "parser.ml"
               : Parser_aux.expression list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 234 "parser.mly"
                                                ( BA_none )
# 606 "parser.ml"
               : Parser_aux.break_arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 235 "parser.mly"
                                                ( BA_pc _1 )
# 613 "parser.ml"
               : Parser_aux.break_arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expression) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : unit) in
    Obj.repr(
# 236 "parser.mly"
                                                ( BA_function _1 )
# 621 "parser.ml"
               : Parser_aux.break_arg))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Longident.t option) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : int64) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int option) in
    Obj.repr(
# 237 "parser.mly"
                                                ( BA_pos1 (_2, (to_int _3), _4))
# 630 "parser.ml"
               : Parser_aux.break_arg))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : Longident.t option) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 238 "parser.mly"
                                                ( BA_pos2 (_2, _4) )
# 638 "parser.ml"
               : Parser_aux.break_arg))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : Longident.t option) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : int) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int option) in
    Obj.repr(
# 245 "parser.mly"
      ( (_1, Some _2, _3) )
# 647 "parser.ml"
               : Longident.t option * int option * int option))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : Longident.t option) in
    Obj.repr(
# 247 "parser.mly"
      ( (_1, None, None) )
# 654 "parser.ml"
               : Longident.t option * int option * int option))
; (fun __caml_parser_env ->
    Obj.repr(
# 252 "parser.mly"
        ( stop_user_input () )
# 660 "parser.ml"
               : unit))
(* Entry argument_list_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry argument_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry integer_list_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry integer_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry int64_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry integer *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_integer_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_signed_integer_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_signed_int64_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry identifier *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry identifier_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry identifier_or_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_identifier *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_identifier_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry expression_list_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry break_argument_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry list_arguments_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry end_of_line *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry longident_eol *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_longident *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry opt_longident_eol *)
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
let argument_list_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : string list)
let argument_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : string)
let integer_list_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 3 lexfun lexbuf : int list)
let integer_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 4 lexfun lexbuf : int)
let int64_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 5 lexfun lexbuf : int64)
let integer (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 6 lexfun lexbuf : int)
let opt_integer_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 7 lexfun lexbuf : int option)
let opt_signed_integer_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 8 lexfun lexbuf : int option)
let opt_signed_int64_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 9 lexfun lexbuf : int64 option)
let identifier (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 10 lexfun lexbuf : string)
let identifier_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 11 lexfun lexbuf : string)
let identifier_or_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 12 lexfun lexbuf : string option)
let opt_identifier (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 13 lexfun lexbuf : string option)
let opt_identifier_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 14 lexfun lexbuf : string option)
let expression_list_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 15 lexfun lexbuf : Parser_aux.expression list)
let break_argument_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 16 lexfun lexbuf : Parser_aux.break_arg)
let list_arguments_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 17 lexfun lexbuf : Longident.t option * int option * int option)
let end_of_line (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 18 lexfun lexbuf : unit)
let longident_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 19 lexfun lexbuf : Longident.t)
let opt_longident (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 20 lexfun lexbuf : Longident.t option)
let opt_longident_eol (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 21 lexfun lexbuf : Longident.t option)
