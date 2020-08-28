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
let configure ?background:eta =
bitmapimage_options_optionals ?background:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKimageBitmap v1;
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKimageBitmap v1;
    TkToken "configure"|] in 
res

let create ?name:v1 =
bitmapimage_options_optionals (fun opts () ->
let res = tkEval [|TkToken "image";
    TkToken "create";
    TkToken "bitmap";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKimageBitmap v1]
 | None -> []);
    TkTokenList opts|] in 
cTKtoCAMLimageBitmap res)

let delete v1 =
tkCommand [|TkToken "image";
    TkToken "delete";
    cCAMLtoTKimageBitmap v1|]

let height v1 =
let res = tkEval [|TkToken "image";
    TkToken "height";
    cCAMLtoTKimageBitmap v1|] in 
int_of_string res

let width v1 =
let res = tkEval [|TkToken "image";
    TkToken "width";
    cCAMLtoTKimageBitmap v1|] in 
int_of_string res

