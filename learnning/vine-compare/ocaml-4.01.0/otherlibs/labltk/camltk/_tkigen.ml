let cCAMLtoTKanchor : anchor -> tkArgs  = function
  | SE -> TkToken "se"
  | S -> TkToken "s"
  | SW -> TkToken "sw"
  | E -> TkToken "e"
  | Center -> TkToken "center"
  | W -> TkToken "w"
  | NE -> TkToken "ne"
  | N -> TkToken "n"
  | NW -> TkToken "nw"


let cCAMLtoTKimageBitmap : imageBitmap -> tkArgs  = function
  | BitmapImage v1 -> TkToken v1


let cTKtoCAMLimageBitmap n =
    match n with
    | n -> BitmapImage n

let cCAMLtoTKimagePhoto : imagePhoto -> tkArgs  = function
  | PhotoImage v1 -> TkToken v1


let cTKtoCAMLimagePhoto n =
    match n with
    | n -> PhotoImage n

let cCAMLtoTKjustification : justification -> tkArgs  = function
  | Justify_Right -> TkToken "right"
  | Justify_Center -> TkToken "center"
  | Justify_Left -> TkToken "left"


let cCAMLtoTKorientation : orientation -> tkArgs  = function
  | Horizontal -> TkToken "horizontal"
  | Vertical -> TkToken "vertical"


let cCAMLtoTKrelief : relief -> tkArgs  = function
  | Groove -> TkToken "groove"
  | Solid -> TkToken "solid"
  | Ridge -> TkToken "ridge"
  | Flat -> TkToken "flat"
  | Sunken -> TkToken "sunken"
  | Raised -> TkToken "raised"


let cCAMLtoTKstate : state -> tkArgs  = function
  | Hidden -> TkToken "hidden"
  | Disabled -> TkToken "disabled"
  | Active -> TkToken "active"
  | Normal -> TkToken "normal"


let cCAMLtoTKcolorMode : colorMode -> tkArgs  = function
  | Mono -> TkToken "mono"
  | Gray -> TkToken "gray"
  | Color -> TkToken "color"


let cCAMLtoTKarcStyle : arcStyle -> tkArgs  = function
  | PieSlice -> TkToken "pieslice"
  | Chord -> TkToken "chord"
  | Arc -> TkToken "arc"


let cCAMLtoTKtagOrId : tagOrId -> tkArgs  = function
  | Id v1 -> TkToken (string_of_int v1)
  | Tag v1 -> TkToken v1


let cTKtoCAMLtagOrId n =
   try Id (int_of_string n)
   with _ ->
    match n with
    | n -> Tag n

let cCAMLtoTKarrowStyle : arrowStyle -> tkArgs  = function
  | Arrow_Both -> TkToken "both"
  | Arrow_Last -> TkToken "last"
  | Arrow_First -> TkToken "first"
  | Arrow_None -> TkToken "none"


let cCAMLtoTKcapStyle : capStyle -> tkArgs  = function
  | Cap_Round -> TkToken "round"
  | Cap_Projecting -> TkToken "projecting"
  | Cap_Butt -> TkToken "butt"


let cCAMLtoTKjoinStyle : joinStyle -> tkArgs  = function
  | Join_Round -> TkToken "round"
  | Join_Miter -> TkToken "miter"
  | Join_Bevel -> TkToken "bevel"


let cCAMLtoTKweight : weight -> tkArgs  = function
  | Weight_Bold -> TkToken "bold"
  | Weight_Normal -> TkToken "normal"


let cCAMLtoTKslant : slant -> tkArgs  = function
  | Slant_Italic -> TkToken "italic"
  | Slant_Roman -> TkToken "roman"


let cCAMLtoTKvisual : visual -> tkArgs  = function
  | Best -> TkToken "best"
  | BestDepth v1 -> TkQuote (TkTokenList [TkToken "best";
    TkToken (string_of_int v1)])
  | WidgetVisual v1 -> cCAMLtoTKwidget widget_any_table v1
  | DefaultVisual -> TkToken "default"
  | ClassVisual ( v1, v2) -> TkQuote (TkTokenList [TkToken v1;
    TkToken (string_of_int v2)])


let cCAMLtoTKcolormap : colormap -> tkArgs  = function
  | WidgetColormap v1 -> cCAMLtoTKwidget widget_any_table v1
  | NewColormap -> TkToken "new"


let cCAMLtoTKselectModeType : selectModeType -> tkArgs  = function
  | Extended -> TkToken "extended"
  | Multiple -> TkToken "multiple"
  | Browse -> TkToken "browse"
  | Single -> TkToken "single"


let cCAMLtoTKmenuType : menuType -> tkArgs  = function
  | Menu_Normal -> TkToken "normal"
  | Menu_Tearoff -> TkToken "tearoff"
  | Menu_Menubar -> TkToken "menubar"


let cCAMLtoTKmenubuttonDirection : menubuttonDirection -> tkArgs  = function
  | Dir_Right -> TkToken "right"
  | Dir_Left -> TkToken "left"
  | Dir_Below -> TkToken "below"
  | Dir_Above -> TkToken "above"


let cCAMLtoTKfillMode : fillMode -> tkArgs  = function
  | Fill_Both -> TkToken "both"
  | Fill_Y -> TkToken "y"
  | Fill_X -> TkToken "x"
  | Fill_None -> TkToken "none"


let cCAMLtoTKside : side -> tkArgs  = function
  | Side_Bottom -> TkToken "bottom"
  | Side_Top -> TkToken "top"
  | Side_Right -> TkToken "right"
  | Side_Left -> TkToken "left"


let cCAMLtoTKborderMode : borderMode -> tkArgs  = function
  | Ignore -> TkToken "ignore"
  | Outside -> TkToken "outside"
  | Inside -> TkToken "inside"


let cCAMLtoTKalignType : alignType -> tkArgs  = function
  | Align_Baseline -> TkToken "baseline"
  | Align_Center -> TkToken "center"
  | Align_Bottom -> TkToken "bottom"
  | Align_Top -> TkToken "top"


let cCAMLtoTKwrapMode : wrapMode -> tkArgs  = function
  | WrapWord -> TkToken "word"
  | WrapChar -> TkToken "char"
  | WrapNone -> TkToken "none"


let cCAMLtoTKtabType : tabType -> tkArgs  = function
  | TabNumeric v1 -> TkTokenList [cCAMLtoTKunits v1;
    TkToken "numeric"]
  | TabCenter v1 -> TkTokenList [cCAMLtoTKunits v1;
    TkToken "center"]
  | TabRight v1 -> TkTokenList [cCAMLtoTKunits v1;
    TkToken "right"]
  | TabLeft v1 -> TkTokenList [cCAMLtoTKunits v1;
    TkToken "left"]


let cCAMLtoTKmessageIcon : messageIcon -> tkArgs  = function
  | Warning -> TkToken "warning"
  | Question -> TkToken "question"
  | Info -> TkToken "info"
  | Error -> TkToken "error"


let cCAMLtoTKmessageType : messageType -> tkArgs  = function
  | YesNoCancel -> TkToken "yesnocancel"
  | YesNo -> TkToken "yesno"
  | RetryCancel -> TkToken "retrycancel"
  | OkCancel -> TkToken "okcancel"
  | Ok -> TkToken "ok"
  | AbortRetryIgnore -> TkToken "abortretryignore"


let options_any_table = [CAccelerator; CActiveBackground; CActiveBorderWidth; CActiveForeground; CActiveRelief; CAfter; CAlign; CAnchor; CArcStyle; CArrowShape; CArrowStyle; CAspect; CBackground; CBefore; CBgStipple; CBigIncrement; CBitmap; CBorderMode; CBorderWidth; CCapStyle; CClass; CCloseEnough; CColormap; CColormode; CColumn; CColumnBreak; CColumnSpan; CCommand; CConfine; CContainer; CCursor; CDash; CData; CDefault; CDefaultExtension; CDigits; CDirection; CDisabledForeground; CElementBorderWidth; CExpand; CExportSelection; CExtent; CFgStipple; CFile; CFileTypes; CFill; CFillColor; CFont; CFont_Family; CFont_Overstrike; CFont_Size; CFont_Slant; CFont_Underline; CFont_Weight; CForeground; CFormat; CFrom; CGamma; CGeometry; CHeight; CHideMargin; CHighlightBackground; CHighlightColor; CHighlightThickness; CIPadX; CIPadY; CImageBitmap; CImagePhoto; CIn; CIndicatorOn; CInitialColor; CInitialDir; CInitialFile; CInsertBackground; CInsertBorderWidth; CInsertOffTime; CInsertOnTime; CInsertWidth; CJoinStyle; CJump; CJustify; CLMargin1; CLMargin2; CLabel; CLength; CMaskdata; CMaskfile; CMenu; CMenuTitle; CMenuType; CMessage; CMessageDefault; CMessageIcon; CMessageType; CMinsize; CName; COffValue; COffset; COnValue; COrient; COutline; COutlineStipple; COverStrike; CPad; CPadX; CPadY; CPageAnchor; CPageHeight; CPageWidth; CPageX; CPageY; CPalette; CParent; CPostCommand; CRMargin; CRelHeight; CRelWidth; CRelX; CRelY; CRelief; CRepeatDelay; CRepeatInterval; CResolution; CRotate; CRow; CRowSpan; CScaleCommand; CScreen; CScrollCommand; CScrollRegion; CSelectBackground; CSelectBorderWidth; CSelectColor; CSelectForeground; CSelectImageBitmap; CSelectImagePhoto; CSelectMode; CSetGrid; CShow; CShowValue; CSide; CSliderLength; CSmooth; CSpacing1; CSpacing2; CSpacing3; CSplineSteps; CStart; CState; CSticky; CStipple; CStretch; CTabs; CTags; CTakeFocus; CTearOff; CTearOffCommand; CText; CTextHeight; CTextVariable; CTextWidth; CTickInterval; CTitle; CTo; CTroughColor; CUnderline; CUnderlinedChar; CUse; CValue; CVariable; CVisual; CWeight; CWidth; CWindow; CWrap; CWrapLength; CX; CXScrollCommand; CXScrollIncrement; CY; CYScrollCommand; CYScrollIncrement]

let options_messageBox_table = [CMessage; CMessageDefault; CMessageIcon; CMessageType; CParent; CTitle]

let options_getFile_table = [CDefaultExtension; CFileTypes; CInitialDir; CInitialFile; CParent; CTitle]

let options_toplevel_table = [CBackground; CBorderWidth; CClass; CColormap; CContainer; CCursor; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CMenu; CRelief; CScreen; CTakeFocus; CUse; CVisual; CWidth]

let options_chooseColor_table = [CInitialColor; CParent; CTitle]

let options_texttag_table = [CBackground; CBgStipple; CBorderWidth; CFgStipple; CFont; CForeground; CJustify; CLMargin1; CLMargin2; COffset; COverStrike; CRMargin; CRelief; CSpacing1; CSpacing2; CSpacing3; CTabs; CUnderline; CWrap]

let options_text_table = [CBackground; CBorderWidth; CCursor; CExportSelection; CFont; CForeground; CHighlightBackground; CHighlightColor; CHighlightThickness; CInsertBackground; CInsertBorderWidth; CInsertOffTime; CInsertOnTime; CInsertWidth; CPadX; CPadY; CRelief; CSelectBackground; CSelectBorderWidth; CSelectForeground; CSetGrid; CSpacing1; CSpacing2; CSpacing3; CState; CTabs; CTakeFocus; CTextHeight; CTextWidth; CWrap; CXScrollCommand; CYScrollCommand]

let options_embeddedw_table = [CAlign; CPadX; CPadY; CStretch; CWindow]

let options_embeddedi_table = [CAlign; CImageBitmap; CImagePhoto; CName; CPadX; CPadY]

let options_scrollbar_table = [CActiveBackground; CActiveRelief; CBackground; CBorderWidth; CCursor; CElementBorderWidth; CHighlightBackground; CHighlightColor; CHighlightThickness; CJump; COrient; CRelief; CRepeatDelay; CRepeatInterval; CScrollCommand; CTakeFocus; CTroughColor; CWidth]

let options_scale_table = [CActiveBackground; CBackground; CBigIncrement; CBorderWidth; CCursor; CDigits; CFont; CForeground; CFrom; CHighlightBackground; CHighlightColor; CHighlightThickness; CLabel; CLength; COrient; CRelief; CRepeatDelay; CRepeatInterval; CResolution; CScaleCommand; CShowValue; CSliderLength; CState; CTakeFocus; CTickInterval; CTo; CTroughColor; CVariable; CWidth]

let options_radiobutton_table = [CActiveBackground; CActiveForeground; CAnchor; CBackground; CBitmap; CBorderWidth; CCommand; CCursor; CDisabledForeground; CFont; CForeground; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CImageBitmap; CImagePhoto; CIndicatorOn; CJustify; CPadX; CPadY; CRelief; CSelectColor; CSelectImageBitmap; CSelectImagePhoto; CState; CTakeFocus; CText; CTextVariable; CUnderlinedChar; CValue; CVariable; CWidth; CWrapLength]

let options_place_table = [CAnchor; CBorderMode; CHeight; CIn; CRelHeight; CRelWidth; CRelX; CRelY; CWidth; CX; CY]

let options_photoimage_table = [CData; CFile; CFormat; CGamma; CHeight; CPalette; CWidth]

let options_pack_table = [CAfter; CAnchor; CBefore; CExpand; CFill; CIPadX; CIPadY; CIn; CPadX; CPadY; CSide]

let options_message_table = [CAnchor; CAspect; CBackground; CBorderWidth; CCursor; CFont; CForeground; CHighlightBackground; CHighlightColor; CHighlightThickness; CJustify; CPadX; CPadY; CRelief; CTakeFocus; CText; CTextVariable; CWidth]

let options_menubutton_table = [CActiveBackground; CActiveForeground; CAnchor; CBackground; CBitmap; CBorderWidth; CCursor; CDirection; CDisabledForeground; CFont; CForeground; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CImageBitmap; CImagePhoto; CIndicatorOn; CJustify; CMenu; CPadX; CPadY; CRelief; CState; CTakeFocus; CText; CTextVariable; CTextWidth; CUnderlinedChar; CWidth; CWrapLength]

let options_menu_table = [CActiveBackground; CActiveBorderWidth; CActiveForeground; CBackground; CBorderWidth; CCursor; CDisabledForeground; CFont; CForeground; CMenuTitle; CMenuType; CPostCommand; CRelief; CSelectColor; CTakeFocus; CTearOff; CTearOffCommand]

let options_menucommand_table = [CAccelerator; CActiveBackground; CActiveForeground; CBackground; CBitmap; CColumnBreak; CCommand; CFont; CForeground; CImageBitmap; CImagePhoto; CLabel; CState; CUnderlinedChar]

let options_menucheck_table = [CAccelerator; CActiveBackground; CActiveForeground; CBackground; CBitmap; CColumnBreak; CCommand; CFont; CForeground; CImageBitmap; CImagePhoto; CIndicatorOn; CLabel; COffValue; COnValue; CSelectColor; CSelectImageBitmap; CSelectImagePhoto; CState; CUnderlinedChar; CVariable]

let options_menuradio_table = [CAccelerator; CActiveBackground; CActiveForeground; CBackground; CBitmap; CColumnBreak; CCommand; CFont; CForeground; CImageBitmap; CImagePhoto; CIndicatorOn; CLabel; CSelectColor; CSelectImageBitmap; CSelectImagePhoto; CState; CUnderlinedChar; CValue; CVariable]

let options_menucascade_table = [CAccelerator; CActiveBackground; CActiveForeground; CBackground; CBitmap; CColumnBreak; CCommand; CFont; CForeground; CHideMargin; CImageBitmap; CImagePhoto; CIndicatorOn; CLabel; CMenu; CState; CUnderlinedChar]

let options_menuentry_table = [CAccelerator; CActiveBackground; CActiveForeground; CBackground; CBitmap; CColumnBreak; CCommand; CFont; CForeground; CHideMargin; CImageBitmap; CImagePhoto; CIndicatorOn; CLabel; CMenu; COffValue; COnValue; CSelectColor; CSelectImageBitmap; CSelectImagePhoto; CState; CUnderlinedChar; CValue; CVariable]

let options_listbox_table = [CBackground; CBorderWidth; CCursor; CExportSelection; CFont; CForeground; CHighlightBackground; CHighlightColor; CHighlightThickness; CRelief; CSelectBackground; CSelectBorderWidth; CSelectForeground; CSelectMode; CSetGrid; CTakeFocus; CTextHeight; CTextWidth; CXScrollCommand; CYScrollCommand]

let options_label_table = [CAnchor; CBackground; CBitmap; CBorderWidth; CCursor; CFont; CForeground; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CImageBitmap; CImagePhoto; CJustify; CPadX; CPadY; CRelief; CTakeFocus; CText; CTextVariable; CTextWidth; CUnderlinedChar; CWidth; CWrapLength]

let options_grid_table = [CColumn; CColumnSpan; CIPadX; CIPadY; CIn; CPadX; CPadY; CRow; CRowSpan; CSticky]

let options_rowcolumnconfigure_table = [CMinsize; CPad; CWeight]

let options_frame_table = [CBackground; CBorderWidth; CClass; CColormap; CContainer; CCursor; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CRelief; CTakeFocus; CVisual; CWidth]

let options_font_table = [CFont_Family; CFont_Overstrike; CFont_Size; CFont_Slant; CFont_Underline; CFont_Weight]

let options_entry_table = [CBackground; CBorderWidth; CCursor; CExportSelection; CFont; CForeground; CHighlightBackground; CHighlightColor; CHighlightThickness; CInsertBackground; CInsertBorderWidth; CInsertOffTime; CInsertOnTime; CInsertWidth; CJustify; CRelief; CSelectBackground; CSelectBorderWidth; CSelectForeground; CShow; CState; CTakeFocus; CTextVariable; CTextWidth; CXScrollCommand]

let options_checkbutton_table = [CActiveBackground; CActiveForeground; CAnchor; CBackground; CBitmap; CBorderWidth; CCommand; CCursor; CDisabledForeground; CFont; CForeground; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CImageBitmap; CImagePhoto; CIndicatorOn; CJustify; COffValue; COnValue; CPadX; CPadY; CRelief; CSelectColor; CSelectImageBitmap; CSelectImagePhoto; CState; CTakeFocus; CText; CTextVariable; CUnderlinedChar; CVariable; CWidth; CWrapLength]

let options_canvas_table = [CBackground; CBorderWidth; CCloseEnough; CConfine; CCursor; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CInsertBackground; CInsertBorderWidth; CInsertOffTime; CInsertOnTime; CInsertWidth; CRelief; CScrollRegion; CSelectBackground; CSelectBorderWidth; CSelectForeground; CTakeFocus; CWidth; CXScrollCommand; CXScrollIncrement; CYScrollCommand; CYScrollIncrement]

let options_window_table = [CAnchor; CDash; CHeight; CTags; CWidth; CWindow]

let options_canvastext_table = [CAnchor; CFillColor; CFont; CJustify; CState; CStipple; CTags; CText; CWidth]

let options_rectangle_table = [CDash; CFillColor; COutline; CStipple; CTags; CWidth]

let options_polygon_table = [CDash; CFillColor; COutline; CSmooth; CSplineSteps; CStipple; CTags; CWidth]

let options_oval_table = [CDash; CFillColor; COutline; CStipple; CTags; CWidth]

let options_line_table = [CArrowShape; CArrowStyle; CCapStyle; CDash; CFillColor; CJoinStyle; CSmooth; CSplineSteps; CStipple; CTags; CWidth]

let options_image_table = [CAnchor; CImageBitmap; CImagePhoto; CTags]

let options_bitmap_table = [CAnchor; CBackground; CBitmap; CForeground; CTags]

let options_arc_table = [CArcStyle; CDash; CExtent; CFillColor; COutline; COutlineStipple; CStart; CStipple; CTags; CWidth]

let options_postscript_table = [CColormode; CFile; CHeight; CPageAnchor; CPageHeight; CPageWidth; CPageX; CPageY; CRotate; CWidth; CX; CY]

let options_button_table = [CActiveBackground; CActiveForeground; CAnchor; CBackground; CBitmap; CBorderWidth; CCommand; CCursor; CDefault; CDisabledForeground; CFont; CForeground; CHeight; CHighlightBackground; CHighlightColor; CHighlightThickness; CImageBitmap; CImagePhoto; CJustify; CPadX; CPadY; CRelief; CState; CTakeFocus; CText; CTextVariable; CUnderlinedChar; CWidth; CWrapLength]

let options_bitmapimage_table = [CBackground; CData; CFile; CForeground; CMaskdata; CMaskfile]

let options_standard_table = [CActiveBackground; CActiveBorderWidth; CActiveForeground; CAnchor; CBackground; CBitmap; CBorderWidth; CCursor; CDisabledForeground; CExportSelection; CFont; CForeground; CGeometry; CHighlightBackground; CHighlightColor; CHighlightThickness; CImageBitmap; CImagePhoto; CInsertBackground; CInsertBorderWidth; CInsertOffTime; CInsertOnTime; CInsertWidth; CJump; CJustify; COrient; CPadX; CPadY; CRelief; CRepeatDelay; CRepeatInterval; CSelectBackground; CSelectBorderWidth; CSelectForeground; CSetGrid; CTakeFocus; CText; CTextVariable; CTroughColor; CUnderlinedChar; CWrapLength; CXScrollCommand; CYScrollCommand]

let cCAMLtoTKoptions w table : options -> tkArgs  = function
  | MessageType v1 -> chk_sub "MessageType" table CMessageType; TkTokenList [TkToken "-type";
    cCAMLtoTKmessageType v1]
  | Message v1 -> chk_sub "Message" table CMessage; TkTokenList [TkToken "-message";
    TkToken v1]
  | MessageIcon v1 -> chk_sub "MessageIcon" table CMessageIcon; TkTokenList [TkToken "-icon";
    cCAMLtoTKmessageIcon v1]
  | MessageDefault v1 -> chk_sub "MessageDefault" table CMessageDefault; TkTokenList [TkToken "-default";
    TkToken v1]
  | InitialFile v1 -> chk_sub "InitialFile" table CInitialFile; TkTokenList [TkToken "-initialfile";
    TkToken v1]
  | InitialDir v1 -> chk_sub "InitialDir" table CInitialDir; TkTokenList [TkToken "-initialdir";
    TkToken v1]
  | FileTypes v1 -> chk_sub "FileTypes" table CFileTypes; TkTokenList [TkToken "-filetypes";
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> cCAMLtoTKfilePattern x) v1)])]
  | DefaultExtension v1 -> chk_sub "DefaultExtension" table CDefaultExtension; TkTokenList [TkToken "-defaultextension";
    TkToken v1]
  | Screen v1 -> chk_sub "Screen" table CScreen; TkTokenList [TkToken "-screen";
    TkToken v1]
  | Use v1 -> chk_sub "Use" table CUse; TkTokenList [TkToken "-use";
    TkToken v1]
  | Title v1 -> chk_sub "Title" table CTitle; TkTokenList [TkToken "-title";
    TkToken v1]
  | Parent v1 -> chk_sub "Parent" table CParent; TkTokenList [TkToken "-parent";
    cCAMLtoTKwidget widget_any_table v1]
  | InitialColor v1 -> chk_sub "InitialColor" table CInitialColor; TkTokenList [TkToken "-initialcolor";
    cCAMLtoTKcolor v1]
  | Underline v1 -> chk_sub "Underline" table CUnderline; TkTokenList [TkToken "-underline";
    if v1 then TkToken "1" else TkToken "0"]
  | RMargin v1 -> chk_sub "RMargin" table CRMargin; TkTokenList [TkToken "-rmargin";
    cCAMLtoTKunits v1]
  | OverStrike v1 -> chk_sub "OverStrike" table COverStrike; TkTokenList [TkToken "-overstrike";
    if v1 then TkToken "1" else TkToken "0"]
  | Offset v1 -> chk_sub "Offset" table COffset; TkTokenList [TkToken "-offset";
    cCAMLtoTKunits v1]
  | LMargin2 v1 -> chk_sub "LMargin2" table CLMargin2; TkTokenList [TkToken "-lmargin2";
    cCAMLtoTKunits v1]
  | LMargin1 v1 -> chk_sub "LMargin1" table CLMargin1; TkTokenList [TkToken "-lmargin1";
    cCAMLtoTKunits v1]
  | FgStipple v1 -> chk_sub "FgStipple" table CFgStipple; TkTokenList [TkToken "-fgstipple";
    cCAMLtoTKbitmap v1]
  | BgStipple v1 -> chk_sub "BgStipple" table CBgStipple; TkTokenList [TkToken "-bgstipple";
    cCAMLtoTKbitmap v1]
  | Spacing1 v1 -> chk_sub "Spacing1" table CSpacing1; TkTokenList [TkToken "-spacing1";
    cCAMLtoTKunits v1]
  | Spacing2 v1 -> chk_sub "Spacing2" table CSpacing2; TkTokenList [TkToken "-spacing2";
    cCAMLtoTKunits v1]
  | Spacing3 v1 -> chk_sub "Spacing3" table CSpacing3; TkTokenList [TkToken "-spacing3";
    cCAMLtoTKunits v1]
  | Tabs v1 -> chk_sub "Tabs" table CTabs; TkTokenList [TkToken "-tabs";
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> cCAMLtoTKtabType x) v1)])]
  | Wrap v1 -> chk_sub "Wrap" table CWrap; TkTokenList [TkToken "-wrap";
    cCAMLtoTKwrapMode v1]
  | Stretch v1 -> chk_sub "Stretch" table CStretch; TkTokenList [TkToken "-stretch";
    if v1 then TkToken "1" else TkToken "0"]
  | Name v1 -> chk_sub "Name" table CName; TkTokenList [TkToken "-name";
    TkToken v1]
  | Align v1 -> chk_sub "Align" table CAlign; TkTokenList [TkToken "-align";
    cCAMLtoTKalignType v1]
  | ActiveRelief v1 -> chk_sub "ActiveRelief" table CActiveRelief; TkTokenList [TkToken "-activerelief";
    cCAMLtoTKrelief v1]
  | ScrollCommand v1 -> chk_sub "ScrollCommand" table CScrollCommand; TkTokenList [TkToken "-command";
    let id = register_callback w ~callback: (fun args ->
        let (a1, args) = cTKtoCAMLscrollValue args in
        v1 a1) in TkToken ("camlcb " ^ id)]
  | ElementBorderWidth v1 -> chk_sub "ElementBorderWidth" table CElementBorderWidth; TkTokenList [TkToken "-elementborderwidth";
    cCAMLtoTKunits v1]
  | BigIncrement v1 -> chk_sub "BigIncrement" table CBigIncrement; TkTokenList [TkToken "-bigincrement";
    TkToken (Printf.sprintf "%g" v1)]
  | ScaleCommand v1 -> chk_sub "ScaleCommand" table CScaleCommand; TkTokenList [TkToken "-command";
    let id = register_callback w ~callback: (fun args ->
        v1(float_of_string (List.hd args))) in TkToken ("camlcb " ^ id)]
  | Digits v1 -> chk_sub "Digits" table CDigits; TkTokenList [TkToken "-digits";
    TkToken (string_of_int v1)]
  | From v1 -> chk_sub "From" table CFrom; TkTokenList [TkToken "-from";
    TkToken (Printf.sprintf "%g" v1)]
  | Length v1 -> chk_sub "Length" table CLength; TkTokenList [TkToken "-length";
    cCAMLtoTKunits v1]
  | Resolution v1 -> chk_sub "Resolution" table CResolution; TkTokenList [TkToken "-resolution";
    TkToken (Printf.sprintf "%g" v1)]
  | ShowValue v1 -> chk_sub "ShowValue" table CShowValue; TkTokenList [TkToken "-showvalue";
    if v1 then TkToken "1" else TkToken "0"]
  | SliderLength v1 -> chk_sub "SliderLength" table CSliderLength; TkTokenList [TkToken "-sliderlength";
    cCAMLtoTKunits v1]
  | TickInterval v1 -> chk_sub "TickInterval" table CTickInterval; TkTokenList [TkToken "-tickinterval";
    TkToken (Printf.sprintf "%g" v1)]
  | To v1 -> chk_sub "To" table CTo; TkTokenList [TkToken "-to";
    TkToken (Printf.sprintf "%g" v1)]
  | BorderMode v1 -> chk_sub "BorderMode" table CBorderMode; TkTokenList [TkToken "-bordermode";
    cCAMLtoTKborderMode v1]
  | RelHeight v1 -> chk_sub "RelHeight" table CRelHeight; TkTokenList [TkToken "-relheight";
    TkToken (Printf.sprintf "%g" v1)]
  | RelWidth v1 -> chk_sub "RelWidth" table CRelWidth; TkTokenList [TkToken "-relwidth";
    TkToken (Printf.sprintf "%g" v1)]
  | RelY v1 -> chk_sub "RelY" table CRelY; TkTokenList [TkToken "-rely";
    TkToken (Printf.sprintf "%g" v1)]
  | RelX v1 -> chk_sub "RelX" table CRelX; TkTokenList [TkToken "-relx";
    TkToken (Printf.sprintf "%g" v1)]
  | Palette v1 -> chk_sub "Palette" table CPalette; TkTokenList [TkToken "-palette";
    cCAMLtoTKpaletteType v1]
  | Gamma v1 -> chk_sub "Gamma" table CGamma; TkTokenList [TkToken "-gamma";
    TkToken (Printf.sprintf "%g" v1)]
  | Format v1 -> chk_sub "Format" table CFormat; TkTokenList [TkToken "-format";
    TkToken v1]
  | Side v1 -> chk_sub "Side" table CSide; TkTokenList [TkToken "-side";
    cCAMLtoTKside v1]
  | Fill v1 -> chk_sub "Fill" table CFill; TkTokenList [TkToken "-fill";
    cCAMLtoTKfillMode v1]
  | Expand v1 -> chk_sub "Expand" table CExpand; TkTokenList [TkToken "-expand";
    if v1 then TkToken "1" else TkToken "0"]
  | Before v1 -> chk_sub "Before" table CBefore; TkTokenList [TkToken "-before";
    cCAMLtoTKwidget widget_any_table v1]
  | After v1 -> chk_sub "After" table CAfter; TkTokenList [TkToken "-after";
    cCAMLtoTKwidget widget_any_table v1]
  | Aspect v1 -> chk_sub "Aspect" table CAspect; TkTokenList [TkToken "-aspect";
    TkToken (string_of_int v1)]
  | Direction v1 -> chk_sub "Direction" table CDirection; TkTokenList [TkToken "-direction";
    cCAMLtoTKmenubuttonDirection v1]
  | PostCommand v1 -> chk_sub "PostCommand" table CPostCommand; TkTokenList [TkToken "-postcommand";
    let id = register_callback w ~callback: (fun _ -> v1 ()) in TkToken ("camlcb " ^ id)]
  | TearOff v1 -> chk_sub "TearOff" table CTearOff; TkTokenList [TkToken "-tearoff";
    if v1 then TkToken "1" else TkToken "0"]
  | TearOffCommand v1 -> chk_sub "TearOffCommand" table CTearOffCommand; TkTokenList [TkToken "-tearoffcommand";
    let id = register_callback w ~callback: (fun args ->
        let (a1, args) = cTKtoCAMLwidget (List.hd args), List.tl args in
        let (a2, args) = cTKtoCAMLwidget (List.hd args), List.tl args in
        v1 a1 a2) in TkToken ("camlcb " ^ id)]
  | MenuTitle v1 -> chk_sub "MenuTitle" table CMenuTitle; TkTokenList [TkToken "-title";
    TkToken v1]
  | MenuType v1 -> chk_sub "MenuType" table CMenuType; TkTokenList [TkToken "-type";
    cCAMLtoTKmenuType v1]
  | Value v1 -> chk_sub "Value" table CValue; TkTokenList [TkToken "-value";
    TkToken v1]
  | Menu v1 -> chk_sub "Menu" table CMenu; TkTokenList [TkToken "-menu";
    cCAMLtoTKwidget widget_menu_table v1]
  | Label v1 -> chk_sub "Label" table CLabel; TkTokenList [TkToken "-label";
    TkToken v1]
  | HideMargin v1 -> chk_sub "HideMargin" table CHideMargin; TkTokenList [TkToken "-hidemargin";
    if v1 then TkToken "1" else TkToken "0"]
  | ColumnBreak v1 -> chk_sub "ColumnBreak" table CColumnBreak; TkTokenList [TkToken "-columnbreak";
    if v1 then TkToken "1" else TkToken "0"]
  | Accelerator v1 -> chk_sub "Accelerator" table CAccelerator; TkTokenList [TkToken "-accelerator";
    TkToken v1]
  | TextHeight v1 -> chk_sub "TextHeight" table CTextHeight; TkTokenList [TkToken "-height";
    TkToken (string_of_int v1)]
  | SelectMode v1 -> chk_sub "SelectMode" table CSelectMode; TkTokenList [TkToken "-selectmode";
    cCAMLtoTKselectModeType v1]
  | Sticky v1 -> chk_sub "Sticky" table CSticky; TkTokenList [TkToken "-sticky";
    TkToken v1]
  | RowSpan v1 -> chk_sub "RowSpan" table CRowSpan; TkTokenList [TkToken "-rowspan";
    TkToken (string_of_int v1)]
  | Row v1 -> chk_sub "Row" table CRow; TkTokenList [TkToken "-row";
    TkToken (string_of_int v1)]
  | IPadY v1 -> chk_sub "IPadY" table CIPadY; TkTokenList [TkToken "-ipady";
    cCAMLtoTKunits v1]
  | IPadX v1 -> chk_sub "IPadX" table CIPadX; TkTokenList [TkToken "-ipadx";
    cCAMLtoTKunits v1]
  | In v1 -> chk_sub "In" table CIn; TkTokenList [TkToken "-in";
    cCAMLtoTKwidget widget_any_table v1]
  | ColumnSpan v1 -> chk_sub "ColumnSpan" table CColumnSpan; TkTokenList [TkToken "-columnspan";
    TkToken (string_of_int v1)]
  | Column v1 -> chk_sub "Column" table CColumn; TkTokenList [TkToken "-column";
    TkToken (string_of_int v1)]
  | Pad v1 -> chk_sub "Pad" table CPad; TkTokenList [TkToken "-pad";
    cCAMLtoTKunits v1]
  | Weight v1 -> chk_sub "Weight" table CWeight; TkTokenList [TkToken "-weight";
    TkToken (string_of_int v1)]
  | Minsize v1 -> chk_sub "Minsize" table CMinsize; TkTokenList [TkToken "-minsize";
    cCAMLtoTKunits v1]
  | Class v1 -> chk_sub "Class" table CClass; TkTokenList [TkToken "-class";
    TkToken v1]
  | Colormap v1 -> chk_sub "Colormap" table CColormap; TkTokenList [TkToken "-colormap";
    cCAMLtoTKcolormap v1]
  | Container v1 -> chk_sub "Container" table CContainer; TkTokenList [TkToken "-container";
    if v1 then TkToken "1" else TkToken "0"]
  | Visual v1 -> chk_sub "Visual" table CVisual; TkTokenList [TkToken "-visual";
    cCAMLtoTKvisual v1]
  | Font_Overstrike v1 -> chk_sub "Font_Overstrike" table CFont_Overstrike; TkTokenList [TkToken "-overstrike";
    if v1 then TkToken "1" else TkToken "0"]
  | Font_Underline v1 -> chk_sub "Font_Underline" table CFont_Underline; TkTokenList [TkToken "-underline";
    if v1 then TkToken "1" else TkToken "0"]
  | Font_Slant v1 -> chk_sub "Font_Slant" table CFont_Slant; TkTokenList [TkToken "-slant";
    cCAMLtoTKslant v1]
  | Font_Weight v1 -> chk_sub "Font_Weight" table CFont_Weight; TkTokenList [TkToken "-weight";
    cCAMLtoTKweight v1]
  | Font_Size v1 -> chk_sub "Font_Size" table CFont_Size; TkTokenList [TkToken "-size";
    TkToken (string_of_int v1)]
  | Font_Family v1 -> chk_sub "Font_Family" table CFont_Family; TkTokenList [TkToken "-family";
    TkToken v1]
  | Show v1 -> chk_sub "Show" table CShow; TkTokenList [TkToken "-show";
    TkToken (Char.escaped v1)]
  | TextWidth v1 -> chk_sub "TextWidth" table CTextWidth; TkTokenList [TkToken "-width";
    TkToken (string_of_int v1)]
  | IndicatorOn v1 -> chk_sub "IndicatorOn" table CIndicatorOn; TkTokenList [TkToken "-indicatoron";
    if v1 then TkToken "1" else TkToken "0"]
  | OffValue v1 -> chk_sub "OffValue" table COffValue; TkTokenList [TkToken "-offvalue";
    TkToken v1]
  | OnValue v1 -> chk_sub "OnValue" table COnValue; TkTokenList [TkToken "-onvalue";
    TkToken v1]
  | SelectColor v1 -> chk_sub "SelectColor" table CSelectColor; TkTokenList [TkToken "-selectcolor";
    cCAMLtoTKcolor v1]
  | SelectImageBitmap v1 -> chk_sub "SelectImageBitmap" table CSelectImageBitmap; TkTokenList [TkToken "-selectimage";
    cCAMLtoTKimageBitmap v1]
  | SelectImagePhoto v1 -> chk_sub "SelectImagePhoto" table CSelectImagePhoto; TkTokenList [TkToken "-selectimage";
    cCAMLtoTKimagePhoto v1]
  | Variable v1 -> chk_sub "Variable" table CVariable; TkTokenList [TkToken "-variable";
    cCAMLtoTKtextVariable v1]
  | CloseEnough v1 -> chk_sub "CloseEnough" table CCloseEnough; TkTokenList [TkToken "-closeenough";
    TkToken (Printf.sprintf "%g" v1)]
  | Confine v1 -> chk_sub "Confine" table CConfine; TkTokenList [TkToken "-confine";
    if v1 then TkToken "1" else TkToken "0"]
  | ScrollRegion ( v1, v2, v3, v4) -> chk_sub "ScrollRegion" table CScrollRegion; TkTokenList [TkToken "-scrollregion";
    TkQuote (TkTokenList [cCAMLtoTKunits v1;
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4])]
  | XScrollIncrement v1 -> chk_sub "XScrollIncrement" table CXScrollIncrement; TkTokenList [TkToken "-xscrollincrement";
    cCAMLtoTKunits v1]
  | YScrollIncrement v1 -> chk_sub "YScrollIncrement" table CYScrollIncrement; TkTokenList [TkToken "-yscrollincrement";
    cCAMLtoTKunits v1]
  | Window v1 -> chk_sub "Window" table CWindow; TkTokenList [TkToken "-window";
    cCAMLtoTKwidget widget_any_table v1]
  | SplineSteps v1 -> chk_sub "SplineSteps" table CSplineSteps; TkTokenList [TkToken "-splinesteps";
    TkToken (string_of_int v1)]
  | Smooth v1 -> chk_sub "Smooth" table CSmooth; TkTokenList [TkToken "-smooth";
    if v1 then TkToken "1" else TkToken "0"]
  | JoinStyle v1 -> chk_sub "JoinStyle" table CJoinStyle; TkTokenList [TkToken "-joinstyle";
    cCAMLtoTKjoinStyle v1]
  | CapStyle v1 -> chk_sub "CapStyle" table CCapStyle; TkTokenList [TkToken "-capstyle";
    cCAMLtoTKcapStyle v1]
  | ArrowShape ( v1, v2, v3) -> chk_sub "ArrowShape" table CArrowShape; TkTokenList [TkToken "-arrowshape";
    TkQuote (TkTokenList [cCAMLtoTKunits v1;
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3])]
  | ArrowStyle v1 -> chk_sub "ArrowStyle" table CArrowStyle; TkTokenList [TkToken "-arrow";
    cCAMLtoTKarrowStyle v1]
  | Tags v1 -> chk_sub "Tags" table CTags; TkTokenList [TkToken "-tags";
    TkQuote (TkTokenList [TkTokenList (List.map (function x -> cCAMLtoTKtagOrId x) v1)])]
  | ArcStyle v1 -> chk_sub "ArcStyle" table CArcStyle; TkTokenList [TkToken "-style";
    cCAMLtoTKarcStyle v1]
  | Stipple v1 -> chk_sub "Stipple" table CStipple; TkTokenList [TkToken "-stipple";
    cCAMLtoTKbitmap v1]
  | Start v1 -> chk_sub "Start" table CStart; TkTokenList [TkToken "-start";
    TkToken (Printf.sprintf "%g" v1)]
  | OutlineStipple v1 -> chk_sub "OutlineStipple" table COutlineStipple; TkTokenList [TkToken "-outlinestipple";
    cCAMLtoTKbitmap v1]
  | Outline v1 -> chk_sub "Outline" table COutline; TkTokenList [TkToken "-outline";
    cCAMLtoTKcolor v1]
  | FillColor v1 -> chk_sub "FillColor" table CFillColor; TkTokenList [TkToken "-fill";
    cCAMLtoTKcolor v1]
  | Dash v1 -> chk_sub "Dash" table CDash; TkTokenList [TkToken "-dash";
    TkToken v1]
  | Extent v1 -> chk_sub "Extent" table CExtent; TkTokenList [TkToken "-extent";
    TkToken (Printf.sprintf "%g" v1)]
  | Y v1 -> chk_sub "Y" table CY; TkTokenList [TkToken "-y";
    cCAMLtoTKunits v1]
  | X v1 -> chk_sub "X" table CX; TkTokenList [TkToken "-x";
    cCAMLtoTKunits v1]
  | Rotate v1 -> chk_sub "Rotate" table CRotate; TkTokenList [TkToken "-rotate";
    if v1 then TkToken "1" else TkToken "0"]
  | PageY v1 -> chk_sub "PageY" table CPageY; TkTokenList [TkToken "-pagey";
    cCAMLtoTKunits v1]
  | PageX v1 -> chk_sub "PageX" table CPageX; TkTokenList [TkToken "-pagex";
    cCAMLtoTKunits v1]
  | PageWidth v1 -> chk_sub "PageWidth" table CPageWidth; TkTokenList [TkToken "-pagewidth";
    cCAMLtoTKunits v1]
  | PageHeight v1 -> chk_sub "PageHeight" table CPageHeight; TkTokenList [TkToken "-pageheight";
    cCAMLtoTKunits v1]
  | PageAnchor v1 -> chk_sub "PageAnchor" table CPageAnchor; TkTokenList [TkToken "-pageanchor";
    cCAMLtoTKanchor v1]
  | Colormode v1 -> chk_sub "Colormode" table CColormode; TkTokenList [TkToken "-colormode";
    cCAMLtoTKcolorMode v1]
  | Command v1 -> chk_sub "Command" table CCommand; TkTokenList [TkToken "-command";
    let id = register_callback w ~callback: (fun _ -> v1 ()) in TkToken ("camlcb " ^ id)]
  | Default v1 -> chk_sub "Default" table CDefault; TkTokenList [TkToken "-default";
    cCAMLtoTKstate v1]
  | Height v1 -> chk_sub "Height" table CHeight; TkTokenList [TkToken "-height";
    cCAMLtoTKunits v1]
  | State v1 -> chk_sub "State" table CState; TkTokenList [TkToken "-state";
    cCAMLtoTKstate v1]
  | Width v1 -> chk_sub "Width" table CWidth; TkTokenList [TkToken "-width";
    cCAMLtoTKunits v1]
  | Maskfile v1 -> chk_sub "Maskfile" table CMaskfile; TkTokenList [TkToken "-maskfile";
    TkToken v1]
  | Maskdata v1 -> chk_sub "Maskdata" table CMaskdata; TkTokenList [TkToken "-maskdata";
    TkToken v1]
  | File v1 -> chk_sub "File" table CFile; TkTokenList [TkToken "-file";
    TkToken v1]
  | Data v1 -> chk_sub "Data" table CData; TkTokenList [TkToken "-data";
    TkToken v1]
  | YScrollCommand v1 -> chk_sub "YScrollCommand" table CYScrollCommand; TkTokenList [TkToken "-yscrollcommand";
    let id = register_callback w ~callback: (fun args ->
        let (a1, args) = float_of_string (List.hd args), List.tl args in
        let (a2, args) = float_of_string (List.hd args), List.tl args in
        v1 a1 a2) in TkToken ("camlcb " ^ id)]
  | XScrollCommand v1 -> chk_sub "XScrollCommand" table CXScrollCommand; TkTokenList [TkToken "-xscrollcommand";
    let id = register_callback w ~callback: (fun args ->
        let (a1, args) = float_of_string (List.hd args), List.tl args in
        let (a2, args) = float_of_string (List.hd args), List.tl args in
        v1 a1 a2) in TkToken ("camlcb " ^ id)]
  | WrapLength v1 -> chk_sub "WrapLength" table CWrapLength; TkTokenList [TkToken "-wraplength";
    cCAMLtoTKunits v1]
  | UnderlinedChar v1 -> chk_sub "UnderlinedChar" table CUnderlinedChar; TkTokenList [TkToken "-underline";
    TkToken (string_of_int v1)]
  | TroughColor v1 -> chk_sub "TroughColor" table CTroughColor; TkTokenList [TkToken "-troughcolor";
    cCAMLtoTKcolor v1]
  | TextVariable v1 -> chk_sub "TextVariable" table CTextVariable; TkTokenList [TkToken "-textvariable";
    cCAMLtoTKtextVariable v1]
  | Text v1 -> chk_sub "Text" table CText; TkTokenList [TkToken "-text";
    TkToken v1]
  | TakeFocus v1 -> chk_sub "TakeFocus" table CTakeFocus; TkTokenList [TkToken "-takefocus";
    if v1 then TkToken "1" else TkToken "0"]
  | SetGrid v1 -> chk_sub "SetGrid" table CSetGrid; TkTokenList [TkToken "-setgrid";
    if v1 then TkToken "1" else TkToken "0"]
  | SelectForeground v1 -> chk_sub "SelectForeground" table CSelectForeground; TkTokenList [TkToken "-selectforeground";
    cCAMLtoTKcolor v1]
  | SelectBorderWidth v1 -> chk_sub "SelectBorderWidth" table CSelectBorderWidth; TkTokenList [TkToken "-selectborderwidth";
    cCAMLtoTKunits v1]
  | SelectBackground v1 -> chk_sub "SelectBackground" table CSelectBackground; TkTokenList [TkToken "-selectbackground";
    cCAMLtoTKcolor v1]
  | RepeatInterval v1 -> chk_sub "RepeatInterval" table CRepeatInterval; TkTokenList [TkToken "-repeatinterval";
    TkToken (string_of_int v1)]
  | RepeatDelay v1 -> chk_sub "RepeatDelay" table CRepeatDelay; TkTokenList [TkToken "-repeatdelay";
    TkToken (string_of_int v1)]
  | Relief v1 -> chk_sub "Relief" table CRelief; TkTokenList [TkToken "-relief";
    cCAMLtoTKrelief v1]
  | PadY v1 -> chk_sub "PadY" table CPadY; TkTokenList [TkToken "-pady";
    cCAMLtoTKunits v1]
  | PadX v1 -> chk_sub "PadX" table CPadX; TkTokenList [TkToken "-padx";
    cCAMLtoTKunits v1]
  | Orient v1 -> chk_sub "Orient" table COrient; TkTokenList [TkToken "-orient";
    cCAMLtoTKorientation v1]
  | Justify v1 -> chk_sub "Justify" table CJustify; TkTokenList [TkToken "-justify";
    cCAMLtoTKjustification v1]
  | Jump v1 -> chk_sub "Jump" table CJump; TkTokenList [TkToken "-jump";
    if v1 then TkToken "1" else TkToken "0"]
  | InsertWidth v1 -> chk_sub "InsertWidth" table CInsertWidth; TkTokenList [TkToken "-insertwidth";
    cCAMLtoTKunits v1]
  | InsertOnTime v1 -> chk_sub "InsertOnTime" table CInsertOnTime; TkTokenList [TkToken "-insertontime";
    TkToken (string_of_int v1)]
  | InsertOffTime v1 -> chk_sub "InsertOffTime" table CInsertOffTime; TkTokenList [TkToken "-insertofftime";
    TkToken (string_of_int v1)]
  | InsertBorderWidth v1 -> chk_sub "InsertBorderWidth" table CInsertBorderWidth; TkTokenList [TkToken "-insertborderwidth";
    cCAMLtoTKunits v1]
  | InsertBackground v1 -> chk_sub "InsertBackground" table CInsertBackground; TkTokenList [TkToken "-insertbackground";
    cCAMLtoTKcolor v1]
  | ImagePhoto v1 -> chk_sub "ImagePhoto" table CImagePhoto; TkTokenList [TkToken "-image";
    cCAMLtoTKimagePhoto v1]
  | ImageBitmap v1 -> chk_sub "ImageBitmap" table CImageBitmap; TkTokenList [TkToken "-image";
    cCAMLtoTKimageBitmap v1]
  | HighlightThickness v1 -> chk_sub "HighlightThickness" table CHighlightThickness; TkTokenList [TkToken "-highlightthickness";
    cCAMLtoTKunits v1]
  | HighlightColor v1 -> chk_sub "HighlightColor" table CHighlightColor; TkTokenList [TkToken "-highlightcolor";
    cCAMLtoTKcolor v1]
  | HighlightBackground v1 -> chk_sub "HighlightBackground" table CHighlightBackground; TkTokenList [TkToken "-highlightbackground";
    cCAMLtoTKcolor v1]
  | Geometry v1 -> chk_sub "Geometry" table CGeometry; TkTokenList [TkToken "-geometry";
    TkToken v1]
  | Foreground v1 -> chk_sub "Foreground" table CForeground; TkTokenList [TkToken "-foreground";
    cCAMLtoTKcolor v1]
  | Font v1 -> chk_sub "Font" table CFont; TkTokenList [TkToken "-font";
    TkToken v1]
  | ExportSelection v1 -> chk_sub "ExportSelection" table CExportSelection; TkTokenList [TkToken "-exportselection";
    if v1 then TkToken "1" else TkToken "0"]
  | DisabledForeground v1 -> chk_sub "DisabledForeground" table CDisabledForeground; TkTokenList [TkToken "-disabledforeground";
    cCAMLtoTKcolor v1]
  | Cursor v1 -> chk_sub "Cursor" table CCursor; TkTokenList [TkToken "-cursor";
    cCAMLtoTKcursor v1]
  | BorderWidth v1 -> chk_sub "BorderWidth" table CBorderWidth; TkTokenList [TkToken "-borderwidth";
    cCAMLtoTKunits v1]
  | Bitmap v1 -> chk_sub "Bitmap" table CBitmap; TkTokenList [TkToken "-bitmap";
    cCAMLtoTKbitmap v1]
  | Background v1 -> chk_sub "Background" table CBackground; TkTokenList [TkToken "-background";
    cCAMLtoTKcolor v1]
  | Anchor v1 -> chk_sub "Anchor" table CAnchor; TkTokenList [TkToken "-anchor";
    cCAMLtoTKanchor v1]
  | ActiveForeground v1 -> chk_sub "ActiveForeground" table CActiveForeground; TkTokenList [TkToken "-activeforeground";
    cCAMLtoTKcolor v1]
  | ActiveBorderWidth v1 -> chk_sub "ActiveBorderWidth" table CActiveBorderWidth; TkTokenList [TkToken "-activeborderwidth";
    cCAMLtoTKunits v1]
  | ActiveBackground v1 -> chk_sub "ActiveBackground" table CActiveBackground; TkTokenList [TkToken "-activebackground";
    cCAMLtoTKcolor v1]


let cCAMLtoTKsearchSpec : searchSpec -> tkArgs  = function
  | Withtag v1 -> TkTokenList [TkToken "withtag";
    cCAMLtoTKtagOrId v1]
  | Overlapping ( v1, v2, v3, v4) -> TkTokenList [TkToken "overlapping";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]
  | Enclosed ( v1, v2, v3, v4) -> TkTokenList [TkToken "enclosed";
    cCAMLtoTKunits v1;
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKunits v4]
  | ClosestHaloStart ( v1, v2, v3, v4) -> TkTokenList [TkToken "closest";
    cCAMLtoTKunits v1;
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3;
    cCAMLtoTKtagOrId v4]
  | ClosestHalo ( v1, v2, v3) -> TkTokenList [TkToken "closest";
    cCAMLtoTKunits v1;
    cCAMLtoTKunits v2;
    cCAMLtoTKunits v3]
  | Closest ( v1, v2) -> TkTokenList [TkToken "closest";
    cCAMLtoTKunits v1;
    cCAMLtoTKunits v2]
  | Below v1 -> TkTokenList [TkToken "below";
    cCAMLtoTKtagOrId v1]
  | All -> TkToken "all"
  | Above v1 -> TkTokenList [TkToken "above";
    cCAMLtoTKtagOrId v1]


let cCAMLtoTKcanvasItem : canvasItem -> tkArgs  = function
  | User_item v1 -> TkToken v1
  | Window_item -> TkToken "window"
  | Text_item -> TkToken "text"
  | Rectangle_item -> TkToken "rectangle"
  | Polygon_item -> TkToken "polygon"
  | Oval_item -> TkToken "oval"
  | Line_item -> TkToken "line"
  | Image_item -> TkToken "image"
  | Bitmap_item -> TkToken "bitmap"
  | Arc_item -> TkToken "arc"


let cTKtoCAMLcanvasItem n =
    match n with
    | "arc" -> Arc_item
    | "bitmap" -> Bitmap_item
    | "image" -> Image_item
    | "line" -> Line_item
    | "oval" -> Oval_item
    | "polygon" -> Polygon_item
    | "rectangle" -> Rectangle_item
    | "text" -> Text_item
    | "window" -> Window_item
    | n -> User_item n

let icccm_any_table = [CDisplayOf; CICCCMFormat; CICCCMType; CLostCommand; CSelection]

let icccm_selection_handle_table = [CICCCMFormat; CICCCMType; CSelection]

let icccm_selection_ownset_table = [CLostCommand; CSelection]

let icccm_selection_get_table = [CDisplayOf; CICCCMType; CSelection]

let icccm_selection_clear_table = [CDisplayOf; CSelection]

let icccm_clipboard_append_table = [CICCCMFormat; CICCCMType]

let cCAMLtoTKicccm w table : icccm -> tkArgs  = function
  | LostCommand v1 -> chk_sub "LostCommand" table CLostCommand; TkTokenList [TkToken "-command";
    let id = register_callback w ~callback: (fun _ -> v1 ()) in TkToken ("camlcb " ^ id)]
  | Selection v1 -> chk_sub "Selection" table CSelection; TkTokenList [TkToken "-selection";
    TkToken v1]
  | DisplayOf v1 -> chk_sub "DisplayOf" table CDisplayOf; TkTokenList [TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1]
  | ICCCMType v1 -> chk_sub "ICCCMType" table CICCCMType; TkTokenList [TkToken "-type";
    TkToken v1]
  | ICCCMFormat v1 -> chk_sub "ICCCMFormat" table CICCCMFormat; TkTokenList [TkToken "-format";
    TkToken v1]


let cCAMLtoTKfontMetrics : fontMetrics -> tkArgs  = function
  | Fixed -> TkToken "-fixed"
  | Linespace -> TkToken "-linespace"
  | Descent -> TkToken "-descent"
  | Ascent -> TkToken "-ascent"


let cCAMLtoTKgrabStatus : grabStatus -> tkArgs  = function
  | GrabGlobal -> TkToken "global"
  | GrabLocal -> TkToken "local"
  | GrabNone -> TkToken "none"


let cTKtoCAMLgrabStatus n =
    match n with
    | "none" -> GrabNone
    | "local" -> GrabLocal
    | "global" -> GrabGlobal
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLgrabStatus: " ^ s))

let cCAMLtoTKmenuItem : menuItem -> tkArgs  = function
  | TearOff_Item -> TkToken "tearoff"
  | Separator_Item -> TkToken "separator"
  | Radiobutton_Item -> TkToken "radiobutton"
  | Command_Item -> TkToken "command"
  | Checkbutton_Item -> TkToken "checkbutton"
  | Cascade_Item -> TkToken "cascade"


let cTKtoCAMLmenuItem n =
    match n with
    | "cascade" -> Cascade_Item
    | "checkbutton" -> Checkbutton_Item
    | "command" -> Command_Item
    | "radiobutton" -> Radiobutton_Item
    | "separator" -> Separator_Item
    | "tearoff" -> TearOff_Item
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLmenuItem: " ^ s))

let cCAMLtoTKoptionPriority : optionPriority -> tkArgs  = function
  | Priority v1 -> TkToken (string_of_int v1)
  | Interactive -> TkToken "interactive"
  | UserDefault -> TkToken "userDefault"
  | StartupFile -> TkToken "startupFile"
  | WidgetDefault -> TkToken "widgetDefault"


let tkPalette_any_table = [CPaletteActiveBackground; CPaletteActiveForeground; CPaletteBackground; CPaletteDisabledForeground; CPaletteForeground; CPaletteForegroundselectColor; CPaletteHighlightBackground; CPaletteHighlightColor; CPaletteInsertBackground; CPaletteSelectBackground; CPaletteSelectColor; CPaletteTroughColor]

let tkPalette_any_table = [CPaletteActiveBackground; CPaletteActiveForeground; CPaletteBackground; CPaletteDisabledForeground; CPaletteForeground; CPaletteForegroundselectColor; CPaletteHighlightBackground; CPaletteHighlightColor; CPaletteInsertBackground; CPaletteSelectBackground; CPaletteSelectColor; CPaletteTroughColor]

let cCAMLtoTKtkPalette table : tkPalette -> tkArgs  = function
  | PaletteTroughColor v1 -> chk_sub "PaletteTroughColor" table CPaletteTroughColor; TkTokenList [TkToken "troughColor";
    cCAMLtoTKcolor v1]
  | PaletteForegroundselectColor v1 -> chk_sub "PaletteForegroundselectColor" table CPaletteForegroundselectColor; TkTokenList [TkToken "selectForeground";
    cCAMLtoTKcolor v1]
  | PaletteSelectBackground v1 -> chk_sub "PaletteSelectBackground" table CPaletteSelectBackground; TkTokenList [TkToken "selectBackground";
    cCAMLtoTKcolor v1]
  | PaletteSelectColor v1 -> chk_sub "PaletteSelectColor" table CPaletteSelectColor; TkTokenList [TkToken "selectColor";
    cCAMLtoTKcolor v1]
  | PaletteInsertBackground v1 -> chk_sub "PaletteInsertBackground" table CPaletteInsertBackground; TkTokenList [TkToken "insertBackground";
    cCAMLtoTKcolor v1]
  | PaletteHighlightColor v1 -> chk_sub "PaletteHighlightColor" table CPaletteHighlightColor; TkTokenList [TkToken "highlightColor";
    cCAMLtoTKcolor v1]
  | PaletteHighlightBackground v1 -> chk_sub "PaletteHighlightBackground" table CPaletteHighlightBackground; TkTokenList [TkToken "hilightBackground";
    cCAMLtoTKcolor v1]
  | PaletteForeground v1 -> chk_sub "PaletteForeground" table CPaletteForeground; TkTokenList [TkToken "foreground";
    cCAMLtoTKcolor v1]
  | PaletteDisabledForeground v1 -> chk_sub "PaletteDisabledForeground" table CPaletteDisabledForeground; TkTokenList [TkToken "disabledForeground";
    cCAMLtoTKcolor v1]
  | PaletteBackground v1 -> chk_sub "PaletteBackground" table CPaletteBackground; TkTokenList [TkToken "background";
    cCAMLtoTKcolor v1]
  | PaletteActiveForeground v1 -> chk_sub "PaletteActiveForeground" table CPaletteActiveForeground; TkTokenList [TkToken "activeForeground";
    cCAMLtoTKcolor v1]
  | PaletteActiveBackground v1 -> chk_sub "PaletteActiveBackground" table CPaletteActiveBackground; TkTokenList [TkToken "activeBackground";
    cCAMLtoTKcolor v1]


let photo_any_table = [CImgFormat; CImgFrom; CImgTo; CShrink; CSubsample; CTopLeft; CZoom]

let photo_write_table = [CImgFormat; CImgFrom]

let photo_read_table = [CImgFormat; CImgFrom; CShrink; CTopLeft]

let photo_put_table = [CImgTo]

let photo_copy_table = [CImgFrom; CImgTo; CShrink; CSubsample; CZoom]

let cCAMLtoTKphoto table : photo -> tkArgs  = function
  | TopLeft ( v1, v2) -> chk_sub "TopLeft" table CTopLeft; TkTokenList [TkToken "-to";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]
  | ImgFormat v1 -> chk_sub "ImgFormat" table CImgFormat; TkTokenList [TkToken "-format";
    TkToken v1]
  | Subsample ( v1, v2) -> chk_sub "Subsample" table CSubsample; TkTokenList [TkToken "-subsample";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]
  | Zoom ( v1, v2) -> chk_sub "Zoom" table CZoom; TkTokenList [TkToken "-zoom";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2)]
  | Shrink -> chk_sub "Shrink" table CShrink; TkToken "-shrink"
  | ImgTo ( v1, v2, v3, v4) -> chk_sub "ImgTo" table CImgTo; TkTokenList [TkToken "-to";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]
  | ImgFrom ( v1, v2, v3, v4) -> chk_sub "ImgFrom" table CImgFrom; TkTokenList [TkToken "-from";
    TkToken (string_of_int v1);
    TkToken (string_of_int v2);
    TkToken (string_of_int v3);
    TkToken (string_of_int v4)]


let widgetElement_any_table = [CArrow1; CArrow2; CBeyond; CSlider; CTrough1; CTrough2]

let widgetElement_scrollbar_table = [CArrow1; CArrow2; CBeyond; CSlider; CTrough1; CTrough2]

let widgetElement_scale_table = [CBeyond; CSlider; CTrough1; CTrough2]

let cCAMLtoTKwidgetElement table : widgetElement -> tkArgs  = function
  | Arrow2 -> chk_sub "Arrow2" table CArrow2; TkToken "arrow2"
  | Arrow1 -> chk_sub "Arrow1" table CArrow1; TkToken "arrow1"
  | Beyond -> chk_sub "Beyond" table CBeyond; TkToken ""
  | Trough2 -> chk_sub "Trough2" table CTrough2; TkToken "trough2"
  | Trough1 -> chk_sub "Trough1" table CTrough1; TkToken "trough1"
  | Slider -> chk_sub "Slider" table CSlider; TkToken "slider"


let cTKtoCAMLwidgetElement n =
    match n with
    | "slider" -> Slider
    | "trough1" -> Trough1
    | "trough2" -> Trough2
    | "" -> Beyond
    | "arrow1" -> Arrow1
    | "arrow2" -> Arrow2
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLwidgetElement: " ^ s))

let cTKtoCAMLscrollbar_widgetElement n =
    match n with
    | "trough2" -> Trough2
    | "trough1" -> Trough1
    | "slider" -> Slider
    | "" -> Beyond
    | "arrow2" -> Arrow2
    | "arrow1" -> Arrow1
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLscrollbar_widgetElement: " ^ s))

let cTKtoCAMLscale_widgetElement n =
    match n with
    | "trough2" -> Trough2
    | "trough1" -> Trough1
    | "slider" -> Slider
    | "" -> Beyond
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLscale_widgetElement: " ^ s))

let cCAMLtoTKsendOption : sendOption -> tkArgs  = function
  | SendAsync -> TkToken "-async"
  | SendDisplayOf v1 -> TkTokenList [TkToken "-displayof";
    cCAMLtoTKwidget widget_any_table v1]


let cCAMLtoTKcomparison : comparison -> tkArgs  = function
  | NEQ -> TkToken "!="
  | GT -> TkToken ">"
  | GE -> TkToken ">="
  | EQ -> TkToken "=="
  | LE -> TkToken "<="
  | LT -> TkToken "<"


let cCAMLtoTKmarkDirection : markDirection -> tkArgs  = function
  | Mark_Right -> TkToken "right"
  | Mark_Left -> TkToken "left"


let cTKtoCAMLmarkDirection n =
    match n with
    | "left" -> Mark_Left
    | "right" -> Mark_Right
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLmarkDirection: " ^ s))

let cCAMLtoTKtextSearch : textSearch -> tkArgs  = function
  | Count v1 -> TkTokenList [TkToken "-count";
    cCAMLtoTKtextVariable v1]
  | Nocase -> TkToken "-nocase"
  | Regexp -> TkToken "-regexp"
  | Exact -> TkToken "-exact"
  | Backwards -> TkToken "-backwards"
  | Forwards -> TkToken "-forwards"


let cCAMLtoTKtext_dump w : text_dump -> tkArgs  = function
  | DumpWindow -> TkToken "-window"
  | DumpText -> TkToken "-text"
  | DumpTag -> TkToken "-tag"
  | DumpMark -> TkToken "-mark"
  | DumpCommand v1 -> TkTokenList [TkToken "-command";
    let id = register_callback w ~callback: (fun args ->
        let (a1, args) = (List.hd args), List.tl args in
        let (a2, args) = (List.hd args), List.tl args in
        let (a3, args) = (List.hd args), List.tl args in
        v1 a1 a2 a3) in TkToken ("camlcb " ^ id)]
  | DumpAll -> TkToken "-all"


let cCAMLtoTKatomId : atomId -> tkArgs  = function
  | AtomId v1 -> TkToken (string_of_int v1)


let cTKtoCAMLatomId n =
   try AtomId (int_of_string n)
   with _ ->
    match n with
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLatomId: " ^ s))

let cCAMLtoTKfocusModel : focusModel -> tkArgs  = function
  | FocusPassive -> TkToken "passive"
  | FocusActive -> TkToken "active"


let cTKtoCAMLfocusModel n =
    match n with
    | "active" -> FocusActive
    | "passive" -> FocusPassive
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLfocusModel: " ^ s))

let cCAMLtoTKwmFrom : wmFrom -> tkArgs  = function
  | Program -> TkToken "program"
  | User -> TkToken "user"


let cTKtoCAMLwmFrom n =
    match n with
    | "user" -> User
    | "program" -> Program
    | s -> Pervasives.raise (Invalid_argument ("cTKtoCAMLwmFrom: " ^ s))

let cCAMLtoTKoptions_constrs = function
  | CMessageType -> TkToken "-type"
  | CMessage -> TkToken "-message"
  | CMessageIcon -> TkToken "-icon"
  | CMessageDefault -> TkToken "-default"
  | CInitialFile -> TkToken "-initialfile"
  | CInitialDir -> TkToken "-initialdir"
  | CFileTypes -> TkToken "-filetypes"
  | CDefaultExtension -> TkToken "-defaultextension"
  | CScreen -> TkToken "-screen"
  | CUse -> TkToken "-use"
  | CTitle -> TkToken "-title"
  | CParent -> TkToken "-parent"
  | CInitialColor -> TkToken "-initialcolor"
  | CUnderline -> TkToken "-underline"
  | CRMargin -> TkToken "-rmargin"
  | COverStrike -> TkToken "-overstrike"
  | COffset -> TkToken "-offset"
  | CLMargin2 -> TkToken "-lmargin2"
  | CLMargin1 -> TkToken "-lmargin1"
  | CFgStipple -> TkToken "-fgstipple"
  | CBgStipple -> TkToken "-bgstipple"
  | CSpacing1 -> TkToken "-spacing1"
  | CSpacing2 -> TkToken "-spacing2"
  | CSpacing3 -> TkToken "-spacing3"
  | CTabs -> TkToken "-tabs"
  | CWrap -> TkToken "-wrap"
  | CStretch -> TkToken "-stretch"
  | CName -> TkToken "-name"
  | CAlign -> TkToken "-align"
  | CActiveRelief -> TkToken "-activerelief"
  | CScrollCommand -> TkToken "-command"
  | CElementBorderWidth -> TkToken "-elementborderwidth"
  | CBigIncrement -> TkToken "-bigincrement"
  | CScaleCommand -> TkToken "-command"
  | CDigits -> TkToken "-digits"
  | CFrom -> TkToken "-from"
  | CLength -> TkToken "-length"
  | CResolution -> TkToken "-resolution"
  | CShowValue -> TkToken "-showvalue"
  | CSliderLength -> TkToken "-sliderlength"
  | CTickInterval -> TkToken "-tickinterval"
  | CTo -> TkToken "-to"
  | CBorderMode -> TkToken "-bordermode"
  | CRelHeight -> TkToken "-relheight"
  | CRelWidth -> TkToken "-relwidth"
  | CRelY -> TkToken "-rely"
  | CRelX -> TkToken "-relx"
  | CPalette -> TkToken "-palette"
  | CGamma -> TkToken "-gamma"
  | CFormat -> TkToken "-format"
  | CSide -> TkToken "-side"
  | CFill -> TkToken "-fill"
  | CExpand -> TkToken "-expand"
  | CBefore -> TkToken "-before"
  | CAfter -> TkToken "-after"
  | CAspect -> TkToken "-aspect"
  | CDirection -> TkToken "-direction"
  | CPostCommand -> TkToken "-postcommand"
  | CTearOff -> TkToken "-tearoff"
  | CTearOffCommand -> TkToken "-tearoffcommand"
  | CMenuTitle -> TkToken "-title"
  | CMenuType -> TkToken "-type"
  | CValue -> TkToken "-value"
  | CMenu -> TkToken "-menu"
  | CLabel -> TkToken "-label"
  | CHideMargin -> TkToken "-hidemargin"
  | CColumnBreak -> TkToken "-columnbreak"
  | CAccelerator -> TkToken "-accelerator"
  | CTextHeight -> TkToken "-height"
  | CSelectMode -> TkToken "-selectmode"
  | CSticky -> TkToken "-sticky"
  | CRowSpan -> TkToken "-rowspan"
  | CRow -> TkToken "-row"
  | CIPadY -> TkToken "-ipady"
  | CIPadX -> TkToken "-ipadx"
  | CIn -> TkToken "-in"
  | CColumnSpan -> TkToken "-columnspan"
  | CColumn -> TkToken "-column"
  | CPad -> TkToken "-pad"
  | CWeight -> TkToken "-weight"
  | CMinsize -> TkToken "-minsize"
  | CClass -> TkToken "-class"
  | CColormap -> TkToken "-colormap"
  | CContainer -> TkToken "-container"
  | CVisual -> TkToken "-visual"
  | CFont_Overstrike -> TkToken "-overstrike"
  | CFont_Underline -> TkToken "-underline"
  | CFont_Slant -> TkToken "-slant"
  | CFont_Weight -> TkToken "-weight"
  | CFont_Size -> TkToken "-size"
  | CFont_Family -> TkToken "-family"
  | CShow -> TkToken "-show"
  | CTextWidth -> TkToken "-width"
  | CIndicatorOn -> TkToken "-indicatoron"
  | COffValue -> TkToken "-offvalue"
  | COnValue -> TkToken "-onvalue"
  | CSelectColor -> TkToken "-selectcolor"
  | CSelectImageBitmap -> TkToken "-selectimage"
  | CSelectImagePhoto -> TkToken "-selectimage"
  | CVariable -> TkToken "-variable"
  | CCloseEnough -> TkToken "-closeenough"
  | CConfine -> TkToken "-confine"
  | CScrollRegion -> TkToken "-scrollregion"
  | CXScrollIncrement -> TkToken "-xscrollincrement"
  | CYScrollIncrement -> TkToken "-yscrollincrement"
  | CWindow -> TkToken "-window"
  | CSplineSteps -> TkToken "-splinesteps"
  | CSmooth -> TkToken "-smooth"
  | CJoinStyle -> TkToken "-joinstyle"
  | CCapStyle -> TkToken "-capstyle"
  | CArrowShape -> TkToken "-arrowshape"
  | CArrowStyle -> TkToken "-arrow"
  | CTags -> TkToken "-tags"
  | CArcStyle -> TkToken "-style"
  | CStipple -> TkToken "-stipple"
  | CStart -> TkToken "-start"
  | COutlineStipple -> TkToken "-outlinestipple"
  | COutline -> TkToken "-outline"
  | CFillColor -> TkToken "-fill"
  | CDash -> TkToken "-dash"
  | CExtent -> TkToken "-extent"
  | CY -> TkToken "-y"
  | CX -> TkToken "-x"
  | CRotate -> TkToken "-rotate"
  | CPageY -> TkToken "-pagey"
  | CPageX -> TkToken "-pagex"
  | CPageWidth -> TkToken "-pagewidth"
  | CPageHeight -> TkToken "-pageheight"
  | CPageAnchor -> TkToken "-pageanchor"
  | CColormode -> TkToken "-colormode"
  | CCommand -> TkToken "-command"
  | CDefault -> TkToken "-default"
  | CHeight -> TkToken "-height"
  | CState -> TkToken "-state"
  | CWidth -> TkToken "-width"
  | CMaskfile -> TkToken "-maskfile"
  | CMaskdata -> TkToken "-maskdata"
  | CFile -> TkToken "-file"
  | CData -> TkToken "-data"
  | CYScrollCommand -> TkToken "-yscrollcommand"
  | CXScrollCommand -> TkToken "-xscrollcommand"
  | CWrapLength -> TkToken "-wraplength"
  | CUnderlinedChar -> TkToken "-underline"
  | CTroughColor -> TkToken "-troughcolor"
  | CTextVariable -> TkToken "-textvariable"
  | CText -> TkToken "-text"
  | CTakeFocus -> TkToken "-takefocus"
  | CSetGrid -> TkToken "-setgrid"
  | CSelectForeground -> TkToken "-selectforeground"
  | CSelectBorderWidth -> TkToken "-selectborderwidth"
  | CSelectBackground -> TkToken "-selectbackground"
  | CRepeatInterval -> TkToken "-repeatinterval"
  | CRepeatDelay -> TkToken "-repeatdelay"
  | CRelief -> TkToken "-relief"
  | CPadY -> TkToken "-pady"
  | CPadX -> TkToken "-padx"
  | COrient -> TkToken "-orient"
  | CJustify -> TkToken "-justify"
  | CJump -> TkToken "-jump"
  | CInsertWidth -> TkToken "-insertwidth"
  | CInsertOnTime -> TkToken "-insertontime"
  | CInsertOffTime -> TkToken "-insertofftime"
  | CInsertBorderWidth -> TkToken "-insertborderwidth"
  | CInsertBackground -> TkToken "-insertbackground"
  | CImagePhoto -> TkToken "-image"
  | CImageBitmap -> TkToken "-image"
  | CHighlightThickness -> TkToken "-highlightthickness"
  | CHighlightColor -> TkToken "-highlightcolor"
  | CHighlightBackground -> TkToken "-highlightbackground"
  | CGeometry -> TkToken "-geometry"
  | CForeground -> TkToken "-foreground"
  | CFont -> TkToken "-font"
  | CExportSelection -> TkToken "-exportselection"
  | CDisabledForeground -> TkToken "-disabledforeground"
  | CCursor -> TkToken "-cursor"
  | CBorderWidth -> TkToken "-borderwidth"
  | CBitmap -> TkToken "-bitmap"
  | CBackground -> TkToken "-background"
  | CAnchor -> TkToken "-anchor"
  | CActiveForeground -> TkToken "-activeforeground"
  | CActiveBorderWidth -> TkToken "-activeborderwidth"
  | CActiveBackground -> TkToken "-activebackground"


