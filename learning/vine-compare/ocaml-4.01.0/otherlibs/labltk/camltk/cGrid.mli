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
open CTk
open Tkintf
open Widget
open Textvariable

val bbox : widget -> int * int * int * int 

val bbox_cell : widget -> int -> int -> int * int * int * int 

val bbox_span : widget -> int -> int -> int -> int -> int * int * int * int 

val column_configure : widget -> int -> (* rowcolumnconfigure *) options list -> unit 

val column_configure_get : widget -> int -> string 

val column_slaves : widget -> int -> widget list 

val configure : widget list -> (* grid *) options list -> unit 

val forget : widget list -> unit 

val info : widget -> string 

val location : widget -> units -> units -> int * int 

val propagate_get : widget -> bool 

val propagate_set : widget -> bool -> unit 

val row_configure : widget -> int -> (* rowcolumnconfigure *) options list -> unit 

val row_configure_get : widget -> int -> string 

val row_slaves : widget -> int -> widget list 

val size : widget -> int * int 

val slaves : ?column:int -> ?row:int -> widget -> widget list 

