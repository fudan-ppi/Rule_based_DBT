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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

open Protocol
let add ~path:v1 ?priority:v3 v2 =
tkCommand [|TkToken "option";
    TkToken "add";
    TkToken v1;
    TkToken v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKoptionPriority v3]
 | None -> [])|]

let clear () =
tkCommand [|TkToken "option";
    TkToken "clear"|]

let get v1 ~name:v2 ~clas:v3 =
let res = tkEval [|TkToken "option";
    TkToken "get";
    cCAMLtoTKwidget v1;
    TkToken v2;
    TkToken v3|] in 
res

let readfile ?priority:v2 v1 =
tkCommand [|TkToken "option";
    TkToken "readfile";
    TkToken v1;
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKoptionPriority v2]
 | None -> [])|]

