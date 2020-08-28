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
let bisque () =
tkCommand [|TkToken "tk_bisque"|]

let set ?activebackground:eta =
any_tkPalette_optionals ?activebackground:eta (fun opts () ->
tkCommand [|TkToken "tk_setPalette";
    TkTokenList opts|])

let set_background v1 =
tkCommand [|TkToken "tk_setPalette";
    cCAMLtoTKcolor v1|]

