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
let atom ?displayof:v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "atom";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> []);
    TkToken v2|] in 
cTKtoCAMLatomId res

let atom_displayof v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "atom";
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1;
    TkToken v2|] in 
cTKtoCAMLatomId res

let atomname ?displayof:v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "atomname";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> []);
    cCAMLtoTKatomId v2|] in 
res

let atomname_displayof v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "atomname";
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1;
    cCAMLtoTKatomId v2|] in 
res

let cells v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "cells";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let children v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "children";
    cCAMLtoTKwidget widget_any_table v1|] in 
    List.map cTKtoCAMLwidget (splitlist res)

let class_name v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "class";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let colormapfull v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "colormapfull";
    cCAMLtoTKwidget widget_any_table v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let containing ?displayof:v1 v2 v3 =
let res = tkEval [|TkToken "winfo";
    TkToken "containing";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> []);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
cTKtoCAMLwidget res

let containing_displayof v1 v2 v3 =
let res = tkEval [|TkToken "winfo";
    TkToken "containing";
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
cTKtoCAMLwidget res

let depth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "depth";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let exists v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "exists";
    cCAMLtoTKwidget widget_any_table v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let fpixels v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "fpixels";
    cCAMLtoTKwidget widget_any_table v1;
    cCAMLtoTKunits v2|] in 
float_of_string res

let geometry v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "geometry";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let height v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "height";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let id v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "id";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let interps ?displayof:v1 () =
let res = tkEval [|TkToken "winfo";
    TkToken "interps";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> [])|] in 
(splitlist res)

let interps_displayof v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "interps";
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1|] in 
(splitlist res)

let ismapped v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "ismapped";
    cCAMLtoTKwidget widget_any_table v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let manager v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "manager";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let name v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "name";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let parent v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "parent";
    cCAMLtoTKwidget widget_any_table v1|] in 
cTKtoCAMLwidget res

let pathname ?displayof:v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "pathname";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> []);
    TkToken v2|] in 
cTKtoCAMLwidget res

let pathname_displayof v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "pathname";
    TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1;
    TkToken v2|] in 
cTKtoCAMLwidget res

let pixels v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "pixels";
    cCAMLtoTKwidget widget_any_table v1;
    cCAMLtoTKunits v2|] in 
int_of_string res

let pointerx v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "pointerx";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let pointerxy v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "pointerxy";
    cCAMLtoTKwidget widget_any_table v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let pointery v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "pointery";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let reqheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "reqheight";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let reqwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "reqwidth";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let rgb v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "rgb";
    cCAMLtoTKwidget widget_any_table v1;
    cCAMLtoTKcolor v2|] in 
    let l = splitlist res in
      if List.length l <> 3
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3

let rootx v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "rootx";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let rooty v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "rooty";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let screen v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screen";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let screencells v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screencells";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let screendepth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screendepth";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let screenheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenheight";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let screenmmheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenmmheight";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let screenmmwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenmmwidth";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let screenvisual v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenvisual";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let screenwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenwidth";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let server v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "server";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let toplevel v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "toplevel";
    cCAMLtoTKwidget widget_any_table v1|] in 
cTKtoCAMLwidget res

let viewable v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "viewable";
    cCAMLtoTKwidget widget_any_table v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let visual v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "visual";
    cCAMLtoTKwidget widget_any_table v1|] in 
res

let visualid v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "visualid";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let visualsavailable ?includeids:v2 v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "visualsavailable";
    cCAMLtoTKwidget widget_any_table v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkTokenList (List.map (function x -> TkToken (string_of_int x)) v2)]
 | None -> [])|] in 
res

let vrootheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrootheight";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let vrootwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrootwidth";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let vrootx v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrootx";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let vrooty v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrooty";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let width v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "width";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let x v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "x";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res

let y v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "y";
    cCAMLtoTKwidget widget_any_table v1|] in 
int_of_string res



let contained x y w =
  w = containing x y
;;


