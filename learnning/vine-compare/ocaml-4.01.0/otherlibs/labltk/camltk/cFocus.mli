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
(* The focus commands  *)
open CTk
open Tkintf
open Widget
open Textvariable

(* unsafe *)
val displayof : widget -> widget 

(* /unsafe *)
val follows_mouse : unit -> unit 

val force : widget -> unit 

(* unsafe *)
val get : ?displayof:widget -> unit -> widget 

(* /unsafe *)
(* unsafe *)
val lastfor : widget -> widget 

(* /unsafe *)
(* unsafe *)
val next : widget -> widget 

(* /unsafe *)
(* unsafe *)
val prev : widget -> widget 

(* /unsafe *)
val set : widget -> unit 

