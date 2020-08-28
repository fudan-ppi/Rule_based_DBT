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
(* The label widget *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?anchor:anchor ->
  ?background:color ->
  ?bitmap:bitmap ->
  ?borderwidth:int ->
  ?cursor:cursor ->
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
  ?takefocus:bool ->
  ?text:string ->
  ?textvariable:textVariable ->
  ?textwidth:int ->
  ?underline:int ->
  ?width:int ->
  ?wraplength:int ->
  'a widget -> label widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val configure : ?anchor:anchor   ->
?background:color   ->
?bitmap:bitmap   ->
?borderwidth:int   ->
?cursor:cursor   ->
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
?takefocus:bool   ->
?text:string   ->
?textvariable:textVariable   ->
?textwidth:int   ->
?underline:int   ->
?width:int   ->
?wraplength:int -> label widget -> unit 

val configure_get : label widget -> string 

