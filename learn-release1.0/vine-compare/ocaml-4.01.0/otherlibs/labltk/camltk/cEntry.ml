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
let create ?name parent options =
  let w = new_atom "entry" ~parent ?name in
  tkCommand [|TkToken "entry";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_entry_table x) options)
             |];
      w

let create_named parent name options =
  let w = new_atom "entry" ~parent ~name in
  tkCommand [|TkToken "entry";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_entry_table x) options)
             |];
      w

let bbox v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "bbox";
    cCAMLtoTKindex index_entry_table v2|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let configure v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_entry_table x) v2)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "configure"|] in 
res

let delete_range v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "delete";
    cCAMLtoTKindex index_entry_table v2;
    cCAMLtoTKindex index_entry_table v3|]

let delete_single v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "delete";
    cCAMLtoTKindex index_entry_table v2|]

let get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "get"|] in 
res

let icursor v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "icursor";
    cCAMLtoTKindex index_entry_table v2|]

let index v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "index";
    cCAMLtoTKindex index_entry_table v2|] in 
int_of_string res

let insert v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_entry_table v2;
    TkToken v3|]

let scan_dragto v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2)|]

let scan_mark v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2)|]

let selection_adjust v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "selection";
    TkToken "adjust";
    cCAMLtoTKindex index_entry_table v2|]

let selection_clear v1 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "selection";
    TkToken "clear"|]

let selection_from v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "selection";
    TkToken "from";
    cCAMLtoTKindex index_entry_table v2|]

let selection_present v1 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "selection";
    TkToken "present"|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let selection_range v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "selection";
    TkToken "range";
    cCAMLtoTKindex index_entry_table v2;
    cCAMLtoTKindex index_entry_table v3|]

let selection_to v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "selection";
    TkToken "to";
    cCAMLtoTKindex index_entry_table v2|]

let xview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let xview_index v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_entry_table v1;
    TkToken "xview";
    cCAMLtoTKindex index_entry_table v2|]

