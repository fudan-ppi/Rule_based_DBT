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
  let w = new_atom "scale" ~parent ?name in
  tkCommand [|TkToken "scale";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_scale_table x) options)
             |];
      w

let create_named parent name options =
  let w = new_atom "scale" ~parent ~name in
  tkCommand [|TkToken "scale";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_scale_table x) options)
             |];
      w

let configure v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_scale_table x) v2)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "configure"|] in 
res

let coords v1 =
let res = tkEval [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "coords"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let coords_at v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "coords";
    TkToken (Printf.sprintf "%g" v2)|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "get"|] in 
float_of_string res

let get_xy v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "get";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
float_of_string res

let identify v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
cTKtoCAMLwidgetElement res

let set v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_scale_table v1;
    TkToken "set";
    TkToken (Printf.sprintf "%g" v2)|]

