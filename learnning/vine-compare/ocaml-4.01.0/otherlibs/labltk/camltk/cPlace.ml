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
tkCommand [|TkToken "place";
    TkToken "configure";
    cCAMLtoTKwidget widget_any_table v1;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_place_table x) v2)|]

let forget v1 =
tkCommand [|TkToken "place";
    TkToken "forget";
    cCAMLtoTKwidget widget_any_table v1|]

let info v1 =
let res = tkEval [|TkToken "place";
    TkToken "info";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let slaves v1 =
let res = tkEval [|TkToken "place";
    TkToken "slaves";
    cCAMLtoTKwidget widget_any_table v1|] in 
    List.map cTKtoCAMLwidget (splitlist res)

