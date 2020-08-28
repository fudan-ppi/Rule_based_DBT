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
let actual_family ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    TkToken "-family"|] in 
res

let actual_overstrike ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    TkToken "-overstrike"|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let actual_size ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    TkToken "-size"|] in 
int_of_string res

let actual_slant ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    TkToken "-slant"|] in 
res

let actual_underline ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    TkToken "-underline"|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let actual_weight ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    TkToken "-weight"|] in 
res

let configure ?family:eta =
font_options_optionals ?family:eta (fun opts v1 ->
tkCommand [|TkToken "font";
    TkToken "configure";
    cCAMLtoTKfont v1;
    TkTokenList opts|])

let create ?name:v1 =
font_options_optionals (fun opts () ->
let res = tkEval [|TkToken "font";
    TkToken "create";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken v1]
 | None -> []);
    TkTokenList opts|] in 
cTKtoCAMLfont res)

let delete v1 =
tkCommand [|TkToken "font";
    TkToken "delete";
    cCAMLtoTKfont v1|]

let families ?displayof:v1 () =
let res = tkEval [|TkToken "font";
    TkToken "families";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> [])|] in 
(splitlist res)

let measure ?displayof:v3 v1 v2 =
let res = tkEval [|TkToken "font";
    TkToken "measure";
    cCAMLtoTKfont v1;
    TkToken v2;
    TkTokenList (match v3 with
 | Some v3 -> [TkToken "-displayof"; cCAMLtoTKwidget v3]
 | None -> [])|] in 
int_of_string res

let metrics ?displayof:v2 v1 v3 =
let res = tkEval [|TkToken "font";
    TkToken "metrics";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget v2]
 | None -> []);
    cCAMLtoTKfontMetrics v3|] in 
int_of_string res

let names () =
let res = tkEval [|TkToken "font";
    TkToken "names"|] in 
(splitlist res)

