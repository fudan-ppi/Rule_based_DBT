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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable



val create :
  parent: 'a widget ->
  title: string ->
  message: string ->
  buttons: string list ->
  ?name: string -> ?bitmap: bitmap -> ?default: int -> unit ->int
  (* [create title message bitmap default button_names parent]
     cf. tk_dialog *)




