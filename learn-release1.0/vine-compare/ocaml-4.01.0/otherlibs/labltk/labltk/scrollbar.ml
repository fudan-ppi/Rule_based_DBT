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
  scrollbar_options_optionals (fun opts parent ->
     let w = new_atom "scrollbar" ~parent ?name in
     tkCommand [|TkToken "scrollbar";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let activate v1 ~element:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "activate";
    cCAMLtoTKscrollbarElement v2|]

let activate_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "activate"|] in 
cTKtoCAMLscrollbarElement res

let configure ?activebackground:eta =
scrollbar_options_optionals ?activebackground:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "configure"|] in 
res

let delta v1 ~x:v2 ~y:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "delta";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
float_of_string res

let fraction v1 ~x:v2 ~y:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "fraction";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
float_of_string res

let get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "get"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let identify v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "identify";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
cTKtoCAMLscrollbarElement res

let old_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "get"|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let old_set v1 ~total:v2 ~window:v3 ~first:v4 ~last:v5 =
tkCommand [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "set";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5)|]

let set v1 ~first:v2 ~last:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : scrollbar widget);
    TkToken "set";
    TkToken (Printf.sprintf "%g" v2);
    TkToken (Printf.sprintf "%g" v3)|]

