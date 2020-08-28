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
let aspect_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "aspect";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let aspect_set v1 ~minnum:v2 ~mindenom:v3 ~maxnum:v4 ~maxdenom:v5 =
tkCommand [|TkToken "wm";
    TkToken "aspect";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5)|]

let client_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "client";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
res

let client_set v1 ~name:v2 =
tkCommand [|TkToken "wm";
    TkToken "client";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken v2|]

let colormapwindows_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "colormapwindows";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
    List.map ~f: cTKtoCAMLwidget (splitlist res)

let colormapwindows_set v1 ~windows:v2 =
tkCommand [|TkToken "wm";
    TkToken "colormapwindows";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> cCAMLtoTKwidget x) v2)])|]

let command_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "command";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let command_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "command";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
(splitlist res)

let command_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "command";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> TkToken x) v2)])|]

let deiconify v1 =
tkCommand [|TkToken "wm";
    TkToken "deiconify";
    cCAMLtoTKwidget (v1 : toplevel widget)|]

let focusmodel_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "focusmodel";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLfocusModel res

let focusmodel_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "focusmodel";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKfocusModel v2|]

let frame v1 =
let res = tkEval [|TkToken "wm";
    TkToken "frame";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
res

let geometry_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "geometry";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
res

let geometry_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "geometry";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken v2|]

let grid_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "grid";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken "";
    TkToken "";
    TkToken "";
    TkToken ""|]

let grid_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "grid";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let grid_set v1 ~basewidth:v2 ~baseheight:v3 ~widthinc:v4 ~heightinc:v5 =
tkCommand [|TkToken "wm";
    TkToken "grid";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5)|]

let group_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "group";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let group_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "group";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLwidget res

let group_set v1 ~leader:v2 =
tkCommand [|TkToken "wm";
    TkToken "group";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKwidget v2|]

let iconbitmap_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconbitmap";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let iconbitmap_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconbitmap";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLbitmap res

let iconbitmap_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconbitmap";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKbitmap v2|]

let iconify v1 =
tkCommand [|TkToken "wm";
    TkToken "iconify";
    cCAMLtoTKwidget (v1 : toplevel widget)|]

let iconmask_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconmask";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let iconmask_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconmask";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLbitmap res

let iconmask_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconmask";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKbitmap v2|]

let iconname_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconname";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
res

let iconname_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "iconname";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken v2|]

let iconposition_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconposition";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken "";
    TkToken ""|]

let iconposition_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconposition";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let iconposition_set v1 ~x:v2 ~y:v3 =
tkCommand [|TkToken "wm";
    TkToken "iconposition";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let iconwindow_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "iconwindow";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let iconwindow_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "iconwindow";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
(Obj.magic (cTKtoCAMLwidget  res ) : toplevel widget)

let iconwindow_set v1 ~icon:v2 =
tkCommand [|TkToken "wm";
    TkToken "iconwindow";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKwidget (v2 : toplevel widget)|]

let maxsize_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "maxsize";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let maxsize_set v1 ~width:v2 ~height:v3 =
tkCommand [|TkToken "wm";
    TkToken "maxsize";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let minsize_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "minsize";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let minsize_set v1 ~width:v2 ~height:v3 =
tkCommand [|TkToken "wm";
    TkToken "minsize";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let overrideredirect_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "overrideredirect";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let overrideredirect_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "overrideredirect";
    cCAMLtoTKwidget (v1 : toplevel widget);
    if v2 then TkToken "1" else TkToken "0"|]

let positionfrom_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "positionfrom";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let positionfrom_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "positionfrom";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLwmFrom res

let positionfrom_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "positionfrom";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKwmFrom v2|]

let protocol_clear v1 ~name:v2 =
tkCommand [|TkToken "wm";
    TkToken "protocol";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken v2;
    TkToken ""|]

let protocol_set v1 ~name:v2 ~command:v3 =
tkCommand [|TkToken "wm";
    TkToken "protocol";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken v2;
    let id = register_callback dummy ~callback: (fun _ -> v3 ()) in TkToken ("camlcb " ^ id)|]

let protocols v1 =
let res = tkEval [|TkToken "wm";
    TkToken "protocol";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
(splitlist res)

let resizable_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "resizable";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
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

let resizable_set v1 ~width:v2 ~height:v3 =
tkCommand [|TkToken "wm";
    TkToken "resizable";
    cCAMLtoTKwidget (v1 : toplevel widget);
    if v2 then TkToken "1" else TkToken "0";
    if v3 then TkToken "1" else TkToken "0"|]

let sizefrom_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "sizefrom";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let sizefrom_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "sizefrom";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLwmFrom res

let sizefrom_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "sizefrom";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKwmFrom v2|]

let state v1 =
let res = tkEval [|TkToken "wm";
    TkToken "state";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
res

let title_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "title";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
res

let title_set v1 v2 =
tkCommand [|TkToken "wm";
    TkToken "title";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken v2|]

let transient_clear v1 =
tkCommand [|TkToken "wm";
    TkToken "transient";
    cCAMLtoTKwidget (v1 : toplevel widget);
    TkToken ""|]

let transient_get v1 =
let res = tkEval [|TkToken "wm";
    TkToken "transient";
    cCAMLtoTKwidget (v1 : toplevel widget)|] in 
cTKtoCAMLwidget res

let transient_set v1 ~master:v2 =
tkCommand [|TkToken "wm";
    TkToken "transient";
    cCAMLtoTKwidget (v1 : toplevel widget);
    cCAMLtoTKwidget v2|]

let withdraw v1 =
tkCommand [|TkToken "wm";
    TkToken "withdraw";
    cCAMLtoTKwidget (v1 : toplevel widget)|]

