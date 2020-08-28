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
open StdLabels
open Tk
open Tkintf
open Widget
open Textvariable

val create :
  ?name:string ->
  ?activebackground:color ->
  ?activeborderwidth:int ->
  ?activeforeground:color ->
  ?background:color ->
  ?borderwidth:int ->
  ?cursor:cursor ->
  ?disabledforeground:color ->
  ?font:string ->
  ?foreground:color ->
  ?postcommand:(unit -> unit) ->
  ?relief:relief ->
  ?selectcolor:color ->
  ?takefocus:bool ->
  ?tearoff:bool ->
  ?tearoffcommand:(menu:any widget -> tornoff:any widget -> unit) ->
  ?title:string ->
  ?typ:menuType ->
  'a widget -> menu widget
(** [create ?name parent options...] creates a new widget with
    parent [parent] and new patch component [name], if specified. *)

val activate : menu widget -> index:menu_index -> unit 

val add_cascade : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?hidemargin:bool   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?menu:menu widget   ->
?state:state   ->
?underline:int -> menu widget -> unit 

val add_checkbutton : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?offvalue:string   ->
?onvalue:string   ->
?selectcolor:color   ->
?selectimage:[< image]   ->
?state:state   ->
?underline:int   ->
?variable:textVariable -> menu widget -> unit 

val add_command : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?label:string   ->
?state:state   ->
?underline:int -> menu widget -> unit 

val add_radiobutton : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?selectcolor:color   ->
?selectimage:[< image]   ->
?state:state   ->
?underline:int   ->
?value:string   ->
?variable:textVariable -> menu widget -> unit 

val add_separator : menu widget -> unit 

val configure : ?activebackground:color   ->
?activeborderwidth:int   ->
?activeforeground:color   ->
?background:color   ->
?borderwidth:int   ->
?cursor:cursor   ->
?disabledforeground:color   ->
?font:string   ->
?foreground:color   ->
?postcommand:(unit -> unit)   ->
?relief:relief   ->
?selectcolor:color   ->
?takefocus:bool   ->
?tearoff:bool   ->
?tearoffcommand:(menu:any widget -> tornoff:any widget -> unit)   ->
?title:string   ->
?typ:menuType -> menu widget -> unit 

val configure_cascade : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?hidemargin:bool   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?menu:menu widget   ->
?state:state   ->
?underline:int -> menu widget -> menu_index -> unit 

val configure_checkbutton : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?offvalue:string   ->
?onvalue:string   ->
?selectcolor:color   ->
?selectimage:[< image]   ->
?state:state   ->
?underline:int   ->
?variable:textVariable -> menu widget -> menu_index -> unit 

val configure_command : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?label:string   ->
?state:state   ->
?underline:int -> menu widget -> menu_index -> unit 

val configure_get : menu widget -> string 

val configure_radiobutton : ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?selectcolor:color   ->
?selectimage:[< image]   ->
?state:state   ->
?underline:int   ->
?value:string   ->
?variable:textVariable -> menu widget -> menu_index -> unit 

val delete : menu widget -> first:menu_index -> last:menu_index -> unit 

val entryconfigure_get : menu widget -> menu_index -> string 

val index : menu widget -> menu_index -> int 

val insert_cascade : index:menu_index -> ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?hidemargin:bool   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?menu:menu widget   ->
?state:state   ->
?underline:int -> menu widget -> unit 

val insert_checkbutton : index:menu_index -> ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?offvalue:string   ->
?onvalue:string   ->
?selectcolor:color   ->
?selectimage:[< image]   ->
?state:state   ->
?underline:int   ->
?variable:textVariable -> menu widget -> unit 

val insert_command : index:menu_index -> ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?label:string   ->
?state:state   ->
?underline:int -> menu widget -> unit 

val insert_radiobutton : index:menu_index -> ?accelerator:string   ->
?activebackground:color   ->
?activeforeground:color   ->
?background:color   ->
?bitmap:bitmap   ->
?columnbreak:bool   ->
?command:(unit -> unit)   ->
?font:string   ->
?foreground:color   ->
?image:[< image]   ->
?indicatoron:bool   ->
?label:string   ->
?selectcolor:color   ->
?selectimage:[< image]   ->
?state:state   ->
?underline:int   ->
?value:string   ->
?variable:textVariable -> menu widget -> unit 

val insert_separator : menu widget -> index:menu_index -> unit 

val invoke : menu widget -> index:menu_index -> string 

val popup : x:int -> y:int -> ?entry:menu_index -> menu widget -> unit 

val post : menu widget -> x:int -> y:int -> unit 

val postcascade : menu widget -> index:menu_index -> unit 

val typeof : menu widget -> index:menu_index -> menuItem 

val unpost : menu widget -> unit 

val yposition : menu widget -> index:menu_index -> int 

