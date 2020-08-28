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
(* The toplevel widget *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?background:color ->
  ?borderwidth:int ->
  ?clas:string ->
  ?colormap:colormap ->
  ?container:bool ->
  ?cursor:cursor ->
  ?height:int ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?menu:menu widget ->
  ?relief:relief ->
  ?screen:string ->
  ?takefocus:bool ->
  ?use:string ->
  ?visual:visual ->
  ?width:int ->
  'a widget -> toplevel widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val configure : ?background:color   ->
?borderwidth:int   ->
?clas:string   ->
?colormap:colormap   ->
?container:bool   ->
?cursor:cursor   ->
?height:int   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?menu:menu widget   ->
?relief:relief   ->
?screen:string   ->
?takefocus:bool   ->
?use:string   ->
?visual:visual   ->
?width:int -> toplevel widget -> unit 

val configure_get : toplevel widget -> string 

