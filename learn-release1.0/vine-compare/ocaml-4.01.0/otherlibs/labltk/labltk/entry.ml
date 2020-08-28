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
let create ?name =
  entry_options_optionals (fun opts parent ->
     let w = new_atom "entry" ~parent ?name in
     tkCommand [|TkToken "entry";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let bbox v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "bbox";
    cCAMLtoTKentry_index (v2 : [< entry_index])|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let configure ?background:eta =
entry_options_optionals ?background:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "configure"|] in 
res

let delete_range v1 ~start:v2 ~stop:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "delete";
    cCAMLtoTKentry_index (v2 : [< entry_index]);
    cCAMLtoTKentry_index (v3 : [< entry_index])|]

let delete_single v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "delete";
    cCAMLtoTKentry_index (v2 : [< entry_index])|]

let get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "get"|] in 
res

let icursor v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "icursor";
    cCAMLtoTKentry_index (v2 : [< entry_index])|]

let index v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "index";
    cCAMLtoTKentry_index (v2 : [< entry_index])|] in 
int_of_string res

let insert v1 ~index:v2 ~text:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "insert";
    cCAMLtoTKentry_index (v2 : [< entry_index]);
    TkToken v3|]

let scan_dragto v1 ~x:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2)|]

let scan_mark v1 ~x:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2)|]

let selection_adjust v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "selection";
    TkToken "adjust";
    cCAMLtoTKentry_index (v2 : [< entry_index])|]

let selection_clear v1 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "selection";
    TkToken "clear"|]

let selection_from v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "selection";
    TkToken "from";
    cCAMLtoTKentry_index (v2 : [< entry_index])|]

let selection_present v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "selection";
    TkToken "present"|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let selection_range v1 ~start:v2 ~stop:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "selection";
    TkToken "range";
    cCAMLtoTKentry_index (v2 : [< entry_index]);
    cCAMLtoTKentry_index (v3 : [< entry_index])|]

let selection_to v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "selection";
    TkToken "to";
    cCAMLtoTKentry_index (v2 : [< entry_index])|]

let xview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let xview_index v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : entry widget);
    TkToken "xview";
    cCAMLtoTKentry_index (v2 : [< entry_index])|]

