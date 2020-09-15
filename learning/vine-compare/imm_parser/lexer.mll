{
open Parser
}

let white = [' ' '\t']+
let digit = ['0'-'9']
let int = digit+
let letter = ['a'-'z' 'A'-'Z']
let id = letter+ '_' digit+

rule read = parse
  | white { read lexbuf }
  | "("   { LPAREN }
  | ")"   { RPAREN }
  | "~"   { NOT }
  | "-"   { SUB }
  | "|"   { OR }                                                                          
  | "<<"  { LSHIFT }
  | "+"   { ADD }
  | id    { ID (Lexing.lexeme lexbuf) }
  | int   { INT (int_of_string (Lexing.lexeme lexbuf))}
  | eof   { EOF }
