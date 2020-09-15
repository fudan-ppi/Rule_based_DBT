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
(* The button widget *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?activebackground:color ->
  ?activeforeground:color ->
  ?anchor:anchor ->
  ?background:color ->
  ?bitmap:bitmap ->
  ?borderwidth:int ->
  ?command:(unit -> unit) ->
  ?cursor:cursor ->
  ?default:state ->
  ?disabledforeground:color ->
  ?font:string ->
  ?foreground:color ->
  ?height:int ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?image:[< image] ->
  ?justify:justification ->
  ?padx:int ->
  ?pady:int ->
  ?relief:relief ->
  ?state:state ->
  ?takefocus:bool ->
  ?text:string ->
  ?textvariable:textVariable ->
  ?underline:int ->
  ?width:int ->
  ?wraplength:int ->
  'a widget -> button widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val configure : ?activebackground:color   ->
?activeforeground:color   ->
?anchor:anchor   ->
?background:color   ->
?bitmap:bitmap   ->
?borderwidth:int   ->
?command:(unit -> unit)   ->
?cursor:cursor   ->
?default:state   ->
?disabledforeground:color   ->
?font:string   ->
?foreground:color   ->
?height:int   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?image:[< image]   ->
?justify:justification   ->
?padx:int   ->
?pady:int   ->
?relief:relief   ->
?state:state   ->
?takefocus:bool   ->
?text:string   ->
?textvariable:textVariable   ->
?underline:int   ->
?width:int   ->
?wraplength:int -> button widget -> unit 

val configure_get : button widget -> string 

val flash : button widget -> unit 

val invoke : button widget -> unit 

