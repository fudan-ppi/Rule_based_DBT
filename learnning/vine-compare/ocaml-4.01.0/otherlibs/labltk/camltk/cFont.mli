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
open CTk
open Tkintf
open Widget
open Textvariable

val actual_family : ?displayof:widget -> font -> string 

val actual_overstrike : ?displayof:widget -> font -> bool 

val actual_size : ?displayof:widget -> font -> int 

val actual_slant : ?displayof:widget -> font -> string 

val actual_underline : ?displayof:widget -> font -> bool 

val actual_weight : ?displayof:widget -> font -> string 

val configure : font -> (* font *) options list -> unit 

val create : ?name:string -> (* font *) options list -> font 

val create_named : string -> (* font *) options list -> font 

val delete : font -> unit 

val families : ?displayof:widget -> unit -> string list 

val families_displayof : widget -> string list 

val measure : ?displayof:widget -> font -> string -> int 

val measure_displayof : font -> widget -> string -> int 

val metrics : ?displayof:widget -> font -> fontMetrics -> int 

val metrics_displayof : font -> widget -> fontMetrics -> int 

val names : unit -> string list 

