(* unsafe *)
val appname_get : unit -> string 

(* /unsafe *)
(* unsafe *)
val appname_set : string -> unit 

(* /unsafe *)
val bindtags : 'a widget -> bindings:bindings list -> unit 

val bindtags_get : 'a widget -> bindings list 

val cget : 'a widget -> options_constrs -> string 

val cgets : 'a widget -> string -> string 

val chooseColor : ?initialcolor:color   ->
?parent:'a widget   ->
?title:string -> unit -> color 

val destroy : 'a widget -> unit 

val getOpenFile : ?defaultextension:string   ->
?filetypes:filePattern list   ->
?initialdir:string   ->
?initialfile:string   ->
?parent:'a widget   ->
?title:string -> unit -> string 

val getSaveFile : ?defaultextension:string   ->
?filetypes:filePattern list   ->
?initialdir:string   ->
?initialfile:string   ->
?parent:'a widget   ->
?title:string -> unit -> string 

val grid : ?column:int   ->
?columnspan:int   ->
?inside:'a widget   ->
?ipadx:int   ->
?ipady:int   ->
?padx:int   ->
?pady:int   ->
?row:int   ->
?rowspan:int   ->
?sticky:string -> 'b widget list -> unit 

val lower_window : ?below:'a widget -> 'b widget -> unit 

val messageBox : ?default:string   ->
?icon:messageIcon   ->
?message:string   ->
?parent:'a widget   ->
?title:string   ->
?typ:messageType -> unit -> string 

val pack : ?after:'a widget   ->
?anchor:anchor   ->
?before:'b widget   ->
?expand:bool   ->
?fill:fillMode   ->
?inside:'c widget   ->
?ipadx:int   ->
?ipady:int   ->
?padx:int   ->
?pady:int   ->
?side:side -> 'd widget list -> unit 

val place : ?anchor:anchor   ->
?bordermode:borderMode   ->
?height:int   ->
?inside:'a widget   ->
?relheight:float   ->
?relwidth:float   ->
?relx:float   ->
?rely:float   ->
?width:int   ->
?x:int   ->
?y:int -> 'b widget -> unit 

val raise_window : ?above:'a widget -> 'b widget -> unit 

val scaling_get : ?displayof:'a widget -> unit -> float 

(* unsafe *)
val scaling_set : ?displayof:'a widget -> float -> unit 

(* /unsafe *)
(* unsafe *)
val send : sendOption list -> app:string -> command:string list -> unit 

(* /unsafe *)
val update : unit -> unit 

val update_idletasks : unit -> unit 

