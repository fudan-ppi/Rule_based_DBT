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
(* The scrollbar widget *)
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

val activate : (* scrollbar *) widget -> (* scrollbar *) widgetElement -> unit 

val activate_get : (* scrollbar *) widget -> widgetElement 

val configure : (* scrollbar *) widget -> (* scrollbar *) options list -> unit 

val configure_get : (* scrollbar *) widget -> string 

val delta : (* scrollbar *) widget -> int -> int -> float 

val fraction : (* scrollbar *) widget -> int -> int -> float 

val get : (* scrollbar *) widget -> float * float 

val identify : (* scale *) widget -> int -> int -> widgetElement 

val old_get : (* scrollbar *) widget -> int * int * int * int 

val old_set : (* scrollbar *) widget -> int -> int -> int -> int -> unit 

val set : (* scrollbar *) widget -> float -> float -> unit 

