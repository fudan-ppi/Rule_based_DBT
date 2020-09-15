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
let clear ?displayof:eta =
selection_clear_icccm_optionals ?displayof:eta (fun opts () ->
tkCommand [|TkToken "selection";
    TkToken "clear";
    TkTokenList opts|])

let get ?displayof:eta =
selection_get_icccm_optionals ?displayof:eta (fun opts () ->
let res = tkEval [|TkToken "selection";
    TkToken "get";
    TkTokenList opts|] in 
res)

let own_get ?displayof:eta =
selection_clear_icccm_optionals ?displayof:eta (fun opts () ->
let res = tkEval [|TkToken "selection";
    TkToken "own";
    TkTokenList opts|] in 
cTKtoCAMLwidget res)



(* The function *must* use tkreturn *)
let handle_set ~command =
selection_handle_icccm_optionals (fun opts w ->
  tkCommand [|
    TkToken"selection";
    TkToken"handle";
    TkTokenList opts;
    cCAMLtoTKwidget w;
    let id = register_callback w ~callback:
        begin fun args ->
          let pos = int_of_string (List.hd args) in
          let len = int_of_string (List.nth args 1) in
          tkreturn (command ~pos ~len)
        end
    in TkToken ("camlcb " ^ id)
  |])
;;




(* builtin to handle callback association to widget *)
let own_set ?command =
  selection_ownset_icccm_optionals ?command (fun opts w ->
    tkCommand [|
      TkToken"selection";
      TkToken"own";
      TkTokenList opts;
      cCAMLtoTKwidget w
  |])
;;


