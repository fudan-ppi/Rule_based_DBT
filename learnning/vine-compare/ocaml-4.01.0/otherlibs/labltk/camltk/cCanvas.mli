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
(* The canvas widget *)
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

val addtag : (* canvas *) widget -> tagOrId -> searchSpec list -> unit 

val bbox : (* canvas *) widget -> tagOrId list -> int * int * int * int 

val canvasx : ?spacing:units -> (* canvas *) widget -> units -> float 

val canvasx_grid : (* canvas *) widget -> units -> units -> float 

val canvasy : ?spacing:units -> (* canvas *) widget -> units -> float 

val canvasy_grid : (* canvas *) widget -> units -> units -> float 

val configure : (* canvas *) widget -> (* canvas *) options list -> unit 

val configure_arc : (* canvas *) widget -> tagOrId -> (* arc *) options list -> unit 

val configure_bitmap : (* canvas *) widget -> tagOrId -> (* bitmap *) options list -> unit 

val configure_get : (* canvas *) widget -> string 

val configure_image : (* canvas *) widget -> tagOrId -> (* image *) options list -> unit 

val configure_line : (* canvas *) widget -> tagOrId -> (* line *) options list -> unit 

val configure_oval : (* canvas *) widget -> tagOrId -> (* oval *) options list -> unit 

val configure_polygon : (* canvas *) widget -> tagOrId -> (* polygon *) options list -> unit 

val configure_rectangle : (* canvas *) widget -> tagOrId -> (* rectangle *) options list -> unit 

val configure_text : (* canvas *) widget -> tagOrId -> (* canvastext *) options list -> unit 

val configure_window : (* canvas *) widget -> tagOrId -> (* window *) options list -> unit 

val coords_get : (* canvas *) widget -> tagOrId -> float list 

val coords_set : (* canvas *) widget -> tagOrId -> units list -> unit 

val create_arc : (* canvas *) widget -> units -> units -> units -> units -> (* arc *) options list -> tagOrId 

val create_bitmap : (* canvas *) widget -> units -> units -> (* bitmap *) options list -> tagOrId 

val create_image : (* canvas *) widget -> units -> units -> (* image *) options list -> tagOrId 

val create_line : (* canvas *) widget -> units list -> (* line *) options list -> tagOrId 

val create_oval : (* canvas *) widget -> units -> units -> units -> units -> (* oval *) options list -> tagOrId 

val create_polygon : (* canvas *) widget -> units list -> (* polygon *) options list -> tagOrId 

val create_rectangle : (* canvas *) widget -> units -> units -> units -> units -> (* rectangle *) options list -> tagOrId 

val create_text : (* canvas *) widget -> units -> units -> (* canvastext *) options list -> tagOrId 

val create_window : (* canvas *) widget -> units -> units -> (* window *) options list -> tagOrId 

val dchars : (* canvas *) widget -> tagOrId -> (* canvas *) index -> (* canvas *) index -> unit 

val delete : (* canvas *) widget -> tagOrId list -> unit 

val dtag : (* canvas *) widget -> tagOrId -> tagOrId -> unit 

val find : (* canvas *) widget -> searchSpec list -> tagOrId list 

val focus : (* canvas *) widget -> tagOrId -> unit 

val focus_get : (* canvas *) widget -> tagOrId 

val focus_reset : (* canvas *) widget -> unit 

val gettags : (* canvas *) widget -> tagOrId -> tagOrId list 

val icursor : (* canvas *) widget -> tagOrId -> (* canvas *) index -> unit 

val index : (* canvas *) widget -> tagOrId -> (* canvas *) index -> int 

val insert : (* canvas *) widget -> tagOrId -> (* canvas *) index -> string -> unit 

val itemconfigure_get : (* canvas *) widget -> tagOrId -> string 

val lower : ?below:tagOrId -> (* canvas *) widget -> tagOrId -> unit 

val lower_below : (* canvas *) widget -> tagOrId -> tagOrId -> unit 

val lower_bot : (* canvas *) widget -> tagOrId -> unit 

val move : (* canvas *) widget -> tagOrId -> units -> units -> unit 

(* unsafe *)
val postscript : (* canvas *) widget -> (* postscript *) options list -> string 

(* /unsafe *)
val raise : ?above:tagOrId -> (* canvas *) widget -> tagOrId -> unit 

val raise_above : (* canvas *) widget -> tagOrId -> tagOrId -> unit 

val raise_top : (* canvas *) widget -> tagOrId -> unit 

val scale : (* canvas *) widget -> tagOrId -> units -> units -> float -> float -> unit 

val scan_dragto : (* canvas *) widget -> int -> int -> unit 

val scan_mark : (* canvas *) widget -> int -> int -> unit 

val select_adjust : (* canvas *) widget -> tagOrId -> (* canvas *) index -> unit 

val select_clear : (* canvas *) widget -> unit 

val select_from : (* canvas *) widget -> tagOrId -> (* canvas *) index -> unit 

val select_item : (* canvas *) widget -> tagOrId 

val select_to : (* canvas *) widget -> tagOrId -> (* canvas *) index -> unit 

val typeof : (* canvas *) widget -> tagOrId -> canvasItem 

val xview : (* canvas *) widget -> scrollValue -> unit 

val xview_get : (* canvas *) widget -> float * float 

val yview : (* canvas *) widget -> scrollValue -> unit 

val yview_get : (* canvas *) widget -> float * float 



val bind : widget -> tagOrId ->
                    (modifier list * xEvent) list -> bindAction -> unit




