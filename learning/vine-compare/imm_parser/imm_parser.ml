open Ast
open Lexer
open Parser

let parse_from_str s =
  let lexbuf = Lexing.from_string s in
  let ast = Parser.main Lexer.read lexbuf in
  ast
