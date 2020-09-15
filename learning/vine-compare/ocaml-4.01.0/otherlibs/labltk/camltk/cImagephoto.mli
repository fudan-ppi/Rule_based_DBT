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
open CTk
open Tkintf
open Widget
open Textvariable

val blank : imagePhoto -> unit 

val configure : imagePhoto -> (* photoimage *) options list -> unit 

val configure_get : imagePhoto -> string 

val copy : imagePhoto -> imagePhoto -> (* copy *) photo list -> unit 

val create : ?name:imagePhoto -> (* photoimage *) options list -> imagePhoto 

val create_named : imagePhoto -> (* photoimage *) options list -> imagePhoto 

val delete : imagePhoto -> unit 

val get : imagePhoto -> int -> int -> int * int * int 

val height : imagePhoto -> int 

val put : imagePhoto -> color list list -> (* put *) photo list -> unit 

val read : imagePhoto -> string -> (* read *) photo list -> unit 

val redither : imagePhoto -> unit 

val width : imagePhoto -> int 

val write : imagePhoto -> string -> (* write *) photo list -> unit 

