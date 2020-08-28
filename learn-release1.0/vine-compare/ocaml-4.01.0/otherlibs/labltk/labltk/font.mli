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
(* The font commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val actual_family : ?displayof:'a widget -> font -> string 

val actual_overstrike : ?displayof:'a widget -> font -> bool 

val actual_size : ?displayof:'a widget -> font -> int 

val actual_slant : ?displayof:'a widget -> font -> string 

val actual_underline : ?displayof:'a widget -> font -> bool 

val actual_weight : ?displayof:'a widget -> font -> string 

val configure : ?family:string   ->
?overstrike:bool   ->
?size:int   ->
?slant:slant   ->
?underline:bool   ->
?weight:weight -> font -> unit 

val create : ?name:string -> ?family:string   ->
?overstrike:bool   ->
?size:int   ->
?slant:slant   ->
?underline:bool   ->
?weight:weight -> unit -> font 

val delete : font -> unit 

val families : ?displayof:'a widget -> unit -> string list 

val measure : ?displayof:'a widget -> font -> string -> int 

val metrics : ?displayof:'a widget -> font -> fontMetrics -> int 

val names : unit -> string list 

