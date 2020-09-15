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
let variable v1 =
tkCommand [|TkToken "tkwait";
    TkToken "variable";
    cCAMLtoTKtextVariable v1|]

let visibility v1 =
tkCommand [|TkToken "tkwait";
    TkToken "visibility";
    cCAMLtoTKwidget widget_any_table v1|]

let window v1 =
tkCommand [|TkToken "tkwait";
    TkToken "window";
    cCAMLtoTKwidget widget_any_table v1|]

