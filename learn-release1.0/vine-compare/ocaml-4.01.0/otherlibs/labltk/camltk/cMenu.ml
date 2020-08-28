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
  let w = new_atom "menu" ~parent ?name in
  tkCommand [|TkToken "menu";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_menu_table x) options)
             |];
      w

let create_named parent name options =
  let w = new_atom "menu" ~parent ~name in
  tkCommand [|TkToken "menu";
              TkToken (Widget.name w);
              TkTokenList (List.map (function x -> cCAMLtoTKoptions w options_menu_table x) options)
             |];
      w

let activate v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "activate";
    cCAMLtoTKindex index_menu_table v2|]

let add_cascade v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "add";
    TkToken "cascade";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucascade_table x) v2)|]

let add_checkbutton v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "add";
    TkToken "checkbutton";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucheck_table x) v2)|]

let add_command v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "add";
    TkToken "command";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucommand_table x) v2)|]

let add_radiobutton v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "add";
    TkToken "radiobutton";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menuradio_table x) v2)|]

let add_separator v1 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "add";
    TkToken "separator"|]

let configure v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "configure";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menu_table x) v2)|]

let configure_cascade v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "entryconfigure";
    cCAMLtoTKindex index_menu_table v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucascade_table x) v3)|]

let configure_checkbutton v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "entryconfigure";
    cCAMLtoTKindex index_menu_table v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucheck_table x) v3)|]

let configure_command v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "entryconfigure";
    cCAMLtoTKindex index_menu_table v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucommand_table x) v3)|]

let configure_get v1 =
let res = tkEval [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "configure"|] in 
res

let configure_radiobutton v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "entryconfigure";
    cCAMLtoTKindex index_menu_table v2;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menuradio_table x) v3)|]

let delete v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "delete";
    cCAMLtoTKindex index_menu_table v2;
    cCAMLtoTKindex index_menu_table v3|]

let entryconfigure_get v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "entryconfigure";
    cCAMLtoTKindex index_menu_table v2|] in 
res

let index v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "index";
    cCAMLtoTKindex index_menu_table v2|] in 
int_of_string res

let insert_cascade v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_menu_table v2;
    TkToken "cascade";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucascade_table x) v3)|]

let insert_checkbutton v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_menu_table v2;
    TkToken "checkbutton";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucheck_table x) v3)|]

let insert_command v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_menu_table v2;
    TkToken "command";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menucommand_table x) v3)|]

let insert_radiobutton v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_menu_table v2;
    TkToken "radiobutton";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions v1 options_menuradio_table x) v3)|]

let insert_separator v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "insert";
    cCAMLtoTKindex index_menu_table v2;
    TkToken "separator"|]

let invoke v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "invoke";
    cCAMLtoTKindex index_menu_table v2|] in 
res

let popup ?entry:v4 v1 v2 v3 =
tkCommand [|TkToken "tk_popup";
    cCAMLtoTKwidget widget_menu_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkTokenList (match v4 with
 | Some v4 -> [cCAMLtoTKindex index_menu_table v4]
 | None -> [])|]

let popup_entry v1 v2 v3 v4 =
tkCommand [|TkToken "tk_popup";
    cCAMLtoTKwidget widget_menu_table v1;
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    cCAMLtoTKindex index_menu_table v4|]

let post v1 v2 v3 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "post";
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)|]

let postcascade v1 v2 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "postcascade";
    cCAMLtoTKindex index_menu_table v2|]

let typeof v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "type";
    cCAMLtoTKindex index_menu_table v2|] in 
cTKtoCAMLmenuItem res

let unpost v1 =
tkCommand [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "unpost"|]

let yposition v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_menu_table v1;
    TkToken "yposition";
    cCAMLtoTKindex index_menu_table v2|] in 
int_of_string res

