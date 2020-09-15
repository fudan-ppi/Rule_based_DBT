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
(* The optionmenu commands  *)
open CTk
open Tkintf
open Widget
open Textvariable



(* Support for tk_optionMenu *)
val create: ?name: string ->
  widget -> textVariable -> string list -> widget * widget
(** [create ?name parent var options] creates a multi-option menubutton and
   its associated menu. The option is also stored in the variable.
   Both widgets (menubutton and menu) are returned. *)




