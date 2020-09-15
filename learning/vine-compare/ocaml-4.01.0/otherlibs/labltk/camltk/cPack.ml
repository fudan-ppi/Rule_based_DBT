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
let configure v1 v2 =
tkCommand [|TkToken "pack";
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKwidget widget_any_table x) v1);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_pack_table x) v2)|]

let forget v1 =
tkCommand [|TkToken "pack";
    TkToken "forget";
    TkTokenList (List.map (function x -> cCAMLtoTKwidget widget_any_table x) v1)|]

let info v1 =
let res = tkEval [|TkToken "pack";
    TkToken "info";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let propagate_get v1 =
let res = tkEval [|TkToken "pack";
    TkToken "propagate";
    cCAMLtoTKwidget widget_any_table v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let propagate_set v1 v2 =
tkCommand [|TkToken "pack";
    TkToken "propagate";
    cCAMLtoTKwidget widget_any_table v1;
    if v2 then TkToken "1" else TkToken "0"|]

let slaves v1 =
let res = tkEval [|TkToken "pack";
    TkToken "slaves";
    cCAMLtoTKwidget widget_any_table v1|] in 
    List.map cTKtoCAMLwidget (splitlist res)

