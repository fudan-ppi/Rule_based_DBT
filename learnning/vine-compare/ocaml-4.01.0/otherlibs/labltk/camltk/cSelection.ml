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
let clear v1 =
tkCommand [|TkToken "selection";
    TkToken "clear";
    TkTokenList (List.map (function x -> cCAMLtoTKicccm dummy icccm_selection_clear_table x) v1)|]

let get v1 =
let res = tkEval [|TkToken "selection";
    TkToken "get";
    TkTokenList (List.map (function x -> cCAMLtoTKicccm dummy icccm_selection_get_table x) v1)|] in 
res

let own_get v1 =
let res = tkEval [|TkToken "selection";
    TkToken "own";
    TkTokenList (List.map (function x -> cCAMLtoTKicccm dummy icccm_selection_clear_table x) v1)|] in 
cTKtoCAMLwidget res



(* The function *must* use tkreturn *)
let handle_set opts w cmd =
  tkCommand [|
    TkToken"selection";
    TkToken"handle";
    TkTokenList
      (List.map
         (function x -> cCAMLtoTKicccm w icccm_selection_handle_table x)
         opts);
    cCAMLtoTKwidget widget_any_table w;
    let id = register_callback w (function args ->
      let (a1,args) = int_of_string (List.hd args), List.tl args in
      let (a2,args) = int_of_string (List.hd args), List.tl args in
      cmd a1 a2) in
    TkToken ("camlcb "^id)
  |]
;;




(* builtin to handle callback association to widget *)
let own_set v1 v2 =
  tkCommand [|
    TkToken"selection";
    TkToken"own";
    TkTokenList
      (List.map
         (function x -> cCAMLtoTKicccm v2 icccm_selection_ownset_table x)
         v1);
    cCAMLtoTKwidget widget_any_table v2
  |]
;;


