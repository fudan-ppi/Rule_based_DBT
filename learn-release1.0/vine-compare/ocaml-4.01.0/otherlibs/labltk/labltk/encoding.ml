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
let convertfrom ?encoding:v1 v2 =
let res = tkEval [|TkToken "encoding";
    TkToken "convertfrom";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken v1]
 | None -> []);
    TkToken v2|] in 
res

let convertto ?encoding:v1 v2 =
let res = tkEval [|TkToken "encoding";
    TkToken "convertto";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken v1]
 | None -> []);
    TkToken v2|] in 
res

let names () =
let res = tkEval [|TkToken "encoding";
    TkToken "names"|] in 
(splitlist res)

let system_get () =
let res = tkEval [|TkToken "encoding";
    TkToken "system"|] in 
res

let system_set v1 =
tkCommand [|TkToken "encoding";
    TkToken "system";
    TkToken v1|]

