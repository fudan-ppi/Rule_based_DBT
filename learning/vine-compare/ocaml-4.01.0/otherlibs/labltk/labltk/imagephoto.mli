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
(* The imagephoto commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val blank : imagePhoto -> unit 

val configure : ?data:string   ->
?file:string   ->
?format:string   ->
?gamma:float   ->
?height:int   ->
?palette:paletteType   ->
?width:int -> imagePhoto -> unit 

val configure_get : imagePhoto -> string 

val copy : src:imagePhoto -> ?dst_area:(int*int*int*int)   ->
?shrink:unit   ->
?src_area:(int*int*int*int)   ->
?subsample:(int*int)   ->
?zoom:(int*int) -> imagePhoto -> unit 

val create : ?name:imagePhoto -> ?data:string   ->
?file:string   ->
?format:string   ->
?gamma:float   ->
?height:int   ->
?palette:paletteType   ->
?width:int -> unit -> [>`Photo of (string)] 

val delete : imagePhoto -> unit 

val get : imagePhoto -> x:int -> y:int -> int * int * int 

val height : imagePhoto -> int 

val put : ?dst_area:(int*int*int*int) -> imagePhoto -> color list list -> unit 

val read : file:string -> ?dst_pos:(int*int)   ->
?format:string   ->
?shrink:unit   ->
?src_area:(int*int*int*int) -> imagePhoto -> unit 

val redither : imagePhoto -> unit 

val width : imagePhoto -> int 

val write : file:string -> ?format:string   ->
?src_area:(int*int*int*int) -> imagePhoto -> unit 

