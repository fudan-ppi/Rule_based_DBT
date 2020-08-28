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
let create ?name parent options =
  let w = new_atom "canvas" ~parent ?name in
  tkCommand [|TkToken "canvas";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_canvas_table x) options)
             |];
      w

let create_named parent name options =
  let w = new_atom "canvas" ~parent ~name in
  tkCommand [|TkToken "canvas";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_canvas_table x) options)
             |];
      w

let addtag v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "addtag";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKsearchSpec x) v3)|]

let bbox v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "bbox";
    TkTokenList (List.map (function x -> cCAMLtoTKtagOrId x) v2)|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let canvasx ?spacing:v2 v1 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "canvasx";
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKunits v2]
 | None -> []);
    cCAMLtoTKunits v3|] in 
float_of_string res

let canvasx_grid v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "canvasx";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3|] in 
float_of_string res

let canvasy ?spacing:v2 v1 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "canvasy";
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKunits v2]
 | None -> []);
    cCAMLtoTKunits v3|] in 
float_of_string res

let canvasy_grid v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "canvasy";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3|] in 
float_of_string res

let configure v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_canvas_table x) v2)|]

let configure_arc v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_arc_table x) v3)|]

let configure_bitmap v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_bitmap_table x) v3)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "configure"|] in 
res

let configure_image v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_image_table x) v3)|]

let configure_line v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_line_table x) v3)|]

let configure_oval v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_oval_table x) v3)|]

let configure_polygon v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_polygon_table x) v3)|]

let configure_rectangle v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_rectangle_table x) v3)|]

let configure_text v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_canvastext_table x) v3)|]

let configure_window v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_window_table x) v3)|]

let coords_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "coords";
    cCAMLtoTKtagOrId v2|] in 
    List.map float_of_string (splitlist res)

let coords_set v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "coords";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map (function x -> cCAMLtoTKunits x) v3)|]

let create_arc v1 v2 v3 v4 v5 v6 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "arc";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4;
    cCAMLtoTKunits v5;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_arc_table x) v6)|] in 
cTKtoCAMLtagOrId res

let create_bitmap v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "bitmap";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_bitmap_table x) v4)|] in 
cTKtoCAMLtagOrId res

let create_image v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "image";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_image_table x) v4)|] in 
cTKtoCAMLtagOrId res

let create_line v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "line";
    TkTokenList (List.map (function x -> cCAMLtoTKunits x) v2);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_line_table x) v3)|] in 
cTKtoCAMLtagOrId res

let create_oval v1 v2 v3 v4 v5 v6 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "oval";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4;
    cCAMLtoTKunits v5;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_oval_table x) v6)|] in 
cTKtoCAMLtagOrId res

let create_polygon v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "polygon";
    TkTokenList (List.map (function x -> cCAMLtoTKunits x) v2);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_polygon_table x) v3)|] in 
cTKtoCAMLtagOrId res

let create_rectangle v1 v2 v3 v4 v5 v6 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "rectangle";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4;
    cCAMLtoTKunits v5;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_rectangle_table x) v6)|] in 
cTKtoCAMLtagOrId res

let create_text v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "text";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_canvastext_table x) v4)|] in 
cTKtoCAMLtagOrId res

let create_window v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "create";
    TkToken "window";
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_window_table x) v4)|] in 
cTKtoCAMLtagOrId res

let dchars v1 v2 v3 v4 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "dchars";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3;
    cCAMLtoTKindex index_canvas_table v4|]

let delete v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "delete";
    TkTokenList (List.map (function x -> cCAMLtoTKtagOrId x) v2)|]

let dtag v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "dtag";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKtagOrId v3|]

let find v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "find";
    TkTokenList (List.map (function x -> cCAMLtoTKsearchSpec x) v2)|] in 
    List.map cTKtoCAMLtagOrId (splitlist res)

let focus v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "focus";
    cCAMLtoTKtagOrId v2|]

let focus_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "focus"|] in 
cTKtoCAMLtagOrId res

let focus_reset v1 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "focus";
    TkToken ""|]

let gettags v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "gettags";
    cCAMLtoTKtagOrId v2|] in 
    List.map cTKtoCAMLtagOrId (splitlist res)

let icursor v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "icursor";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3|]

let index v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "index";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3|] in 
int_of_string res

let insert v1 v2 v3 v4 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "insert";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3;
    TkToken v4|]

let itemconfigure_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2|] in 
res

let lower ?below:v3 v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "lower";
    cCAMLtoTKtagOrId v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtagOrId v3]
 | None -> [])|]

let lower_below v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "lower";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKtagOrId v3|]

let lower_bot v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "lower";
    cCAMLtoTKtagOrId v2|]

let move v1 v2 v3 v4 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "move";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4|]

let postscript v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "postscript";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_postscript_table x) v2)|] in 
res

let raise ?above:v3 v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "raise";
    cCAMLtoTKtagOrId v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtagOrId v3]
 | None -> [])|]

let raise_above v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "raise";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKtagOrId v3|]

let raise_top v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "raise";
    cCAMLtoTKtagOrId v2|]

let scale v1 v2 v3 v4 v5 v6 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "scale";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4;
    TkToken (Printf.sprintf "%g" v5);
    TkToken (Printf.sprintf "%g" v6)|]

let scan_dragto v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let scan_mark v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let select_adjust v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "select";
    TkToken "adjust";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3|]

let select_clear v1 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "select";
    TkToken "clear"|]

let select_from v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "select";
    TkToken "from";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3|]

let select_item v1 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "select";
    TkToken "item"|] in 
cTKtoCAMLtagOrId res

let select_to v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "select";
    TkToken "to";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKindex index_canvas_table v3|]

let typeof v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "type";
    cCAMLtoTKtagOrId v2|] in 
cTKtoCAMLcanvasItem res

let xview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "yview";
    cCAMLtoTKscrollValue v2|]

let yview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_canvas_table v1;
    TkToken "yview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2



let bind widget tag eventsequence action =
  tkCommand [|
    cCAMLtoTKwidget widget_canvas_table widget;
    TkToken "bind";
    cCAMLtoTKtagOrId tag;
    cCAMLtoTKeventSequence eventsequence;
    begin match action with
    | BindRemove -> TkToken ""
    | BindSet (what, f) ->
        let cbId = register_callback widget (wrapeventInfo f what) in
        TkToken ("camlcb " ^ cbId ^ (writeeventField what))
    | BindSetBreakable (what, f) ->
        let cbId = register_callback widget (wrapeventInfo f what) in
        TkToken ("camlcb " ^ cbId ^ (writeeventField what)^
                 " ; if { $BreakBindingsSequence == 1 } then { break ;} ; \
                   set BreakBindingsSequence 0")
    | BindExtend (what, f) ->
        let cbId = register_callback widget (wrapeventInfo f what) in
        TkToken ("+camlcb " ^ cbId ^ (writeeventField what))
    end
 |]
;;


