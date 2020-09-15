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
(* The entry widget *)
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

val bbox : (* entry *) widget -> (* entry *) index -> int * int * int * int 

val configure : (* entry *) widget -> (* entry *) options list -> unit 

val configure_get : (* entry *) widget -> string 

val delete_range : (* entry *) widget -> (* entry *) index -> (* entry *) index -> unit 

val delete_single : (* entry *) widget -> (* entry *) index -> unit 

val get : (* entry *) widget -> string 

val icursor : (* entry *) widget -> (* entry *) index -> unit 

val index : (* entry *) widget -> (* entry *) index -> int 

val insert : (* entry *) widget -> (* entry *) index -> string -> unit 

val scan_dragto : (* entry *) widget -> int -> unit 

val scan_mark : (* entry *) widget -> int -> unit 

val selection_adjust : (* entry *) widget -> (* entry *) index -> unit 

val selection_clear : (* entry *) widget -> unit 

val selection_from : (* entry *) widget -> (* entry *) index -> unit 

val selection_present : (* entry *) widget -> bool 

val selection_range : (* entry *) widget -> (* entry *) index -> (* entry *) index -> unit 

val selection_to : (* entry *) widget -> (* entry *) index -> unit 

val xview : (* entry *) widget -> scrollValue -> unit 

val xview_get : (* entry *) widget -> float * float 

val xview_get : (* entry *) widget -> float * float 

val xview_index : (* entry *) widget -> (* entry *) index -> unit 

