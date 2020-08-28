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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val clear : ?displayof:'a widget   ->
?selection:string -> unit -> unit 

val get : ?displayof:'a widget   ->
?selection:string   ->
?typ:string -> unit -> string 

(* unsafe *)
val own_get : ?displayof:'a widget   ->
?selection:string -> unit -> any widget 

(* /unsafe *)


val handle_set :
    command: (pos:int -> len:int -> string) ->
    ?format: string -> ?selection:string -> ?typ: string -> 'a widget -> unit
(** tk invocation: selection handle <icccm list> <widget> <command> *)






val own_set :
    ?command:(unit->unit) -> ?selection:string -> 'a widget -> unit
(** tk invocation: selection own <icccm list> <widget> *)




