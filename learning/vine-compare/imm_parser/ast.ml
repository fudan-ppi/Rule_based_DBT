type expr =
  | Var of string
  | Int of int
  | Neg of expr
  | Not of expr
  | Lshift of expr * expr
  | Or of expr * expr
  | Add of expr * expr
  | Sub of expr * expr
