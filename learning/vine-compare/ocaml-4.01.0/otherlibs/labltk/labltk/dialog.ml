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


let create ~parent ~title ~message ~buttons ?name
    ?(bitmap = `Predefined "") ?(default = -1) () =
  let w = Widget.new_atom "toplevel" ?name ~parent in
  let res = tkEval [|TkToken"tk_dialog";
                     cCAMLtoTKwidget w;
                     TkToken title;
                     TkToken message;
                     cCAMLtoTKbitmap bitmap;
                     TkToken (string_of_int default);
                     TkTokenList (List.map ~f:(fun x -> TkToken x) buttons)|]
   in
    int_of_string res
;;


