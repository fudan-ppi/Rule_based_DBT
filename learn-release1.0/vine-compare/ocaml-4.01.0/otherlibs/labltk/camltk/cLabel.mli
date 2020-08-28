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
(* The label widget *)
open CTk
open Tkintf
open Widget
open Textvariable

val create : ?name: string -> widget -> options list -> widget 
(** [create ?name parent options] creates a new widget with
    parent [parent] and new patch component [name] if specified.
    Options are restricted to the widget class subset, and checked
    dynamically. *)

val create_named : widget -> string -> options list -> widget 
(** [create_named parent name options] creates a new widget with
    parent [parent] and new patch component [name].
    This function is now obsolete and unified with [create]. *)

val configure : (* label *) widget -> (* label *) options list -> unit 

val configure_get : (* label *) widget -> string 

