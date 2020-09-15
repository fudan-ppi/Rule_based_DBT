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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

(* unsafe *)
val atom : ?displayof:'a widget -> string -> atomId 

(* /unsafe *)
(* unsafe *)
val atomname : ?displayof:'a widget -> atomId -> string 

(* /unsafe *)
val cells : 'a widget -> int 

val children : 'a widget -> any widget list 

val class_name : 'a widget -> string 

val colormapfull : 'a widget -> bool 

(* unsafe *)
val containing : x:int -> y:int -> ?displayof:'a widget -> unit -> any widget 

(* /unsafe *)
val depth : 'a widget -> int 

val exists : 'a widget -> bool 

val fpixels : 'a widget -> length:units -> float 

val geometry : 'a widget -> string 

val height : 'a widget -> int 

(* unsafe *)
val id : 'a widget -> string 

(* /unsafe *)
(* unsafe *)
val interps : ?displayof:'a widget -> unit -> string list 

(* /unsafe *)
val ismapped : 'a widget -> bool 

val manager : 'a widget -> string 

val name : 'a widget -> string 

(* unsafe *)
val parent : 'a widget -> any widget 

(* /unsafe *)
(* unsafe *)
val pathname : ?displayof:'a widget -> string -> any widget 

(* /unsafe *)
val pixels : 'a widget -> length:units -> int 

val pointerx : 'a widget -> int 

val pointerxy : 'a widget -> int * int 

val pointery : 'a widget -> int 

val reqheight : 'a widget -> int 

val reqwidth : 'a widget -> int 

val rgb : 'a widget -> color:color -> int * int * int 

val rootx : 'a widget -> int 

val rooty : 'a widget -> int 

(* unsafe *)
val screen : 'a widget -> string 

(* /unsafe *)
val screencells : 'a widget -> int 

val screendepth : 'a widget -> int 

val screenheight : 'a widget -> int 

val screenmmheight : 'a widget -> int 

val screenmmwidth : 'a widget -> int 

val screenvisual : 'a widget -> string 

val screenwidth : 'a widget -> int 

(* unsafe *)
val server : 'a widget -> string 

(* /unsafe *)
(* unsafe *)
val toplevel : 'a widget -> toplevel widget 

(* /unsafe *)
val viewable : 'a widget -> bool 

val visual : 'a widget -> string 

val visualid : 'a widget -> int 

val visualsavailable : ?includeids:int list -> 'a widget -> string 

val vrootheight : 'a widget -> int 

val vrootwidth : 'a widget -> int 

val vrootx : 'a widget -> int 

val vrooty : 'a widget -> int 

val width : 'a widget -> int 

val x : 'a widget -> int 

val y : 'a widget -> int 



val contained : x:int -> y:int -> 'a widget -> bool
(** [contained x y w] returns true if (x,y) is in w *)




