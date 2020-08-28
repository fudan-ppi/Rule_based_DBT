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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?background:color ->
  ?borderwidth:int ->
  ?closeenough:float ->
  ?confine:bool ->
  ?cursor:cursor ->
  ?height:int ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?insertbackground:color ->
  ?insertborderwidth:int ->
  ?insertofftime:int ->
  ?insertontime:int ->
  ?insertwidth:int ->
  ?relief:relief ->
  ?scrollregion:(int * int * int * int) ->
  ?selectbackground:color ->
  ?selectborderwidth:int ->
  ?selectforeground:color ->
  ?takefocus:bool ->
  ?width:int ->
  ?xscrollcommand:(first:float -> last:float -> unit) ->
  ?xscrollincrement:int ->
  ?yscrollcommand:(first:float -> last:float -> unit) ->
  ?yscrollincrement:int ->
  'a widget -> canvas widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val addtag : canvas widget -> tag:string -> specs:searchSpec list -> unit 

val bbox : canvas widget -> tagOrId list -> int * int * int * int 

val canvasx : x:int -> ?spacing:int -> canvas widget -> float 

val canvasy : y:int -> ?spacing:int -> canvas widget -> float 

val configure : ?background:color   ->
?borderwidth:int   ->
?closeenough:float   ->
?confine:bool   ->
?cursor:cursor   ->
?height:int   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?insertbackground:color   ->
?insertborderwidth:int   ->
?insertofftime:int   ->
?insertontime:int   ->
?insertwidth:int   ->
?relief:relief   ->
?scrollregion:(int*int*int*int)   ->
?selectbackground:color   ->
?selectborderwidth:int   ->
?selectforeground:color   ->
?takefocus:bool   ->
?width:int   ->
?xscrollcommand:(first:float -> last:float -> unit)   ->
?xscrollincrement:int   ->
?yscrollcommand:(first:float -> last:float -> unit)   ->
?yscrollincrement:int -> canvas widget -> unit 

val configure_arc : ?dash:string   ->
?extent:float   ->
?fill:color   ->
?outline:color   ->
?outlinestipple:bitmap   ->
?start:float   ->
?stipple:bitmap   ->
?style:arcStyle   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId -> unit 

val configure_bitmap : ?anchor:anchor   ->
?background:color   ->
?bitmap:bitmap   ->
?foreground:color   ->
?tags:string list -> canvas widget -> tagOrId -> unit 

val configure_get : canvas widget -> string 

val configure_image : ?anchor:anchor   ->
?image:[< image]   ->
?tags:string list -> canvas widget -> tagOrId -> unit 

val configure_line : ?arrow:arrowStyle   ->
?arrowshape:(int*int*int)   ->
?capstyle:capStyle   ->
?dash:string   ->
?fill:color   ->
?joinstyle:joinStyle   ->
?smooth:bool   ->
?splinesteps:int   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId -> unit 

val configure_oval : ?dash:string   ->
?fill:color   ->
?outline:color   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId -> unit 

val configure_polygon : ?dash:string   ->
?fill:color   ->
?outline:color   ->
?smooth:bool   ->
?splinesteps:int   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId -> unit 

val configure_rectangle : ?dash:string   ->
?fill:color   ->
?outline:color   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId -> unit 

val configure_text : ?anchor:anchor   ->
?fill:color   ->
?font:string   ->
?justify:justification   ->
?state:canvasTextState   ->
?stipple:bitmap   ->
?tags:string list   ->
?text:string   ->
?width:int -> canvas widget -> tagOrId -> unit 

val configure_window : ?anchor:anchor   ->
?dash:string   ->
?height:int   ->
?tags:string list   ->
?width:int   ->
?window:'a widget -> canvas widget -> tagOrId -> unit 

val coords_get : canvas widget -> tagOrId -> float list 

val coords_set : canvas widget -> tagOrId -> xys:(int * int) list -> unit 

val create_arc : x1:int -> y1:int -> x2:int -> y2:int -> ?dash:string   ->
?extent:float   ->
?fill:color   ->
?outline:color   ->
?outlinestipple:bitmap   ->
?start:float   ->
?stipple:bitmap   ->
?style:arcStyle   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId 

val create_bitmap : x:int -> y:int -> ?anchor:anchor   ->
?background:color   ->
?bitmap:bitmap   ->
?foreground:color   ->
?tags:string list -> canvas widget -> tagOrId 

val create_image : x:int -> y:int -> ?anchor:anchor   ->
?image:[< image]   ->
?tags:string list -> canvas widget -> tagOrId 

val create_line : xys:(int * int) list -> ?arrow:arrowStyle   ->
?arrowshape:(int*int*int)   ->
?capstyle:capStyle   ->
?dash:string   ->
?fill:color   ->
?joinstyle:joinStyle   ->
?smooth:bool   ->
?splinesteps:int   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId 

val create_oval : x1:int -> y1:int -> x2:int -> y2:int -> ?dash:string   ->
?fill:color   ->
?outline:color   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId 

val create_polygon : xys:(int * int) list -> ?dash:string   ->
?fill:color   ->
?outline:color   ->
?smooth:bool   ->
?splinesteps:int   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId 

val create_rectangle : x1:int -> y1:int -> x2:int -> y2:int -> ?dash:string   ->
?fill:color   ->
?outline:color   ->
?stipple:bitmap   ->
?tags:string list   ->
?width:int -> canvas widget -> tagOrId 

val create_text : x:int -> y:int -> ?anchor:anchor   ->
?fill:color   ->
?font:string   ->
?justify:justification   ->
?state:canvasTextState   ->
?stipple:bitmap   ->
?tags:string list   ->
?text:string   ->
?width:int -> canvas widget -> tagOrId 

val create_window : x:int -> y:int -> ?anchor:anchor   ->
?dash:string   ->
?height:int   ->
?tags:string list   ->
?width:int   ->
?window:'a widget -> canvas widget -> tagOrId 

val dchars : canvas widget -> tagOrId -> first:canvas_index -> last:canvas_index -> unit 

val delete : canvas widget -> tagOrId list -> unit 

val dtag : canvas widget -> tagOrId -> tag:string -> unit 

val find : canvas widget -> specs:searchSpec list -> tagOrId list 

val focus : canvas widget -> tagOrId -> unit 

val focus_get : canvas widget -> tagOrId 

val focus_reset : canvas widget -> unit 

val gettags : canvas widget -> tagOrId -> string list 

val icursor : canvas widget -> tagOrId -> index:canvas_index -> unit 

val index : canvas widget -> tagOrId -> index:canvas_index -> int 

val insert : canvas widget -> tagOrId -> before:canvas_index -> text:string -> unit 

val itemconfigure_get : canvas widget -> tagOrId -> string 

val lower : ?below:tagOrId -> canvas widget -> tagOrId -> unit 

val move : canvas widget -> tagOrId -> x:int -> y:int -> unit 

(* unsafe *)
val postscript : ?colormode:colorMode   ->
?file:string   ->
?height:int   ->
?pageanchor:anchor   ->
?pageheight:int   ->
?pagewidth:int   ->
?pagex:int   ->
?pagey:int   ->
?rotate:bool   ->
?width:int   ->
?x:int   ->
?y:int -> canvas widget -> string 

(* /unsafe *)
val raise : ?above:tagOrId -> canvas widget -> tagOrId -> unit 

val scale : canvas widget -> tagOrId -> xorigin:int -> yorigin:int -> xscale:float -> yscale:float -> unit 

val scan_dragto : canvas widget -> x:int -> y:int -> unit 

val scan_mark : canvas widget -> x:int -> y:int -> unit 

val select_adjust : canvas widget -> tagOrId -> index:canvas_index -> unit 

val select_clear : canvas widget -> unit 

val select_from : canvas widget -> tagOrId -> index:canvas_index -> unit 

val select_item : canvas widget -> tagOrId 

val select_to : canvas widget -> tagOrId -> index:canvas_index -> unit 

val typeof : canvas widget -> tagOrId -> canvasItem 

val xview : canvas widget -> scroll:scrollValue -> unit 

val xview_get : canvas widget -> float * float 

val yview : canvas widget -> scroll:scrollValue -> unit 

val yview_get : canvas widget -> float * float 



val bind :
  events: event list ->
  ?extend: bool ->
  ?breakable: bool ->
  ?fields: eventField list ->
  ?action: (eventInfo -> unit) ->
  canvas widget -> tagOrId -> unit




