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
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?insertbackground:color ->
  ?insertborderwidth:int ->
  ?insertofftime:int ->
  ?insertontime:int ->
  ?insertwidth:int ->
  ?justify:justification ->
  ?relief:relief ->
  ?selectbackground:color ->
  ?selectborderwidth:int ->
  ?selectforeground:color ->
  ?show:char ->
  ?state:inputState ->
  ?takefocus:bool ->
  ?textvariable:textVariable ->
  ?width:int ->
  ?xscrollcommand:(first:float -> last:float -> unit) ->
  'a widget -> entry widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val bbox : entry widget -> entry_index -> int * int * int * int 

val configure : ?background:color   ->
?borderwidth:int   ->
?cursor:cursor   ->
?exportselection:bool   ->
?font:string   ->
?foreground:color   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?insertbackground:color   ->
?insertborderwidth:int   ->
?insertofftime:int   ->
?insertontime:int   ->
?insertwidth:int   ->
?justify:justification   ->
?relief:relief   ->
?selectbackground:color   ->
?selectborderwidth:int   ->
?selectforeground:color   ->
?show:char   ->
?state:inputState   ->
?takefocus:bool   ->
?textvariable:textVariable   ->
?width:int   ->
?xscrollcommand:(first:float -> last:float -> unit) -> entry widget -> unit 

val configure_get : entry widget -> string 

val delete_range : entry widget -> start:entry_index -> stop:entry_index -> unit 

val delete_single : entry widget -> index:entry_index -> unit 

val get : entry widget -> string 

val icursor : entry widget -> index:entry_index -> unit 

val index : entry widget -> index:entry_index -> int 

val insert : entry widget -> index:entry_index -> text:string -> unit 

val scan_dragto : entry widget -> x:int -> unit 

val scan_mark : entry widget -> x:int -> unit 

val selection_adjust : entry widget -> index:entry_index -> unit 

val selection_clear : entry widget -> unit 

val selection_from : entry widget -> index:entry_index -> unit 

val selection_present : entry widget -> bool 

val selection_range : entry widget -> start:entry_index -> stop:entry_index -> unit 

val selection_to : entry widget -> index:entry_index -> unit 

val xview : entry widget -> scroll:scrollValue -> unit 

val xview_get : entry widget -> float * float 

val xview_get : entry widget -> float * float 

val xview_index : entry widget -> index:entry_index -> unit 

