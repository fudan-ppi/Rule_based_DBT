(***********************************************************************)
(*                                                                     *)
(*                              CamlIDL                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1999 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  Distributed only by permission.                   *)
(*                                                                     *)
(***********************************************************************)

(* $Id: config.mlp,v 1.3 2001/06/29 13:29:59 xleroy Exp $ *)

(* Compile-time configuration *)

(* How to invoke the C preprocessor *)
let cpp = "/lib/cpp"

(* The C names for 64-bit signed and unsigned integers *)

let (int64_type, uint64_type) =
  match Sys.os_type with
    "Win32" -> ("__int64", "unsigned __int64")
  | _       -> ("long long", "unsigned long long")
