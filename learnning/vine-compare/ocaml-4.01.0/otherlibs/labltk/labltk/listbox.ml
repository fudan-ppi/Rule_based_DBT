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
  listbox_options_optionals (fun opts parent ->
     let w = new_atom "listbox" ~parent ?name in
     tkCommand [|TkToken "listbox";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let activate v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "activate";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|]

let bbox v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "bbox";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let configure ?background:eta =
listbox_options_optionals ?background:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "configure"|] in 
res

let curselection v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "curselection"|] in 
    List.map ~f: cTKtoCAMLlistbox_index (splitlist res)

let delete v1 ~first:v2 ~last:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "delete";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index]);
    cCAMLtoTKlistbox_index (v3 : [< listbox_index])|]

let get v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "get";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|] in 
res

let get_range v1 ~first:v2 ~last:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "get";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index]);
    cCAMLtoTKlistbox_index (v3 : [< listbox_index])|] in 
(splitlist res)

let index v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "index";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|] in 
cTKtoCAMLlistbox_index res

let insert v1 ~index:v2 ~texts:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "insert";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index]);
    TkTokenList (List.map ~f:(function x -> TkToken x) v3)|]

let nearest v1 ~y:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "nearest";
    TkToken (string_of_int v2)|] in 
cTKtoCAMLlistbox_index res

let scan_dragto v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let scan_mark v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let see v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "see";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|]

let selection_anchor v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "selection";
    TkToken "anchor";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|]

let selection_clear v1 ~first:v2 ~last:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "selection";
    TkToken "clear";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index]);
    cCAMLtoTKlistbox_index (v3 : [< listbox_index])|]

let selection_includes v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "selection";
    TkToken "includes";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let selection_set v1 ~first:v2 ~last:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "selection";
    TkToken "set";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index]);
    cCAMLtoTKlistbox_index (v3 : [< listbox_index])|]

let size v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "size"|] in 
int_of_string res

let xview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let xview_index v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "xview";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|]

let yview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "yview";
    cCAMLtoTKscrollValue v2|]

let yview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "yview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview_index v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : listbox widget);
    TkToken "yview";
    cCAMLtoTKlistbox_index (v2 : [< listbox_index])|]

