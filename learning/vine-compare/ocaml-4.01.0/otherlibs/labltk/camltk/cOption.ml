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
open CTk
open Tkintf
open Widget
open Textvariable

open Protocol
let add v1 v2 v3 =
tkCommand [|TkToken "option";
    TkToken "add";
    TkToken v1;
    TkToken v2;
    cCAMLtoTKoptionPriority v3|]

let clear () =
tkCommand [|TkToken "option";
    TkToken "clear"|]

let get v1 v2 v3 =
let res = tkEval [|TkToken "option";
    TkToken "get";
    cCAMLtoTKwidget widget_any_table v1;
    TkToken v2;
    TkToken v3|] in 
res

let readfile v1 v2 =
tkCommand [|TkToken "option";
    TkToken "readfile";
    TkToken v1;
    cCAMLtoTKoptionPriority v2|]

