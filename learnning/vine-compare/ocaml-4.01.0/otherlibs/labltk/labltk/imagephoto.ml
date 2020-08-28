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
let blank v1 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "blank"|]

let configure ?data:eta =
photoimage_options_optionals ?data:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "configure";
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKimagePhoto v1;
    TkToken "configure"|] in 
res

let copy ~src:v2 =
copy_photo_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "copy";
    cCAMLtoTKimagePhoto v2;
    TkTokenList opts|])

let create ?name:v1 =
photoimage_options_optionals (fun opts () ->
let res = tkEval [|TkToken "image";
    TkToken "create";
    TkToken "photo";
    TkTokenList (match v1 with
 | Some v1 -> [cCAMLtoTKimagePhoto v1]
 | None -> []);
    TkTokenList opts|] in 
cTKtoCAMLimagePhoto res)

let delete v1 =
tkCommand [|TkToken "image";
    TkToken "delete";
    cCAMLtoTKimagePhoto v1|]

let get v1 ~x:v2 ~y:v3 =
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

let put ?dst_area:eta =
put_photo_optionals ?dst_area:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "put";
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> TkQuote (TkTokenList (List.map ~f:(fun y ->  cCAMLtoTKcolor y ) x ))) v2)]);
    TkTokenList opts|])

let read ~file:v2 =
read_photo_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "read";
    TkToken v2;
    TkTokenList opts|])

let redither v1 =
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "redither"|]

let width v1 =
let res = tkEval [|TkToken "image";
    TkToken "width";
    cCAMLtoTKimagePhoto v1|] in 
int_of_string res

let write ~file:v2 =
write_photo_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKimagePhoto v1;
    TkToken "write";
    TkToken v2;
    TkTokenList opts|])

