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
  let w = new_atom "listbox" ~parent ?name in
  tkCommand [|TkToken "listbox";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_listbox_table x) options)
             |];
      w

let create_named parent name options =
  let w = new_atom "listbox" ~parent ~name in
  tkCommand [|TkToken "listbox";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_listbox_table x) options)
             |];
      w

let activate v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "activate";
    cCAMLtoTKindex index_listbox_table v2|]

let bbox v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "bbox";
    cCAMLtoTKindex index_listbox_table v2|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let configure v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_listbox_table x) v2)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "configure"|] in 
res

let curselection v1 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "curselection"|] in 
    List.map cTKtoCAMLindex (splitlist res)

let delete v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "delete";
    cCAMLtoTKindex index_listbox_table v2;
    cCAMLtoTKindex index_listbox_table v3|]

let get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "get";
    cCAMLtoTKindex index_listbox_table v2|] in 
res

let get_range v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "get";
    cCAMLtoTKindex index_listbox_table v2;
    cCAMLtoTKindex index_listbox_table v3|] in 
(splitlist res)

let index v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "index";
    cCAMLtoTKindex index_listbox_table v2|] in 
cTKtoCAMLindex res

let insert v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_listbox_table v2;
    TkTokenList (List.map (function x -> TkToken x) v3)|]

let nearest v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "nearest";
    TkToken (string_of_int v2)|] in 
cTKtoCAMLindex res

let scan_dragto v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let scan_mark v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let see v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "see";
    cCAMLtoTKindex index_listbox_table v2|]

let selection_anchor v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "selection";
    TkToken "anchor";
    cCAMLtoTKindex index_listbox_table v2|]

let selection_clear v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "selection";
    TkToken "clear";
    cCAMLtoTKindex index_listbox_table v2;
    cCAMLtoTKindex index_listbox_table v3|]

let selection_includes v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "selection";
    TkToken "includes";
    cCAMLtoTKindex index_listbox_table v2|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let selection_set v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "selection";
    TkToken "set";
    cCAMLtoTKindex index_listbox_table v2;
    cCAMLtoTKindex index_listbox_table v3|]

let size v1 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "size"|] in 
int_of_string res

let xview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let xview_index v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "xview";
    cCAMLtoTKindex index_listbox_table v2|]

let yview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "yview";
    cCAMLtoTKscrollValue v2|]

let yview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "yview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview_index v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_listbox_table v1;
    TkToken "yview";
    cCAMLtoTKindex index_listbox_table v2|]

