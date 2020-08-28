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
let current ?displayof:v1 () =
let res = tkEval [|TkToken "grab";
    TkToken "current";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKwidget widget_any_table v1]
 | None -> [])|] in 
    List.map cTKtoCAMLwidget (splitlist res)

let current_of v1 =
let res = tkEval [|TkToken "grab";
    TkToken "current";
    cCAMLtoTKwidget widget_any_table v1|] in 
    List.map cTKtoCAMLwidget (splitlist res)

let release v1 =
tkCommand [|TkToken "grab";
    TkToken "release";
    cCAMLtoTKwidget widget_any_table v1|]

let set ?global:v1 v2 =
tkCommand [|TkToken "grab";
    TkToken "set";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKgrabGlobal v1]
 | None -> []);
    cCAMLtoTKwidget widget_any_table v2|]

let set_global v1 =
tkCommand [|TkToken "grab";
    TkToken "set";
    TkToken "-global";
    cCAMLtoTKwidget widget_any_table v1|]

let status v1 =
let res = tkEval [|TkToken "grab";
    TkToken "status";
    cCAMLtoTKwidget widget_any_table v1|] in 
cTKtoCAMLgrabStatus res

