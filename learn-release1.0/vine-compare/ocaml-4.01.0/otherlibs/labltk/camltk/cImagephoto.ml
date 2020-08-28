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
let blank v1 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "blank"|]

let configure v1 v2 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_photoimage_table x) v2)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKimagePhoto v1;
    TkToken "configure"|] in 
res

let copy v1 v2 v3 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "copy";
    cCAMLtoTKimagePhoto v2;
    TkTokenList (List.map (function x -> cCAMLtoTKphoto photo_copy_table x) v3)|]

let create ?name:v1 v2 =
let res = tkEval [|TkToken "image";
    TkToken "create";
    TkToken "photo";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKimagePhoto v1]
 | None -> []);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_photoimage_table x) v2)|] in 
cTKtoCAMLimagePhoto res

let create_named v1 v2 =
let res = tkEval [|TkToken "image";
    TkToken "create";
    TkToken "photo";
    cCAMLtoTKimagePhoto v1;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_photoimage_table x) v2)|] in 
cTKtoCAMLimagePhoto res

let delete v1 =
tkCommand [|TkToken "image";
    TkToken "delete";
    cCAMLtoTKimagePhoto v1|]

let get v1 v2 v3 =
let res = tkEval [|cCAMLtoTKimagePhoto v1;
    TkToken "get";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|] in 
    let l = splitlist res in
      if List.length l <> 3
      then Pervasives.raise (TkError ("unexpected result: " ^ res))
      else     let r1, l = int_of_string (List.hd l), List.tl l in
    let r2, l = int_of_string (List.hd l), List.tl l in
    let r3, l = int_of_string (List.hd l), List.tl l in
r1, r2, r3

let height v1 =
let res = tkEval [|TkToken "image";
    TkToken "height";
    cCAMLtoTKimagePhoto v1|] in 
int_of_string res

let put v1 v2 v3 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "put";
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> TkQuote (TkTokenList (List.map (fun y ->  cCAMLtoTKcolor y ) x ))) v2)]);
    TkTokenList (List.map (function x -> cCAMLtoTKphoto photo_put_table x) v3)|]

let read v1 v2 v3 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "read";
    TkToken v2;
    TkTokenList (List.map (function x -> cCAMLtoTKphoto photo_read_table x) v3)|]

let redither v1 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "redither"|]

let width v1 =
let res = tkEval [|TkToken "image";
    TkToken "width";
    cCAMLtoTKimagePhoto v1|] in 
int_of_string res

let write v1 v2 v3 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "write";
    TkToken v2;
    TkTokenList (List.map (function x -> cCAMLtoTKphoto photo_write_table x) v3)|]

