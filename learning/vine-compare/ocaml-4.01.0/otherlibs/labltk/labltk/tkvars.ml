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
let library () =
let res = tkEval [|TkToken "$tk_library"|] in 
res

let patchLevel () =
let res = tkEval [|TkToken "$tk_patchLevel"|] in 
res

let set_strictMotif v1 =
tkCommand [|TkToken "set";
    TkToken "tk_strictMotif";
    if v1 then TkToken "1" else TkToken "0"|]

let strictMotif () =
let res = tkEval [|TkToken "$tk_strictMotif"|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let version () =
let res = tkEval [|TkToken "$tk_version"|] in 
res

