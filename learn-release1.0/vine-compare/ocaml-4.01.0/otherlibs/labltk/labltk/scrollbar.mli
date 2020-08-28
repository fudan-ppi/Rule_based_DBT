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
(* The scrollbar widget *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?activebackground:color ->
  ?activerelief:relief ->
  ?background:color ->
  ?borderwidth:int ->
  ?command:(scroll:scrollValue -> unit) ->
  ?cursor:cursor ->
  ?elementborderwidth:int ->
  ?highlightbackground:color ->
  ?highlightcolor:color ->
  ?highlightthickness:int ->
  ?jump:bool ->
  ?orient:orientation ->
  ?relief:relief ->
  ?repeatdelay:int ->
  ?repeatinterval:int ->
  ?takefocus:bool ->
  ?troughcolor:color ->
  ?width:int ->
  'a widget -> scrollbar widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val activate : scrollbar widget -> element:scrollbarElement -> unit 

val activate_get : scrollbar widget -> scrollbarElement 

val configure : ?activebackground:color   ->
?activerelief:relief   ->
?background:color   ->
?borderwidth:int   ->
?command:(scroll:scrollValue -> unit)   ->
?cursor:cursor   ->
?elementborderwidth:int   ->
?highlightbackground:color   ->
?highlightcolor:color   ->
?highlightthickness:int   ->
?jump:bool   ->
?orient:orientation   ->
?relief:relief   ->
?repeatdelay:int   ->
?repeatinterval:int   ->
?takefocus:bool   ->
?troughcolor:color   ->
?width:int -> scrollbar widget -> unit 

val configure_get : scrollbar widget -> string 

val delta : scrollbar widget -> x:int -> y:int -> float 

val fraction : scrollbar widget -> x:int -> y:int -> float 

val get : scrollbar widget -> float * float 

val identify : scale widget -> int -> int -> scrollbarElement 

val old_get : scrollbar widget -> int * int * int * int 

val old_set : scrollbar widget -> total:int -> window:int -> first:int -> last:int -> unit 

val set : scrollbar widget -> first:float -> last:float -> unit 

