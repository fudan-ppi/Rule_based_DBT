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
(* The scale widget *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?activebackground:color ->
  ?background:color ->
  ?bigincrement:float ->
  ?borderwidth:int ->
  ?command:(float -> unit) ->
  ?cursor:cursor ->
  ?digits:int ->
  ?font:string ->
  ?foreground:color ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?label:string ->
  ?length:int ->
  ?max:float ->
  ?min:float ->
  ?orient:orientation ->
  ?relief:relief ->
  ?repeatdelay:int ->
  ?repeatinterval:int ->
  ?resolution:float ->
  ?showvalue:bool ->
  ?sliderlength:int ->
  ?state:state ->
  ?takefocus:bool ->
  ?tickinterval:float ->
  ?troughcolor:color ->
  ?variable:textVariable ->
  ?width:int ->
  'a widget -> scale widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val configure : ?activebackground:color   ->
?background:color   ->
?bigincrement:float   ->
?borderwidth:int   ->
?command:(float -> unit)   ->
?cursor:cursor   ->
?digits:int   ->
?font:string   ->
?foreground:color   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?label:string   ->
?length:int   ->
?max:float   ->
?min:float   ->
?orient:orientation   ->
?relief:relief   ->
?repeatdelay:int   ->
?repeatinterval:int   ->
?resolution:float   ->
?showvalue:bool   ->
?sliderlength:int   ->
?state:state   ->
?takefocus:bool   ->
?tickinterval:float   ->
?troughcolor:color   ->
?variable:textVariable   ->
?width:int -> scale widget -> unit 

val configure_get : scale widget -> string 

val coords : ?at:float -> scale widget -> int * int 

val get : scale widget -> float 

val get_xy : scale widget -> x:int -> y:int -> float 

val identify : scale widget -> x:int -> y:int -> scaleElement 

val set : scale widget -> float -> unit 

