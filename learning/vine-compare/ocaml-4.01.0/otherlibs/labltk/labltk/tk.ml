open StdLabels
open Widget
open Protocol
open Support
open Textvariable
(* Report globals from protocol *)
let opentk = Protocol.opentk
let keywords = Protocol.keywords
let opentk_with_args = Protocol.opentk_with_args
let openTk = Protocol.openTk
let openTkClass = Protocol.openTkClass
let openTkDisplayClass = Protocol.openTkDisplayClass
let closeTk = Protocol.closeTk
let mainLoop = Protocol.mainLoop
let register = Protocol.register

(* From support *)
let may = Support.may
let maycons = Support.maycons

(* From widget *)
let coe = Widget.coe
(* File patterns *)
(* type *)
type filePattern = {
    typename : string;
    extensions : string list;
    mactypes : string list
  }
(* /type *)

let cCAMLtoTKfilePattern fp =
  let typename = TkQuote (TkToken fp.typename) in
  let extensions =
    TkQuote (TkTokenList (List.map (fun x -> TkToken x) fp.extensions)) in
  let mactypes =
    match fp.mactypes with
    | [] -> []
    | [s] -> [TkToken s]
    | _ -> [TkQuote (TkTokenList (List.map (fun x -> TkToken x) fp.mactypes))]
  in
  TkQuote (TkTokenList (typename :: extensions :: mactypes))
(* Tk_GetBitmap emulation *)



(* type *)
type bitmap = [
  | `File of string                 (* path of file *)
  | `Predefined of string           (* bitmap  name *)
]
;;
(* /type *)


(* Color *)



(* type *)
type color = [
  | `Color of string
  | `Black                      (* tk keyword: black *)
  | `White                      (* tk keyword: white *)
  | `Red                        (* tk keyword: red *)
  | `Green                      (* tk keyword: green *)
  | `Blue                       (* tk keyword: blue *)
  | `Yellow                     (* tk keyword: yellow *)
]
;;
(* /type *)





(* Tk_GetCursor emulation *)
(* type *)
type cursor = [
  | `Xcursor of string
  | `Xcursorfg of string * color
  | `Xcursorfgbg of string * color * color
  | `Cursorfilefg of string * color
  | `Cursormaskfile of string * string * color * color
]
;;
(* /type *)


(* Tk_GetPixels emulation *)



(* type *)
type units = [
  | `Pix of int
  | `Cm of float
  | `In of float
  | `Mm of float
  | `Pt of float
]
;;
(* /type *)




(* type *)
type scrollValue = [
  | `Page of int          (* tk option: scroll <int> page *)
  | `Unit of int          (* tk option: scroll <int> unit *)
  | `Moveto of float      (* tk option: moveto <float> *)
]
;;
(* /type *)




open Widget;;

(* Events and bindings *)
(* Builtin types *)

(* type *)
type event = [
  | `Activate
  | `ButtonPress (* also Button, but we omit it *)
  | `ButtonPressDetail of int
  | `ButtonRelease
  | `ButtonReleaseDetail of int
  | `Circulate
  | `Colormap
  | `Configure
  | `Deactivate
  | `Destroy
  | `Enter
  | `Expose
  | `FocusIn
  | `FocusOut
  | `Gravity
  | `KeyPress (* also Key, but we omit it *)
  | `KeyPressDetail of string      (* /usr/include/X11/keysymdef.h *)
  | `KeyRelease
  | `KeyReleaseDetail of string
  | `Leave
  | `Map
  | `Motion
  | `Property
  | `Reparent
  | `Unmap
  | `Visibility
  | `Virtual of string  (* Virtual event. Must be without modifiers *)
  | `Modified of modifier list * event
]

and modifier = [
  | `Control
  | `Shift
  | `Lock
  | `Button1
  | `Button2
  | `Button3
  | `Button4
  | `Button5
  | `Double
  | `Triple
  | `Mod1
  | `Mod2
  | `Mod3
  | `Mod4
  | `Mod5
  | `Meta
  | `Alt
]
;;
(* /type *)

(* Event structure, passed to bounded functions *)

(* type *)
type eventInfo = {
  (* %# : event serial number is unsupported *)
    mutable ev_Above : int;               (* tk: %a *)
    mutable ev_ButtonNumber : int;        (* tk: %b *)
    mutable ev_Count : int;               (* tk: %c *)
    mutable ev_Detail : string;           (* tk: %d *)
    mutable ev_Focus : bool;              (* tk: %f *)
    mutable ev_Height : int;              (* tk: %h *)
    mutable ev_KeyCode : int;             (* tk: %k *)
    mutable ev_Mode : string;             (* tk: %m *)
    mutable ev_OverrideRedirect : bool;   (* tk: %o *)
    mutable ev_Place : string;            (* tk: %p *)
    mutable ev_State : string;            (* tk: %s *)
    mutable ev_Time : int;                (* tk: %t *)
    mutable ev_Width : int;               (* tk: %w *)
    mutable ev_MouseX : int;              (* tk: %x *)
    mutable ev_MouseY : int;              (* tk: %y *)
    mutable ev_Char : string;             (* tk: %A *)
    mutable ev_BorderWidth : int;         (* tk: %B *)
    mutable ev_SendEvent : bool;          (* tk: %E *)
    mutable ev_KeySymString : string;     (* tk: %K *)
    mutable ev_KeySymInt : int;           (* tk: %N *)
    mutable ev_RootWindow : int;          (* tk: %R *)
    mutable ev_SubWindow : int;           (* tk: %S *)
    mutable ev_Type : int;                (* tk: %T *)
    mutable ev_Widget : any widget;       (* tk: %W *)
    mutable ev_RootX : int;               (* tk: %X *)
    mutable ev_RootY : int                (* tk: %Y *)
  }
;;
(* /type *)


(* To avoid collision with other constructors (Width, State),
   use Ev_ prefix *)
(* type *)
type eventField = [
  | `Above
  | `ButtonNumber
  | `Count
  | `Detail
  | `Focus
  | `Height
  | `KeyCode
  | `Mode
  | `OverrideRedirect
  | `Place
  | `State
  | `Time
  | `Width
  | `MouseX
  | `MouseY
  | `Char
  | `BorderWidth
  | `SendEvent
  | `KeySymString
  | `KeySymInt
  | `RootWindow
  | `SubWindow
  | `Type
  | `Widget
  | `RootX
  | `RootY
]
;;
(* /type *)

let filleventInfo ev v : eventField -> unit = function
  | `Above    ->        ev.ev_Above <- int_of_string v
  | `ButtonNumber ->    ev.ev_ButtonNumber <- int_of_string v
  | `Count ->           ev.ev_Count <- int_of_string v
  | `Detail ->          ev.ev_Detail <- v
  | `Focus ->           ev.ev_Focus <- v = "1"
  | `Height ->          ev.ev_Height <- int_of_string v
  | `KeyCode ->         ev.ev_KeyCode <- int_of_string v
  | `Mode ->            ev.ev_Mode <- v
  | `OverrideRedirect -> ev.ev_OverrideRedirect <- v = "1"
  | `Place ->           ev.ev_Place <- v
  | `State ->           ev.ev_State <- v
  | `Time ->            ev.ev_Time <- int_of_string v
  | `Width ->           ev.ev_Width <- int_of_string v
  | `MouseX ->          ev.ev_MouseX <- int_of_string v
  | `MouseY ->          ev.ev_MouseY <- int_of_string v
  | `Char ->            ev.ev_Char <- v
  | `BorderWidth ->     ev.ev_BorderWidth <- int_of_string v
  | `SendEvent ->       ev.ev_SendEvent <- v = "1"
  | `KeySymString ->    ev.ev_KeySymString <- v
  | `KeySymInt ->       ev.ev_KeySymInt <- int_of_string v
  | `RootWindow ->      ev.ev_RootWindow <- int_of_string v
  | `SubWindow ->       ev.ev_SubWindow <- int_of_string v
  | `Type ->            ev.ev_Type <- int_of_string v
  | `Widget ->          ev.ev_Widget <- cTKtoCAMLwidget v
  | `RootX ->           ev.ev_RootX <- int_of_string v
  | `RootY ->           ev.ev_RootY <- int_of_string v
;;

let wrapeventInfo f (what : eventField list) =
  let ev = {
    ev_Above = 0;
    ev_ButtonNumber = 0;
    ev_Count = 0;
    ev_Detail = "";
    ev_Focus = false;
    ev_Height = 0;
    ev_KeyCode = 0;
    ev_Mode = "";
    ev_OverrideRedirect = false;
    ev_Place = "";
    ev_State = "";
    ev_Time = 0;
    ev_Width = 0;
    ev_MouseX = 0;
    ev_MouseY = 0;
    ev_Char = "";
    ev_BorderWidth = 0;
    ev_SendEvent = false;
    ev_KeySymString = "";
    ev_KeySymInt = 0;
    ev_RootWindow = 0;
    ev_SubWindow = 0;
    ev_Type = 0;
    ev_Widget = forget_type default_toplevel;
    ev_RootX = 0;
    ev_RootY = 0 } in
     function args ->
       let l = ref args in
       List.iter what ~f:
         begin fun field ->
           match !l with
           | [] -> ()
           | v :: rest -> filleventInfo ev v field; l := rest
         end;
       f ev
;;

let rec writeeventField : eventField list -> string = function
  | [] -> ""
  | field :: rest ->
    begin
    match field with
    | `Above ->     " %a"
    | `ButtonNumber ->" %b"
    | `Count ->     " %c"
    | `Detail ->    " %d"
    | `Focus ->     " %f"
    | `Height ->    " %h"
    | `KeyCode ->   " %k"
    | `Mode ->      " %m"
    | `OverrideRedirect -> " %o"
    | `Place ->     " %p"
    | `State ->     " %s"
    | `Time ->      " %t"
    | `Width ->     " %w"
    | `MouseX ->    " %x"
    | `MouseY ->    " %y"
    (* Quoting is done by Tk *)
    | `Char ->      " %A"
    | `BorderWidth -> " %B"
    | `SendEvent -> " %E"
    | `KeySymString -> " %K"
    | `KeySymInt -> " %N"
    | `RootWindow ->" %R"
    | `SubWindow -> " %S"
    | `Type ->      " %T"
    | `Widget ->    " %W"
    | `RootX ->     " %X"
    | `RootY ->     " %Y"
    end
    ^ writeeventField rest
;;




(* type *)
type bindings = [
  | `Tag of string                (* tk option: <string> *)
  | `Widget of any widget         (* tk option: <widget> *)
]
;;
(* /type *)


(* type *)
type font = string
(* /type *)
(* type *)
type grabGlobal = bool
(* /type *)
(* Various indexes
    canvas
    entry
    listbox
*)



type canvas_index = [
  | `Num of int
  | `End
  | `Insert
  | `Selfirst
  | `Sellast
  | `Atxy of int * int
]
;;

type entry_index = [
  | `Num of int
  | `End
  | `Insert
  | `Selfirst
  | `Sellast
  | `At of int
  | `Anchor
]
;;

type listbox_index = [
  | `Num of int
  | `Active
  | `Anchor
  | `End
  | `Atxy of int * int
]
;;

type menu_index = [
  | `Num of int
  | `Active
  | `End
  | `Last
  | `None
  | `At of int
  | `Pattern of string
]
;;

type text_index = [
  | `Linechar of int * int
  | `Atxy of int * int
  | `End
  | `Mark of string
  | `Tagfirst of string
  | `Taglast of string
  | `Window of any widget
  | `Image of string
]
;;

type linechar_index = int * int;;
type num_index = int;;




(* type *)
type paletteType = [
  | `Gray of int
  | `Rgb of int * int * int
]
;;
(* /type *)


(* Not a string as such, more like a symbol *)

(* type *)
type textMark = string;;
(* /type *)

(* type *)
type textTag = string;;
(* /type *)



(* type *)
type textModifier = [
  | `Char of int                (* tk keyword: +/- Xchars *)
  | `Line of int                (* tk keyword: +/- Xlines *)
  | `Linestart                  (* tk keyword: linestart *)
  | `Lineend                    (* tk keyword: lineend *)
  | `Wordstart                  (* tk keyword: wordstart *)
  | `Wordend                    (* tk keyword: wordend *)
]
;;
(* /type *)

(* type *)
type textIndex = text_index * textModifier list
;;
(* /type *)


(* Variant type *)
type anchor = [
  | `Center        (* tk option: center *)
  | `E        (* tk option: e *)
  | `N        (* tk option: n *)
  | `Ne        (* tk option: ne *)
  | `Nw        (* tk option: nw *)
  | `S        (* tk option: s *)
  | `Se        (* tk option: se *)
  | `Sw        (* tk option: sw *)
  | `W        (* tk option: w *)
]

(* Variant type *)
type image = [
  | `Bitmap of (string)        (* tk option: <string> *)
  | `Photo of (string)        (* tk option: <string> *)
]

(* Variant type *)
type justification = [
  | `Center        (* tk option: center *)
  | `Left        (* tk option: left *)
  | `Right        (* tk option: right *)
]

(* Variant type *)
type orientation = [
  | `Horizontal        (* tk option: horizontal *)
  | `Vertical        (* tk option: vertical *)
]

(* Variant type *)
type relief = [
  | `Flat        (* tk option: flat *)
  | `Groove        (* tk option: groove *)
  | `Raised        (* tk option: raised *)
  | `Ridge        (* tk option: ridge *)
  | `Solid        (* tk option: solid *)
  | `Sunken        (* tk option: sunken *)
]

(* Variant type *)
type state = [
  | `Active        (* tk option: active *)
  | `Disabled        (* tk option: disabled *)
  | `Hidden        (* tk option: hidden *)
  | `Normal        (* tk option: normal *)
]

(* Variant type *)
type colorMode = [
  | `Color        (* tk option: color *)
  | `Gray        (* tk option: gray *)
  | `Mono        (* tk option: mono *)
]

(* Variant type *)
type arcStyle = [
  | `Arc        (* tk option: arc *)
  | `Chord        (* tk option: chord *)
  | `Pieslice        (* tk option: pieslice *)
]

(* Variant type *)
type arrowStyle = [
  | `Both        (* tk option: both *)
  | `First        (* tk option: first *)
  | `Last        (* tk option: last *)
  | `None        (* tk option: none *)
]

(* Variant type *)
type capStyle = [
  | `Butt        (* tk option: butt *)
  | `Projecting        (* tk option: projecting *)
  | `Round        (* tk option: round *)
]

(* Variant type *)
type joinStyle = [
  | `Bevel        (* tk option: bevel *)
  | `Miter        (* tk option: miter *)
  | `Round        (* tk option: round *)
]

(* Variant type *)
type canvasTextState = [
  | `Disabled        (* tk option: disabled *)
  | `Hidden        (* tk option: hidden *)
  | `Normal        (* tk option: normal *)
]

(* Variant type *)
type inputState = [
  | `Disabled        (* tk option: disabled *)
  | `Normal        (* tk option: normal *)
]

(* Variant type *)
type weight = [
  | `Bold        (* tk option: bold *)
  | `Normal        (* tk option: normal *)
]

(* Variant type *)
type slant = [
  | `Italic        (* tk option: italic *)
  | `Roman        (* tk option: roman *)
]

(* Variant type *)
type visual = [
  | `Best        (* tk option: best *)
  | `Bestdepth of (int)        (* tk option: {best <int>} *)
  | `Clas of (string * int)        (* tk option: {<string> <int>} *)
  | `Default        (* tk option: default *)
  | `Widget of (any widget)        (* tk option: <'a widget> *)
]

(* Variant type *)
type colormap = [
  | `New        (* tk option: new *)
  | `Widget of (any widget)        (* tk option: <'a widget> *)
]

(* Variant type *)
type selectModeType = [
  | `Browse        (* tk option: browse *)
  | `Extended        (* tk option: extended *)
  | `Multiple        (* tk option: multiple *)
  | `Single        (* tk option: single *)
]

(* Variant type *)
type menuType = [
  | `Menubar        (* tk option: menubar *)
  | `Normal        (* tk option: normal *)
  | `Tearoff        (* tk option: tearoff *)
]

(* Variant type *)
type menubuttonDirection = [
  | `Above        (* tk option: above *)
  | `Below        (* tk option: below *)
  | `Left        (* tk option: left *)
  | `Right        (* tk option: right *)
]

(* Variant type *)
type fillMode = [
  | `Both        (* tk option: both *)
  | `None        (* tk option: none *)
  | `X        (* tk option: x *)
  | `Y        (* tk option: y *)
]

(* Variant type *)
type side = [
  | `Bottom        (* tk option: bottom *)
  | `Left        (* tk option: left *)
  | `Right        (* tk option: right *)
  | `Top        (* tk option: top *)
]

(* Variant type *)
type borderMode = [
  | `Ignore        (* tk option: ignore *)
  | `Inside        (* tk option: inside *)
  | `Outside        (* tk option: outside *)
]

(* Variant type *)
type alignType = [
  | `Baseline        (* tk option: baseline *)
  | `Bottom        (* tk option: bottom *)
  | `Center        (* tk option: center *)
  | `Top        (* tk option: top *)
]

(* Variant type *)
type wrapMode = [
  | `Char        (* tk option: char *)
  | `None        (* tk option: none *)
  | `Word        (* tk option: word *)
]

(* Variant type *)
type tabType = [
  | `TabCenter of (int)        (* tk option: <int> center *)
  | `TabLeft of (int)        (* tk option: <int> left *)
  | `TabNumeric of (int)        (* tk option: <int> numeric *)
  | `TabRight of (int)        (* tk option: <int> right *)
]

(* Variant type *)
type messageIcon = [
  | `Error        (* tk option: error *)
  | `Info        (* tk option: info *)
  | `Question        (* tk option: question *)
  | `Warning        (* tk option: warning *)
]

(* Variant type *)
type messageType = [
  | `Abortretryignore        (* tk option: abortretryignore *)
  | `Ok        (* tk option: ok *)
  | `Okcancel        (* tk option: okcancel *)
  | `Retrycancel        (* tk option: retrycancel *)
  | `Yesno        (* tk option: yesno *)
  | `Yesnocancel        (* tk option: yesnocancel *)
]

(* Variant type *)
type tagOrId = [
  | `Id of (int)        (* tk option: <int> *)
  | `Tag of (string)        (* tk option: <string> *)
]

(* Variant type *)
type imageBitmap = [
  | `Bitmap of (string)        (* tk option: <string> *)
]

(* Variant type *)
type imagePhoto = [
  | `Photo of (string)        (* tk option: <string> *)
]

(* Variant type *)
type searchSpec = [
  | `Above of (tagOrId)        (* tk option: above <tagOrId> *)
  | `All        (* tk option: all *)
  | `Below of (tagOrId)        (* tk option: below <tagOrId> *)
  | `Closest of (int * int)        (* tk option: closest <int> <int> *)
  | `Closesthalo of (int * int * int)        (* tk option: closest <int> <int> <int> *)
  | `Closesthalostart of (int * int * int * tagOrId)        (* tk option: closest <int> <int> <int> <tagOrId> *)
  | `Enclosed of (int * int * int * int)        (* tk option: enclosed <int> <int> <int> <int> *)
  | `Overlapping of (int * int * int * int)        (* tk option: overlapping <int> <int> <int> <int> *)
  | `Withtag of (tagOrId)        (* tk option: withtag <tagOrId> *)
]

(* Variant type *)
type canvasItem = [
  | `Arc        (* tk option: arc *)
  | `Bitmap        (* tk option: bitmap *)
  | `Image        (* tk option: image *)
  | `Line        (* tk option: line *)
  | `Oval        (* tk option: oval *)
  | `Polygon        (* tk option: polygon *)
  | `Rectangle        (* tk option: rectangle *)
  | `Text        (* tk option: text *)
  | `User_item of (string)        (* tk option: <string> *)
  | `Window        (* tk option: window *)
]

(* Variant type *)
type fontMetrics = [
  | `Ascent        (* tk option: -ascent *)
  | `Descent        (* tk option: -descent *)
  | `Fixed        (* tk option: -fixed *)
  | `Linespace        (* tk option: -linespace *)
]

(* Variant type *)
type grabStatus = [
  | `Global        (* tk option: global *)
  | `Local        (* tk option: local *)
  | `None        (* tk option: none *)
]

(* Variant type *)
type menuItem = [
  | `Cascade        (* tk option: cascade *)
  | `Checkbutton        (* tk option: checkbutton *)
  | `Command        (* tk option: command *)
  | `Radiobutton        (* tk option: radiobutton *)
  | `Separator        (* tk option: separator *)
  | `Tearoff        (* tk option: tearoff *)
]

(* Variant type *)
type optionPriority = [
  | `Interactive        (* tk option: interactive *)
  | `Priority of (int)        (* tk option: <int> *)
  | `StartupFile        (* tk option: startupFile *)
  | `UserDefault        (* tk option: userDefault *)
  | `WidgetDefault        (* tk option: widgetDefault *)
]

(* Variant type *)
type scaleElement = [
  | `Beyond        (* tk option:  *)
  | `Slider        (* tk option: slider *)
  | `Trough1        (* tk option: trough1 *)
  | `Trough2        (* tk option: trough2 *)
]

(* Variant type *)
type scrollbarElement = [
  | `Arrow1        (* tk option: arrow1 *)
  | `Arrow2        (* tk option: arrow2 *)
  | `Beyond        (* tk option:  *)
  | `Slider        (* tk option: slider *)
  | `Through1        (* tk option: through1 *)
  | `Through2        (* tk option: through2 *)
]

(* Variant type *)
type sendOption = [
  | `Async        (* tk option: -async *)
  | `Displayof of (any widget)        (* tk option: -displayof <'a widget> *)
]

(* Variant type *)
type comparison = [
  | `Eq        (* tk option: == *)
  | `Ge        (* tk option: >= *)
  | `Gt        (* tk option: > *)
  | `Le        (* tk option: <= *)
  | `Lt        (* tk option: < *)
  | `Neq        (* tk option: != *)
]

(* Variant type *)
type markDirection = [
  | `Left        (* tk option: left *)
  | `Right        (* tk option: right *)
]

(* Variant type *)
type textSearch = [
  | `Backwards        (* tk option: -backwards *)
  | `Count of (textVariable)        (* tk option: -count <textVariable> *)
  | `Exact        (* tk option: -exact *)
  | `Forwards        (* tk option: -forwards *)
  | `Nocase        (* tk option: -nocase *)
  | `Regexp        (* tk option: -regexp *)
]

(* Variant type *)
type text_dump = [
  | `All        (* tk option: -all *)
  | `Command of ((key:string -> value:string -> index:string -> unit))        (* tk option: -command <(key:string -> value:string -> index:string -> unit)> *)
  | `Mark        (* tk option: -mark *)
  | `Tag        (* tk option: -tag *)
  | `Text        (* tk option: -text *)
  | `Window        (* tk option: -window *)
]

(* Variant type *)
type atomId = [
  | `AtomId of (int)        (* tk option: <int> *)
]

(* Variant type *)
type focusModel = [
  | `Active        (* tk option: active *)
  | `Passive        (* tk option: passive *)
]

(* Variant type *)
type wmFrom = [
  | `Program        (* tk option: program *)
  | `User        (* tk option: user *)
]



module Tkintf = struct


let cCAMLtoTKbitmap : bitmap -> tkArgs = function
  | `File s -> TkToken ("@" ^ s)
  | `Predefined s -> TkToken s
;;

let cTKtoCAMLbitmap s =
 if String.get s 0 = '@'
 then `File (String.sub s ~pos:1 ~len:(String.length s - 1))
 else `Predefined s
;;




let cCAMLtoTKcolor : color -> tkArgs = function
  | `Color x -> TkToken x
  | `Black -> TkToken "black"
  | `White -> TkToken "white"
  | `Red -> TkToken "red"
  | `Green -> TkToken "green"
  | `Blue -> TkToken "blue"
  | `Yellow -> TkToken "yellow"
;;

let cTKtoCAMLcolor = function  s -> `Color s
;;

let cCAMLtoTKcursor : cursor -> tkArgs = function
 | `Xcursor s -> TkToken s
 | `Xcursorfg (s,fg) ->
    TkQuote(TkTokenList [TkToken s; cCAMLtoTKcolor fg])
 | `Xcursorfgbg (s,fg,bg) ->
    TkQuote(TkTokenList [TkToken s; cCAMLtoTKcolor fg; cCAMLtoTKcolor bg])
 | `Cursorfilefg (s,fg) ->
    TkQuote(TkTokenList [TkToken ("@"^s); cCAMLtoTKcolor fg])
 | `Cursormaskfile (s,m,fg,bg) ->
    TkQuote(TkTokenList [TkToken ("@"^s); TkToken m; cCAMLtoTKcolor fg; cCAMLtoTKcolor bg])
;;




let cCAMLtoTKunits : units -> tkArgs = function
  | `Pix (foo) -> TkToken (string_of_int foo)
  | `Mm (foo)  -> TkToken(Printf.sprintf "%gm" foo)
  | `In (foo)  -> TkToken(Printf.sprintf "%gi" foo)
  | `Pt (foo) -> TkToken(Printf.sprintf "%gp" foo)
  | `Cm (foo) -> TkToken(Printf.sprintf "%gc" foo)
;;

let cTKtoCAMLunits str =
  let len = String.length str in
  let num_part str = String.sub str ~pos:0 ~len:(len - 1) in
  match String.get str (pred len) with
  | 'c' -> `Cm (float_of_string (num_part str))
  | 'i' -> `In (float_of_string (num_part str))
  | 'm' -> `Mm (float_of_string (num_part str))
  | 'p' -> `Pt (float_of_string (num_part str))
  | _ -> `Pix(int_of_string str)
;;




let cCAMLtoTKscrollValue : scrollValue -> tkArgs = function
 | `Page v1 ->
    TkTokenList [TkToken"scroll"; TkToken (string_of_int v1); TkToken"pages"]
 | `Unit v1 ->
    TkTokenList [TkToken"scroll"; TkToken (string_of_int v1); TkToken"units"]
 | `Moveto v1 ->
    TkTokenList [TkToken"moveto"; TkToken (Printf.sprintf "%g" v1)]
;;

(* str l -> scrllv -> str l *)
let cTKtoCAMLscrollValue = function
 | "scroll" :: n :: ("pages"|"page") :: l ->
     `Page (int_of_string n), l
 | "scroll" :: n :: "units" :: l ->
     `Unit (int_of_string n), l
 | "moveto" :: f :: l ->
     `Moveto (float_of_string f), l
 | l -> raise (Invalid_argument (String.concat " " ("TKtoCAMLscrollValue"::l)))
;;




let cCAMLtoTKmodifier : modifier -> string = function
 | `Control -> "Control-"
 | `Shift -> "Shift-"
 | `Lock -> "Lock-"
 | `Button1 -> "Button1-"
 | `Button2 -> "Button2-"
 | `Button3 -> "Button3-"
 | `Button4 -> "Button4-"
 | `Button5 -> "Button5-"
 | `Double -> "Double-"
 | `Triple -> "Triple-"
 | `Mod1 -> "Mod1-"
 | `Mod2 -> "Mod2-"
 | `Mod3 -> "Mod3-"
 | `Mod4 -> "Mod4-"
 | `Mod5 -> "Mod5-"
 | `Meta -> "Meta-"
 | `Alt -> "Alt-"
;;

exception IllegalVirtualEvent

let cCAMLtoTKevent (ev : event) =
  let modified = ref false in
  let rec convert = function
    | `Activate -> "Activate"
    | `ButtonPress -> "ButtonPress"
    | `ButtonPressDetail n -> "ButtonPress-"^string_of_int n
    | `ButtonRelease -> "ButtonRelease"
    | `ButtonReleaseDetail n -> "ButtonRelease-"^string_of_int n
    | `Circulate -> "Circulate"
    | `Colormap -> "Colormap"
    | `Configure -> "Configure"
    | `Deactivate -> "Deactivate"
    | `Destroy -> "Destroy"
    | `Enter -> "Enter"
    | `Expose -> "Expose"
    | `FocusIn -> "FocusIn"
    | `FocusOut -> "FocusOut"
    | `Gravity -> "Gravity"
    | `KeyPress -> "KeyPress"
    | `KeyPressDetail s -> "KeyPress-"^s
    | `KeyRelease -> "KeyRelease"
    | `KeyReleaseDetail s -> "KeyRelease-"^s
    | `Leave -> "Leave"
    | `Map -> "Map"
    | `Motion -> "Motion"
    | `Property -> "Property"
    | `Reparent -> "Reparent"
    | `Unmap -> "Unmap"
    | `Visibility -> "Visibility"
    | `Virtual s ->
        if !modified then raise IllegalVirtualEvent else "<"^s^">"
    | `Modified(ml, ev) ->
        modified := true;
        String.concat ~sep:"" (List.map ~f:cCAMLtoTKmodifier ml)
        ^ convert ev
  in "<" ^ convert ev ^ ">"
;;

let cCAMLtoTKeventSequence (l : event list) =
  TkToken(String.concat ~sep:"" (List.map ~f:cCAMLtoTKevent l))
;;




let cCAMLtoTKbindings = function
| `Widget v1 -> cCAMLtoTKwidget v1
| `Tag v1 -> TkToken v1
;;

(* this doesn't really belong here *)
let cTKtoCAMLbindings s =
  if String.length s > 0 && s.[0] = '.' then
    `Widget (cTKtoCAMLwidget s)
  else `Tag s
;;


let cCAMLtoTKfont (s : font) = TkToken s
let cTKtoCAMLfont (s : font) = s
let cCAMLtoTKgrabGlobal x =
  if x then TkToken "-global" else TkTokenList []


let cCAMLtoTKindex (* Don't put explicit typing *) = function
 | `Num x -> TkToken (string_of_int x)
 | `Active -> TkToken "active"
 | `End -> TkToken "end"
 | `Last -> TkToken "last"
 | `None -> TkToken "none"
 | `Insert -> TkToken "insert"
 | `Selfirst -> TkToken "sel.first"
 | `Sellast -> TkToken "sel.last"
 | `At n -> TkToken ("@" ^ string_of_int n)
 | `Atxy (x,y) -> TkToken ("@" ^ string_of_int x ^ "," ^ string_of_int y)
 | `Anchor -> TkToken "anchor"
 | `Pattern s -> TkToken s
 | `Linechar (l,c) -> TkToken (string_of_int l ^ "." ^ string_of_int c)
 | `Mark s -> TkToken s
 | `Tagfirst t -> TkToken (t ^ ".first")
 | `Taglast t -> TkToken (t ^ ".last")
 | `Window (w : any widget) -> cCAMLtoTKwidget w
 | `Image s -> TkToken s
;;

let cCAMLtoTKcanvas_index = (cCAMLtoTKindex : canvas_index -> tkArgs);;
let cCAMLtoTKentry_index = (cCAMLtoTKindex : entry_index -> tkArgs);;
let cCAMLtoTKlistbox_index = (cCAMLtoTKindex : listbox_index -> tkArgs);;
let cCAMLtoTKmenu_index = (cCAMLtoTKindex : menu_index -> tkArgs);;
let cCAMLtoTKtext_index = (cCAMLtoTKindex : text_index -> tkArgs);;

(* Assume returned values are only numerical and l.c *)

let cTKtoCAMLtext_index s =
  try
   let p = String.index s '.' in
    `Linechar (int_of_string (String.sub s ~pos:0 ~len:p),
             int_of_string (String.sub s ~pos:(p + 1)
                                         ~len:(String.length s - p - 1)))
  with
    Not_found ->
      raise (Invalid_argument ("TKtoCAMLtext_index: " ^ s))
;;

let cTKtoCAMLlistbox_index s =
  try `Num (int_of_string s)
  with _ -> raise (Invalid_argument ("TKtoCAMLlistbox_index: " ^ s))
;;




let cCAMLtoTKpaletteType : paletteType -> tkArgs = function
  | `Gray (foo) -> TkToken (string_of_int foo)
  | `Rgb (r,v,b) -> TkToken (string_of_int r ^ "/" ^
                             string_of_int v ^ "/" ^
                             string_of_int b)
;;


let cCAMLtoTKtextMark  x =  TkToken x;;
let cTKtoCAMLtextMark x = x;;

let cCAMLtoTKtextTag  x =  TkToken x;;
let cTKtoCAMLtextTag x = x;;



(* TextModifiers are never returned by Tk *)
let cCAMLtoTKtextIndex (i : textIndex) =
  let ppTextModifier = function
    | `Char n ->
        if n > 0 then "+" ^ (string_of_int n) ^ "chars"
        else if n = 0 then ""
        else (string_of_int n) ^ "chars"
    | `Line n ->
        if n > 0 then "+" ^ (string_of_int n) ^ "lines"
        else if n = 0 then ""
        else (string_of_int n) ^ "lines"
    | `Linestart -> " linestart"
    | `Lineend -> " lineend"
    | `Wordstart -> " wordstart"
    | `Wordend -> " wordend"
  in
  let ppTextIndex (base, ml : textIndex) =
    match cCAMLtoTKtext_index base with
      TkToken ppbase ->
        String.concat ~sep:"" (ppbase :: List.map ~f:ppTextModifier ml)
    | _ -> assert false
  in
  TkToken (ppTextIndex i)
;;


let cCAMLtoTKanchor : anchor -> tkArgs  = function
  | `Se -> TkToken "se"
  | `S -> TkToken "s"
  | `Sw -> TkToken "sw"
  | `E -> TkToken "e"
  | `Center -> TkToken "center"
  | `W -> TkToken "w"
  | `Ne -> TkToken "ne"
  | `N -> TkToken "n"
  | `Nw -> TkToken "nw"


let cCAMLtoTKimage : [< image] -> tkArgs  = function
  | `Photo v1 -> TkToken v1
  | `Bitmap v1 -> TkToken v1


let cCAMLtoTKjustification : justification -> tkArgs  = function
  | `Right -> TkToken "right"
  | `Center -> TkToken "center"
  | `Left -> TkToken "left"


let cCAMLtoTKorientation : orientation -> tkArgs  = function
  | `Horizontal -> TkToken "horizontal"
  | `Vertical -> TkToken "vertical"


let cCAMLtoTKrelief : relief -> tkArgs  = function
  | `Groove -> TkToken "groove"
  | `Solid -> TkToken "solid"
  | `Ridge -> TkToken "ridge"
  | `Flat -> TkToken "flat"
  | `Sunken -> TkToken "sunken"
  | `Raised -> TkToken "raised"


let cCAMLtoTKstate : state -> tkArgs  = function
  | `Hidden -> TkToken "hidden"
  | `Disabled -> TkToken "disabled"
  | `Active -> TkToken "active"
  | `Normal -> TkToken "normal"


let cCAMLtoTKcolorMode : colorMode -> tkArgs  = function
  | `Mono -> TkToken "mono"
  | `Gray -> TkToken "gray"
  | `Color -> TkToken "color"


let cCAMLtoTKarcStyle : arcStyle -> tkArgs  = function
  | `Pieslice -> TkToken "pieslice"
  | `Chord -> TkToken "chord"
  | `Arc -> TkToken "arc"


let cCAMLtoTKarrowStyle : arrowStyle -> tkArgs  = function
  | `Both -> TkToken "both"
  | `Last -> TkToken "last"
  | `First -> TkToken "first"
  | `None -> TkToken "none"


let cCAMLtoTKcapStyle : capStyle -> tkArgs  = function
  | `Round -> TkToken "round"
  | `Projecting -> TkToken "projecting"
  | `Butt -> TkToken "butt"


let cCAMLtoTKjoinStyle : joinStyle -> tkArgs  = function
  | `Round -> TkToken "round"
  | `Miter -> TkToken "miter"
  | `Bevel -> TkToken "bevel"


let cCAMLtoTKcanvasTextState : canvasTextState -> tkArgs  = function
  | `Hidden -> TkToken "hidden"
  | `Disabled -> TkToken "disabled"
  | `Normal -> TkToken "normal"


let cCAMLtoTKinputState : inputState -> tkArgs  = function
  | `Disabled -> TkToken "disabled"
  | `Normal -> TkToken "normal"


let cCAMLtoTKweight : weight -> tkArgs  = function
  | `Bold -> TkToken "bold"
  | `Normal -> TkToken "normal"


let cCAMLtoTKslant : slant -> tkArgs  = function
  | `Italic -> TkToken "italic"
  | `Roman -> TkToken "roman"


let cCAMLtoTKvisual : visual -> tkArgs  = function
  | `Best -> TkToken "best"
  | `Bestdepth v1 -> TkQuote (TkTokenList [TkToken "best";
    TkToken (string_of_int v1)])
  | `Widget v1 -> cCAMLtoTKwidget v1
  | `Default -> TkToken "default"
  | `Clas ( v1, v2) -> TkQuote (TkTokenList [TkToken v1;
    TkToken (string_of_int v2)])


let cCAMLtoTKcolormap : colormap -> tkArgs  = function
  | `Widget v1 -> cCAMLtoTKwidget v1
  | `New -> TkToken "new"


let cCAMLtoTKselectModeType : selectModeType -> tkArgs  = function
  | `Extended -> TkToken "extended"
  | `Multiple -> TkToken "multiple"
  | `Browse -> TkToken "browse"
  | `Single -> TkToken "single"


let cCAMLtoTKmenuType : menuType -> tkArgs  = function
  | `Normal -> TkToken "normal"
  | `Tearoff -> TkToken "tearoff"
  | `Menubar -> TkToken "menubar"


let cCAMLtoTKmenubuttonDirection : menubuttonDirection -> tkArgs  = function
  | `Right -> TkToken "right"
  | `Left -> TkToken "left"
  | `Below -> TkToken "below"
  | `Above -> TkToken "above"


let cCAMLtoTKfillMode : fillMode -> tkArgs  = function
  | `Both -> TkToken "both"
  | `Y -> TkToken "y"
  | `X -> TkToken "x"
  | `None -> TkToken "none"


let cCAMLtoTKside : side -> tkArgs  = function
  | `Bottom -> TkToken "bottom"
  | `Top -> TkToken "top"
  | `Right -> TkToken "right"
  | `Left -> TkToken "left"


let cCAMLtoTKborderMode : borderMode -> tkArgs  = function
  | `Ignore -> TkToken "ignore"
  | `Outside -> TkToken "outside"
  | `Inside -> TkToken "inside"


let cCAMLtoTKalignType : alignType -> tkArgs  = function
  | `Baseline -> TkToken "baseline"
  | `Center -> TkToken "center"
  | `Bottom -> TkToken "bottom"
  | `Top -> TkToken "top"


let cCAMLtoTKwrapMode : wrapMode -> tkArgs  = function
  | `Word -> TkToken "word"
  | `Char -> TkToken "char"
  | `None -> TkToken "none"


let cCAMLtoTKtabType : tabType -> tkArgs  = function
  | `TabNumeric v1 -> TkTokenList [TkToken (string_of_int v1);
    TkToken "numeric"]
  | `TabCenter v1 -> TkTokenList [TkToken (string_of_int v1);
    TkToken "center"]
  | `TabRight v1 -> TkTokenList [TkToken (string_of_int v1);
    TkToken "right"]
  | `TabLeft v1 -> TkTokenList [TkToken (string_of_int v1);
    TkToken "left"]


let cCAMLtoTKmessageIcon : messageIcon -> tkArgs  = function
  | `Warning -> TkToken "warning"
  | `Question -> TkToken "question"
  | `Info -> TkToken "info"
  | `Error -> TkToken "error"


let cCAMLtoTKmessageType : messageType -> tkArgs  = function
  | `Yesnocancel -> TkToken "yesnocancel"
  | `Yesno -> TkToken "yesno"
  | `Retrycancel -> TkToken "retrycancel"
  | `Okcancel -> TkToken "okcancel"
  | `Ok -> TkToken "ok"
  | `Abortretryignore -> TkToken "abortretryignore"


let cCAMLtoTKtagOrId : tagOrId -> tkArgs  = function
  | `Id v1 -> TkToken (string_of_int v1)
  | `Tag v1 -> TkToken v1


let cTKtoCAMLtagOrId n =
   try `Id (int_of_string n)
   with _ ->
    match n with
    | n -> `Tag n

let cCAMLtoTKimageBitmap : [< imageBitmap] -> tkArgs  = function
  | `Bitmap v1 -> TkToken v1


let cTKtoCAMLimageBitmap n =
    match n with
    | n -> `Bitmap n

let cCAMLtoTKimagePhoto : [< imagePhoto] -> tkArgs  = function
  | `Photo v1 -> TkToken v1


let cTKtoCAMLimagePhoto n =
    match n with
    | n -> `Photo n

let ccCAMLtoTKoptions_messagetype (v1) =
    TkTokenList [TkToken "-type";
    cCAMLtoTKmessageType v1]

let ccCAMLtoTKoptions_message (v1) =
    TkTokenList [TkToken "-message";
    TkToken v1]

let ccCAMLtoTKoptions_messageicon (v1) =
    TkTokenList [TkToken "-icon";
    cCAMLtoTKmessageIcon v1]

let ccCAMLtoTKoptions_messagedefault (v1) =
    TkTokenList [TkToken "-default";
    TkToken v1]

let ccCAMLtoTKoptions_initialfile (v1) =
    TkTokenList [TkToken "-initialfile";
    TkToken v1]

let ccCAMLtoTKoptions_initialdir (v1) =
    TkTokenList [TkToken "-initialdir";
    TkToken v1]

let ccCAMLtoTKoptions_filetypes (v1) =
    TkTokenList [TkToken "-filetypes";
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> cCAMLtoTKfilePattern x) v1)])]

let ccCAMLtoTKoptions_defaultextension (v1) =
    TkTokenList [TkToken "-defaultextension";
    TkToken v1]

let ccCAMLtoTKoptions_screen (v1) =
    TkTokenList [TkToken "-screen";
    TkToken v1]

let ccCAMLtoTKoptions_use (v1) =
    TkTokenList [TkToken "-use";
    TkToken v1]

let ccCAMLtoTKoptions_title (v1) =
    TkTokenList [TkToken "-title";
    TkToken v1]

let ccCAMLtoTKoptions_parent (v1) =
    TkTokenList [TkToken "-parent";
    cCAMLtoTKwidget v1]

let ccCAMLtoTKoptions_initialcolor (v1) =
    TkTokenList [TkToken "-initialcolor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_underline (v1) =
    TkTokenList [TkToken "-underline";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_rmargin (v1) =
    TkTokenList [TkToken "-rmargin";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_overstrike (v1) =
    TkTokenList [TkToken "-overstrike";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_offset (v1) =
    TkTokenList [TkToken "-offset";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_lmargin2 (v1) =
    TkTokenList [TkToken "-lmargin2";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_lmargin1 (v1) =
    TkTokenList [TkToken "-lmargin1";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_fgstipple (v1) =
    TkTokenList [TkToken "-fgstipple";
    cCAMLtoTKbitmap v1]

let ccCAMLtoTKoptions_bgstipple (v1) =
    TkTokenList [TkToken "-bgstipple";
    cCAMLtoTKbitmap v1]

let ccCAMLtoTKoptions_spacing1 (v1) =
    TkTokenList [TkToken "-spacing1";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_spacing2 (v1) =
    TkTokenList [TkToken "-spacing2";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_spacing3 (v1) =
    TkTokenList [TkToken "-spacing3";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_tabs (v1) =
    TkTokenList [TkToken "-tabs";
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> cCAMLtoTKtabType x) v1)])]

let ccCAMLtoTKoptions_wrap (v1) =
    TkTokenList [TkToken "-wrap";
    cCAMLtoTKwrapMode v1]

let ccCAMLtoTKoptions_stretch (v1) =
    TkTokenList [TkToken "-stretch";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_name (v1) =
    TkTokenList [TkToken "-name";
    TkToken v1]

let ccCAMLtoTKoptions_align (v1) =
    TkTokenList [TkToken "-align";
    cCAMLtoTKalignType v1]

let ccCAMLtoTKoptions_activerelief (v1) =
    TkTokenList [TkToken "-activerelief";
    cCAMLtoTKrelief v1]

let ccCAMLtoTKoptions_scrollcommand (v1) =
    TkTokenList [TkToken "-command";
    let id = register_callback dummy ~callback: (fun args ->
        let (a1, args) = cTKtoCAMLscrollValue args in
        v1 ~scroll:a1) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_elementborderwidth (v1) =
    TkTokenList [TkToken "-elementborderwidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_bigincrement (v1) =
    TkTokenList [TkToken "-bigincrement";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_scalecommand (v1) =
    TkTokenList [TkToken "-command";
    let id = register_callback dummy ~callback: (fun args ->
        v1(float_of_string (List.hd args))) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_digits (v1) =
    TkTokenList [TkToken "-digits";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_from (v1) =
    TkTokenList [TkToken "-from";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_length (v1) =
    TkTokenList [TkToken "-length";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_resolution (v1) =
    TkTokenList [TkToken "-resolution";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_showvalue (v1) =
    TkTokenList [TkToken "-showvalue";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_sliderlength (v1) =
    TkTokenList [TkToken "-sliderlength";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_tickinterval (v1) =
    TkTokenList [TkToken "-tickinterval";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_to (v1) =
    TkTokenList [TkToken "-to";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_bordermode (v1) =
    TkTokenList [TkToken "-bordermode";
    cCAMLtoTKborderMode v1]

let ccCAMLtoTKoptions_relheight (v1) =
    TkTokenList [TkToken "-relheight";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_relwidth (v1) =
    TkTokenList [TkToken "-relwidth";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_rely (v1) =
    TkTokenList [TkToken "-rely";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_relx (v1) =
    TkTokenList [TkToken "-relx";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_palette (v1) =
    TkTokenList [TkToken "-palette";
    cCAMLtoTKpaletteType v1]

let ccCAMLtoTKoptions_gamma (v1) =
    TkTokenList [TkToken "-gamma";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_format (v1) =
    TkTokenList [TkToken "-format";
    TkToken v1]

let ccCAMLtoTKoptions_side (v1) =
    TkTokenList [TkToken "-side";
    cCAMLtoTKside v1]

let ccCAMLtoTKoptions_fill (v1) =
    TkTokenList [TkToken "-fill";
    cCAMLtoTKfillMode v1]

let ccCAMLtoTKoptions_expand (v1) =
    TkTokenList [TkToken "-expand";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_before (v1) =
    TkTokenList [TkToken "-before";
    cCAMLtoTKwidget v1]

let ccCAMLtoTKoptions_after (v1) =
    TkTokenList [TkToken "-after";
    cCAMLtoTKwidget v1]

let ccCAMLtoTKoptions_aspect (v1) =
    TkTokenList [TkToken "-aspect";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_direction (v1) =
    TkTokenList [TkToken "-direction";
    cCAMLtoTKmenubuttonDirection v1]

let ccCAMLtoTKoptions_postcommand (v1) =
    TkTokenList [TkToken "-postcommand";
    let id = register_callback dummy ~callback: (fun _ -> v1 ()) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_tearoff (v1) =
    TkTokenList [TkToken "-tearoff";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_tearoffcommand (v1) =
    TkTokenList [TkToken "-tearoffcommand";
    let id = register_callback dummy ~callback: (fun args ->
        let (a1, args) = (Obj.magic (cTKtoCAMLwidget  (List.hd args) ) : any widget), List.tl args in
        let (a2, args) = (Obj.magic (cTKtoCAMLwidget  (List.hd args) ) : any widget), List.tl args in
        v1 ~menu:a1 ~tornoff:a2) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_menutitle (v1) =
    TkTokenList [TkToken "-title";
    TkToken v1]

let ccCAMLtoTKoptions_menutype (v1) =
    TkTokenList [TkToken "-type";
    cCAMLtoTKmenuType v1]

let ccCAMLtoTKoptions_value (v1) =
    TkTokenList [TkToken "-value";
    TkToken v1]

let ccCAMLtoTKoptions_menu (v1) =
    TkTokenList [TkToken "-menu";
    cCAMLtoTKwidget (v1 : menu widget)]

let ccCAMLtoTKoptions_label (v1) =
    TkTokenList [TkToken "-label";
    TkToken v1]

let ccCAMLtoTKoptions_hidemargin (v1) =
    TkTokenList [TkToken "-hidemargin";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_columnbreak (v1) =
    TkTokenList [TkToken "-columnbreak";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_accelerator (v1) =
    TkTokenList [TkToken "-accelerator";
    TkToken v1]

let ccCAMLtoTKoptions_textheight (v1) =
    TkTokenList [TkToken "-height";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_selectmode (v1) =
    TkTokenList [TkToken "-selectmode";
    cCAMLtoTKselectModeType v1]

let ccCAMLtoTKoptions_sticky (v1) =
    TkTokenList [TkToken "-sticky";
    TkToken v1]

let ccCAMLtoTKoptions_rowspan (v1) =
    TkTokenList [TkToken "-rowspan";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_row (v1) =
    TkTokenList [TkToken "-row";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_ipady (v1) =
    TkTokenList [TkToken "-ipady";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_ipadx (v1) =
    TkTokenList [TkToken "-ipadx";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_in (v1) =
    TkTokenList [TkToken "-in";
    cCAMLtoTKwidget v1]

let ccCAMLtoTKoptions_columnspan (v1) =
    TkTokenList [TkToken "-columnspan";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_column (v1) =
    TkTokenList [TkToken "-column";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_pad (v1) =
    TkTokenList [TkToken "-pad";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_weight (v1) =
    TkTokenList [TkToken "-weight";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_minsize (v1) =
    TkTokenList [TkToken "-minsize";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_clas (v1) =
    TkTokenList [TkToken "-class";
    TkToken v1]

let ccCAMLtoTKoptions_colormap (v1) =
    TkTokenList [TkToken "-colormap";
    cCAMLtoTKcolormap v1]

let ccCAMLtoTKoptions_container (v1) =
    TkTokenList [TkToken "-container";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_visual (v1) =
    TkTokenList [TkToken "-visual";
    cCAMLtoTKvisual v1]

let ccCAMLtoTKoptions_font_overstrike (v1) =
    TkTokenList [TkToken "-overstrike";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_font_underline (v1) =
    TkTokenList [TkToken "-underline";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_font_slant (v1) =
    TkTokenList [TkToken "-slant";
    cCAMLtoTKslant v1]

let ccCAMLtoTKoptions_font_weight (v1) =
    TkTokenList [TkToken "-weight";
    cCAMLtoTKweight v1]

let ccCAMLtoTKoptions_font_size (v1) =
    TkTokenList [TkToken "-size";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_font_family (v1) =
    TkTokenList [TkToken "-family";
    TkToken v1]

let ccCAMLtoTKoptions_show (v1) =
    TkTokenList [TkToken "-show";
    TkToken (Char.escaped v1)]

let ccCAMLtoTKoptions_entrystate (v1) =
    TkTokenList [TkToken "-state";
    cCAMLtoTKinputState v1]

let ccCAMLtoTKoptions_textwidth (v1) =
    TkTokenList [TkToken "-width";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_indicatoron (v1) =
    TkTokenList [TkToken "-indicatoron";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_offvalue (v1) =
    TkTokenList [TkToken "-offvalue";
    TkToken v1]

let ccCAMLtoTKoptions_onvalue (v1) =
    TkTokenList [TkToken "-onvalue";
    TkToken v1]

let ccCAMLtoTKoptions_selectcolor (v1) =
    TkTokenList [TkToken "-selectcolor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_selectimage (v1) =
    TkTokenList [TkToken "-selectimage";
    cCAMLtoTKimage v1]

let ccCAMLtoTKoptions_variable (v1) =
    TkTokenList [TkToken "-variable";
    cCAMLtoTKtextVariable v1]

let ccCAMLtoTKoptions_closeenough (v1) =
    TkTokenList [TkToken "-closeenough";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_confine (v1) =
    TkTokenList [TkToken "-confine";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_scrollregion (v1, v2, v3, v4) =
    TkTokenList [TkToken "-scrollregion";
    TkQuote (TkTokenList [TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)])]

let ccCAMLtoTKoptions_xscrollincrement (v1) =
    TkTokenList [TkToken "-xscrollincrement";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_yscrollincrement (v1) =
    TkTokenList [TkToken "-yscrollincrement";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_window (v1) =
    TkTokenList [TkToken "-window";
    cCAMLtoTKwidget v1]

let ccCAMLtoTKoptions_canvastextstate (v1) =
    TkTokenList [TkToken "-state";
    cCAMLtoTKcanvasTextState v1]

let ccCAMLtoTKoptions_splinesteps (v1) =
    TkTokenList [TkToken "-splinesteps";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_smooth (v1) =
    TkTokenList [TkToken "-smooth";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_joinstyle (v1) =
    TkTokenList [TkToken "-joinstyle";
    cCAMLtoTKjoinStyle v1]

let ccCAMLtoTKoptions_capstyle (v1) =
    TkTokenList [TkToken "-capstyle";
    cCAMLtoTKcapStyle v1]

let ccCAMLtoTKoptions_arrowshape (v1, v2, v3) =
    TkTokenList [TkToken "-arrowshape";
    TkQuote (TkTokenList [TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)])]

let ccCAMLtoTKoptions_arrowstyle (v1) =
    TkTokenList [TkToken "-arrow";
    cCAMLtoTKarrowStyle v1]

let ccCAMLtoTKoptions_tags (v1) =
    TkTokenList [TkToken "-tags";
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> TkToken x) v1)])]

let ccCAMLtoTKoptions_arcstyle (v1) =
    TkTokenList [TkToken "-style";
    cCAMLtoTKarcStyle v1]

let ccCAMLtoTKoptions_stipple (v1) =
    TkTokenList [TkToken "-stipple";
    cCAMLtoTKbitmap v1]

let ccCAMLtoTKoptions_start (v1) =
    TkTokenList [TkToken "-start";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_outlinestipple (v1) =
    TkTokenList [TkToken "-outlinestipple";
    cCAMLtoTKbitmap v1]

let ccCAMLtoTKoptions_outline (v1) =
    TkTokenList [TkToken "-outline";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_fillcolor (v1) =
    TkTokenList [TkToken "-fill";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_dash (v1) =
    TkTokenList [TkToken "-dash";
    TkToken v1]

let ccCAMLtoTKoptions_extent (v1) =
    TkTokenList [TkToken "-extent";
    TkToken (Printf.sprintf "%g" v1)]

let ccCAMLtoTKoptions_y (v1) =
    TkTokenList [TkToken "-y";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_x (v1) =
    TkTokenList [TkToken "-x";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_rotate (v1) =
    TkTokenList [TkToken "-rotate";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_pagey (v1) =
    TkTokenList [TkToken "-pagey";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_pagex (v1) =
    TkTokenList [TkToken "-pagex";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_pagewidth (v1) =
    TkTokenList [TkToken "-pagewidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_pageheight (v1) =
    TkTokenList [TkToken "-pageheight";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_pageanchor (v1) =
    TkTokenList [TkToken "-pageanchor";
    cCAMLtoTKanchor v1]

let ccCAMLtoTKoptions_colormode (v1) =
    TkTokenList [TkToken "-colormode";
    cCAMLtoTKcolorMode v1]

let ccCAMLtoTKoptions_command (v1) =
    TkTokenList [TkToken "-command";
    let id = register_callback dummy ~callback: (fun _ -> v1 ()) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_default (v1) =
    TkTokenList [TkToken "-default";
    cCAMLtoTKstate v1]

let ccCAMLtoTKoptions_height (v1) =
    TkTokenList [TkToken "-height";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_state (v1) =
    TkTokenList [TkToken "-state";
    cCAMLtoTKstate v1]

let ccCAMLtoTKoptions_width (v1) =
    TkTokenList [TkToken "-width";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_maskfile (v1) =
    TkTokenList [TkToken "-maskfile";
    TkToken v1]

let ccCAMLtoTKoptions_maskdata (v1) =
    TkTokenList [TkToken "-maskdata";
    TkToken v1]

let ccCAMLtoTKoptions_file (v1) =
    TkTokenList [TkToken "-file";
    TkToken v1]

let ccCAMLtoTKoptions_data (v1) =
    TkTokenList [TkToken "-data";
    TkToken v1]

let ccCAMLtoTKoptions_yscrollcommand (v1) =
    TkTokenList [TkToken "-yscrollcommand";
    let id = register_callback dummy ~callback: (fun args ->
        let (a1, args) = float_of_string (List.hd args), List.tl args in
        let (a2, args) = float_of_string (List.hd args), List.tl args in
        v1 ~first:a1 ~last:a2) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_xscrollcommand (v1) =
    TkTokenList [TkToken "-xscrollcommand";
    let id = register_callback dummy ~callback: (fun args ->
        let (a1, args) = float_of_string (List.hd args), List.tl args in
        let (a2, args) = float_of_string (List.hd args), List.tl args in
        v1 ~first:a1 ~last:a2) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKoptions_wraplength (v1) =
    TkTokenList [TkToken "-wraplength";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_underlinedchar (v1) =
    TkTokenList [TkToken "-underline";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_troughcolor (v1) =
    TkTokenList [TkToken "-troughcolor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_textvariable (v1) =
    TkTokenList [TkToken "-textvariable";
    cCAMLtoTKtextVariable v1]

let ccCAMLtoTKoptions_text (v1) =
    TkTokenList [TkToken "-text";
    TkToken v1]

let ccCAMLtoTKoptions_takefocus (v1) =
    TkTokenList [TkToken "-takefocus";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_setgrid (v1) =
    TkTokenList [TkToken "-setgrid";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_selectforeground (v1) =
    TkTokenList [TkToken "-selectforeground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_selectborderwidth (v1) =
    TkTokenList [TkToken "-selectborderwidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_selectbackground (v1) =
    TkTokenList [TkToken "-selectbackground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_repeatinterval (v1) =
    TkTokenList [TkToken "-repeatinterval";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_repeatdelay (v1) =
    TkTokenList [TkToken "-repeatdelay";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_relief (v1) =
    TkTokenList [TkToken "-relief";
    cCAMLtoTKrelief v1]

let ccCAMLtoTKoptions_pady (v1) =
    TkTokenList [TkToken "-pady";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_padx (v1) =
    TkTokenList [TkToken "-padx";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_orient (v1) =
    TkTokenList [TkToken "-orient";
    cCAMLtoTKorientation v1]

let ccCAMLtoTKoptions_justify (v1) =
    TkTokenList [TkToken "-justify";
    cCAMLtoTKjustification v1]

let ccCAMLtoTKoptions_jump (v1) =
    TkTokenList [TkToken "-jump";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_insertwidth (v1) =
    TkTokenList [TkToken "-insertwidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_insertontime (v1) =
    TkTokenList [TkToken "-insertontime";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_insertofftime (v1) =
    TkTokenList [TkToken "-insertofftime";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_insertborderwidth (v1) =
    TkTokenList [TkToken "-insertborderwidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_insertbackground (v1) =
    TkTokenList [TkToken "-insertbackground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_image (v1) =
    TkTokenList [TkToken "-image";
    cCAMLtoTKimage v1]

let ccCAMLtoTKoptions_highlightthickness (v1) =
    TkTokenList [TkToken "-highlightthickness";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_highlightcolor (v1) =
    TkTokenList [TkToken "-highlightcolor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_highlightbackground (v1) =
    TkTokenList [TkToken "-highlightbackground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_geometry (v1) =
    TkTokenList [TkToken "-geometry";
    TkToken v1]

let ccCAMLtoTKoptions_foreground (v1) =
    TkTokenList [TkToken "-foreground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_font (v1) =
    TkTokenList [TkToken "-font";
    TkToken v1]

let ccCAMLtoTKoptions_exportselection (v1) =
    TkTokenList [TkToken "-exportselection";
    if v1 then TkToken "1" else TkToken "0"]

let ccCAMLtoTKoptions_disabledforeground (v1) =
    TkTokenList [TkToken "-disabledforeground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_cursor (v1) =
    TkTokenList [TkToken "-cursor";
    cCAMLtoTKcursor v1]

let ccCAMLtoTKoptions_borderwidth (v1) =
    TkTokenList [TkToken "-borderwidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_bitmap (v1) =
    TkTokenList [TkToken "-bitmap";
    cCAMLtoTKbitmap v1]

let ccCAMLtoTKoptions_background (v1) =
    TkTokenList [TkToken "-background";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_anchor (v1) =
    TkTokenList [TkToken "-anchor";
    cCAMLtoTKanchor v1]

let ccCAMLtoTKoptions_activeforeground (v1) =
    TkTokenList [TkToken "-activeforeground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKoptions_activeborderwidth (v1) =
    TkTokenList [TkToken "-activeborderwidth";
    TkToken (string_of_int v1)]

let ccCAMLtoTKoptions_activebackground (v1) =
    TkTokenList [TkToken "-activebackground";
    cCAMLtoTKcolor v1]

let messageBox_options_optionals f = fun
  ?default
  ?icon
  ?message
  ?parent
  ?title
  ?typ ->
    f (maycons ccCAMLtoTKoptions_messagedefault default
      (maycons ccCAMLtoTKoptions_messageicon icon
      (maycons ccCAMLtoTKoptions_message message
      (maycons ccCAMLtoTKoptions_parent parent
      (maycons ccCAMLtoTKoptions_title title
      (maycons ccCAMLtoTKoptions_messagetype typ
       []))))))

let getFile_options_optionals f = fun
  ?defaultextension
  ?filetypes
  ?initialdir
  ?initialfile
  ?parent
  ?title ->
    f (maycons ccCAMLtoTKoptions_defaultextension defaultextension
      (maycons ccCAMLtoTKoptions_filetypes filetypes
      (maycons ccCAMLtoTKoptions_initialdir initialdir
      (maycons ccCAMLtoTKoptions_initialfile initialfile
      (maycons ccCAMLtoTKoptions_parent parent
      (maycons ccCAMLtoTKoptions_title title
       []))))))

let toplevel_options_optionals f = fun
  ?background
  ?borderwidth
  ?clas
  ?colormap
  ?container
  ?cursor
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?menu
  ?relief
  ?screen
  ?takefocus
  ?use
  ?visual
  ?width ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_clas clas
      (maycons ccCAMLtoTKoptions_colormap colormap
      (maycons ccCAMLtoTKoptions_container container
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_menu menu
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_screen screen
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_use use
      (maycons ccCAMLtoTKoptions_visual visual
      (maycons ccCAMLtoTKoptions_width width
       [])))))))))))))))))

let chooseColor_options_optionals f = fun
  ?initialcolor
  ?parent
  ?title ->
    f (maycons ccCAMLtoTKoptions_initialcolor initialcolor
      (maycons ccCAMLtoTKoptions_parent parent
      (maycons ccCAMLtoTKoptions_title title
       [])))

let texttag_options_optionals f = fun
  ?background
  ?bgstipple
  ?borderwidth
  ?fgstipple
  ?font
  ?foreground
  ?justify
  ?lmargin1
  ?lmargin2
  ?offset
  ?overstrike
  ?relief
  ?rmargin
  ?spacing1
  ?spacing2
  ?spacing3
  ?tabs
  ?underline
  ?wrap ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bgstipple bgstipple
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_fgstipple fgstipple
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_lmargin1 lmargin1
      (maycons ccCAMLtoTKoptions_lmargin2 lmargin2
      (maycons ccCAMLtoTKoptions_offset offset
      (maycons ccCAMLtoTKoptions_overstrike overstrike
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_rmargin rmargin
      (maycons ccCAMLtoTKoptions_spacing1 spacing1
      (maycons ccCAMLtoTKoptions_spacing2 spacing2
      (maycons ccCAMLtoTKoptions_spacing3 spacing3
      (maycons ccCAMLtoTKoptions_tabs tabs
      (maycons ccCAMLtoTKoptions_underline underline
      (maycons ccCAMLtoTKoptions_wrap wrap
       [])))))))))))))))))))

let text_options_optionals f = fun
  ?background
  ?borderwidth
  ?cursor
  ?exportselection
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?insertbackground
  ?insertborderwidth
  ?insertofftime
  ?insertontime
  ?insertwidth
  ?padx
  ?pady
  ?relief
  ?selectbackground
  ?selectborderwidth
  ?selectforeground
  ?setgrid
  ?spacing1
  ?spacing2
  ?spacing3
  ?state
  ?tabs
  ?takefocus
  ?width
  ?wrap
  ?xscrollcommand
  ?yscrollcommand ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_exportselection exportselection
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_textheight height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_insertbackground insertbackground
      (maycons ccCAMLtoTKoptions_insertborderwidth insertborderwidth
      (maycons ccCAMLtoTKoptions_insertofftime insertofftime
      (maycons ccCAMLtoTKoptions_insertontime insertontime
      (maycons ccCAMLtoTKoptions_insertwidth insertwidth
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_selectbackground selectbackground
      (maycons ccCAMLtoTKoptions_selectborderwidth selectborderwidth
      (maycons ccCAMLtoTKoptions_selectforeground selectforeground
      (maycons ccCAMLtoTKoptions_setgrid setgrid
      (maycons ccCAMLtoTKoptions_spacing1 spacing1
      (maycons ccCAMLtoTKoptions_spacing2 spacing2
      (maycons ccCAMLtoTKoptions_spacing3 spacing3
      (maycons ccCAMLtoTKoptions_entrystate state
      (maycons ccCAMLtoTKoptions_tabs tabs
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_textwidth width
      (maycons ccCAMLtoTKoptions_wrap wrap
      (maycons ccCAMLtoTKoptions_xscrollcommand xscrollcommand
      (maycons ccCAMLtoTKoptions_yscrollcommand yscrollcommand
       []))))))))))))))))))))))))))))))))

let embeddedw_options_optionals f = fun
  ?align
  ?padx
  ?pady
  ?stretch
  ?window ->
    f (maycons ccCAMLtoTKoptions_align align
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_stretch stretch
      (maycons ccCAMLtoTKoptions_window window
       [])))))

let embeddedi_options_optionals f = fun
  ?align
  ?image
  ?name
  ?padx
  ?pady ->
    f (maycons ccCAMLtoTKoptions_align align
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_name name
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
       [])))))

let scrollbar_options_optionals f = fun
  ?activebackground
  ?activerelief
  ?background
  ?borderwidth
  ?command
  ?cursor
  ?elementborderwidth
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?jump
  ?orient
  ?relief
  ?repeatdelay
  ?repeatinterval
  ?takefocus
  ?troughcolor
  ?width ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activerelief activerelief
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_scrollcommand command
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_elementborderwidth elementborderwidth
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_jump jump
      (maycons ccCAMLtoTKoptions_orient orient
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_repeatdelay repeatdelay
      (maycons ccCAMLtoTKoptions_repeatinterval repeatinterval
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_troughcolor troughcolor
      (maycons ccCAMLtoTKoptions_width width
       []))))))))))))))))))

let scale_options_optionals f = fun
  ?activebackground
  ?background
  ?bigincrement
  ?borderwidth
  ?command
  ?cursor
  ?digits
  ?font
  ?foreground
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?label
  ?length
  ?max
  ?min
  ?orient
  ?relief
  ?repeatdelay
  ?repeatinterval
  ?resolution
  ?showvalue
  ?sliderlength
  ?state
  ?takefocus
  ?tickinterval
  ?troughcolor
  ?variable
  ?width ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bigincrement bigincrement
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_scalecommand command
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_digits digits
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_label label
      (maycons ccCAMLtoTKoptions_length length
      (maycons ccCAMLtoTKoptions_to max
      (maycons ccCAMLtoTKoptions_from min
      (maycons ccCAMLtoTKoptions_orient orient
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_repeatdelay repeatdelay
      (maycons ccCAMLtoTKoptions_repeatinterval repeatinterval
      (maycons ccCAMLtoTKoptions_resolution resolution
      (maycons ccCAMLtoTKoptions_showvalue showvalue
      (maycons ccCAMLtoTKoptions_sliderlength sliderlength
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_tickinterval tickinterval
      (maycons ccCAMLtoTKoptions_troughcolor troughcolor
      (maycons ccCAMLtoTKoptions_variable variable
      (maycons ccCAMLtoTKoptions_width width
       [])))))))))))))))))))))))))))))

let radiobutton_options_optionals f = fun
  ?activebackground
  ?activeforeground
  ?anchor
  ?background
  ?bitmap
  ?borderwidth
  ?command
  ?cursor
  ?disabledforeground
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?image
  ?indicatoron
  ?justify
  ?padx
  ?pady
  ?relief
  ?selectcolor
  ?selectimage
  ?state
  ?takefocus
  ?text
  ?textvariable
  ?underline
  ?value
  ?variable
  ?width
  ?wraplength ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_disabledforeground disabledforeground
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_selectcolor selectcolor
      (maycons ccCAMLtoTKoptions_selectimage selectimage
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_value value
      (maycons ccCAMLtoTKoptions_variable variable
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_wraplength wraplength
       []))))))))))))))))))))))))))))))))

let place_options_optionals f = fun
  ?anchor
  ?bordermode
  ?height
  ?inside
  ?relheight
  ?relwidth
  ?relx
  ?rely
  ?width
  ?x
  ?y ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_bordermode bordermode
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_in inside
      (maycons ccCAMLtoTKoptions_relheight relheight
      (maycons ccCAMLtoTKoptions_relwidth relwidth
      (maycons ccCAMLtoTKoptions_relx relx
      (maycons ccCAMLtoTKoptions_rely rely
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_x x
      (maycons ccCAMLtoTKoptions_y y
       [])))))))))))

let photoimage_options_optionals f = fun
  ?data
  ?file
  ?format
  ?gamma
  ?height
  ?palette
  ?width ->
    f (maycons ccCAMLtoTKoptions_data data
      (maycons ccCAMLtoTKoptions_file file
      (maycons ccCAMLtoTKoptions_format format
      (maycons ccCAMLtoTKoptions_gamma gamma
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_palette palette
      (maycons ccCAMLtoTKoptions_width width
       [])))))))

let pack_options_optionals f = fun
  ?after
  ?anchor
  ?before
  ?expand
  ?fill
  ?inside
  ?ipadx
  ?ipady
  ?padx
  ?pady
  ?side ->
    f (maycons ccCAMLtoTKoptions_after after
      (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_before before
      (maycons ccCAMLtoTKoptions_expand expand
      (maycons ccCAMLtoTKoptions_fill fill
      (maycons ccCAMLtoTKoptions_in inside
      (maycons ccCAMLtoTKoptions_ipadx ipadx
      (maycons ccCAMLtoTKoptions_ipady ipady
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_side side
       [])))))))))))

let message_options_optionals f = fun
  ?anchor
  ?aspect
  ?background
  ?borderwidth
  ?cursor
  ?font
  ?foreground
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?justify
  ?padx
  ?pady
  ?relief
  ?takefocus
  ?text
  ?textvariable
  ?width ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_aspect aspect
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_width width
       []))))))))))))))))))

let menubutton_options_optionals f = fun
  ?activebackground
  ?activeforeground
  ?anchor
  ?background
  ?bitmap
  ?borderwidth
  ?cursor
  ?direction
  ?disabledforeground
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?image
  ?indicatoron
  ?justify
  ?menu
  ?padx
  ?pady
  ?relief
  ?state
  ?takefocus
  ?text
  ?textvariable
  ?textwidth
  ?underline
  ?width
  ?wraplength ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_direction direction
      (maycons ccCAMLtoTKoptions_disabledforeground disabledforeground
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_menu menu
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_textwidth textwidth
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_wraplength wraplength
       []))))))))))))))))))))))))))))))

let menu_options_optionals f = fun
  ?activebackground
  ?activeborderwidth
  ?activeforeground
  ?background
  ?borderwidth
  ?cursor
  ?disabledforeground
  ?font
  ?foreground
  ?postcommand
  ?relief
  ?selectcolor
  ?takefocus
  ?tearoff
  ?tearoffcommand
  ?title
  ?typ ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeborderwidth activeborderwidth
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_disabledforeground disabledforeground
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_postcommand postcommand
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_selectcolor selectcolor
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_tearoff tearoff
      (maycons ccCAMLtoTKoptions_tearoffcommand tearoffcommand
      (maycons ccCAMLtoTKoptions_menutitle title
      (maycons ccCAMLtoTKoptions_menutype typ
       [])))))))))))))))))

let menucommand_options_optionals f = fun
  ?accelerator
  ?activebackground
  ?activeforeground
  ?background
  ?bitmap
  ?columnbreak
  ?command
  ?font
  ?foreground
  ?image
  ?label
  ?state
  ?underline ->
    f (maycons ccCAMLtoTKoptions_accelerator accelerator
      (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_columnbreak columnbreak
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_label label
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_underlinedchar underline
       [])))))))))))))

let menucheck_options_optionals f = fun
  ?accelerator
  ?activebackground
  ?activeforeground
  ?background
  ?bitmap
  ?columnbreak
  ?command
  ?font
  ?foreground
  ?image
  ?indicatoron
  ?label
  ?offvalue
  ?onvalue
  ?selectcolor
  ?selectimage
  ?state
  ?underline
  ?variable ->
    f (maycons ccCAMLtoTKoptions_accelerator accelerator
      (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_columnbreak columnbreak
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_label label
      (maycons ccCAMLtoTKoptions_offvalue offvalue
      (maycons ccCAMLtoTKoptions_onvalue onvalue
      (maycons ccCAMLtoTKoptions_selectcolor selectcolor
      (maycons ccCAMLtoTKoptions_selectimage selectimage
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_variable variable
       [])))))))))))))))))))

let menuradio_options_optionals f = fun
  ?accelerator
  ?activebackground
  ?activeforeground
  ?background
  ?bitmap
  ?columnbreak
  ?command
  ?font
  ?foreground
  ?image
  ?indicatoron
  ?label
  ?selectcolor
  ?selectimage
  ?state
  ?underline
  ?value
  ?variable ->
    f (maycons ccCAMLtoTKoptions_accelerator accelerator
      (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_columnbreak columnbreak
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_label label
      (maycons ccCAMLtoTKoptions_selectcolor selectcolor
      (maycons ccCAMLtoTKoptions_selectimage selectimage
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_value value
      (maycons ccCAMLtoTKoptions_variable variable
       []))))))))))))))))))

let menucascade_options_optionals f = fun
  ?accelerator
  ?activebackground
  ?activeforeground
  ?background
  ?bitmap
  ?columnbreak
  ?command
  ?font
  ?foreground
  ?hidemargin
  ?image
  ?indicatoron
  ?label
  ?menu
  ?state
  ?underline ->
    f (maycons ccCAMLtoTKoptions_accelerator accelerator
      (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_columnbreak columnbreak
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_hidemargin hidemargin
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_label label
      (maycons ccCAMLtoTKoptions_menu menu
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_underlinedchar underline
       []))))))))))))))))

let menuentry_options_optionals f = fun
  ?accelerator
  ?activebackground
  ?activeforeground
  ?background
  ?bitmap
  ?columnbreak
  ?command
  ?font
  ?foreground
  ?hidemargin
  ?image
  ?indicatoron
  ?label
  ?menu
  ?offvalue
  ?onvalue
  ?selectcolor
  ?selectimage
  ?state
  ?underline
  ?value
  ?variable ->
    f (maycons ccCAMLtoTKoptions_accelerator accelerator
      (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_columnbreak columnbreak
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_hidemargin hidemargin
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_label label
      (maycons ccCAMLtoTKoptions_menu menu
      (maycons ccCAMLtoTKoptions_offvalue offvalue
      (maycons ccCAMLtoTKoptions_onvalue onvalue
      (maycons ccCAMLtoTKoptions_selectcolor selectcolor
      (maycons ccCAMLtoTKoptions_selectimage selectimage
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_value value
      (maycons ccCAMLtoTKoptions_variable variable
       []))))))))))))))))))))))

let listbox_options_optionals f = fun
  ?background
  ?borderwidth
  ?cursor
  ?exportselection
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?relief
  ?selectbackground
  ?selectborderwidth
  ?selectforeground
  ?selectmode
  ?setgrid
  ?takefocus
  ?width
  ?xscrollcommand
  ?yscrollcommand ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_exportselection exportselection
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_textheight height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_selectbackground selectbackground
      (maycons ccCAMLtoTKoptions_selectborderwidth selectborderwidth
      (maycons ccCAMLtoTKoptions_selectforeground selectforeground
      (maycons ccCAMLtoTKoptions_selectmode selectmode
      (maycons ccCAMLtoTKoptions_setgrid setgrid
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_textwidth width
      (maycons ccCAMLtoTKoptions_xscrollcommand xscrollcommand
      (maycons ccCAMLtoTKoptions_yscrollcommand yscrollcommand
       []))))))))))))))))))))

let label_options_optionals f = fun
  ?anchor
  ?background
  ?bitmap
  ?borderwidth
  ?cursor
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?image
  ?justify
  ?padx
  ?pady
  ?relief
  ?takefocus
  ?text
  ?textvariable
  ?textwidth
  ?underline
  ?width
  ?wraplength ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_textwidth textwidth
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_wraplength wraplength
       [])))))))))))))))))))))))

let grid_options_optionals f = fun
  ?column
  ?columnspan
  ?inside
  ?ipadx
  ?ipady
  ?padx
  ?pady
  ?row
  ?rowspan
  ?sticky ->
    f (maycons ccCAMLtoTKoptions_column column
      (maycons ccCAMLtoTKoptions_columnspan columnspan
      (maycons ccCAMLtoTKoptions_in inside
      (maycons ccCAMLtoTKoptions_ipadx ipadx
      (maycons ccCAMLtoTKoptions_ipady ipady
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_row row
      (maycons ccCAMLtoTKoptions_rowspan rowspan
      (maycons ccCAMLtoTKoptions_sticky sticky
       []))))))))))

let rowcolumnconfigure_options_optionals f = fun
  ?minsize
  ?pad
  ?weight ->
    f (maycons ccCAMLtoTKoptions_minsize minsize
      (maycons ccCAMLtoTKoptions_pad pad
      (maycons ccCAMLtoTKoptions_weight weight
       [])))

let frame_options_optionals f = fun
  ?background
  ?borderwidth
  ?clas
  ?colormap
  ?container
  ?cursor
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?relief
  ?takefocus
  ?visual
  ?width ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_clas clas
      (maycons ccCAMLtoTKoptions_colormap colormap
      (maycons ccCAMLtoTKoptions_container container
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_visual visual
      (maycons ccCAMLtoTKoptions_width width
       []))))))))))))))

let font_options_optionals f = fun
  ?family
  ?overstrike
  ?size
  ?slant
  ?underline
  ?weight ->
    f (maycons ccCAMLtoTKoptions_font_family family
      (maycons ccCAMLtoTKoptions_font_overstrike overstrike
      (maycons ccCAMLtoTKoptions_font_size size
      (maycons ccCAMLtoTKoptions_font_slant slant
      (maycons ccCAMLtoTKoptions_font_underline underline
      (maycons ccCAMLtoTKoptions_font_weight weight
       []))))))

let entry_options_optionals f = fun
  ?background
  ?borderwidth
  ?cursor
  ?exportselection
  ?font
  ?foreground
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?insertbackground
  ?insertborderwidth
  ?insertofftime
  ?insertontime
  ?insertwidth
  ?justify
  ?relief
  ?selectbackground
  ?selectborderwidth
  ?selectforeground
  ?show
  ?state
  ?takefocus
  ?textvariable
  ?width
  ?xscrollcommand ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_exportselection exportselection
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_insertbackground insertbackground
      (maycons ccCAMLtoTKoptions_insertborderwidth insertborderwidth
      (maycons ccCAMLtoTKoptions_insertofftime insertofftime
      (maycons ccCAMLtoTKoptions_insertontime insertontime
      (maycons ccCAMLtoTKoptions_insertwidth insertwidth
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_selectbackground selectbackground
      (maycons ccCAMLtoTKoptions_selectborderwidth selectborderwidth
      (maycons ccCAMLtoTKoptions_selectforeground selectforeground
      (maycons ccCAMLtoTKoptions_show show
      (maycons ccCAMLtoTKoptions_entrystate state
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_textwidth width
      (maycons ccCAMLtoTKoptions_xscrollcommand xscrollcommand
       [])))))))))))))))))))))))))

let checkbutton_options_optionals f = fun
  ?activebackground
  ?activeforeground
  ?anchor
  ?background
  ?bitmap
  ?borderwidth
  ?command
  ?cursor
  ?disabledforeground
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?image
  ?indicatoron
  ?justify
  ?offvalue
  ?onvalue
  ?padx
  ?pady
  ?relief
  ?selectcolor
  ?selectimage
  ?state
  ?takefocus
  ?text
  ?textvariable
  ?underline
  ?variable
  ?width
  ?wraplength ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_disabledforeground disabledforeground
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_indicatoron indicatoron
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_offvalue offvalue
      (maycons ccCAMLtoTKoptions_onvalue onvalue
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_selectcolor selectcolor
      (maycons ccCAMLtoTKoptions_selectimage selectimage
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_variable variable
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_wraplength wraplength
       [])))))))))))))))))))))))))))))))))

let canvas_options_optionals f = fun
  ?background
  ?borderwidth
  ?closeenough
  ?confine
  ?cursor
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?insertbackground
  ?insertborderwidth
  ?insertofftime
  ?insertontime
  ?insertwidth
  ?relief
  ?scrollregion
  ?selectbackground
  ?selectborderwidth
  ?selectforeground
  ?takefocus
  ?width
  ?xscrollcommand
  ?xscrollincrement
  ?yscrollcommand
  ?yscrollincrement ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_closeenough closeenough
      (maycons ccCAMLtoTKoptions_confine confine
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_insertbackground insertbackground
      (maycons ccCAMLtoTKoptions_insertborderwidth insertborderwidth
      (maycons ccCAMLtoTKoptions_insertofftime insertofftime
      (maycons ccCAMLtoTKoptions_insertontime insertontime
      (maycons ccCAMLtoTKoptions_insertwidth insertwidth
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_scrollregion scrollregion
      (maycons ccCAMLtoTKoptions_selectbackground selectbackground
      (maycons ccCAMLtoTKoptions_selectborderwidth selectborderwidth
      (maycons ccCAMLtoTKoptions_selectforeground selectforeground
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_xscrollcommand xscrollcommand
      (maycons ccCAMLtoTKoptions_xscrollincrement xscrollincrement
      (maycons ccCAMLtoTKoptions_yscrollcommand yscrollcommand
      (maycons ccCAMLtoTKoptions_yscrollincrement yscrollincrement
       [])))))))))))))))))))))))))

let window_options_optionals f = fun
  ?anchor
  ?dash
  ?height
  ?tags
  ?width
  ?window ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_dash dash
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_window window
       []))))))

let canvastext_options_optionals f = fun
  ?anchor
  ?fill
  ?font
  ?justify
  ?state
  ?stipple
  ?tags
  ?text
  ?width ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_fillcolor fill
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_canvastextstate state
      (maycons ccCAMLtoTKoptions_stipple stipple
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_width width
       [])))))))))

let rectangle_options_optionals f = fun
  ?dash
  ?fill
  ?outline
  ?stipple
  ?tags
  ?width ->
    f (maycons ccCAMLtoTKoptions_dash dash
      (maycons ccCAMLtoTKoptions_fillcolor fill
      (maycons ccCAMLtoTKoptions_outline outline
      (maycons ccCAMLtoTKoptions_stipple stipple
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_width width
       []))))))

let polygon_options_optionals f = fun
  ?dash
  ?fill
  ?outline
  ?smooth
  ?splinesteps
  ?stipple
  ?tags
  ?width ->
    f (maycons ccCAMLtoTKoptions_dash dash
      (maycons ccCAMLtoTKoptions_fillcolor fill
      (maycons ccCAMLtoTKoptions_outline outline
      (maycons ccCAMLtoTKoptions_smooth smooth
      (maycons ccCAMLtoTKoptions_splinesteps splinesteps
      (maycons ccCAMLtoTKoptions_stipple stipple
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_width width
       []))))))))

let oval_options_optionals f = fun
  ?dash
  ?fill
  ?outline
  ?stipple
  ?tags
  ?width ->
    f (maycons ccCAMLtoTKoptions_dash dash
      (maycons ccCAMLtoTKoptions_fillcolor fill
      (maycons ccCAMLtoTKoptions_outline outline
      (maycons ccCAMLtoTKoptions_stipple stipple
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_width width
       []))))))

let line_options_optionals f = fun
  ?arrow
  ?arrowshape
  ?capstyle
  ?dash
  ?fill
  ?joinstyle
  ?smooth
  ?splinesteps
  ?stipple
  ?tags
  ?width ->
    f (maycons ccCAMLtoTKoptions_arrowstyle arrow
      (maycons ccCAMLtoTKoptions_arrowshape arrowshape
      (maycons ccCAMLtoTKoptions_capstyle capstyle
      (maycons ccCAMLtoTKoptions_dash dash
      (maycons ccCAMLtoTKoptions_fillcolor fill
      (maycons ccCAMLtoTKoptions_joinstyle joinstyle
      (maycons ccCAMLtoTKoptions_smooth smooth
      (maycons ccCAMLtoTKoptions_splinesteps splinesteps
      (maycons ccCAMLtoTKoptions_stipple stipple
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_width width
       [])))))))))))

let image_options_optionals f = fun
  ?anchor
  ?image
  ?tags ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_tags tags
       [])))

let bitmap_options_optionals f = fun
  ?anchor
  ?background
  ?bitmap
  ?foreground
  ?tags ->
    f (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_tags tags
       [])))))

let arc_options_optionals f = fun
  ?dash
  ?extent
  ?fill
  ?outline
  ?outlinestipple
  ?start
  ?stipple
  ?style
  ?tags
  ?width ->
    f (maycons ccCAMLtoTKoptions_dash dash
      (maycons ccCAMLtoTKoptions_extent extent
      (maycons ccCAMLtoTKoptions_fillcolor fill
      (maycons ccCAMLtoTKoptions_outline outline
      (maycons ccCAMLtoTKoptions_outlinestipple outlinestipple
      (maycons ccCAMLtoTKoptions_start start
      (maycons ccCAMLtoTKoptions_stipple stipple
      (maycons ccCAMLtoTKoptions_arcstyle style
      (maycons ccCAMLtoTKoptions_tags tags
      (maycons ccCAMLtoTKoptions_width width
       []))))))))))

let postscript_options_optionals f = fun
  ?colormode
  ?file
  ?height
  ?pageanchor
  ?pageheight
  ?pagewidth
  ?pagex
  ?pagey
  ?rotate
  ?width
  ?x
  ?y ->
    f (maycons ccCAMLtoTKoptions_colormode colormode
      (maycons ccCAMLtoTKoptions_file file
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_pageanchor pageanchor
      (maycons ccCAMLtoTKoptions_pageheight pageheight
      (maycons ccCAMLtoTKoptions_pagewidth pagewidth
      (maycons ccCAMLtoTKoptions_pagex pagex
      (maycons ccCAMLtoTKoptions_pagey pagey
      (maycons ccCAMLtoTKoptions_rotate rotate
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_x x
      (maycons ccCAMLtoTKoptions_y y
       []))))))))))))

let button_options_optionals f = fun
  ?activebackground
  ?activeforeground
  ?anchor
  ?background
  ?bitmap
  ?borderwidth
  ?command
  ?cursor
  ?default
  ?disabledforeground
  ?font
  ?foreground
  ?height
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?image
  ?justify
  ?padx
  ?pady
  ?relief
  ?state
  ?takefocus
  ?text
  ?textvariable
  ?underline
  ?width
  ?wraplength ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_command command
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_default default
      (maycons ccCAMLtoTKoptions_disabledforeground disabledforeground
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_height height
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_state state
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_width width
      (maycons ccCAMLtoTKoptions_wraplength wraplength
       []))))))))))))))))))))))))))))

let bitmapimage_options_optionals f = fun
  ?background
  ?data
  ?file
  ?foreground
  ?maskdata
  ?maskfile ->
    f (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_data data
      (maycons ccCAMLtoTKoptions_file file
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_maskdata maskdata
      (maycons ccCAMLtoTKoptions_maskfile maskfile
       []))))))

let standard_options_optionals f = fun
  ?activebackground
  ?activeborderwidth
  ?activeforeground
  ?anchor
  ?background
  ?bitmap
  ?borderwidth
  ?cursor
  ?disabledforeground
  ?exportselection
  ?font
  ?foreground
  ?geometry
  ?highlightbackground
  ?highlightcolor
  ?highlightthickness
  ?image
  ?insertbackground
  ?insertborderwidth
  ?insertofftime
  ?insertontime
  ?insertwidth
  ?jump
  ?justify
  ?orient
  ?padx
  ?pady
  ?relief
  ?repeatdelay
  ?repeatinterval
  ?selectbackground
  ?selectborderwidth
  ?selectforeground
  ?setgrid
  ?takefocus
  ?text
  ?textvariable
  ?troughcolor
  ?underline
  ?wraplength
  ?xscrollcommand
  ?yscrollcommand ->
    f (maycons ccCAMLtoTKoptions_activebackground activebackground
      (maycons ccCAMLtoTKoptions_activeborderwidth activeborderwidth
      (maycons ccCAMLtoTKoptions_activeforeground activeforeground
      (maycons ccCAMLtoTKoptions_anchor anchor
      (maycons ccCAMLtoTKoptions_background background
      (maycons ccCAMLtoTKoptions_bitmap bitmap
      (maycons ccCAMLtoTKoptions_borderwidth borderwidth
      (maycons ccCAMLtoTKoptions_cursor cursor
      (maycons ccCAMLtoTKoptions_disabledforeground disabledforeground
      (maycons ccCAMLtoTKoptions_exportselection exportselection
      (maycons ccCAMLtoTKoptions_font font
      (maycons ccCAMLtoTKoptions_foreground foreground
      (maycons ccCAMLtoTKoptions_geometry geometry
      (maycons ccCAMLtoTKoptions_highlightbackground highlightbackground
      (maycons ccCAMLtoTKoptions_highlightcolor highlightcolor
      (maycons ccCAMLtoTKoptions_highlightthickness highlightthickness
      (maycons ccCAMLtoTKoptions_image image
      (maycons ccCAMLtoTKoptions_insertbackground insertbackground
      (maycons ccCAMLtoTKoptions_insertborderwidth insertborderwidth
      (maycons ccCAMLtoTKoptions_insertofftime insertofftime
      (maycons ccCAMLtoTKoptions_insertontime insertontime
      (maycons ccCAMLtoTKoptions_insertwidth insertwidth
      (maycons ccCAMLtoTKoptions_jump jump
      (maycons ccCAMLtoTKoptions_justify justify
      (maycons ccCAMLtoTKoptions_orient orient
      (maycons ccCAMLtoTKoptions_padx padx
      (maycons ccCAMLtoTKoptions_pady pady
      (maycons ccCAMLtoTKoptions_relief relief
      (maycons ccCAMLtoTKoptions_repeatdelay repeatdelay
      (maycons ccCAMLtoTKoptions_repeatinterval repeatinterval
      (maycons ccCAMLtoTKoptions_selectbackground selectbackground
      (maycons ccCAMLtoTKoptions_selectborderwidth selectborderwidth
      (maycons ccCAMLtoTKoptions_selectforeground selectforeground
      (maycons ccCAMLtoTKoptions_setgrid setgrid
      (maycons ccCAMLtoTKoptions_takefocus takefocus
      (maycons ccCAMLtoTKoptions_text text
      (maycons ccCAMLtoTKoptions_textvariable textvariable
      (maycons ccCAMLtoTKoptions_troughcolor troughcolor
      (maycons ccCAMLtoTKoptions_underlinedchar underline
      (maycons ccCAMLtoTKoptions_wraplength wraplength
      (maycons ccCAMLtoTKoptions_xscrollcommand xscrollcommand
      (maycons ccCAMLtoTKoptions_yscrollcommand yscrollcommand
       []))))))))))))))))))))))))))))))))))))))))))

let cCAMLtoTKsearchSpec : searchSpec -> tkArgs  = function
  | `Withtag v1 -> TkTokenList [TkToken "withtag";
    cCAMLtoTKtagOrId v1]
  | `Overlapping ( v1, v2, v3, v4) -> TkTokenList [TkToken "overlapping";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]
  | `Enclosed ( v1, v2, v3, v4) -> TkTokenList [TkToken "enclosed";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]
  | `Closesthalostart ( v1, v2, v3, v4) -> TkTokenList [TkToken "closest";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    cCAMLtoTKtagOrId v4]
  | `Closesthalo ( v1, v2, v3) -> TkTokenList [TkToken "closest";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3)]
  | `Closest ( v1, v2) -> TkTokenList [TkToken "closest";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]
  | `Below v1 -> TkTokenList [TkToken "below";
    cCAMLtoTKtagOrId v1]
  | `All -> TkToken "all"
  | `Above v1 -> TkTokenList [TkToken "above";
    cCAMLtoTKtagOrId v1]


let cCAMLtoTKcanvasItem : canvasItem -> tkArgs  = function
  | `User_item v1 -> TkToken v1
  | `Window -> TkToken "window"
  | `Text -> TkToken "text"
  | `Rectangle -> TkToken "rectangle"
  | `Polygon -> TkToken "polygon"
  | `Oval -> TkToken "oval"
  | `Line -> TkToken "line"
  | `Image -> TkToken "image"
  | `Bitmap -> TkToken "bitmap"
  | `Arc -> TkToken "arc"


let cTKtoCAMLcanvasItem n =
    match n with
    | "arc" -> `Arc
    | "bitmap" -> `Bitmap
    | "image" -> `Image
    | "line" -> `Line
    | "oval" -> `Oval
    | "polygon" -> `Polygon
    | "rectangle" -> `Rectangle
    | "text" -> `Text
    | "window" -> `Window
    | n -> `User_item n

let ccCAMLtoTKicccm_lostcommand (v1) =
    TkTokenList [TkToken "-command";
    let id = register_callback dummy ~callback: (fun _ -> v1 ()) in TkToken ("camlcb " ^ id)]

let ccCAMLtoTKicccm_selection (v1) =
    TkTokenList [TkToken "-selection";
    TkToken v1]

let ccCAMLtoTKicccm_displayof (v1) =
    TkTokenList [TkToken "-displayof";
    cCAMLtoTKwidget v1]

let ccCAMLtoTKicccm_icccmtype (v1) =
    TkTokenList [TkToken "-type";
    TkToken v1]

let ccCAMLtoTKicccm_icccmformat (v1) =
    TkTokenList [TkToken "-format";
    TkToken v1]

let selection_handle_icccm_optionals f = fun
  ?format
  ?selection
  ?typ ->
    f (maycons ccCAMLtoTKicccm_icccmformat format
      (maycons ccCAMLtoTKicccm_selection selection
      (maycons ccCAMLtoTKicccm_icccmtype typ
       [])))

let selection_ownset_icccm_optionals f = fun
  ?command
  ?selection ->
    f (maycons ccCAMLtoTKicccm_lostcommand command
      (maycons ccCAMLtoTKicccm_selection selection
       []))

let selection_get_icccm_optionals f = fun
  ?displayof
  ?selection
  ?typ ->
    f (maycons ccCAMLtoTKicccm_displayof displayof
      (maycons ccCAMLtoTKicccm_selection selection
      (maycons ccCAMLtoTKicccm_icccmtype typ
       [])))

let selection_clear_icccm_optionals f = fun
  ?displayof
  ?selection ->
    f (maycons ccCAMLtoTKicccm_displayof displayof
      (maycons ccCAMLtoTKicccm_selection selection
       []))

let clipboard_append_icccm_optionals f = fun
  ?format
  ?typ ->
    f (maycons ccCAMLtoTKicccm_icccmformat format
      (maycons ccCAMLtoTKicccm_icccmtype typ
       []))

let cCAMLtoTKfontMetrics : fontMetrics -> tkArgs  = function
  | `Fixed -> TkToken "-fixed"
  | `Linespace -> TkToken "-linespace"
  | `Descent -> TkToken "-descent"
  | `Ascent -> TkToken "-ascent"


let cCAMLtoTKgrabStatus : grabStatus -> tkArgs  = function
  | `Global -> TkToken "global"
  | `Local -> TkToken "local"
  | `None -> TkToken "none"


let cTKtoCAMLgrabStatus n =
    match n with
    | "none" -> `None
    | "local" -> `Local
    | "global" -> `Global
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLgrabStatus: " ^ s))

let cCAMLtoTKmenuItem : menuItem -> tkArgs  = function
  | `Tearoff -> TkToken "tearoff"
  | `Separator -> TkToken "separator"
  | `Radiobutton -> TkToken "radiobutton"
  | `Command -> TkToken "command"
  | `Checkbutton -> TkToken "checkbutton"
  | `Cascade -> TkToken "cascade"


let cTKtoCAMLmenuItem n =
    match n with
    | "cascade" -> `Cascade
    | "checkbutton" -> `Checkbutton
    | "command" -> `Command
    | "radiobutton" -> `Radiobutton
    | "separator" -> `Separator
    | "tearoff" -> `Tearoff
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLmenuItem: " ^ s))

let cCAMLtoTKoptionPriority : optionPriority -> tkArgs  = function
  | `Priority v1 -> TkToken (string_of_int v1)
  | `Interactive -> TkToken "interactive"
  | `UserDefault -> TkToken "userDefault"
  | `StartupFile -> TkToken "startupFile"
  | `WidgetDefault -> TkToken "widgetDefault"


let ccCAMLtoTKtkPalette_palettetroughcolor (v1) =
    TkTokenList [TkToken "troughColor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteforegroundselectcolor (v1) =
    TkTokenList [TkToken "selectForeground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteselectbackground (v1) =
    TkTokenList [TkToken "selectBackground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteselectcolor (v1) =
    TkTokenList [TkToken "selectColor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteinsertbackground (v1) =
    TkTokenList [TkToken "insertBackground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_palettehighlightcolor (v1) =
    TkTokenList [TkToken "highlightColor";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_palettehighlightbackground (v1) =
    TkTokenList [TkToken "hilightBackground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteforeground (v1) =
    TkTokenList [TkToken "foreground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_palettedisabledforeground (v1) =
    TkTokenList [TkToken "disabledForeground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_palettebackground (v1) =
    TkTokenList [TkToken "background";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteactiveforeground (v1) =
    TkTokenList [TkToken "activeForeground";
    cCAMLtoTKcolor v1]

let ccCAMLtoTKtkPalette_paletteactivebackground (v1) =
    TkTokenList [TkToken "activeBackground";
    cCAMLtoTKcolor v1]

let any_tkPalette_optionals f = fun
  ?activebackground
  ?activeforeground
  ?background
  ?disabledforeground
  ?foreground
  ?highlightcolor
  ?hilightbackground
  ?insertbackground
  ?selectbackground
  ?selectcolor
  ?selectforeground
  ?troughcolor ->
    f (maycons ccCAMLtoTKtkPalette_paletteactivebackground activebackground
      (maycons ccCAMLtoTKtkPalette_paletteactiveforeground activeforeground
      (maycons ccCAMLtoTKtkPalette_palettebackground background
      (maycons ccCAMLtoTKtkPalette_palettedisabledforeground disabledforeground
      (maycons ccCAMLtoTKtkPalette_paletteforeground foreground
      (maycons ccCAMLtoTKtkPalette_palettehighlightcolor highlightcolor
      (maycons ccCAMLtoTKtkPalette_palettehighlightbackground hilightbackground
      (maycons ccCAMLtoTKtkPalette_paletteinsertbackground insertbackground
      (maycons ccCAMLtoTKtkPalette_paletteselectbackground selectbackground
      (maycons ccCAMLtoTKtkPalette_paletteselectcolor selectcolor
      (maycons ccCAMLtoTKtkPalette_paletteforegroundselectcolor selectforeground
      (maycons ccCAMLtoTKtkPalette_palettetroughcolor troughcolor
       []))))))))))))

let ccCAMLtoTKphoto_topleft (v1, v2) =
    TkTokenList [TkToken "-to";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]

let ccCAMLtoTKphoto_imgformat (v1) =
    TkTokenList [TkToken "-format";
    TkToken v1]

let ccCAMLtoTKphoto_subsample (v1, v2) =
    TkTokenList [TkToken "-subsample";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]

let ccCAMLtoTKphoto_zoom (v1, v2) =
    TkTokenList [TkToken "-zoom";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]

let ccCAMLtoTKphoto_shrink () =
    TkToken "-shrink"

let ccCAMLtoTKphoto_imgto (v1, v2, v3, v4) =
    TkTokenList [TkToken "-to";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]

let ccCAMLtoTKphoto_imgfrom (v1, v2, v3, v4) =
    TkTokenList [TkToken "-from";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]

let write_photo_optionals f = fun
  ?format
  ?src_area ->
    f (maycons ccCAMLtoTKphoto_imgformat format
      (maycons ccCAMLtoTKphoto_imgfrom src_area
       []))

let read_photo_optionals f = fun
  ?dst_pos
  ?format
  ?shrink
  ?src_area ->
    f (maycons ccCAMLtoTKphoto_topleft dst_pos
      (maycons ccCAMLtoTKphoto_imgformat format
      (maycons ccCAMLtoTKphoto_shrink shrink
      (maycons ccCAMLtoTKphoto_imgfrom src_area
       []))))

let put_photo_optionals f = fun
  ?dst_area ->
    f (maycons ccCAMLtoTKphoto_imgto dst_area
       [])

let copy_photo_optionals f = fun
  ?dst_area
  ?shrink
  ?src_area
  ?subsample
  ?zoom ->
    f (maycons ccCAMLtoTKphoto_imgto dst_area
      (maycons ccCAMLtoTKphoto_shrink shrink
      (maycons ccCAMLtoTKphoto_imgfrom src_area
      (maycons ccCAMLtoTKphoto_subsample subsample
      (maycons ccCAMLtoTKphoto_zoom zoom
       [])))))

let cCAMLtoTKscaleElement : scaleElement -> tkArgs  = function
  | `Beyond -> TkToken ""
  | `Trough2 -> TkToken "trough2"
  | `Trough1 -> TkToken "trough1"
  | `Slider -> TkToken "slider"


let cTKtoCAMLscaleElement n =
    match n with
    | "slider" -> `Slider
    | "trough1" -> `Trough1
    | "trough2" -> `Trough2
    | "" -> `Beyond
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLscaleElement: " ^ s))

let cCAMLtoTKscrollbarElement : scrollbarElement -> tkArgs  = function
  | `Beyond -> TkToken ""
  | `Arrow2 -> TkToken "arrow2"
  | `Slider -> TkToken "slider"
  | `Through2 -> TkToken "through2"
  | `Through1 -> TkToken "through1"
  | `Arrow1 -> TkToken "arrow1"


let cTKtoCAMLscrollbarElement n =
    match n with
    | "arrow1" -> `Arrow1
    | "through1" -> `Through1
    | "through2" -> `Through2
    | "slider" -> `Slider
    | "arrow2" -> `Arrow2
    | "" -> `Beyond
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLscrollbarElement: " ^ s))

let cCAMLtoTKsendOption : sendOption -> tkArgs  = function
  | `Async -> TkToken "-async"
  | `Displayof v1 -> TkTokenList [TkToken "-displayof";
    cCAMLtoTKwidget v1]


let cCAMLtoTKcomparison : comparison -> tkArgs  = function
  | `Neq -> TkToken "!="
  | `Gt -> TkToken ">"
  | `Ge -> TkToken ">="
  | `Eq -> TkToken "=="
  | `Le -> TkToken "<="
  | `Lt -> TkToken "<"


let cCAMLtoTKmarkDirection : markDirection -> tkArgs  = function
  | `Right -> TkToken "right"
  | `Left -> TkToken "left"


let cTKtoCAMLmarkDirection n =
    match n with
    | "left" -> `Left
    | "right" -> `Right
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLmarkDirection: " ^ s))

let cCAMLtoTKtextSearch : textSearch -> tkArgs  = function
  | `Count v1 -> TkTokenList [TkToken "-count";
    cCAMLtoTKtextVariable v1]
  | `Nocase -> TkToken "-nocase"
  | `Regexp -> TkToken "-regexp"
  | `Exact -> TkToken "-exact"
  | `Backwards -> TkToken "-backwards"
  | `Forwards -> TkToken "-forwards"


let cCAMLtoTKtext_dump w : text_dump -> tkArgs  = function
  | `Window -> TkToken "-window"
  | `Text -> TkToken "-text"
  | `Tag -> TkToken "-tag"
  | `Mark -> TkToken "-mark"
  | `Command v1 -> TkTokenList [TkToken "-command";
    let id = register_callback w ~callback: (fun args ->
        let (a1, args) = (List.hd args), List.tl args in
        let (a2, args) = (List.hd args), List.tl args in
        let (a3, args) = (List.hd args), List.tl args in
        v1 ~key:a1 ~value:a2 ~index:a3) in TkToken ("camlcb " ^ id)]
  | `All -> TkToken "-all"


let cCAMLtoTKatomId : atomId -> tkArgs  = function
  | `AtomId v1 -> TkToken (string_of_int v1)


let cTKtoCAMLatomId n =
   try `AtomId (int_of_string n)
   with _ ->
    match n with
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLatomId: " ^ s))

let cCAMLtoTKfocusModel : focusModel -> tkArgs  = function
  | `Passive -> TkToken "passive"
  | `Active -> TkToken "active"


let cTKtoCAMLfocusModel n =
    match n with
    | "active" -> `Active
    | "passive" -> `Passive
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLfocusModel: " ^ s))

let cCAMLtoTKwmFrom : wmFrom -> tkArgs  = function
  | `Program -> TkToken "program"
  | `User -> TkToken "user"


let cTKtoCAMLwmFrom n =
    match n with
    | "user" -> `User
    | "program" -> `Program
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLwmFrom: " ^ s))

let cCAMLtoTKoptions_constrs = function
  | `Sliderlength -> TkToken "-sliderlength"
  | `Cursor -> TkToken "-cursor"
  | `Max -> TkToken "-to"
  | `Tearoff -> TkToken "-tearoff"
  | `Height -> TkToken "-height"
  | `State -> TkToken "-state"
  | `Rowspan -> TkToken "-rowspan"
  | `Selectborderwidth -> TkToken "-selectborderwidth"
  | `Confine -> TkToken "-confine"
  | `Defaultextension -> TkToken "-defaultextension"
  | `Direction -> TkToken "-direction"
  | `Insertwidth -> TkToken "-insertwidth"
  | `Insertontime -> TkToken "-insertontime"
  | `Orient -> TkToken "-orient"
  | `Family -> TkToken "-family"
  | `Selectmode -> TkToken "-selectmode"
  | `Column -> TkToken "-column"
  | `Window -> TkToken "-window"
  | `Jump -> TkToken "-jump"
  | `Initialfile -> TkToken "-initialfile"
  | `Value -> TkToken "-value"
  | `Pad -> TkToken "-pad"
  | `Container -> TkToken "-container"
  | `Selectcolor -> TkToken "-selectcolor"
  | `Initialdir -> TkToken "-initialdir"
  | `Filetypes -> TkToken "-filetypes"
  | `Inside -> TkToken "-in"
  | `Relief -> TkToken "-relief"
  | `Sticky -> TkToken "-sticky"
  | `Bitmap -> TkToken "-bitmap"
  | `Min -> TkToken "-from"
  | `Data -> TkToken "-data"
  | `Type -> TkToken "-type"
  | `Postcommand -> TkToken "-postcommand"
  | `X -> TkToken "-x"
  | `Takefocus -> TkToken "-takefocus"
  | `Relheight -> TkToken "-relheight"
  | `Troughcolor -> TkToken "-troughcolor"
  | `Image -> TkToken "-image"
  | `Resolution -> TkToken "-resolution"
  | `Background -> TkToken "-background"
  | `Icon -> TkToken "-icon"
  | `Accelerator -> TkToken "-accelerator"
  | `Xscrollincrement -> TkToken "-xscrollincrement"
  | `Style -> TkToken "-style"
  | `Indicatoron -> TkToken "-indicatoron"
  | `Colormode -> TkToken "-colormode"
  | `Width -> TkToken "-width"
  | `Class -> TkToken "-class"
  | `After -> TkToken "-after"
  | `Command -> TkToken "-command"
  | `Before -> TkToken "-before"
  | `Format -> TkToken "-format"
  | `Start -> TkToken "-start"
  | `Bgstipple -> TkToken "-bgstipple"
  | `Screen -> TkToken "-screen"
  | `Length -> TkToken "-length"
  | `Onvalue -> TkToken "-onvalue"
  | `Arrowshape -> TkToken "-arrowshape"
  | `Activeborderwidth -> TkToken "-activeborderwidth"
  | `Arrow -> TkToken "-arrow"
  | `Pagex -> TkToken "-pagex"
  | `Pagewidth -> TkToken "-pagewidth"
  | `Spacing1 -> TkToken "-spacing1"
  | `Joinstyle -> TkToken "-joinstyle"
  | `Selectbackground -> TkToken "-selectbackground"
  | `Outline -> TkToken "-outline"
  | `Default -> TkToken "-default"
  | `Palette -> TkToken "-palette"
  | `Scrollregion -> TkToken "-scrollregion"
  | `Size -> TkToken "-size"
  | `Xscrollcommand -> TkToken "-xscrollcommand"
  | `Underline -> TkToken "-underline"
  | `Digits -> TkToken "-digits"
  | `Tags -> TkToken "-tags"
  | `Show -> TkToken "-show"
  | `Padx -> TkToken "-padx"
  | `Foreground -> TkToken "-foreground"
  | `Lmargin1 -> TkToken "-lmargin1"
  | `Tickinterval -> TkToken "-tickinterval"
  | `Weight -> TkToken "-weight"
  | `Splinesteps -> TkToken "-splinesteps"
  | `Colormap -> TkToken "-colormap"
  | `Extent -> TkToken "-extent"
  | `Ipadx -> TkToken "-ipadx"
  | `Capstyle -> TkToken "-capstyle"
  | `Dash -> TkToken "-dash"
  | `Closeenough -> TkToken "-closeenough"
  | `Lmargin2 -> TkToken "-lmargin2"
  | `Relx -> TkToken "-relx"
  | `Geometry -> TkToken "-geometry"
  | `Title -> TkToken "-title"
  | `Offset -> TkToken "-offset"
  | `Fgstipple -> TkToken "-fgstipple"
  | `Tabs -> TkToken "-tabs"
  | `Exportselection -> TkToken "-exportselection"
  | `Maskfile -> TkToken "-maskfile"
  | `Activeforeground -> TkToken "-activeforeground"
  | `Wrap -> TkToken "-wrap"
  | `Label -> TkToken "-label"
  | `Ipady -> TkToken "-ipady"
  | `Variable -> TkToken "-variable"
  | `Spacing3 -> TkToken "-spacing3"
  | `Text -> TkToken "-text"
  | `Repeatinterval -> TkToken "-repeatinterval"
  | `Expand -> TkToken "-expand"
  | `Visual -> TkToken "-visual"
  | `Font -> TkToken "-font"
  | `Gamma -> TkToken "-gamma"
  | `Rotate -> TkToken "-rotate"
  | `Pagey -> TkToken "-pagey"
  | `Yscrollcommand -> TkToken "-yscrollcommand"
  | `Use -> TkToken "-use"
  | `Columnspan -> TkToken "-columnspan"
  | `File -> TkToken "-file"
  | `Y -> TkToken "-y"
  | `Relwidth -> TkToken "-relwidth"
  | `Rely -> TkToken "-rely"
  | `Stretch -> TkToken "-stretch"
  | `Aspect -> TkToken "-aspect"
  | `Minsize -> TkToken "-minsize"
  | `Highlightbackground -> TkToken "-highlightbackground"
  | `Bigincrement -> TkToken "-bigincrement"
  | `Insertborderwidth -> TkToken "-insertborderwidth"
  | `Borderwidth -> TkToken "-borderwidth"
  | `Slant -> TkToken "-slant"
  | `Pageheight -> TkToken "-pageheight"
  | `Textwidth -> TkToken "-width"
  | `Bordermode -> TkToken "-bordermode"
  | `Activerelief -> TkToken "-activerelief"
  | `Offvalue -> TkToken "-offvalue"
  | `Setgrid -> TkToken "-setgrid"
  | `Message -> TkToken "-message"
  | `Selectforeground -> TkToken "-selectforeground"
  | `Rmargin -> TkToken "-rmargin"
  | `Menu -> TkToken "-menu"
  | `Columnbreak -> TkToken "-columnbreak"
  | `Stipple -> TkToken "-stipple"
  | `Textvariable -> TkToken "-textvariable"
  | `Justify -> TkToken "-justify"
  | `Insertofftime -> TkToken "-insertofftime"
  | `Overstrike -> TkToken "-overstrike"
  | `Maskdata -> TkToken "-maskdata"
  | `Pady -> TkToken "-pady"
  | `Tearoffcommand -> TkToken "-tearoffcommand"
  | `Side -> TkToken "-side"
  | `Disabledforeground -> TkToken "-disabledforeground"
  | `Row -> TkToken "-row"
  | `Insertbackground -> TkToken "-insertbackground"
  | `Anchor -> TkToken "-anchor"
  | `Parent -> TkToken "-parent"
  | `Spacing2 -> TkToken "-spacing2"
  | `Yscrollincrement -> TkToken "-yscrollincrement"
  | `Pageanchor -> TkToken "-pageanchor"
  | `Initialcolor -> TkToken "-initialcolor"
  | `Highlightthickness -> TkToken "-highlightthickness"
  | `Fill -> TkToken "-fill"
  | `Repeatdelay -> TkToken "-repeatdelay"
  | `Showvalue -> TkToken "-showvalue"
  | `Outlinestipple -> TkToken "-outlinestipple"
  | `Name -> TkToken "-name"
  | `Align -> TkToken "-align"
  | `Highlightcolor -> TkToken "-highlightcolor"
  | `Hidemargin -> TkToken "-hidemargin"
  | `Selectimage -> TkToken "-selectimage"
  | `Smooth -> TkToken "-smooth"
  | `Wraplength -> TkToken "-wraplength"
  | `Elementborderwidth -> TkToken "-elementborderwidth"
  | `Activebackground -> TkToken "-activebackground"


end (* module Tkintf *)


open Tkintf




let pixels units =
  let res =
    tkEval
     [|TkToken"winfo";
       TkToken"pixels";
       cCAMLtoTKwidget default_toplevel;
       cCAMLtoTKunits units|] in
  int_of_string res




let bind_class ~events ?(extend = false) ?(breakable = false) ?(fields = [])
    ?action ?on:widget name =
  let widget = match widget with None -> Widget.dummy | Some w -> coe w in
  tkCommand
    [| TkToken "bind";
       TkToken name;
       cCAMLtoTKeventSequence events;
       begin match action with None -> TkToken ""
       | Some f ->
           let cbId =
             register_callback widget ~callback: (wrapeventInfo f fields) in
           let cb = if extend then "+camlcb " else "camlcb " in
           let cb = cb ^ cbId ^ writeeventField fields in
           let cb =
             if breakable then
               cb ^ " ; if { $BreakBindingsSequence == 1 } then { break ;}"
               ^ " ; set BreakBindingsSequence 0"
             else cb in
           TkToken cb
       end
     |]
;;

let bind ~events ?extend ?breakable ?fields ?action widget =
  bind_class ~events ?extend ?breakable ?fields ?action ~on:widget
    (Widget.name widget)
;;

let bind_tag = bind_class
;;

(*
FUNCTION
  val break : unit -> unit
/FUNCTION
*)
let break = function () ->
  tkCommand [| TkToken "set" ; TkToken "BreakBindingsSequence" ; TkToken "1" |]
;;


let messageBox ?default:eta =
messageBox_options_optionals ?default:eta (fun opts () ->
let res = tkEval [|TkToken "tk_messageBox";
    TkTokenList opts|] in 
res)

let getSaveFile ?defaultextension:eta =
getFile_options_optionals ?defaultextension:eta (fun opts () ->
let res = tkEval [|TkToken "tk_getSaveFile";
    TkTokenList opts|] in 
res)

let getOpenFile ?defaultextension:eta =
getFile_options_optionals ?defaultextension:eta (fun opts () ->
let res = tkEval [|TkToken "tk_getOpenFile";
    TkTokenList opts|] in 
res)

let update_idletasks () =
tkCommand [|TkToken "update";
    TkToken "idletasks"|]

let update () =
tkCommand [|TkToken "update"|]

let chooseColor ?initialcolor:eta =
chooseColor_options_optionals ?initialcolor:eta (fun opts () ->
let res = tkEval [|TkToken "tk_chooseColor";
    TkTokenList opts|] in 
cTKtoCAMLcolor res)

let scaling_set ?displayof:v1 v2 =
tkCommand [|TkToken "tk";
    TkToken "scaling";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> []);
    TkToken (Printf.sprintf "%g" v2)|]

let scaling_get ?displayof:v1 () =
let res = tkEval [|TkToken "tk";
    TkToken "scaling";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget v1]
 | None -> [])|] in 
float_of_string res

let appname_get () =
let res = tkEval [|TkToken "tk";
    TkToken "appname"|] in 
res

let appname_set v1 =
tkCommand [|TkToken "tk";
    TkToken "appname";
    TkToken v1|]

let send v1 ~app:v2 ~command:v3 =
tkCommand [|TkToken "send";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKsendOption x) v1);
    TkToken "--";
    TkToken v2;
    TkTokenList (List.map ~f:(function x -> TkToken x) v3)|]

let raise_window ?above:v2 v1 =
tkCommand [|TkToken "raise";
    cCAMLtoTKwidget v1;
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKwidget v2]
 | None -> [])|]

let place ?anchor:eta =
place_options_optionals ?anchor:eta (fun opts v1 ->
tkCommand [|TkToken "place";
    cCAMLtoTKwidget v1;
    TkTokenList opts|])

let pack ?after:eta =
pack_options_optionals ?after:eta (fun opts v1 ->
tkCommand [|TkToken "pack";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKwidget x) v1);
    TkTokenList opts|])

let lower_window ?below:v2 v1 =
tkCommand [|TkToken "lower";
    cCAMLtoTKwidget v1;
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKwidget v2]
 | None -> [])|]

let grid ?column:eta =
grid_options_optionals ?column:eta (fun opts v1 ->
tkCommand [|TkToken "grid";
    TkTokenList (List.map ~f:(function x -> cCAMLtoTKwidget x) v1);
    TkTokenList opts|])

let destroy v1 =
tkCommand [|TkToken "destroy";
    cCAMLtoTKwidget v1|]

let bindtags_get v1 =
let res = tkEval [|TkToken "bindtags";
    cCAMLtoTKwidget v1|] in 
    List.map ~f: cTKtoCAMLbindings (splitlist res)

let bindtags v1 ~bindings:v2 =
tkCommand [|TkToken "bindtags";
    cCAMLtoTKwidget v1;
    TkQuote (TkTokenList [TkTokenList (List.map ~f:(function x -> cCAMLtoTKbindings x) v2)])|]

let cget v1 v2 =
let res = tkEval [|cCAMLtoTKwidget v1;
    TkToken "cget";
    cCAMLtoTKoptions_constrs v2|] in 
res

let cgets v1 v2 =
let res = tkEval [|cCAMLtoTKwidget v1;
    TkToken "cget";
    TkToken v2|] in 
res


