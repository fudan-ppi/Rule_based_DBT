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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

(* unsafe *)
val displayof : 'a widget -> any widget 

(* /unsafe *)
val follows_mouse : unit -> unit 

val force : 'a widget -> unit 

(* unsafe *)
val get : ?displayof:'a widget -> unit -> any widget 

(* /unsafe *)
(* unsafe *)
val lastfor : 'a widget -> any widget 

(* /unsafe *)
(* unsafe *)
val next : 'a widget -> any widget 

(* /unsafe *)
(* unsafe *)
val prev : 'a widget -> any widget 

(* /unsafe *)
val set : 'a widget -> unit 

