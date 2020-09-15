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
(* The listbox widget *)
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

val activate : (* listbox *) widget -> (* listbox *) index -> unit 

val bbox : (* listbox *) widget -> (* listbox *) index -> int * int * int * int 

val configure : (* listbox *) widget -> (* listbox *) options list -> unit 

val configure_get : (* listbox *) widget -> string 

val curselection : (* listbox *) widget -> (* listbox *) index list 

val delete : (* listbox *) widget -> (* listbox *) index -> (* listbox *) index -> unit 

val get : (* listbox *) widget -> (* listbox *) index -> string 

val get_range : (* listbox *) widget -> (* listbox *) index -> (* listbox *) index -> string list 

val index : (* listbox *) widget -> (* listbox *) index -> (* listbox *) index 

val insert : (* listbox *) widget -> (* listbox *) index -> string list -> unit 

val nearest : (* listbox *) widget -> int -> (* listbox *) index 

val scan_dragto : (* listbox *) widget -> int -> int -> unit 

val scan_mark : (* listbox *) widget -> int -> int -> unit 

val see : (* listbox *) widget -> (* listbox *) index -> unit 

val selection_anchor : (* listbox *) widget -> (* listbox *) index -> unit 

val selection_clear : (* listbox *) widget -> (* listbox *) index -> (* listbox *) index -> unit 

val selection_includes : (* listbox *) widget -> (* listbox *) index -> bool 

val selection_set : (* listbox *) widget -> (* listbox *) index -> (* listbox *) index -> unit 

val size : (* listbox *) widget -> int 

val xview : (* listbox *) widget -> scrollValue -> unit 

val xview_get : (* listbox *) widget -> float * float 

val xview_index : (* listbox *) widget -> (* listbox *) index -> unit 

val yview : (* listbox *) widget -> scrollValue -> unit 

val yview_get : (* listbox *) widget -> float * float 

val yview_index : (* listbox *) widget -> (* listbox *) index -> unit 

