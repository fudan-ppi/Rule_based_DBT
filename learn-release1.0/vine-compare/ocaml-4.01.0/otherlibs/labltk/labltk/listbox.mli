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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?background:color ->
  ?borderwidth:int ->
  ?cursor:cursor ->
  ?exportselection:bool ->
  ?font:string ->
  ?foreground:color ->
  ?height:int ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?relief:relief ->
  ?selectbackground:color ->
  ?selectborderwidth:int ->
  ?selectforeground:color ->
  ?selectmode:selectModeType ->
  ?setgrid:bool ->
  ?takefocus:bool ->
  ?width:int ->
  ?xscrollcommand:(first:float -> last:float -> unit) ->
  ?yscrollcommand:(first:float -> last:float -> unit) ->
  'a widget -> listbox widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val activate : listbox widget -> index:listbox_index -> unit 

val bbox : listbox widget -> index:listbox_index -> int * int * int * int 

val configure : ?background:color   ->
?borderwidth:int   ->
?cursor:cursor   ->
?exportselection:bool   ->
?font:string   ->
?foreground:color   ->
?height:int   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?relief:relief   ->
?selectbackground:color   ->
?selectborderwidth:int   ->
?selectforeground:color   ->
?selectmode:selectModeType   ->
?setgrid:bool   ->
?takefocus:bool   ->
?width:int   ->
?xscrollcommand:(first:float -> last:float -> unit)   ->
?yscrollcommand:(first:float -> last:float -> unit) -> listbox widget -> unit 

val configure_get : listbox widget -> string 

val curselection : listbox widget -> [>`Num of int] list 

val delete : listbox widget -> first:listbox_index -> last:listbox_index -> unit 

val get : listbox widget -> index:listbox_index -> string 

val get_range : listbox widget -> first:listbox_index -> last:listbox_index -> string list 

val index : listbox widget -> index:listbox_index -> [>`Num of int] 

val insert : listbox widget -> index:listbox_index -> texts:string list -> unit 

val nearest : listbox widget -> y:int -> [>`Num of int] 

val scan_dragto : listbox widget -> x:int -> y:int -> unit 

val scan_mark : listbox widget -> x:int -> y:int -> unit 

val see : listbox widget -> index:listbox_index -> unit 

val selection_anchor : listbox widget -> index:listbox_index -> unit 

val selection_clear : listbox widget -> first:listbox_index -> last:listbox_index -> unit 

val selection_includes : listbox widget -> index:listbox_index -> bool 

val selection_set : listbox widget -> first:listbox_index -> last:listbox_index -> unit 

val size : listbox widget -> int 

val xview : listbox widget -> scroll:scrollValue -> unit 

val xview_get : listbox widget -> float * float 

val xview_index : listbox widget -> index:listbox_index -> unit 

val yview : listbox widget -> scroll:scrollValue -> unit 

val yview_get : listbox widget -> float * float 

val yview_index : listbox widget -> index:listbox_index -> unit 

