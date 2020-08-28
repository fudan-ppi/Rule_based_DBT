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
  scale_options_optionals (fun opts parent ->
     let w = new_atom "scale" ~parent ?name in
     tkCommand [|TkToken "scale";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let configure ?activebackground:eta =
scale_options_optionals ?activebackground:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "configure"|] in 
res

let coords ?at:v2 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "coords";
    TkTokenList (match v2 with
 | Some v2 -> [TkToken (Printf.sprintf "%g" v2)]
 | None -> [])|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "get"|] in 
float_of_string res

let get_xy v1 ~x:v2 ~y:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "get";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
float_of_string res

let identify v1 ~x:v2 ~y:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
cTKtoCAMLscaleElement res

let set v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : scale widget);
    TkToken "set";
    TkToken (Printf.sprintf "%g" v2)|]

