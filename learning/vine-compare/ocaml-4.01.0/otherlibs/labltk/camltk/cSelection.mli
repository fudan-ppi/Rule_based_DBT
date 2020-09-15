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
(* The selection commands  *)
open CTk
open Tkintf
open Widget
open Textvariable

val clear : (* selection_clear *) icccm list -> unit 

val get : (* selection_get *) icccm list -> string 

(* unsafe *)
val own_get : (* selection_clear *) icccm list -> widget 

(* /unsafe *)


val handle_set : icccm list -> widget -> (int -> int -> unit) -> unit
(** tk invocation: selection handle <icccm list> <widget> <command> *)






val own_set : icccm list -> widget -> unit
(** tk invocation: selection own <icccm list> <widget> *)




