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
  text_options_optionals (fun opts parent ->
     let w = new_atom "text" ~parent ?name in
     tkCommand [|TkToken "text";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let bbox v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "bbox";
    cCAMLtoTKtextIndex v2|] in 
    let l = splitlist res in
      if List.length l <> 4
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4

let compare v1 ~index:v2 ~op:v3 ~index:v4 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "compare";
    cCAMLtoTKtextIndex v2;
    cCAMLtoTKcomparison v3;
    cCAMLtoTKtextIndex v4|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let configure ?background:eta =
text_options_optionals ?background:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "configure"|] in 
res

let debug v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "debug";
    if v2 then TkToken "1" else TkToken "0"|]

let delete v1 ~start:v2 ~stop:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "delete";
    cCAMLtoTKtextIndex v2;
    cCAMLtoTKtextIndex v3|]

let delete_char v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "delete";
    cCAMLtoTKtextIndex v2|]

let dlineinfo v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "dlineinfo";
    cCAMLtoTKtextIndex v2|] in 
    let l = splitlist res in
      if List.length l <> 5
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
    let r4, l = int_of_string (List.hd l), List.tl l in
    let r5, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3, r4, r5

let dump v1 v2 ~start:v3 ~stop:v4 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "dump";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtext_dump v1 x) v2);
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|] in 
(splitlist res)

let dump_char v1 v2 ~index:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "dump";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtext_dump v1 x) v2);
    cCAMLtoTKtextIndex v3|] in 
(splitlist res)

let get v1 ~start:v2 ~stop:v3 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "get";
    cCAMLtoTKtextIndex v2;
    cCAMLtoTKtextIndex v3|] in 
res

let get_char v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "get";
    cCAMLtoTKtextIndex v2|] in 
res

let image_configure ~name:v2 =
embeddedi_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "image";
    TkToken "configure";
    TkToken v2;
    TkTokenList opts|])

let image_configure_get v1 ~name:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "image";
    TkToken "cgets";
    TkToken v2|] in 
res

let image_create ~index:v2 =
embeddedi_options_optionals (fun opts v1 ->
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "image";
    TkToken "create";
    cCAMLtoTKtextIndex v2;
    TkTokenList opts|] in 
res)

let image_names v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "image";
    TkToken "names"|] in 
(splitlist res)

let index v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "index";
    cCAMLtoTKtextIndex v2|] in 
cTKtoCAMLtext_index res

let insert ~index:v2 ~text:v3 ?tags:v4 v1 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "insert";
    cCAMLtoTKtextIndex v2;
    TkToken v3;
    TkTokenList (match v4 with
 | Some v4 -> [TkTokenList (List.map ~f:(function x -> cCAMLtoTKtextTag x) v4)]
 | None -> [])|]

let mark_gravity_get v1 ~mark:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "gravity";
    cCAMLtoTKtextMark v2|] in 
cTKtoCAMLmarkDirection res

let mark_gravity_set v1 ~mark:v2 ~direction:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "gravity";
    cCAMLtoTKtextMark v2;
    cCAMLtoTKmarkDirection v3|]

let mark_names v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "names"|] in 
    List.map ~f: cTKtoCAMLtextMark (splitlist res)

let mark_next v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "next";
    cCAMLtoTKtextIndex v2|] in 
cTKtoCAMLtextMark res

let mark_previous v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "previous";
    cCAMLtoTKtextIndex v2|] in 
cTKtoCAMLtextMark res

let mark_set v1 ~mark:v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "set";
    cCAMLtoTKtextMark v2;
    cCAMLtoTKtextIndex v3|]

let mark_unset v1 ~marks:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "mark";
    TkToken "unset";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtextMark x) v2)|]

let scan_dragto v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let scan_mark v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let search ~switches:v2 ~pattern:v3 ~start:v4 ?stop:v5 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "search";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtextSearch x) v2);
    TkToken "--";
    TkToken v3;
    cCAMLtoTKtextIndex v4;
    TkTokenList (match v5 with
 | Some v5 -> [cCAMLtoTKtextIndex v5]
 | None -> [])|] in 
cTKtoCAMLtext_index res

let see v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "see";
    cCAMLtoTKtextIndex v2|]

let tag_add v1 ~tag:v2 ~start:v3 ~stop:v4 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "add";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|]

let tag_add_char v1 ~tag:v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "add";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3|]

let tag_configure ~tag:v2 =
texttag_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "configure";
    cCAMLtoTKtextTag v2;
    TkTokenList opts|])

let tag_delete v1 v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "delete";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKtextTag x) v2)|]

let tag_lower ~tag:v2 ?below:v3 v1 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "lower";
    cCAMLtoTKtextTag v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtextTag v3]
 | None -> [])|]

let tag_names ?index:v2 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "names";
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKtextIndex v2]
 | None -> [])|] in 
    List.map ~f: cTKtoCAMLtextTag (splitlist res)

let tag_nextrange ~tag:v2 ~start:v3 ?stop:v4 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "nextrange";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    TkTokenList (match v4 with
 | Some v4 -> [cCAMLtoTKtextIndex v4]
 | None -> [])|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = cTKtoCAMLtext_index (List.hd l), List.tl l in
    let r2, l = cTKtoCAMLtext_index (List.hd l), List.tl l in
r1, r2

let tag_prevrange ~tag:v2 ~start:v3 ?stop:v4 v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "prevrange";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    TkTokenList (match v4 with
 | Some v4 -> [cCAMLtoTKtextIndex v4]
 | None -> [])|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = cTKtoCAMLtext_index (List.hd l), List.tl l in
    let r2, l = cTKtoCAMLtext_index (List.hd l), List.tl l in
r1, r2

let tag_raise ~tag:v2 ?above:v3 v1 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "raise";
    cCAMLtoTKtextTag v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtextTag v3]
 | None -> [])|]

let tag_ranges v1 ~tag:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "ranges";
    cCAMLtoTKtextTag v2|] in 
    List.map ~f: cTKtoCAMLtext_index (splitlist res)

let tag_remove v1 ~tag:v2 ~start:v3 ~stop:v4 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "remove";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|]

let tag_remove_char v1 ~tag:v2 ~index:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "tag";
    TkToken "remove";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3|]

let window_configure ~tag:v2 =
embeddedw_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "window";
    TkToken "configure";
    cCAMLtoTKtextTag v2;
    TkTokenList opts|])

let window_create ~index:v2 =
embeddedw_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "window";
    TkToken "create";
    cCAMLtoTKtextIndex v2;
    TkTokenList opts|])

let window_names v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "window";
    TkToken "names"|] in 
    List.map ~f: cTKtoCAMLwidget (splitlist res)

let xview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview v1 ~scroll:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "yview";
    cCAMLtoTKscrollValue v2|]

let yview_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "yview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview_index v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "yview";
    cCAMLtoTKtextIndex v2|]

let yview_index_pickplace v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "yview";
    TkToken "-pickplace";
    cCAMLtoTKtextIndex v2|]

let yview_line v1 ~line:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : text widget);
    TkToken "yview";
    TkToken (string_of_int v2)|]



let tag_bind ~tag ~events ?(extend = false) ?(breakable = false)
    ?(fields = []) ?action widget =
  tkCommand [|
    cCAMLtoTKwidget widget;
    TkToken "tag";
    TkToken "bind";
    cCAMLtoTKtextTag tag;
    cCAMLtoTKeventSequence events;
    begin match action with
    | None -> TkToken ""
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


