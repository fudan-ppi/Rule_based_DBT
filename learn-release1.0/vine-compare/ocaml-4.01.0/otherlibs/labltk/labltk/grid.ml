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
let bbox v1 =
let res = tkEval [|TkToken "grid";
    TkToken "bbox";
    cCAMLtoTKwidget v1|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let bbox_cell v1 ~column:v2 ~row:v3 =
let res = tkEval [|TkToken "grid";
    TkToken "bbox";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let bbox_span v1 ~column1:v2 ~row1:v3 ~column2:v4 ~row2:v5 =
let res = tkEval [|TkToken "grid";
    TkToken "bbox";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5)|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let column_configure ?minsize:eta =
rowcolumnconfigure_options_optionals ?minsize:eta (fun opts v1 v2 ->
tkCommand [|TkToken "grid";
    TkToken "columnconfigure";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2);
    TkTokenList opts|])

let column_configure_get v1 v2 =
let res = tkEval [|TkToken "grid";
    TkToken "columnconfigure";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2)|] in 
res

let configure ?column:eta =
grid_options_optionals ?column:eta (fun opts v1 ->
tkCommand [|TkToken "grid";
    TkToken "configure";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKwidget x) v1);
    TkTokenList opts|])

let forget v1 =
tkCommand [|TkToken "grid";
    TkToken "forget";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKwidget x) v1)|]

let info v1 =
let res = tkEval [|TkToken "grid";
    TkToken "info";
    cCAMLtoTKwidget v1|] in 
res

let location v1 ~x:v2 ~y:v3 =
let res = tkEval [|TkToken "grid";
    TkToken "location";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let propagate_get v1 =
let res = tkEval [|TkToken "grid";
    TkToken "propagate";
    cCAMLtoTKwidget v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let propagate_set v1 v2 =
tkCommand [|TkToken "grid";
    TkToken "propagate";
    cCAMLtoTKwidget v1;
    if v2 then TkToken "1" else TkToken "0"|]

let row_configure ?minsize:eta =
rowcolumnconfigure_options_optionals ?minsize:eta (fun opts v1 v2 ->
tkCommand [|TkToken "grid";
    TkToken "rowconfigure";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2);
    TkTokenList opts|])

let row_configure_get v1 v2 =
let res = tkEval [|TkToken "grid";
    TkToken "rowconfigure";
    cCAMLtoTKwidget v1;
    TkToken (string_of_int v2)|] in 
res

let size v1 =
let res = tkEval [|TkToken "grid";
    TkToken "size";
    cCAMLtoTKwidget v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let slaves ?column:v2 ?row:v3 v1 =
let res = tkEval [|TkToken "grid";
    TkToken "slaves";
    cCAMLtoTKwidget v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkToken "-column"; TkToken (string_of_int v2)]
 | None -> []);
    TkTokenList (match v3 with
 | Some v3 -> [TkToken "-row"; TkToken (string_of_int v3)]
 | None -> [])|] in 
    List.map ~f: cTKtoCAMLwidget (splitlist res)

