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
(* The menu widget *)
open CTk
open Tkintf
open Widget
open Textvariable

val create : ?name: string -> widget -> options list -> widget 
(** [create ?name parent options] creates a new widget with
    parent [parent] and new patch component [name] if specified.
    Options are restricted to the widget class subset, and checked
    dynamically. *)

val create_named : widget -> string -> options list -> widget 
(** [create_named parent name options] creates a new widget with
    parent [parent] and new patch component [name].
    This function is now obsolete and unified with [create]. *)

val activate : (* menu *) widget -> (* menu *) index -> unit 

val add_cascade : (* menu *) widget -> (* menucascade *) options list -> unit 

val add_checkbutton : (* menu *) widget -> (* menucheck *) options list -> unit 

val add_command : (* menu *) widget -> (* menucommand *) options list -> unit 

val add_radiobutton : (* menu *) widget -> (* menuradio *) options list -> unit 

val add_separator : (* menu *) widget -> unit 

val configure : (* menu *) widget -> (* menu *) options list -> unit 

val configure_cascade : (* menu *) widget -> (* menu *) index -> (* menucascade *) options list -> unit 

val configure_checkbutton : (* menu *) widget -> (* menu *) index -> (* menucheck *) options list -> unit 

val configure_command : (* menu *) widget -> (* menu *) index -> (* menucommand *) options list -> unit 

val configure_get : (* menu *) widget -> string 

val configure_radiobutton : (* menu *) widget -> (* menu *) index -> (* menuradio *) options list -> unit 

val delete : (* menu *) widget -> (* menu *) index -> (* menu *) index -> unit 

val entryconfigure_get : (* menu *) widget -> (* menu *) index -> string 

val index : (* menu *) widget -> (* menu *) index -> int 

val insert_cascade : (* menu *) widget -> (* menu *) index -> (* menucascade *) options list -> unit 

val insert_checkbutton : (* menu *) widget -> (* menu *) index -> (* menucheck *) options list -> unit 

val insert_command : (* menu *) widget -> (* menu *) index -> (* menucommand *) options list -> unit 

val insert_radiobutton : (* menu *) widget -> (* menu *) index -> (* menuradio *) options list -> unit 

val insert_separator : (* menu *) widget -> (* menu *) index -> unit 

val invoke : (* menu *) widget -> (* menu *) index -> string 

val popup : ?entry:(* menu *) index -> (* menu *) widget -> int -> int -> unit 

val popup_entry : (* menu *) widget -> int -> int -> (* menu *) index -> unit 

val post : (* menu *) widget -> int -> int -> unit 

val postcascade : (* menu *) widget -> (* menu *) index -> unit 

val typeof : (* menu *) widget -> (* menu *) index -> menuItem 

val unpost : (* menu *) widget -> unit 

val yposition : (* menu *) widget -> (* menu *) index -> int 

