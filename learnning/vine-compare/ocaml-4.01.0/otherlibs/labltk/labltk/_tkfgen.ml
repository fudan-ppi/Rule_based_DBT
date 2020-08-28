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

