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
let append ?displayof:v1 v2 v3 =
tkCommand [|TkToken "clipboard";
    TkToken "append";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> []);
    TkTokenList (List.map (function x -> cCAMLtoTKicccm dummy icccm_clipboard_append_table x) v2);
    TkToken "--";
    TkToken v3|]

let clear ?displayof:v1 () =
tkCommand [|TkToken "clipboard";
    TkToken "clear";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> [])|]

