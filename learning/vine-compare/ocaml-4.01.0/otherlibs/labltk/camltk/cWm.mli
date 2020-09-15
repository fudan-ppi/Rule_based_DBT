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
(* The wm commands  *)
open CTk
open Tkintf
open Widget
open Textvariable

val aspect_get : (* toplevel *) widget -> int * int * int * int 

val aspect_set : (* toplevel *) widget -> int -> int -> int -> int -> unit 

val client_get : (* toplevel *) widget -> string 

val client_set : (* toplevel *) widget -> string -> unit 

(* unsafe *)
val colormapwindows_get : (* toplevel *) widget -> widget list 

(* /unsafe *)
val colormapwindows_set : (* toplevel *) widget -> widget list -> unit 

val command_clear : (* toplevel *) widget -> unit 

val command_get : (* toplevel *) widget -> string list 

val command_set : (* toplevel *) widget -> string list -> unit 

val deiconify : (* toplevel *) widget -> unit 

val focusmodel_get : (* toplevel *) widget -> focusModel 

val focusmodel_set : (* toplevel *) widget -> focusModel -> unit 

val frame : (* toplevel *) widget -> string 

val geometry_get : (* toplevel *) widget -> string 

val geometry_set : (* toplevel *) widget -> string -> unit 

val grid_clear : (* toplevel *) widget -> unit 

val grid_get : (* toplevel *) widget -> int * int * int * int 

val grid_set : (* toplevel *) widget -> int -> int -> int -> int -> unit 

val group_clear : (* toplevel *) widget -> unit 

(* unsafe *)
val group_get : (* toplevel *) widget -> widget 

(* /unsafe *)
val group_set : (* toplevel *) widget -> widget -> unit 

val iconbitmap_clear : (* toplevel *) widget -> unit 

val iconbitmap_get : (* toplevel *) widget -> bitmap 

val iconbitmap_set : (* toplevel *) widget -> bitmap -> unit 

val iconify : (* toplevel *) widget -> unit 

val iconmask_clear : (* toplevel *) widget -> unit 

val iconmask_get : (* toplevel *) widget -> bitmap 

val iconmask_set : (* toplevel *) widget -> bitmap -> unit 

val iconname_get : (* toplevel *) widget -> string 

val iconname_set : (* toplevel *) widget -> string -> unit 

val iconposition_clear : (* toplevel *) widget -> unit 

val iconposition_get : (* toplevel *) widget -> int * int 

val iconposition_set : (* toplevel *) widget -> int -> int -> unit 

val iconwindow_clear : (* toplevel *) widget -> unit 

(* unsafe *)
val iconwindow_get : (* toplevel *) widget -> (* toplevel *) widget 

(* /unsafe *)
val iconwindow_set : (* toplevel *) widget -> (* toplevel *) widget -> unit 

val maxsize_get : (* toplevel *) widget -> int * int 

val maxsize_set : (* toplevel *) widget -> int -> int -> unit 

val minsize_get : (* toplevel *) widget -> int * int 

val minsize_set : (* toplevel *) widget -> int -> int -> unit 

val overrideredirect_get : (* toplevel *) widget -> bool 

(* unsafe *)
val overrideredirect_set : (* toplevel *) widget -> bool -> unit 

(* /unsafe *)
val positionfrom_clear : (* toplevel *) widget -> unit 

val positionfrom_get : (* toplevel *) widget -> wmFrom 

val positionfrom_set : (* toplevel *) widget -> wmFrom -> unit 

val protocol_clear : (* toplevel *) widget -> string -> unit 

val protocol_set : (* toplevel *) widget -> string -> (unit -> unit) -> unit 

val protocols : (* toplevel *) widget -> string list 

val resizable_get : (* toplevel *) widget -> bool * bool 

val resizable_set : (* toplevel *) widget -> bool -> bool -> unit 

val sizefrom_clear : (* toplevel *) widget -> unit 

val sizefrom_get : (* toplevel *) widget -> wmFrom 

val sizefrom_set : (* toplevel *) widget -> wmFrom -> unit 

val state : (* toplevel *) widget -> string 

val title_get : (* toplevel *) widget -> string 

val title_set : (* toplevel *) widget -> string -> unit 

val transient_clear : (* toplevel *) widget -> unit 

(* unsafe *)
val transient_get : (* toplevel *) widget -> widget 

(* /unsafe *)
val transient_set : (* toplevel *) widget -> widget -> unit 

val withdraw : (* toplevel *) widget -> unit 

