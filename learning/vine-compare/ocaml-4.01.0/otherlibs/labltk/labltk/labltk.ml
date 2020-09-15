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
(** This module Labltk provides the module name spaces of the LablTk API,
useful to call LablTk functions inside CamlTk programs. 100% LablTk users
do not need to use this. *)

module Widget = Widget;;
module Protocol = Protocol;;
module Textvariable = Textvariable;;
module Fileevent = Fileevent;;
module Timer = Timer;;
module Bell = Bell;;
module Scale = Scale;;
module Winfo = Winfo;;
module Scrollbar = Scrollbar;;
module Entry = Entry;;
module Listbox = Listbox;;
module Wm = Wm;;
module Tkwait = Tkwait;;
module Grab = Grab;;
module Font = Font;;
module Canvas = Canvas;;
module Image = Image;;
module Clipboard = Clipboard;;
module Label = Label;;
module Message = Message;;
module Text = Text;;
module Imagephoto = Imagephoto;;
module Option = Option;;
module Frame = Frame;;
module Selection = Selection;;
module Dialog = Dialog;;
module Place = Place;;
module Pixmap = Pixmap;;
module Menubutton = Menubutton;;
module Radiobutton = Radiobutton;;
module Focus = Focus;;
module Pack = Pack;;
module Imagebitmap = Imagebitmap;;
module Encoding = Encoding;;
module Optionmenu = Optionmenu;;
module Checkbutton = Checkbutton;;
module Tkvars = Tkvars;;
module Palette = Palette;;
module Menu = Menu;;
module Button = Button;;
module Toplevel = Toplevel;;
module Grid = Grid;;

(** Widget typers *)

open Widget

let scale (w : any widget) =
  Rawwidget.check_class w widget_scale_table;
  (Obj.magic w : scale widget);;

let scrollbar (w : any widget) =
  Rawwidget.check_class w widget_scrollbar_table;
  (Obj.magic w : scrollbar widget);;

let entry (w : any widget) =
  Rawwidget.check_class w widget_entry_table;
  (Obj.magic w : entry widget);;

let listbox (w : any widget) =
  Rawwidget.check_class w widget_listbox_table;
  (Obj.magic w : listbox widget);;

let canvas (w : any widget) =
  Rawwidget.check_class w widget_canvas_table;
  (Obj.magic w : canvas widget);;

let label (w : any widget) =
  Rawwidget.check_class w widget_label_table;
  (Obj.magic w : label widget);;

let message (w : any widget) =
  Rawwidget.check_class w widget_message_table;
  (Obj.magic w : message widget);;

let text (w : any widget) =
  Rawwidget.check_class w widget_text_table;
  (Obj.magic w : text widget);;

let frame (w : any widget) =
  Rawwidget.check_class w widget_frame_table;
  (Obj.magic w : frame widget);;

let menubutton (w : any widget) =
  Rawwidget.check_class w widget_menubutton_table;
  (Obj.magic w : menubutton widget);;

let radiobutton (w : any widget) =
  Rawwidget.check_class w widget_radiobutton_table;
  (Obj.magic w : radiobutton widget);;

let checkbutton (w : any widget) =
  Rawwidget.check_class w widget_checkbutton_table;
  (Obj.magic w : checkbutton widget);;

let menu (w : any widget) =
  Rawwidget.check_class w widget_menu_table;
  (Obj.magic w : menu widget);;

let button (w : any widget) =
  Rawwidget.check_class w widget_button_table;
  (Obj.magic w : button widget);;

let toplevel (w : any widget) =
  Rawwidget.check_class w widget_toplevel_table;
  (Obj.magic w : toplevel widget);;

