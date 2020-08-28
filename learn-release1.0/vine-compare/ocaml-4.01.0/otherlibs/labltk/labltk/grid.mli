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
(* The grid commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val bbox : 'a widget -> int * int * int * int 

val bbox_cell : 'a widget -> column:int -> row:int -> int * int * int * int 

val bbox_span : 'a widget -> column1:int -> row1:int -> column2:int -> row2:int -> int * int * int * int 

val column_configure : ?minsize:int   ->
?pad:int   ->
?weight:int -> 'a widget -> int -> unit 

val column_configure_get : 'a widget -> int -> string 

val configure : ?column:int   ->
?columnspan:int   ->
?inside:'a widget   ->
?ipadx:int   ->
?ipady:int   ->
?padx:int   ->
?pady:int   ->
?row:int   ->
?rowspan:int   ->
?sticky:string -> 'b widget list -> unit 

val forget : 'a widget list -> unit 

val info : 'a widget -> string 

val location : 'a widget -> x:int -> y:int -> int * int 

val propagate_get : 'a widget -> bool 

val propagate_set : 'a widget -> bool -> unit 

val row_configure : ?minsize:int   ->
?pad:int   ->
?weight:int -> 'a widget -> int -> unit 

val row_configure_get : 'a widget -> int -> string 

val size : 'a widget -> int * int 

val slaves : ?column:int -> ?row:int -> 'a widget -> any widget list 

