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
let current ?displayof:v1 () =
let res = tkEval [|TkToken "grab";
    TkToken "current";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKwidget v1]
 | None -> [])|] in 
    List.map ~f: cTKtoCAMLwidget (splitlist res)

let release v1 =
tkCommand [|TkToken "grab";
    TkToken "release";
    cCAMLtoTKwidget v1|]

let set ?global:v1 v2 =
tkCommand [|TkToken "grab";
    TkToken "set";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKgrabGlobal v1]
 | None -> []);
    cCAMLtoTKwidget v2|]

let status v1 =
let res = tkEval [|TkToken "grab";
    TkToken "status";
    cCAMLtoTKwidget v1|] in 
cTKtoCAMLgrabStatus res

