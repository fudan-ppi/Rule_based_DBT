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
  menu_options_optionals (fun opts parent ->
     let w = new_atom "menu" ~parent ?name in
     tkCommand [|TkToken "menu";
              TkToken (Widget.name w);
              TkTokenList opts |];
      w)


let activate v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "activate";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|]

let add_cascade ?accelerator:eta =
menucascade_options_optionals ?accelerator:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "add";
    TkToken "cascade";
    TkTokenList opts|])

let add_checkbutton ?accelerator:eta =
menucheck_options_optionals ?accelerator:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "add";
    TkToken "checkbutton";
    TkTokenList opts|])

let add_command ?accelerator:eta =
menucommand_options_optionals ?accelerator:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "add";
    TkToken "command";
    TkTokenList opts|])

let add_radiobutton ?accelerator:eta =
menuradio_options_optionals ?accelerator:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "add";
    TkToken "radiobutton";
    TkTokenList opts|])

let add_separator v1 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "add";
    TkToken "separator"|]

let configure ?activebackground:eta =
menu_options_optionals ?activebackground:eta (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "configure";
    TkTokenList opts|])

let configure_cascade ?accelerator:eta =
menucascade_options_optionals ?accelerator:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "entryconfigure";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkTokenList opts|])

let configure_checkbutton ?accelerator:eta =
menucheck_options_optionals ?accelerator:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "entryconfigure";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkTokenList opts|])

let configure_command ?accelerator:eta =
menucommand_options_optionals ?accelerator:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "entryconfigure";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkTokenList opts|])

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "configure"|] in 
res

let configure_radiobutton ?accelerator:eta =
menuradio_options_optionals ?accelerator:eta (fun opts v1 v2 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "entryconfigure";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkTokenList opts|])

let delete v1 ~first:v2 ~last:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "delete";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    cCAMLtoTKmenu_index (v3 : [< menu_index])|]

let entryconfigure_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "entryconfigure";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|] in 
res

let index v1 v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "index";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|] in 
int_of_string res

let insert_cascade ~index:v2 =
menucascade_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "insert";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkToken "cascade";
    TkTokenList opts|])

let insert_checkbutton ~index:v2 =
menucheck_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "insert";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkToken "checkbutton";
    TkTokenList opts|])

let insert_command ~index:v2 =
menucommand_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "insert";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkToken "command";
    TkTokenList opts|])

let insert_radiobutton ~index:v2 =
menuradio_options_optionals (fun opts v1 ->
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "insert";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkToken "radiobutton";
    TkTokenList opts|])

let insert_separator v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "insert";
    cCAMLtoTKmenu_index (v2 : [< menu_index]);
    TkToken "separator"|]

let invoke v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "invoke";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|] in 
res

let popup ~x:v2 ~y:v3 ?entry:v4 v1 =
tkCommand [|TkToken "tk_popup";
    cCAMLtoTKwidget (v1 : menu widget);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkTokenList (match v4 with
 | Some v4 -> [cCAMLtoTKmenu_index (v4 : [< menu_index])]
 | None -> [])|]

let post v1 ~x:v2 ~y:v3 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "post";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let postcascade v1 ~index:v2 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "postcascade";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|]

let typeof v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "type";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|] in 
cTKtoCAMLmenuItem res

let unpost v1 =
tkCommand [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "unpost"|]

let yposition v1 ~index:v2 =
let res = tkEval [|cCAMLtoTKwidget (v1 : menu widget);
    TkToken "yposition";
    cCAMLtoTKmenu_index (v2 : [< menu_index])|] in 
int_of_string res

