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
(* The imagebitmap commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val configure : ?background:color   ->
?data:string   ->
?file:string   ->
?foreground:color   ->
?maskdata:string   ->
?maskfile:string -> imageBitmap -> unit 

val configure_get : imageBitmap -> string 

val create : ?name:imageBitmap -> ?background:color   ->
?data:string   ->
?file:string   ->
?foreground:color   ->
?maskdata:string   ->
?maskfile:string -> unit -> [>`Bitmap of (string)] 

val delete : imageBitmap -> unit 

val height : imageBitmap -> int 

val width : imageBitmap -> int 

