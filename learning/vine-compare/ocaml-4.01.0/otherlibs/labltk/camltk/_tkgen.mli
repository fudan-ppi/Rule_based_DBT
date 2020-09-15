(* unsafe *)
val appname_get : unit -> string 

(* /unsafe *)
(* unsafe *)
val appname_set : string -> unit 

(* /unsafe *)
val bindtags : widget -> bindings list -> unit 

val bindtags_get : widget -> bindings list 

val cget : widget -> options_constrs -> string 

val cgets : widget -> string -> string 

val chooseColor : (* chooseColor *) options list -> color 

val destroy : widget -> unit 

val getOpenFile : (* getFile *) options list -> string 

val getSaveFile : (* getFile *) options list -> string 

val grid : widget list -> (* grid *) options list -> unit 

val lower_window : ?below:widget -> widget -> unit 

val lower_window_below : widget -> widget -> unit 

val messageBox : (* messageBox *) options list -> string 

val pack : widget list -> (* pack *) options list -> unit 

val place : widget -> (* place *) options list -> unit 

val raise_window : ?above:widget -> widget -> unit 

val raise_window_above : widget -> widget -> unit 

val scaling_get : ?displayof:widget -> unit -> float 

(* unsafe *)
val scaling_set : ?displayof:widget -> float -> unit 

(* /unsafe *)
(* unsafe *)
val send : sendOption list -> string -> string list -> unit 

(* /unsafe *)
val update : unit -> unit 

val update_idletasks : unit -> unit 

