(* type *)
type anchor =
  | Center        (* tk option: center *)
  | E        (* tk option: e *)
  | N        (* tk option: n *)
  | NE        (* tk option: ne *)
  | NW        (* tk option: nw *)
  | S        (* tk option: s *)
  | SE        (* tk option: se *)
  | SW        (* tk option: sw *)
  | W        (* tk option: w *)
(* /type *)

(* type *)
type imageBitmap =
  | BitmapImage of (string)        (* tk option: <string> *)
(* /type *)

(* type *)
type imagePhoto =
  | PhotoImage of (string)        (* tk option: <string> *)
(* /type *)

(* type *)
type justification =
  | Justify_Center        (* tk option: center *)
  | Justify_Left        (* tk option: left *)
  | Justify_Right        (* tk option: right *)
(* /type *)

(* type *)
type orientation =
  | Horizontal        (* tk option: horizontal *)
  | Vertical        (* tk option: vertical *)
(* /type *)

(* type *)
type relief =
  | Flat        (* tk option: flat *)
  | Groove        (* tk option: groove *)
  | Raised        (* tk option: raised *)
  | Ridge        (* tk option: ridge *)
  | Solid        (* tk option: solid *)
  | Sunken        (* tk option: sunken *)
(* /type *)

(* type *)
type state =
  | Active        (* tk option: active *)
  | Disabled        (* tk option: disabled *)
  | Hidden        (* tk option: hidden *)
  | Normal        (* tk option: normal *)
(* /type *)

(* type *)
type colorMode =
  | Color        (* tk option: color *)
  | Gray        (* tk option: gray *)
  | Mono        (* tk option: mono *)
(* /type *)

(* type *)
type arcStyle =
  | Arc        (* tk option: arc *)
  | Chord        (* tk option: chord *)
  | PieSlice        (* tk option: pieslice *)
(* /type *)

(* type *)
type tagOrId =
  | Id of (int)        (* tk option: <int> *)
  | Tag of (string)        (* tk option: <string> *)
(* /type *)

(* type *)
type arrowStyle =
  | Arrow_Both        (* tk option: both *)
  | Arrow_First        (* tk option: first *)
  | Arrow_Last        (* tk option: last *)
  | Arrow_None        (* tk option: none *)
(* /type *)

(* type *)
type capStyle =
  | Cap_Butt        (* tk option: butt *)
  | Cap_Projecting        (* tk option: projecting *)
  | Cap_Round        (* tk option: round *)
(* /type *)

(* type *)
type joinStyle =
  | Join_Bevel        (* tk option: bevel *)
  | Join_Miter        (* tk option: miter *)
  | Join_Round        (* tk option: round *)
(* /type *)

(* type *)
type weight =
  | Weight_Bold        (* tk option: bold *)
  | Weight_Normal        (* tk option: normal *)
(* /type *)

(* type *)
type slant =
  | Slant_Italic        (* tk option: italic *)
  | Slant_Roman        (* tk option: roman *)
(* /type *)

(* type *)
type visual =
  | Best        (* tk option: best *)
  | BestDepth of (int)        (* tk option: {best <int>} *)
  | ClassVisual of (string * int)        (* tk option: {<string> <int>} *)
  | DefaultVisual        (* tk option: default *)
  | WidgetVisual of (widget)        (* tk option: <widget> *)
(* /type *)

(* type *)
type colormap =
  | NewColormap        (* tk option: new *)
  | WidgetColormap of (widget)        (* tk option: <widget> *)
(* /type *)

(* type *)
type selectModeType =
  | Browse        (* tk option: browse *)
  | Extended        (* tk option: extended *)
  | Multiple        (* tk option: multiple *)
  | Single        (* tk option: single *)
(* /type *)

(* type *)
type menuType =
  | Menu_Menubar        (* tk option: menubar *)
  | Menu_Normal        (* tk option: normal *)
  | Menu_Tearoff        (* tk option: tearoff *)
(* /type *)

(* type *)
type menubuttonDirection =
  | Dir_Above        (* tk option: above *)
  | Dir_Below        (* tk option: below *)
  | Dir_Left        (* tk option: left *)
  | Dir_Right        (* tk option: right *)
(* /type *)

(* type *)
type fillMode =
  | Fill_Both        (* tk option: both *)
  | Fill_None        (* tk option: none *)
  | Fill_X        (* tk option: x *)
  | Fill_Y        (* tk option: y *)
(* /type *)

(* type *)
type side =
  | Side_Bottom        (* tk option: bottom *)
  | Side_Left        (* tk option: left *)
  | Side_Right        (* tk option: right *)
  | Side_Top        (* tk option: top *)
(* /type *)

(* type *)
type borderMode =
  | Ignore        (* tk option: ignore *)
  | Inside        (* tk option: inside *)
  | Outside        (* tk option: outside *)
(* /type *)

(* type *)
type alignType =
  | Align_Baseline        (* tk option: baseline *)
  | Align_Bottom        (* tk option: bottom *)
  | Align_Center        (* tk option: center *)
  | Align_Top        (* tk option: top *)
(* /type *)

(* type *)
type wrapMode =
  | WrapChar        (* tk option: char *)
  | WrapNone        (* tk option: none *)
  | WrapWord        (* tk option: word *)
(* /type *)

(* type *)
type tabType =
  | TabCenter of (units)        (* tk option: <units> center *)
  | TabLeft of (units)        (* tk option: <units> left *)
  | TabNumeric of (units)        (* tk option: <units> numeric *)
  | TabRight of (units)        (* tk option: <units> right *)
(* /type *)

(* type *)
type messageIcon =
  | Error        (* tk option: error *)
  | Info        (* tk option: info *)
  | Question        (* tk option: question *)
  | Warning        (* tk option: warning *)
(* /type *)

(* type *)
type messageType =
  | AbortRetryIgnore        (* tk option: abortretryignore *)
  | Ok        (* tk option: ok *)
  | OkCancel        (* tk option: okcancel *)
  | RetryCancel        (* tk option: retrycancel *)
  | YesNo        (* tk option: yesno *)
  | YesNoCancel        (* tk option: yesnocancel *)
(* /type *)

(* type *)
type options =
  | Accelerator of (string)        (* tk option: -accelerator <string> *)
  | ActiveBackground of (color)        (* tk option: -activebackground <color> *)
  | ActiveBorderWidth of (units)        (* tk option: -activeborderwidth <units> *)
  | ActiveForeground of (color)        (* tk option: -activeforeground <color> *)
  | ActiveRelief of (relief)        (* tk option: -activerelief <relief> *)
  | After of (widget)        (* tk option: -after <widget> *)
  | Align of (alignType)        (* tk option: -align <alignType> *)
  | Anchor of (anchor)        (* tk option: -anchor <anchor> *)
  | ArcStyle of (arcStyle)        (* tk option: -style <arcStyle> *)
  | ArrowShape of (units * units * units)        (* tk option: -arrowshape {<units> <units> <units>} *)
  | ArrowStyle of (arrowStyle)        (* tk option: -arrow <arrowStyle> *)
  | Aspect of (int)        (* tk option: -aspect <int> *)
  | Background of (color)        (* tk option: -background <color> *)
  | Before of (widget)        (* tk option: -before <widget> *)
  | BgStipple of (bitmap)        (* tk option: -bgstipple <bitmap> *)
  | BigIncrement of (float)        (* tk option: -bigincrement <float> *)
  | Bitmap of (bitmap)        (* tk option: -bitmap <bitmap> *)
  | BorderMode of (borderMode)        (* tk option: -bordermode <borderMode> *)
  | BorderWidth of (units)        (* tk option: -borderwidth <units> *)
  | CapStyle of (capStyle)        (* tk option: -capstyle <capStyle> *)
  | Class of (string)        (* tk option: -class <string> *)
  | CloseEnough of (float)        (* tk option: -closeenough <float> *)
  | Colormap of (colormap)        (* tk option: -colormap <colormap> *)
  | Colormode of (colorMode)        (* tk option: -colormode <colorMode> *)
  | Column of (int)        (* tk option: -column <int> *)
  | ColumnBreak of (bool)        (* tk option: -columnbreak <bool> *)
  | ColumnSpan of (int)        (* tk option: -columnspan <int> *)
  | Command of ((unit -> unit))        (* tk option: -command <(unit -> unit)> *)
  | Confine of (bool)        (* tk option: -confine <bool> *)
  | Container of (bool)        (* tk option: -container <bool> *)
  | Cursor of (cursor)        (* tk option: -cursor <cursor> *)
  | Dash of (string)        (* tk option: -dash <string> *)
  | Data of (string)        (* tk option: -data <string> *)
  | Default of (state)        (* tk option: -default <state> *)
  | DefaultExtension of (string)        (* tk option: -defaultextension <string> *)
  | Digits of (int)        (* tk option: -digits <int> *)
  | Direction of (menubuttonDirection)        (* tk option: -direction <menubuttonDirection> *)
  | DisabledForeground of (color)        (* tk option: -disabledforeground <color> *)
  | ElementBorderWidth of (units)        (* tk option: -elementborderwidth <units> *)
  | Expand of (bool)        (* tk option: -expand <bool> *)
  | ExportSelection of (bool)        (* tk option: -exportselection <bool> *)
  | Extent of (float)        (* tk option: -extent <float> *)
  | FgStipple of (bitmap)        (* tk option: -fgstipple <bitmap> *)
  | File of (string)        (* tk option: -file <string> *)
  | FileTypes of (filePattern list)        (* tk option: -filetypes {<filePattern list>} *)
  | Fill of (fillMode)        (* tk option: -fill <fillMode> *)
  | FillColor of (color)        (* tk option: -fill <color> *)
  | Font of (string)        (* tk option: -font <string> *)
  | Font_Family of (string)        (* tk option: -family <string> *)
  | Font_Overstrike of (bool)        (* tk option: -overstrike <bool> *)
  | Font_Size of (int)        (* tk option: -size <int> *)
  | Font_Slant of (slant)        (* tk option: -slant <slant> *)
  | Font_Underline of (bool)        (* tk option: -underline <bool> *)
  | Font_Weight of (weight)        (* tk option: -weight <weight> *)
  | Foreground of (color)        (* tk option: -foreground <color> *)
  | Format of (string)        (* tk option: -format <string> *)
  | From of (float)        (* tk option: -from <float> *)
  | Gamma of (float)        (* tk option: -gamma <float> *)
  | Geometry of (string)        (* tk option: -geometry <string> *)
  | Height of (units)        (* tk option: -height <units> *)
  | HideMargin of (bool)        (* tk option: -hidemargin <bool> *)
  | HighlightBackground of (color)        (* tk option: -highlightbackground <color> *)
  | HighlightColor of (color)        (* tk option: -highlightcolor <color> *)
  | HighlightThickness of (units)        (* tk option: -highlightthickness <units> *)
  | IPadX of (units)        (* tk option: -ipadx <units> *)
  | IPadY of (units)        (* tk option: -ipady <units> *)
  | ImageBitmap of (imageBitmap)        (* tk option: -image <imageBitmap> *)
  | ImagePhoto of (imagePhoto)        (* tk option: -image <imagePhoto> *)
  | In of (widget)        (* tk option: -in <widget> *)
  | IndicatorOn of (bool)        (* tk option: -indicatoron <bool> *)
  | InitialColor of (color)        (* tk option: -initialcolor <color> *)
  | InitialDir of (string)        (* tk option: -initialdir <string> *)
  | InitialFile of (string)        (* tk option: -initialfile <string> *)
  | InsertBackground of (color)        (* tk option: -insertbackground <color> *)
  | InsertBorderWidth of (units)        (* tk option: -insertborderwidth <units> *)
  | InsertOffTime of (int)        (* tk option: -insertofftime <int> *)
  | InsertOnTime of (int)        (* tk option: -insertontime <int> *)
  | InsertWidth of (units)        (* tk option: -insertwidth <units> *)
  | JoinStyle of (joinStyle)        (* tk option: -joinstyle <joinStyle> *)
  | Jump of (bool)        (* tk option: -jump <bool> *)
  | Justify of (justification)        (* tk option: -justify <justification> *)
  | LMargin1 of (units)        (* tk option: -lmargin1 <units> *)
  | LMargin2 of (units)        (* tk option: -lmargin2 <units> *)
  | Label of (string)        (* tk option: -label <string> *)
  | Length of (units)        (* tk option: -length <units> *)
  | Maskdata of (string)        (* tk option: -maskdata <string> *)
  | Maskfile of (string)        (* tk option: -maskfile <string> *)
  | Menu of ((* menu *) widget)        (* tk option: -menu <(* menu *) widget> *)
  | MenuTitle of (string)        (* tk option: -title <string> *)
  | MenuType of (menuType)        (* tk option: -type <menuType> *)
  | Message of (string)        (* tk option: -message <string> *)
  | MessageDefault of (string)        (* tk option: -default <string> *)
  | MessageIcon of (messageIcon)        (* tk option: -icon <messageIcon> *)
  | MessageType of (messageType)        (* tk option: -type <messageType> *)
  | Minsize of (units)        (* tk option: -minsize <units> *)
  | Name of (string)        (* tk option: -name <string> *)
  | OffValue of (string)        (* tk option: -offvalue <string> *)
  | Offset of (units)        (* tk option: -offset <units> *)
  | OnValue of (string)        (* tk option: -onvalue <string> *)
  | Orient of (orientation)        (* tk option: -orient <orientation> *)
  | Outline of (color)        (* tk option: -outline <color> *)
  | OutlineStipple of (bitmap)        (* tk option: -outlinestipple <bitmap> *)
  | OverStrike of (bool)        (* tk option: -overstrike <bool> *)
  | Pad of (units)        (* tk option: -pad <units> *)
  | PadX of (units)        (* tk option: -padx <units> *)
  | PadY of (units)        (* tk option: -pady <units> *)
  | PageAnchor of (anchor)        (* tk option: -pageanchor <anchor> *)
  | PageHeight of (units)        (* tk option: -pageheight <units> *)
  | PageWidth of (units)        (* tk option: -pagewidth <units> *)
  | PageX of (units)        (* tk option: -pagex <units> *)
  | PageY of (units)        (* tk option: -pagey <units> *)
  | Palette of (paletteType)        (* tk option: -palette <paletteType> *)
  | Parent of (widget)        (* tk option: -parent <widget> *)
  | PostCommand of ((unit -> unit))        (* tk option: -postcommand <(unit -> unit)> *)
  | RMargin of (units)        (* tk option: -rmargin <units> *)
  | RelHeight of (float)        (* tk option: -relheight <float> *)
  | RelWidth of (float)        (* tk option: -relwidth <float> *)
  | RelX of (float)        (* tk option: -relx <float> *)
  | RelY of (float)        (* tk option: -rely <float> *)
  | Relief of (relief)        (* tk option: -relief <relief> *)
  | RepeatDelay of (int)        (* tk option: -repeatdelay <int> *)
  | RepeatInterval of (int)        (* tk option: -repeatinterval <int> *)
  | Resolution of (float)        (* tk option: -resolution <float> *)
  | Rotate of (bool)        (* tk option: -rotate <bool> *)
  | Row of (int)        (* tk option: -row <int> *)
  | RowSpan of (int)        (* tk option: -rowspan <int> *)
  | ScaleCommand of ((float -> unit))        (* tk option: -command <(float -> unit)> *)
  | Screen of (string)        (* tk option: -screen <string> *)
  | ScrollCommand of ((scrollValue -> unit))        (* tk option: -command <(scrollValue -> unit)> *)
  | ScrollRegion of (units * units * units * units)        (* tk option: -scrollregion {<units> <units> <units> <units>} *)
  | SelectBackground of (color)        (* tk option: -selectbackground <color> *)
  | SelectBorderWidth of (units)        (* tk option: -selectborderwidth <units> *)
  | SelectColor of (color)        (* tk option: -selectcolor <color> *)
  | SelectForeground of (color)        (* tk option: -selectforeground <color> *)
  | SelectImageBitmap of (imageBitmap)        (* tk option: -selectimage <imageBitmap> *)
  | SelectImagePhoto of (imagePhoto)        (* tk option: -selectimage <imagePhoto> *)
  | SelectMode of (selectModeType)        (* tk option: -selectmode <selectModeType> *)
  | SetGrid of (bool)        (* tk option: -setgrid <bool> *)
  | Show of (char)        (* tk option: -show <char> *)
  | ShowValue of (bool)        (* tk option: -showvalue <bool> *)
  | Side of (side)        (* tk option: -side <side> *)
  | SliderLength of (units)        (* tk option: -sliderlength <units> *)
  | Smooth of (bool)        (* tk option: -smooth <bool> *)
  | Spacing1 of (units)        (* tk option: -spacing1 <units> *)
  | Spacing2 of (units)        (* tk option: -spacing2 <units> *)
  | Spacing3 of (units)        (* tk option: -spacing3 <units> *)
  | SplineSteps of (int)        (* tk option: -splinesteps <int> *)
  | Start of (float)        (* tk option: -start <float> *)
  | State of (state)        (* tk option: -state <state> *)
  | Sticky of (string)        (* tk option: -sticky <string> *)
  | Stipple of (bitmap)        (* tk option: -stipple <bitmap> *)
  | Stretch of (bool)        (* tk option: -stretch <bool> *)
  | Tabs of (tabType list)        (* tk option: -tabs {<tabType list>} *)
  | Tags of (tagOrId list)        (* tk option: -tags {<tagOrId list>} *)
  | TakeFocus of (bool)        (* tk option: -takefocus <bool> *)
  | TearOff of (bool)        (* tk option: -tearoff <bool> *)
  | TearOffCommand of (((* any *) widget -> (* any *) widget -> unit))        (* tk option: -tearoffcommand <((* any *) widget -> (* any *) widget -> unit)> *)
  | Text of (string)        (* tk option: -text <string> *)
  | TextHeight of (int)        (* tk option: -height <int> *)
  | TextVariable of (textVariable)        (* tk option: -textvariable <textVariable> *)
  | TextWidth of (int)        (* tk option: -width <int> *)
  | TickInterval of (float)        (* tk option: -tickinterval <float> *)
  | Title of (string)        (* tk option: -title <string> *)
  | To of (float)        (* tk option: -to <float> *)
  | TroughColor of (color)        (* tk option: -troughcolor <color> *)
  | Underline of (bool)        (* tk option: -underline <bool> *)
  | UnderlinedChar of (int)        (* tk option: -underline <int> *)
  | Use of (string)        (* tk option: -use <string> *)
  | Value of (string)        (* tk option: -value <string> *)
  | Variable of (textVariable)        (* tk option: -variable <textVariable> *)
  | Visual of (visual)        (* tk option: -visual <visual> *)
  | Weight of (int)        (* tk option: -weight <int> *)
  | Width of (units)        (* tk option: -width <units> *)
  | Window of (widget)        (* tk option: -window <widget> *)
  | Wrap of (wrapMode)        (* tk option: -wrap <wrapMode> *)
  | WrapLength of (units)        (* tk option: -wraplength <units> *)
  | X of (units)        (* tk option: -x <units> *)
  | XScrollCommand of ((float -> float -> unit))        (* tk option: -xscrollcommand <(float -> float -> unit)> *)
  | XScrollIncrement of (units)        (* tk option: -xscrollincrement <units> *)
  | Y of (units)        (* tk option: -y <units> *)
  | YScrollCommand of ((float -> float -> unit))        (* tk option: -yscrollcommand <(float -> float -> unit)> *)
  | YScrollIncrement of (units)        (* tk option: -yscrollincrement <units> *)
(* /type *)

(* type *)
type options_constrs =
	  | CAccelerator
  | CActiveBackground
  | CActiveBorderWidth
  | CActiveForeground
  | CActiveRelief
  | CAfter
  | CAlign
  | CAnchor
  | CArcStyle
  | CArrowShape
  | CArrowStyle
  | CAspect
  | CBackground
  | CBefore
  | CBgStipple
  | CBigIncrement
  | CBitmap
  | CBorderMode
  | CBorderWidth
  | CCapStyle
  | CClass
  | CCloseEnough
  | CColormap
  | CColormode
  | CColumn
  | CColumnBreak
  | CColumnSpan
  | CCommand
  | CConfine
  | CContainer
  | CCursor
  | CDash
  | CData
  | CDefault
  | CDefaultExtension
  | CDigits
  | CDirection
  | CDisabledForeground
  | CElementBorderWidth
  | CExpand
  | CExportSelection
  | CExtent
  | CFgStipple
  | CFile
  | CFileTypes
  | CFill
  | CFillColor
  | CFont
  | CFont_Family
  | CFont_Overstrike
  | CFont_Size
  | CFont_Slant
  | CFont_Underline
  | CFont_Weight
  | CForeground
  | CFormat
  | CFrom
  | CGamma
  | CGeometry
  | CHeight
  | CHideMargin
  | CHighlightBackground
  | CHighlightColor
  | CHighlightThickness
  | CIPadX
  | CIPadY
  | CImageBitmap
  | CImagePhoto
  | CIn
  | CIndicatorOn
  | CInitialColor
  | CInitialDir
  | CInitialFile
  | CInsertBackground
  | CInsertBorderWidth
  | CInsertOffTime
  | CInsertOnTime
  | CInsertWidth
  | CJoinStyle
  | CJump
  | CJustify
  | CLMargin1
  | CLMargin2
  | CLabel
  | CLength
  | CMaskdata
  | CMaskfile
  | CMenu
  | CMenuTitle
  | CMenuType
  | CMessage
  | CMessageDefault
  | CMessageIcon
  | CMessageType
  | CMinsize
  | CName
  | COffValue
  | COffset
  | COnValue
  | COrient
  | COutline
  | COutlineStipple
  | COverStrike
  | CPad
  | CPadX
  | CPadY
  | CPageAnchor
  | CPageHeight
  | CPageWidth
  | CPageX
  | CPageY
  | CPalette
  | CParent
  | CPostCommand
  | CRMargin
  | CRelHeight
  | CRelWidth
  | CRelX
  | CRelY
  | CRelief
  | CRepeatDelay
  | CRepeatInterval
  | CResolution
  | CRotate
  | CRow
  | CRowSpan
  | CScaleCommand
  | CScreen
  | CScrollCommand
  | CScrollRegion
  | CSelectBackground
  | CSelectBorderWidth
  | CSelectColor
  | CSelectForeground
  | CSelectImageBitmap
  | CSelectImagePhoto
  | CSelectMode
  | CSetGrid
  | CShow
  | CShowValue
  | CSide
  | CSliderLength
  | CSmooth
  | CSpacing1
  | CSpacing2
  | CSpacing3
  | CSplineSteps
  | CStart
  | CState
  | CSticky
  | CStipple
  | CStretch
  | CTabs
  | CTags
  | CTakeFocus
  | CTearOff
  | CTearOffCommand
  | CText
  | CTextHeight
  | CTextVariable
  | CTextWidth
  | CTickInterval
  | CTitle
  | CTo
  | CTroughColor
  | CUnderline
  | CUnderlinedChar
  | CUse
  | CValue
  | CVariable
  | CVisual
  | CWeight
  | CWidth
  | CWindow
  | CWrap
  | CWrapLength
  | CX
  | CXScrollCommand
  | CXScrollIncrement
  | CY
  | CYScrollCommand
  | CYScrollIncrement

(* type *)
type searchSpec =
  | Above of (tagOrId)        (* tk option: above <tagOrId> *)
  | All        (* tk option: all *)
  | Below of (tagOrId)        (* tk option: below <tagOrId> *)
  | Closest of (units * units)        (* tk option: closest <units> <units> *)
  | ClosestHalo of (units * units * units)        (* tk option: closest <units> <units> <units> *)
  | ClosestHaloStart of (units * units * units * tagOrId)        (* tk option: closest <units> <units> <units> <tagOrId> *)
  | Enclosed of (units * units * units * units)        (* tk option: enclosed <units> <units> <units> <units> *)
  | Overlapping of (int * int * int * int)        (* tk option: overlapping <int> <int> <int> <int> *)
  | Withtag of (tagOrId)        (* tk option: withtag <tagOrId> *)
(* /type *)

(* type *)
type canvasItem =
  | Arc_item        (* tk option: arc *)
  | Bitmap_item        (* tk option: bitmap *)
  | Image_item        (* tk option: image *)
  | Line_item        (* tk option: line *)
  | Oval_item        (* tk option: oval *)
  | Polygon_item        (* tk option: polygon *)
  | Rectangle_item        (* tk option: rectangle *)
  | Text_item        (* tk option: text *)
  | User_item of (string)        (* tk option: <string> *)
  | Window_item        (* tk option: window *)
(* /type *)

(* type *)
type icccm =
  | DisplayOf of (widget)        (* tk option: -displayof <widget> *)
  | ICCCMFormat of (string)        (* tk option: -format <string> *)
  | ICCCMType of (string)        (* tk option: -type <string> *)
  | LostCommand of ((unit -> unit))        (* tk option: -command <(unit -> unit)> *)
  | Selection of (string)        (* tk option: -selection <string> *)
(* /type *)

(* no doc *) type icccm_constrs =
  | CDisplayOf
  | CICCCMFormat
  | CICCCMType
  | CLostCommand
  | CSelection

(* type *)
type fontMetrics =
  | Ascent        (* tk option: -ascent *)
  | Descent        (* tk option: -descent *)
  | Fixed        (* tk option: -fixed *)
  | Linespace        (* tk option: -linespace *)
(* /type *)

(* type *)
type grabStatus =
  | GrabGlobal        (* tk option: global *)
  | GrabLocal        (* tk option: local *)
  | GrabNone        (* tk option: none *)
(* /type *)

(* type *)
type menuItem =
  | Cascade_Item        (* tk option: cascade *)
  | Checkbutton_Item        (* tk option: checkbutton *)
  | Command_Item        (* tk option: command *)
  | Radiobutton_Item        (* tk option: radiobutton *)
  | Separator_Item        (* tk option: separator *)
  | TearOff_Item        (* tk option: tearoff *)
(* /type *)

(* type *)
type optionPriority =
  | Interactive        (* tk option: interactive *)
  | Priority of (int)        (* tk option: <int> *)
  | StartupFile        (* tk option: startupFile *)
  | UserDefault        (* tk option: userDefault *)
  | WidgetDefault        (* tk option: widgetDefault *)
(* /type *)

(* type *)
type tkPalette =
  | PaletteActiveBackground of (color)        (* tk option: activeBackground <color> *)
  | PaletteActiveForeground of (color)        (* tk option: activeForeground <color> *)
  | PaletteBackground of (color)        (* tk option: background <color> *)
  | PaletteDisabledForeground of (color)        (* tk option: disabledForeground <color> *)
  | PaletteForeground of (color)        (* tk option: foreground <color> *)
  | PaletteForegroundselectColor of (color)        (* tk option: selectForeground <color> *)
  | PaletteHighlightBackground of (color)        (* tk option: hilightBackground <color> *)
  | PaletteHighlightColor of (color)        (* tk option: highlightColor <color> *)
  | PaletteInsertBackground of (color)        (* tk option: insertBackground <color> *)
  | PaletteSelectBackground of (color)        (* tk option: selectBackground <color> *)
  | PaletteSelectColor of (color)        (* tk option: selectColor <color> *)
  | PaletteTroughColor of (color)        (* tk option: troughColor <color> *)
(* /type *)

(* no doc *) type tkPalette_constrs =
  | CPaletteActiveBackground
  | CPaletteActiveForeground
  | CPaletteBackground
  | CPaletteDisabledForeground
  | CPaletteForeground
  | CPaletteForegroundselectColor
  | CPaletteHighlightBackground
  | CPaletteHighlightColor
  | CPaletteInsertBackground
  | CPaletteSelectBackground
  | CPaletteSelectColor
  | CPaletteTroughColor

(* type *)
type photo =
  | ImgFormat of (string)        (* tk option: -format <string> *)
  | ImgFrom of (int * int * int * int)        (* tk option: -from <int> <int> <int> <int> *)
  | ImgTo of (int * int * int * int)        (* tk option: -to <int> <int> <int> <int> *)
  | Shrink        (* tk option: -shrink *)
  | Subsample of (int * int)        (* tk option: -subsample <int> <int> *)
  | TopLeft of (int * int)        (* tk option: -to <int> <int> *)
  | Zoom of (int * int)        (* tk option: -zoom <int> <int> *)
(* /type *)

(* no doc *) type photo_constrs =
  | CImgFormat
  | CImgFrom
  | CImgTo
  | CShrink
  | CSubsample
  | CTopLeft
  | CZoom

(* type *)
type widgetElement =
  | Arrow1        (* tk option: arrow1 *)
  | Arrow2        (* tk option: arrow2 *)
  | Beyond        (* tk option:  *)
  | Slider        (* tk option: slider *)
  | Trough1        (* tk option: trough1 *)
  | Trough2        (* tk option: trough2 *)
(* /type *)

(* no doc *) type widgetElement_constrs =
  | CArrow1
  | CArrow2
  | CBeyond
  | CSlider
  | CTrough1
  | CTrough2

(* type *)
type sendOption =
  | SendAsync        (* tk option: -async *)
  | SendDisplayOf of (widget)        (* tk option: -displayof <widget> *)
(* /type *)

(* type *)
type comparison =
  | EQ        (* tk option: == *)
  | GE        (* tk option: >= *)
  | GT        (* tk option: > *)
  | LE        (* tk option: <= *)
  | LT        (* tk option: < *)
  | NEQ        (* tk option: != *)
(* /type *)

(* type *)
type markDirection =
  | Mark_Left        (* tk option: left *)
  | Mark_Right        (* tk option: right *)
(* /type *)

(* type *)
type textSearch =
  | Backwards        (* tk option: -backwards *)
  | Count of (textVariable)        (* tk option: -count <textVariable> *)
  | Exact        (* tk option: -exact *)
  | Forwards        (* tk option: -forwards *)
  | Nocase        (* tk option: -nocase *)
  | Regexp        (* tk option: -regexp *)
(* /type *)

(* type *)
type text_dump =
  | DumpAll        (* tk option: -all *)
  | DumpCommand of ((string -> string -> string -> unit))        (* tk option: -command <(string -> string -> string -> unit)> *)
  | DumpMark        (* tk option: -mark *)
  | DumpTag        (* tk option: -tag *)
  | DumpText        (* tk option: -text *)
  | DumpWindow        (* tk option: -window *)
(* /type *)

(* type *)
type atomId =
  | AtomId of (int)        (* tk option: <int> *)
(* /type *)

(* type *)
type focusModel =
  | FocusActive        (* tk option: active *)
  | FocusPassive        (* tk option: passive *)
(* /type *)

(* type *)
type wmFrom =
  | Program        (* tk option: program *)
  | User        (* tk option: user *)
(* /type *)

