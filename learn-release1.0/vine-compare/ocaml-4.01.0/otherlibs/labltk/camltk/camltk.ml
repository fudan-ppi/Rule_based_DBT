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
(** This module Camltk provides the module name spaces of the CamlTk API.

The users of the CamlTk API should open this module first to access
the types, functions and modules of the CamlTk API easier.
For the documentation of each sub modules such as [Button] and [Toplevel],
refer to its defintion file,  [cButton.mli], [cToplevel.mli], etc.
*)

include CTk
module Tk = CTk
module Bell = CBell;;
module Scale = CScale;;
module Winfo = CWinfo;;
module Scrollbar = CScrollbar;;
module Entry = CEntry;;
module Listbox = CListbox;;
module Wm = CWm;;
module Tkwait = CTkwait;;
module Grab = CGrab;;
module Font = CFont;;
module Canvas = CCanvas;;
module Image = CImage;;
module Clipboard = CClipboard;;
module Label = CLabel;;
module Resource = CResource;;
module Message = CMessage;;
module Text = CText;;
module Imagephoto = CImagephoto;;
module Option = COption;;
module Frame = CFrame;;
module Selection = CSelection;;
module Dialog = CDialog;;
module Place = CPlace;;
module Pixmap = CPixmap;;
module Menubutton = CMenubutton;;
module Radiobutton = CRadiobutton;;
module Focus = CFocus;;
module Pack = CPack;;
module Imagebitmap = CImagebitmap;;
module Encoding = CEncoding;;
module Optionmenu = COptionmenu;;
module Checkbutton = CCheckbutton;;
module Tkvars = CTkvars;;
module Palette = CPalette;;
module Menu = CMenu;;
module Button = CButton;;
module Toplevel = CToplevel;;
module Grid = CGrid;;
