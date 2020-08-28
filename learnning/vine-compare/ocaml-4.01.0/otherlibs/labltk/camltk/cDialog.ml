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


let create ?name parent title mesg bitmap def buttons =
  let w = Widget.new_atom "toplevel" ~parent ?name in
  let res = tkEval [|TkToken"tk_dialog";
                     cCAMLtoTKwidget widget_any_table w;
                     TkToken title;
                     TkToken mesg;
                     cCAMLtoTKbitmap bitmap;
                     TkToken (string_of_int def);
                     TkTokenList (List.map (function x -> TkToken x) buttons)|]
   in
    int_of_string res
;;

let create_named parent name title mesg bitmap def buttons =
  let w = Widget.new_atom "toplevel" ~parent ~name in
  let res = tkEval [|TkToken"tk_dialog";
                     cCAMLtoTKwidget widget_any_table w;
                     TkToken title;
                     TkToken mesg;
                     cCAMLtoTKbitmap bitmap;
                     TkToken (string_of_int def);
                     TkTokenList (List.map (function x -> TkToken x) buttons)|]
   in
    int_of_string res
;;


