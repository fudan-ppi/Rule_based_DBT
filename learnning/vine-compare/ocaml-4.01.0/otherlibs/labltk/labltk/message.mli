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
(* The message widget *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?anchor:anchor ->
  ?aspect:int ->
  ?background:color ->
  ?borderwidth:int ->
  ?cursor:cursor ->
  ?font:string ->
  ?foreground:color ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?justify:justification ->
  ?padx:int ->
  ?pady:int ->
  ?relief:relief ->
  ?takefocus:bool ->
  ?text:string ->
  ?textvariable:textVariable ->
  ?width:int ->
  'a widget -> message widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val configure : ?anchor:anchor   ->
?aspect:int   ->
?background:color   ->
?borderwidth:int   ->
?cursor:cursor   ->
?font:string   ->
?foreground:color   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?justify:justification   ->
?padx:int   ->
?pady:int   ->
?relief:relief   ->
?takefocus:bool   ->
?text:string   ->
?textvariable:textVariable   ->
?width:int -> message widget -> unit 

val configure_get : message widget -> string 

