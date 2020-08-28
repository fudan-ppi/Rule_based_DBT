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
let create ?name =
  canvas_options_optionals (fun opts parent ->
     let w = new_atom "canvas" ~parent ?name in
     tkCommand [|TkToken "canvas";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let addtag v1 ~tag:v2 ~specs:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "addtag";
    TkToken v2;
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKsearchSpec x) v3)|]

let bbox v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "bbox";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtagOrId x) v2)|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let canvasx ~x:v2 ?spacing:v3 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "canvasx";
    TkToken (string_of_int v2);
    TkTokenList (match v3 with
 | Some v3 -> [TkToken (string_of_int v3)]
 | None -> [])|] in 
float_of_string res

let canvasy ~y:v2 ?spacing:v3 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "canvasy";
    TkToken (string_of_int v2);
    TkTokenList (match v3 with
 | Some v3 -> [TkToken (string_of_int v3)]
 | None -> [])|] in 
float_of_string res

let configure ?background:eta =
canvas_options_optionals ?background:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_arc ?dash:eta =
arc_options_optionals ?dash:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_bitmap ?anchor:eta =
bitmap_options_optionals ?anchor:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "configure"|] in 
res

let configure_image ?anchor:eta =
image_options_optionals ?anchor:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_line ?arrow:eta =
line_options_optionals ?arrow:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_oval ?dash:eta =
oval_options_optionals ?dash:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_polygon ?dash:eta =
polygon_options_optionals ?dash:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_rectangle ?dash:eta =
rectangle_options_optionals ?dash:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_text ?anchor:eta =
canvastext_options_optionals ?anchor:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let configure_window ?anchor:eta =
window_options_optionals ?anchor:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2;
    TkTokenList opts|])

let coords_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "coords";
    cCAMLtoTKtagOrId v2|] in 
    List.map ~f: float_of_string (splitlist res)

let coords_set v1 v2 ~xys:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "coords";
    cCAMLtoTKtagOrId v2;
    TkTokenList (List.map ~f:(function x -> let z1,z2 = x in TkTokenList [ TkToken (string_of_int z1); TkToken (string_of_int z2) ]) v3)|]

let create_arc ~x1:v2 ~y1:v3 ~x2:v4 ~y2:v5 =
arc_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "arc";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_bitmap ~x:v2 ~y:v3 =
bitmap_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "bitmap";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_image ~x:v2 ~y:v3 =
image_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "image";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_line ~xys:v2 =
line_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "line";
    TkTokenList (List.map ~f:(function x -> let z1,z2 = x in TkTokenList [ TkToken (string_of_int z1); TkToken (string_of_int z2) ]) v2);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_oval ~x1:v2 ~y1:v3 ~x2:v4 ~y2:v5 =
oval_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "oval";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_polygon ~xys:v2 =
polygon_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "polygon";
    TkTokenList (List.map ~f:(function x -> let z1,z2 = x in TkTokenList [ TkToken (string_of_int z1); TkToken (string_of_int z2) ]) v2);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_rectangle ~x1:v2 ~y1:v3 ~x2:v4 ~y2:v5 =
rectangle_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "rectangle";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (string_of_int v5);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_text ~x:v2 ~y:v3 =
canvastext_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "text";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let create_window ~x:v2 ~y:v3 =
window_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "create";
    TkToken "window";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkTokenList opts|] in 
cTKtoCAMLtagOrId res)

let dchars v1 v2 ~first:v3 ~last:v4 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "dchars";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index]);
    cCAMLtoTKcanvas_index (v4 : [< canvas_index])|]

let delete v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "delete";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtagOrId x) v2)|]

let dtag v1 v2 ~tag:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "dtag";
    cCAMLtoTKtagOrId v2;
    TkToken v3|]

let find v1 ~specs:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "find";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKsearchSpec x) v2)|] in 
    List.map ~f: cTKtoCAMLtagOrId (splitlist res)

let focus v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "focus";
    cCAMLtoTKtagOrId v2|]

let focus_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "focus"|] in 
cTKtoCAMLtagOrId res

let focus_reset v1 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "focus";
    TkToken ""|]

let gettags v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "gettags";
    cCAMLtoTKtagOrId v2|] in 
(splitlist res)

let icursor v1 v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "icursor";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index])|]

let index v1 v2 ~index:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "index";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index])|] in 
int_of_string res

let insert v1 v2 ~before:v3 ~text:v4 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "insert";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index]);
    TkToken v4|]

let itemconfigure_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "itemconfigure";
    cCAMLtoTKtagOrId v2|] in 
res

let lower ?below:v3 v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "lower";
    cCAMLtoTKtagOrId v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtagOrId v3]
 | None -> [])|]

let move v1 v2 ~x:v3 ~y:v4 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "move";
    cCAMLtoTKtagOrId v2;
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)|]

let postscript ?colormode:eta =
postscript_options_optionals ?colormode:eta (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "postscript";
    TkTokenList opts|] in 
res)

let raise ?above:v3 v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "raise";
    cCAMLtoTKtagOrId v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtagOrId v3]
 | None -> [])|]

let scale v1 v2 ~xorigin:v3 ~yorigin:v4 ~xscale:v5 ~yscale:v6 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "scale";
    cCAMLtoTKtagOrId v2;
    TkToken (string_of_int v3);
    TkToken (string_of_int v4);
    TkToken (Printf.sprintf "%g" v5);
    TkToken (Printf.sprintf "%g" v6)|]

let scan_dragto v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let scan_mark v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let select_adjust v1 v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "select";
    TkToken "adjust";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index])|]

let select_clear v1 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "select";
    TkToken "clear"|]

let select_from v1 v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "select";
    TkToken "from";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index])|]

let select_item v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "select";
    TkToken "item"|] in 
cTKtoCAMLtagOrId res

let select_to v1 v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "select";
    TkToken "to";
    cCAMLtoTKtagOrId v2;
    cCAMLtoTKcanvas_index (v3 : [< canvas_index])|]

let typeof v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "type";
    cCAMLtoTKtagOrId v2|] in 
cTKtoCAMLcanvasItem res

let xview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "yview";
    cCAMLtoTKscrollValue v2|]

let yview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : canvas widget);
    TkToken "yview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2



let bind ~events
    ?(extend = false) ?(breakable = false) ?(fields = [])
    ?action widget tag =
  tkCommand
    [| cCAMLtoTKwidget widget;
       TkToken "bind";
       cCAMLtoTKtagOrId tag;
       cCAMLtoTKeventSequence events;
       begin match action with None -> TkToken ""
       | Some f ->
           let cbId =
             register_callback widget ~callback: (wrapeventInfo f fields) in
           let cb = if extend then "+camlcb " else "camlcb " in
           let cb = cb ^ cbId ^ writeeventField fields in
           let cb =
             if breakable then
               cb ^ " ; if { $BreakBindingsSequence == 1 } then { break ;}"
               ^ " ; set BreakBindingsSequence 0"
             else cb in
           TkToken cb
       end
     |]
;;


