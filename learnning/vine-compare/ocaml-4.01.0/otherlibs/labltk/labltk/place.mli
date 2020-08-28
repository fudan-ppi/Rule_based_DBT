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
(* The place commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val configure : ?anchor:anchor   ->
?bordermode:borderMode   ->
?height:int   ->
?inside:'a widget   ->
?relheight:float   ->
?relwidth:float   ->
?relx:float   ->
?rely:float   ->
?width:int   ->
?x:int   ->
?y:int -> 'b widget -> unit 

val forget : 'a widget -> unit 

val info : 'a widget -> string 

val slaves : 'a widget -> any widget list 

