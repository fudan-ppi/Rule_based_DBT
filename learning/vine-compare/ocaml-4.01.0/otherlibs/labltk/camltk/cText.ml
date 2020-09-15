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
  let w = new_atom "text" ~parent ?name in
  tkCommand [|TkToken "text";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_text_table x) options)
             |];
      w

let create_named parent name options =
  let w = new_atom "text" ~parent ~name in
  tkCommand [|TkToken "text";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_text_table x) options)
             |];
      w

let bbox v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
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

let compare v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "compare";
    cCAMLtoTKtextIndex v2;
    cCAMLtoTKcomparison v3;
    cCAMLtoTKtextIndex v4|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let configure v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_text_table x) v2)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "configure"|] in 
res

let debug v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "debug";
    if v2 then TkToken "1" else TkToken "0"|]

let delete v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "delete";
    cCAMLtoTKtextIndex v2;
    cCAMLtoTKtextIndex v3|]

let delete_char v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "delete";
    cCAMLtoTKtextIndex v2|]

let dlineinfo v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
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

let dump v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "dump";
    TkTokenList (List.map (function x -> cCAMLtoTKtext_dump v1 x) v2);
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|] in 
(splitlist res)

let dump_char v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "dump";
    TkTokenList (List.map (function x -> cCAMLtoTKtext_dump v1 x) v2);
    cCAMLtoTKtextIndex v3|] in 
(splitlist res)

let get v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "get";
    cCAMLtoTKtextIndex v2;
    cCAMLtoTKtextIndex v3|] in 
res

let get_char v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "get";
    cCAMLtoTKtextIndex v2|] in 
res

let image_configure v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "image";
    TkToken "configure";
    TkToken v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_embeddedi_table x) v3)|]

let image_configure_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "image";
    TkToken "cgets";
    TkToken v2|] in 
res

let image_create v1 v2 v3 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "image";
    TkToken "create";
    cCAMLtoTKtextIndex v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_embeddedi_table x) v3)|] in 
res

let image_names v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "image";
    TkToken "names"|] in 
(splitlist res)

let index v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "index";
    cCAMLtoTKtextIndex v2|] in 
cTKtoCAMLindex res

let insert v1 v2 v3 v4 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "insert";
    cCAMLtoTKtextIndex v2;
    TkToken v3;
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> cCAMLtoTKtextTag x) v4)])|]

let mark_gravity_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "gravity";
    cCAMLtoTKtextMark v2|] in 
cTKtoCAMLmarkDirection res

let mark_gravity_set v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "gravity";
    cCAMLtoTKtextMark v2;
    cCAMLtoTKmarkDirection v3|]

let mark_names v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "names"|] in 
    List.map cTKtoCAMLtextMark (splitlist res)

let mark_next v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "next";
    cCAMLtoTKtextIndex v2|] in 
cTKtoCAMLtextMark res

let mark_previous v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "previous";
    cCAMLtoTKtextIndex v2|] in 
cTKtoCAMLtextMark res

let mark_set v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "set";
    cCAMLtoTKtextMark v2;
    cCAMLtoTKtextIndex v3|]

let mark_unset v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "mark";
    TkToken "unset";
    TkTokenList (List.map (function x -> cCAMLtoTKtextMark x) v2)|]

let scan_dragto v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "scan";
    TkToken "dragto";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let scan_mark v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "scan";
    TkToken "mark";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let search v1 v2 v3 v4 v5 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "search";
    TkTokenList (List.map (function x -> cCAMLtoTKtextSearch x) v2);
    TkToken "--";
    TkToken v3;
    cCAMLtoTKtextIndex v4;
    cCAMLtoTKtextIndex v5|] in 
cTKtoCAMLindex res

let see v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "see";
    cCAMLtoTKtextIndex v2|]

let tag_add v1 v2 v3 v4 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "add";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|]

let tag_add_char v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "add";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3|]

let tag_allnames v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "names"|] in 
    List.map cTKtoCAMLtextTag (splitlist res)

let tag_configure v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "configure";
    cCAMLtoTKtextTag v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_texttag_table x) v3)|]

let tag_delete v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "delete";
    TkTokenList (List.map (function x -> cCAMLtoTKtextTag x) v2)|]

let tag_indexnames v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "names";
    cCAMLtoTKtextIndex v2|] in 
    List.map cTKtoCAMLtextTag (splitlist res)

let tag_lower ?below:v3 v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "lower";
    cCAMLtoTKtextTag v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtextTag v3]
 | None -> [])|]

let tag_lower_below v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "lower";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextTag v3|]

let tag_lower_bot v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "lower";
    cCAMLtoTKtextTag v2|]

let tag_names ?index:v2 v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "names";
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKtextIndex v2]
 | None -> [])|] in 
    List.map cTKtoCAMLtextTag (splitlist res)

let tag_nextrange v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "nextrange";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = cTKtoCAMLindex (List.hd l), List.tl l in
    let r2, l = cTKtoCAMLindex (List.hd l), List.tl l in
r1, r2

let tag_prevrange v1 v2 v3 v4 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "prevrange";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = cTKtoCAMLindex (List.hd l), List.tl l in
    let r2, l = cTKtoCAMLindex (List.hd l), List.tl l in
r1, r2

let tag_raise ?above:v3 v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "raise";
    cCAMLtoTKtextTag v2;
    TkTokenList (match v3 with
 | Some v3 -> [cCAMLtoTKtextTag v3]
 | None -> [])|]

let tag_raise_above v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "raise";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextTag v3|]

let tag_raise_top v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "raise";
    cCAMLtoTKtextTag v2|]

let tag_ranges v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "ranges";
    cCAMLtoTKtextTag v2|] in 
    List.map cTKtoCAMLindex (splitlist res)

let tag_remove v1 v2 v3 v4 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "remove";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3;
    cCAMLtoTKtextIndex v4|]

let tag_remove_char v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "tag";
    TkToken "remove";
    cCAMLtoTKtextTag v2;
    cCAMLtoTKtextIndex v3|]

let window_configure v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "window";
    TkToken "configure";
    cCAMLtoTKtextTag v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_embeddedw_table x) v3)|]

let window_create v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "window";
    TkToken "create";
    cCAMLtoTKtextIndex v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_embeddedw_table x) v3)|]

let window_names v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "window";
    TkToken "names"|] in 
    List.map cTKtoCAMLwidget (splitlist res)

let xview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "xview";
    cCAMLtoTKscrollValue v2|]

let xview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "xview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "yview";
    cCAMLtoTKscrollValue v2|]

let yview_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "yview"|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = float_of_string (List.hd l), List.tl l in
    let r2, l = float_of_string (List.hd l), List.tl l in
r1, r2

let yview_index v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "yview";
    cCAMLtoTKtextIndex v2|]

let yview_index_pickplace v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "yview";
    TkToken "-pickplace";
    cCAMLtoTKtextIndex v2|]

let yview_line v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_text_table v1;
    TkToken "yview";
    TkToken (string_of_int v2)|]



let tag_bind widget tag eventsequence action =
  check_class widget widget_text_table;
  tkCommand [|
    cCAMLtoTKwidget widget_text_table widget;
    TkToken "tag";
    TkToken "bind";
    cCAMLtoTKtextTag tag;
    cCAMLtoTKeventSequence eventsequence;
    begin match action with
    | BindRemove -> TkToken ""
    | BindSet (what, f) ->
        let cbId = register_callback widget (wrapeventInfo f what) in
        TkToken ("camlcb " ^ cbId ^ (writeeventField what))
    | BindSetBreakable (what, f) ->
        let cbId = register_callback widget (wrapeventInfo f what) in
        TkToken ("camlcb " ^ cbId ^ (writeeventField what) ^
                 " ; if { $BreakBindingsSequence == 1 } then { break ;} ; \
                   set BreakBindingsSequence 0")
    | BindExtend (what, f) ->
        let cbId = register_callback widget (wrapeventInfo f what) in
        TkToken ("+camlcb " ^ cbId ^ (writeeventField what))
    end
  |]
;;


