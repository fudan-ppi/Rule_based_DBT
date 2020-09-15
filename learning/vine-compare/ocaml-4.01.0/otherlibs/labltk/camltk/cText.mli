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
(* The text widget *)
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

val bbox : (* text *) widget -> textIndex -> int * int * int * int 

val compare : (* text *) widget -> textIndex -> comparison -> textIndex -> bool 

val configure : (* text *) widget -> (* text *) options list -> unit 

val configure_get : (* text *) widget -> string 

val debug : (* text *) widget -> bool -> unit 

val delete : (* text *) widget -> textIndex -> textIndex -> unit 

val delete_char : (* text *) widget -> textIndex -> unit 

val dlineinfo : (* text *) widget -> textIndex -> int * int * int * int * int 

val dump : (* text *) widget -> text_dump list -> textIndex -> textIndex -> string list 

val dump_char : (* text *) widget -> text_dump list -> textIndex -> string list 

val get : (* text *) widget -> textIndex -> textIndex -> string 

val get_char : (* text *) widget -> textIndex -> string 

val image_configure : (* text *) widget -> string -> (* embeddedi *) options list -> unit 

val image_configure_get : (* text *) widget -> string -> string 

val image_create : (* text *) widget -> textIndex -> (* embeddedi *) options list -> string 

val image_names : (* text *) widget -> string list 

val index : (* text *) widget -> textIndex -> (* text *) index 

val insert : (* text *) widget -> textIndex -> string -> textTag list -> unit 

val mark_gravity_get : (* text *) widget -> textMark -> markDirection 

val mark_gravity_set : (* text *) widget -> textMark -> markDirection -> unit 

val mark_names : (* text *) widget -> textMark list 

val mark_next : (* text *) widget -> textIndex -> textMark 

val mark_previous : (* text *) widget -> textIndex -> textMark 

val mark_set : (* text *) widget -> textMark -> textIndex -> unit 

val mark_unset : (* text *) widget -> textMark list -> unit 

val scan_dragto : (* text *) widget -> int -> int -> unit 

val scan_mark : (* text *) widget -> int -> int -> unit 

val search : (* text *) widget -> textSearch list -> string -> textIndex -> textIndex -> index 

val see : (* text *) widget -> textIndex -> unit 

val tag_add : (* text *) widget -> textTag -> textIndex -> textIndex -> unit 

val tag_add_char : (* text *) widget -> textTag -> textIndex -> unit 

val tag_allnames : (* text *) widget -> textTag list 

val tag_configure : (* text *) widget -> textTag -> (* texttag *) options list -> unit 

val tag_delete : (* text *) widget -> textTag list -> unit 

val tag_indexnames : (* text *) widget -> textIndex -> textTag list 

val tag_lower : ?below:textTag -> (* text *) widget -> textTag -> unit 

val tag_lower_below : (* text *) widget -> textTag -> textTag -> unit 

val tag_lower_bot : (* text *) widget -> textTag -> unit 

val tag_names : ?index:textIndex -> (* text *) widget -> textTag list 

val tag_nextrange : (* text *) widget -> textTag -> textIndex -> textIndex -> index * index 

val tag_prevrange : (* text *) widget -> textTag -> textIndex -> textIndex -> index * index 

val tag_raise : ?above:textTag -> (* text *) widget -> textTag -> unit 

val tag_raise_above : (* text *) widget -> textTag -> textTag -> unit 

val tag_raise_top : (* text *) widget -> textTag -> unit 

val tag_ranges : (* text *) widget -> textTag -> index list 

val tag_remove : (* text *) widget -> textTag -> textIndex -> textIndex -> unit 

val tag_remove_char : (* text *) widget -> textTag -> textIndex -> unit 

val window_configure : (* text *) widget -> textTag -> (* embeddedw *) options list -> unit 

val window_create : (* text *) widget -> textIndex -> (* embeddedw *) options list -> unit 

val window_names : (* text *) widget -> widget list 

val xview : (* text *) widget -> scrollValue -> unit 

val xview_get : (* text *) widget -> float * float 

val yview : (* text *) widget -> scrollValue -> unit 

val yview_get : (* text *) widget -> float * float 

val yview_index : (* text *) widget -> textIndex -> unit 

val yview_index_pickplace : (* text *) widget -> textIndex -> unit 

val yview_line : (* text *) widget -> int -> unit 



val tag_bind:
    widget -> textTag -> (modifier list * xEvent) list -> bindAction -> unit




