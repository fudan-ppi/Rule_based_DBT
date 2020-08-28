let messageBox v1 =
let res = tkEval [|TkToken "tk_messageBox";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_messageBox_table x) v1)|] in 
res

let getSaveFile v1 =
let res = tkEval [|TkToken "tk_getSaveFile";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_getFile_table x) v1)|] in 
res

let getOpenFile v1 =
let res = tkEval [|TkToken "tk_getOpenFile";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_getFile_table x) v1)|] in 
res

let update_idletasks () =
tkCommand [|TkToken "update";
    TkToken "idletasks"|]

let update () =
tkCommand [|TkToken "update"|]

let chooseColor v1 =
let res = tkEval [|TkToken "tk_chooseColor";
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_chooseColor_table x) v1)|] in 
cTKtoCAMLcolor res

let scaling_set ?displayof:v1 v2 =
tkCommand [|TkToken "tk";
    TkToken "scaling";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
 | None -> []);
    TkToken (Printf.sprintf "%g" v2)|]

let scaling_get ?displayof:v1 () =
let res = tkEval [|TkToken "tk";
    TkToken "scaling";
    TkTokenList (match v1 with
 | Some v1 -> [TkToken "-displayof"; cCAMLtoTKwidget widget_any_table v1]
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

let send v1 v2 v3 =
tkCommand [|TkToken "send";
    TkTokenList (List.map (function x -> cCAMLtoTKsendOption x) v1);
    TkToken "--";
    TkToken v2;
    TkTokenList (List.map (function x -> TkToken x) v3)|]

let raise_window_above v1 v2 =
tkCommand [|TkToken "raise";
    cCAMLtoTKwidget widget_any_table v1;
    cCAMLtoTKwidget widget_any_table v2|]

let raise_window ?above:v2 v1 =
tkCommand [|TkToken "raise";
    cCAMLtoTKwidget widget_any_table v1;
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKwidget widget_any_table v2]
 | None -> [])|]

let place v1 v2 =
tkCommand [|TkToken "place";
    cCAMLtoTKwidget widget_any_table v1;
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_place_table x) v2)|]

let pack v1 v2 =
tkCommand [|TkToken "pack";
    TkTokenList (List.map (function x -> cCAMLtoTKwidget widget_any_table x) v1);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_pack_table x) v2)|]

let lower_window_below v1 v2 =
tkCommand [|TkToken "lower";
    cCAMLtoTKwidget widget_any_table v1;
    cCAMLtoTKwidget widget_any_table v2|]

let lower_window ?below:v2 v1 =
tkCommand [|TkToken "lower";
    cCAMLtoTKwidget widget_any_table v1;
    TkTokenList (match v2 with
 | Some v2 -> [cCAMLtoTKwidget widget_any_table v2]
 | None -> [])|]

let grid v1 v2 =
tkCommand [|TkToken "grid";
    TkTokenList (List.map (function x -> cCAMLtoTKwidget widget_any_table x) v1);
    TkTokenList (List.map (function x -> cCAMLtoTKoptions dummy options_grid_table x) v2)|]

let destroy v1 =
tkCommand [|TkToken "destroy";
    cCAMLtoTKwidget widget_any_table v1|]

let bindtags_get v1 =
let res = tkEval [|TkToken "bindtags";
    cCAMLtoTKwidget widget_any_table v1|] in 
    List.map cTKtoCAMLbindings (splitlist res)

let bindtags v1 v2 =
tkCommand [|TkToken "bindtags";
    cCAMLtoTKwidget widget_any_table v1;
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> cCAMLtoTKbindings x) v2)])|]

let cget v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_any_table v1;
    TkToken "cget";
    cCAMLtoTKoptions_constrs v2|] in 
res

let cgets v1 v2 =
let res = tkEval [|cCAMLtoTKwidget widget_any_table v1;
    TkToken "cget";
    TkToken v2|] in 
res

