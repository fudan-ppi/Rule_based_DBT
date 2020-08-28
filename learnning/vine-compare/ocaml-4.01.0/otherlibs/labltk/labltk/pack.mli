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
(* The pack commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val configure : ?after:'a widget   ->
?anchor:anchor   ->
?before:'b widget   ->
?expand:bool   ->
?fill:fillMode   ->
?inside:'c widget   ->
?ipadx:int   ->
?ipady:int   ->
?padx:int   ->
?pady:int   ->
?side:side -> 'd widget list -> unit 

val forget : 'a widget list -> unit 

val info : 'a widget -> string 

val propagate_get : 'a widget -> bool 

val propagate_set : 'a widget -> bool -> unit 

val slaves : 'a widget -> any widget list 

