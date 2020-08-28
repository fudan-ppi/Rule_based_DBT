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
let atom ?displayof:v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "atom";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> []);
    TkToken v2|] in 
cTKtoCAMLatomId res

let atomname ?displayof:v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "atomname";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> []);
    cCAMLtoTKatomId v2|] in 
res

let cells v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "cells";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let children v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "children";
    cCAMLtoTKwidget v1|] in 
    List.map ~f: cTKtoCAMLwidget (splitlist res)

let class_name v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "class";
    cCAMLtoTKwidget v1|] in 
res

let colormapfull v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "colormapfull";
    cCAMLtoTKwidget v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let containing ~x:v2 ~y:v3 ?displayof:v1 () =
let res = tkEval [|TkToken "winfo";
    TkToken "containing";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> []);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
cTKtoCAMLwidget res

let depth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "depth";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let exists v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "exists";
    cCAMLtoTKwidget v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let fpixels v1 ~length:v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "fpixels";
    cCAMLtoTKwidget v1;
    cCAMLtoTKunits v2|] in 
float_of_string res

let geometry v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "geometry";
    cCAMLtoTKwidget v1|] in 
res

let height v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "height";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let id v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "id";
    cCAMLtoTKwidget v1|] in 
res

let interps ?displayof:v1 () =
let res = tkEval [|TkToken "winfo";
    TkToken "interps";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> [])|] in 
(splitlist res)

let ismapped v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "ismapped";
    cCAMLtoTKwidget v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let manager v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "manager";
    cCAMLtoTKwidget v1|] in 
res

let name v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "name";
    cCAMLtoTKwidget v1|] in 
res

let parent v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "parent";
    cCAMLtoTKwidget v1|] in 
cTKtoCAMLwidget res

let pathname ?displayof:v1 v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "pathname";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> []);
    TkToken v2|] in 
cTKtoCAMLwidget res

let pixels v1 ~length:v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "pixels";
    cCAMLtoTKwidget v1;
    cCAMLtoTKunits v2|] in 
int_of_string res

let pointerx v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "pointerx";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let pointerxy v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "pointerxy";
    cCAMLtoTKwidget v1|] in 
    let l = splitlist res in
      if List.length l <> 2
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
r1, r2

let pointery v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "pointery";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let reqheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "reqheight";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let reqwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "reqwidth";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let rgb v1 ~color:v2 =
let res = tkEval [|TkToken "winfo";
    TkToken "rgb";
    cCAMLtoTKwidget v1;
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
    cCAMLtoTKwidget v1|] in 
int_of_string res

let rooty v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "rooty";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let screen v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screen";
    cCAMLtoTKwidget v1|] in 
res

let screencells v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screencells";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let screendepth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screendepth";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let screenheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenheight";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let screenmmheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenmmheight";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let screenmmwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenmmwidth";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let screenvisual v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenvisual";
    cCAMLtoTKwidget v1|] in 
res

let screenwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "screenwidth";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let server v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "server";
    cCAMLtoTKwidget v1|] in 
res

let toplevel v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "toplevel";
    cCAMLtoTKwidget v1|] in 
(Obj.magic (cTKtoCAMLwidget  res ) : toplevel widget)

let viewable v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "viewable";
    cCAMLtoTKwidget v1|] in 
(match res with
| "1" -> true
| "0" -> false
| s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLbool" ^ s)))

let visual v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "visual";
    cCAMLtoTKwidget v1|] in 
res

let visualid v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "visualid";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let visualsavailable ?includeids:v2 v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "visualsavailable";
    cCAMLtoTKwidget v1;
    TkTokenList (match v2 with
 | Some v2 -> [TkTokenList (List.map ~f:(function x -> TkToken (string_of_int x)) v2)]
 | None -> [])|] in 
res

let vrootheight v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrootheight";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let vrootwidth v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrootwidth";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let vrootx v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrootx";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let vrooty v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "vrooty";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let width v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "width";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let x v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "x";
    cCAMLtoTKwidget v1|] in 
int_of_string res

let y v1 =
let res = tkEval [|TkToken "winfo";
    TkToken "y";
    cCAMLtoTKwidget v1|] in 
int_of_string res



let contained ~x ~y w =
  forget_type w = containing ~x ~y ()
;;


