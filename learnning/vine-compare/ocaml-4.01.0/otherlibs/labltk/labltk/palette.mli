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
(* The palette commands  *)
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val bisque : unit -> unit 

val set : ?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?disabledforeground:color   ->
?foreground:color   ->
?highlightcolor:color   ->
?hilightbackground:color   ->
?insertbackground:color   ->
?selectbackground:color   ->
?selectcolor:color   ->
?selectforeground:color   ->
?troughcolor:color -> unit -> unit 

val set_background : color -> unit 

