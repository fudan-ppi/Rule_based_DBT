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
let actual_family ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
 | None -> []);
    TkToken "-family"|] in 
res

let actual_overstrike ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
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
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
 | None -> []);
    TkToken "-size"|] in 
int_of_string res

let actual_slant ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
 | None -> []);
    TkToken "-slant"|] in 
res

let actual_underline ?displayof:v2 v1 =
let res = tkEval [|TkToken "font";
    TkToken "actual";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
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
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
 | None -> []);
    TkToken "-weight"|] in 
res

let configure v1 v2 =
tkCommand [|TkToken "font";
    TkToken "configure";
    cCAMLtoTKfont v1;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_font_table x) v2)|]

let create ?name:v1 v2 =
let res = tkEval [|TkToken "font";
    TkToken "create";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken v1]
 | None -> []);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_font_table x) v2)|] in 
cTKtoCAMLfont res

let create_named v1 v2 =
let res = tkEval [|TkToken "font";
    TkToken "create";
    TkToken v1;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_font_table x) v2)|] in 
cTKtoCAMLfont res

let delete v1 =
tkCommand [|TkToken "font";
    TkToken "delete";
    cCAMLtoTKfont v1|]

let families ?displayof:v1 () =
let res = tkEval [|TkToken "font";
    TkToken "families";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> [])|] in 
(splitlist res)

let families_displayof v1 =
let res = tkEval [|TkToken "font";
    TkToken "families";
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1|] in 
(splitlist res)

let measure ?displayof:v3 v1 v2 =
let res = tkEval [|TkToken "font";
    TkToken "measure";
    cCAMLtoTKfont v1;
    TkToken v2;
    TkTokenList (match v3 with
 | Some v3 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v3]
 | None -> [])|] in 
int_of_string res

let measure_displayof v1 v2 v3 =
let res = tkEval [|TkToken "font";
    TkToken "measure";
    cCAMLtoTKfont v1;
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v2;
    TkToken v3|] in 
int_of_string res

let metrics ?displayof:v2 v1 v3 =
let res = tkEval [|TkToken "font";
    TkToken "metrics";
    cCAMLtoTKfont v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v2]
 | None -> []);
    cCAMLtoTKfontMetrics v3|] in 
int_of_string res

let metrics_displayof v1 v2 v3 =
let res = tkEval [|TkToken "font";
    TkToken "metrics";
    cCAMLtoTKfont v1;
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v2;
    cCAMLtoTKfontMetrics v3|] in 
int_of_string res

let names () =
let res = tkEval [|TkToken "font";
    TkToken "names"|] in 
(splitlist res)

