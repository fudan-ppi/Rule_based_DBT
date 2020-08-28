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
  ?insertbackground:color ->
  ?insertborderwidth:int ->
  ?insertofftime:int ->
  ?insertontime:int ->
  ?insertwidth:int ->
  ?padx:int ->
  ?pady:int ->
  ?relief:relief ->
  ?selectbackground:color ->
  ?selectborderwidth:int ->
  ?selectforeground:color ->
  ?setgrid:bool ->
  ?spacing1:int ->
  ?spacing2:int ->
  ?spacing3:int ->
  ?state:inputState ->
  ?tabs:tabType list ->
  ?takefocus:bool ->
  ?width:int ->
  ?wrap:wrapMode ->
  ?xscrollcommand:(first:float -> last:float -> unit) ->
  ?yscrollcommand:(first:float -> last:float -> unit) ->
  'a widget -> text widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val bbox : text widget -> index:textIndex -> int * int * int * int 

val compare : text widget -> index:textIndex -> op:comparison -> index:textIndex -> bool 

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
?insertbackground:color   ->
?insertborderwidth:int   ->
?insertofftime:int   ->
?insertontime:int   ->
?insertwidth:int   ->
?padx:int   ->
?pady:int   ->
?relief:relief   ->
?selectbackground:color   ->
?selectborderwidth:int   ->
?selectforeground:color   ->
?setgrid:bool   ->
?spacing1:int   ->
?spacing2:int   ->
?spacing3:int   ->
?state:inputState   ->
?tabs:tabType list   ->
?takefocus:bool   ->
?width:int   ->
?wrap:wrapMode   ->
?xscrollcommand:(first:float -> last:float -> unit)   ->
?yscrollcommand:(first:float -> last:float -> unit) -> text widget -> unit 

val configure_get : text widget -> string 

val debug : text widget -> bool -> unit 

val delete : text widget -> start:textIndex -> stop:textIndex -> unit 

val delete_char : text widget -> index:textIndex -> unit 

val dlineinfo : text widget -> index:textIndex -> int * int * int * int * int 

val dump : text widget -> text_dump list -> start:textIndex -> stop:textIndex -> string list 

val dump_char : text widget -> text_dump list -> index:textIndex -> string list 

val get : text widget -> start:textIndex -> stop:textIndex -> string 

val get_char : text widget -> index:textIndex -> string 

val image_configure : name:string -> ?align:alignType   ->
?image:[< image]   ->
?name:string   ->
?padx:int   ->
?pady:int -> text widget -> unit 

val image_configure_get : text widget -> name:string -> string 

val image_create : index:textIndex -> ?align:alignType   ->
?image:[< image]   ->
?name:string   ->
?padx:int   ->
?pady:int -> text widget -> string 

val image_names : text widget -> string list 

val index : text widget -> index:textIndex -> [>`Linechar of int * int] 

val insert : index:textIndex -> text:string -> ?tags:textTag list -> text widget -> unit 

val mark_gravity_get : text widget -> mark:textMark -> markDirection 

val mark_gravity_set : text widget -> mark:textMark -> direction:markDirection -> unit 

val mark_names : text widget -> textMark list 

val mark_next : text widget -> index:textIndex -> textMark 

val mark_previous : text widget -> index:textIndex -> textMark 

val mark_set : text widget -> mark:textMark -> index:textIndex -> unit 

val mark_unset : text widget -> marks:textMark list -> unit 

val scan_dragto : text widget -> x:int -> y:int -> unit 

val scan_mark : text widget -> x:int -> y:int -> unit 

val search : switches:textSearch list -> pattern:string -> start:textIndex -> ?stop:textIndex -> text widget -> [>`Linechar of int * int] 

val see : text widget -> index:textIndex -> unit 

val tag_add : text widget -> tag:textTag -> start:textIndex -> stop:textIndex -> unit 

val tag_add_char : text widget -> tag:textTag -> index:textIndex -> unit 

val tag_configure : tag:textTag -> ?background:color   ->
?bgstipple:bitmap   ->
?borderwidth:int   ->
?fgstipple:bitmap   ->
?font:string   ->
?foreground:color   ->
?justify:justification   ->
?lmargin1:int   ->
?lmargin2:int   ->
?offset:int   ->
?overstrike:bool   ->
?relief:relief   ->
?rmargin:int   ->
?spacing1:int   ->
?spacing2:int   ->
?spacing3:int   ->
?tabs:tabType list   ->
?underline:bool   ->
?wrap:wrapMode -> text widget -> unit 

val tag_delete : text widget -> textTag list -> unit 

val tag_lower : tag:textTag -> ?below:textTag -> text widget -> unit 

val tag_names : ?index:textIndex -> text widget -> textTag list 

val tag_nextrange : tag:textTag -> start:textIndex -> ?stop:textIndex -> text widget -> [>`Linechar of int * int] * [>`Linechar of int * int] 

val tag_prevrange : tag:textTag -> start:textIndex -> ?stop:textIndex -> text widget -> [>`Linechar of int * int] * [>`Linechar of int * int] 

val tag_raise : tag:textTag -> ?above:textTag -> text widget -> unit 

val tag_ranges : text widget -> tag:textTag -> [>`Linechar of int * int] list 

val tag_remove : text widget -> tag:textTag -> start:textIndex -> stop:textIndex -> unit 

val tag_remove_char : text widget -> tag:textTag -> index:textIndex -> unit 

val window_configure : tag:textTag -> ?align:alignType   ->
?padx:int   ->
?pady:int   ->
?stretch:bool   ->
?window:'a widget -> text widget -> unit 

val window_create : index:textIndex -> ?align:alignType   ->
?padx:int   ->
?pady:int   ->
?stretch:bool   ->
?window:'a widget -> text widget -> unit 

val window_names : text widget -> any widget list 

val xview : text widget -> scroll:scrollValue -> unit 

val xview_get : text widget -> float * float 

val yview : text widget -> scroll:scrollValue -> unit 

val yview_get : text widget -> float * float 

val yview_index : text widget -> index:textIndex -> unit 

val yview_index_pickplace : text widget -> index:textIndex -> unit 

val yview_line : text widget -> line:int -> unit 



val tag_bind :
  tag: string -> events: event list ->
  ?extend: bool -> ?breakable: bool -> ?fields: eventField list ->
  ?action: (eventInfo -> unit) -> text widget -> unit




