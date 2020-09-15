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

