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
let aspect_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "aspect";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let aspect_set v1 v2 v3 v4 v5 =
tkCommand [|TkToken "wm";
    TkToken "aspect";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5)|]

let client_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "client";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
res

let client_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "client";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken v2|]

let colormapwindows_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "colormapwindows";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    List.map cTKtoCAMLwidget (splitlist res)

let colormapwindows_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "colormapwindows";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> cCAMLtoTKwidget widget_any_table x) v2)])|]

let command_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "command";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let command_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "command";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
(splitlist res)

let command_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "command";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> TkToken x) v2)])|]

let deiconify v1 =
tkCommand [|TkToken "wm";
    TkToken "deiconify";
    cCAMLtoTKwidget widget_toplevel_table v1|]

let focusmodel_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "focusmodel";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLfocusModel res

let focusmodel_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "focusmodel";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKfocusModel v2|]

let frame v1 =
let res = tkEval [|TkToken "wm";
    TkToken "frame";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
res

let geometry_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "geometry";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
res

let geometry_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "geometry";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken v2|]

let grid_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "grid";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken "";
    TkToken "";
    TkToken "";
    TkToken ""|]

let grid_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "grid";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let grid_set v1 v2 v3 v4 v5 =
tkCommand [|TkToken "wm";
    TkToken "grid";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5)|]

let group_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "group";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let group_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "group";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLwidget res

let group_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "group";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKwidget widget_any_table v2|]

let iconbitmap_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconbitmap";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let iconbitmap_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconbitmap";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLbitmap res

let iconbitmap_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconbitmap";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKbitmap v2|]

let iconify v1 =
tkCommand [|TkToken "wm";
    TkToken "iconify";
    cCAMLtoTKwidget widget_toplevel_table v1|]

let iconmask_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconmask";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let iconmask_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconmask";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLbitmap res

let iconmask_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconmask";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKbitmap v2|]

let iconname_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconname";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
res

let iconname_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconname";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken v2|]

let iconposition_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconposition";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken "";
    TkToken ""|]

let iconposition_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconposition";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let iconposition_set v1 v2 v3 =
tkCommand [|TkToken "wm";
    TkToken "iconposition";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let iconwindow_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconwindow";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let iconwindow_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconwindow";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLwidget res

let iconwindow_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconwindow";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKwidget widget_toplevel_table v2|]

let maxsize_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "maxsize";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let maxsize_set v1 v2 v3 =
tkCommand [|TkToken "wm";
    TkToken "maxsize";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let minsize_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "minsize";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let minsize_set v1 v2 v3 =
tkCommand [|TkToken "wm";
    TkToken "minsize";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let overrideredirect_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "overrideredirect";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let overrideredirect_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "overrideredirect";
    cCAMLtoTKwidget widget_toplevel_table v1;
    if v2 then TkToken "1" else TkToken "0"|]

let positionfrom_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "positionfrom";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let positionfrom_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "positionfrom";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLwmFrom res

let positionfrom_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "positionfrom";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKwmFrom v2|]

let protocol_clear v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "protocol";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken v2;
    TkToken ""|]

let protocol_set v1 v2 v3 =
tkCommand [|TkToken "wm";
    TkToken "protocol";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken v2;
    let id = register_callback dummy ~callback: (fun _ -> v3 ()) in TkToken ("camlcb " ^ id)|]

let protocols v1 =
let res = tkEval [|TkToken "wm";
    TkToken "protocol";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
(splitlist res)

let resizable_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "resizable";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = (match (List.hd l) with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s))), List.tl l in
    let r2, l = (match (List.hd l) with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s))), List.tl l in
r1, r2

let resizable_set v1 v2 v3 =
tkCommand [|TkToken "wm";
    TkToken "resizable";
    cCAMLtoTKwidget widget_toplevel_table v1;
    if v2 then TkToken "1" else TkToken "0";
    if v3 then TkToken "1" else TkToken "0"|]

let sizefrom_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "sizefrom";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let sizefrom_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "sizefrom";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLwmFrom res

let sizefrom_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "sizefrom";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKwmFrom v2|]

let state v1 =
let res = tkEval [|TkToken "wm";
    TkToken "state";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
res

let title_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "title";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
res

let title_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "title";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken v2|]

let transient_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "transient";
    cCAMLtoTKwidget widget_toplevel_table v1;
    TkToken ""|]

let transient_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "transient";
    cCAMLtoTKwidget widget_toplevel_table v1|] in 
cTKtoCAMLwidget res

let transient_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "transient";
    cCAMLtoTKwidget widget_toplevel_table v1;
    cCAMLtoTKwidget widget_any_table v2|]

let withdraw v1 =
tkCommand [|TkToken "wm";
    TkToken "withdraw";
    cCAMLtoTKwidget widget_toplevel_table v1|]

