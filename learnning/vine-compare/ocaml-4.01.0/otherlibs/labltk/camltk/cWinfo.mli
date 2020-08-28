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
(* The winfo commands  *)
open CTk
open Tkintf
open Widget
open Textvariable

(* unsafe *)
val atom : ?displayof:widget -> string -> atomId 

(* /unsafe *)
(* unsafe *)
val atom_displayof : widget -> string -> atomId 

(* /unsafe *)
(* unsafe *)
val atomname : ?displayof:widget -> atomId -> string 

(* /unsafe *)
(* unsafe *)
val atomname_displayof : widget -> atomId -> string 

(* /unsafe *)
val cells : widget -> int 

val children : widget -> widget list 

val class_name : widget -> string 

val colormapfull : widget -> bool 

(* unsafe *)
val containing : ?displayof:widget -> int -> int -> widget 

(* /unsafe *)
(* unsafe *)
val containing_displayof : widget -> int -> int -> widget 

(* /unsafe *)
val depth : widget -> int 

val exists : widget -> bool 

val fpixels : widget -> units -> float 

val geometry : widget -> string 

val height : widget -> int 

(* unsafe *)
val id : widget -> string 

(* /unsafe *)
(* unsafe *)
val interps : ?displayof:widget -> unit -> string list 

(* /unsafe *)
(* unsafe *)
val interps_displayof : widget -> string list 

(* /unsafe *)
val ismapped : widget -> bool 

val manager : widget -> string 

val name : widget -> string 

(* unsafe *)
val parent : widget -> widget 

(* /unsafe *)
(* unsafe *)
val pathname : ?displayof:widget -> string -> widget 

(* /unsafe *)
(* unsafe *)
val pathname_displayof : widget -> string -> widget 

(* /unsafe *)
val pixels : widget -> units -> int 

val pointerx : widget -> int 

val pointerxy : widget -> int * int 

val pointery : widget -> int 

val reqheight : widget -> int 

val reqwidth : widget -> int 

val rgb : widget -> color -> int * int * int 

val rootx : widget -> int 

val rooty : widget -> int 

(* unsafe *)
val screen : widget -> string 

(* /unsafe *)
val screencells : widget -> int 

val screendepth : widget -> int 

val screenheight : widget -> int 

val screenmmheight : widget -> int 

val screenmmwidth : widget -> int 

val screenvisual : widget -> string 

val screenwidth : widget -> int 

(* unsafe *)
val server : widget -> string 

(* /unsafe *)
(* unsafe *)
val toplevel : widget -> (* toplevel *) widget 

(* /unsafe *)
val viewable : widget -> bool 

val visual : widget -> string 

val visualid : widget -> int 

val visualsavailable : ?includeids:int list -> widget -> string 

val vrootheight : widget -> int 

val vrootwidth : widget -> int 

val vrootx : widget -> int 

val vrooty : widget -> int 

val width : widget -> int 

val x : widget -> int 

val y : widget -> int 



val contained : int -> int -> widget -> bool
(** [contained x y w] returns true if (x,y) is in w *)




