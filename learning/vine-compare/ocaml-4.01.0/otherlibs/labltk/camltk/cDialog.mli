(***********************************************************************)
(*                                                                     *)
(*                 MLTk, Tcl/Tk interface of OCaml                     *)
(*                                                                     *)
(*    Francois Rouaix, Francois Pessaux, Jun Furuse and Pierre Weis    *)
(*               projet Cristal, INRIA Rocquencourt                    *)
(*            Jacques Garrigue, Kyoto University RIMS                  *)
(*                                                                     *)
(*  Copyright 2002 Institut National de Recherche en Informatique et   *)
(*  en Automatique and Kyoto University.  All rights reserved.         *)
(*  This file is distributed under the terms of the GNU Library        *)
(*  General Public License, with the special exception on linking      *)
(*  described in file LICENSE found in the OCaml source tree.          *)
(*                                                                     *)
(***********************************************************************)
(* The dialog commands  *)
open CTk
open Tkintf
open Widget
open Textvariable



val create : ?name: string ->
  widget -> string -> string -> bitmap -> int -> string list -> int
  (* [create ~name parent title message bitmap default button_names]
     cf. tk_dialog *)

val create_named :
  widget -> string -> string -> string -> bitmap -> int -> string list -> int
  (* [create_named parent name title message bitmap default button_names]
     cf. tk_dialog *)




