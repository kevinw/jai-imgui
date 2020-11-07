
//
// section: ENUMS
//

ImDrawCornerFlags :: enum_flags s32 {
    None        :: 0;
    TopLeft     :: 1 << 0;
    TopRight    :: 1 << 1;
    BotLeft     :: 1 << 2;
    BotRight    :: 1 << 3;
    Top         :: ImDrawCornerFlags.TopLeft | ImDrawCornerFlags.TopRight;
    Bot         :: ImDrawCornerFlags.BotLeft | ImDrawCornerFlags.BotRight;
    Left        :: ImDrawCornerFlags.TopLeft | ImDrawCornerFlags.BotLeft;
    Right       :: ImDrawCornerFlags.TopRight | ImDrawCornerFlags.BotRight;
    All         :: 0xF;
}

ImDrawListFlags :: enum_flags s32 {
    None                      :: 0;
    AntiAliasedLines          :: 1 << 0;
    AntiAliasedLinesUseTex    :: 1 << 1;
    AntiAliasedFill           :: 1 << 2;
    AllowVtxOffset            :: 1 << 3;
}

ImFontAtlasFlags :: enum_flags s32 {
    None                  :: 0;
    NoPowerOfTwoHeight    :: 1 << 0;
    NoMouseCursors        :: 1 << 1;
    NoBakedLines          :: 1 << 2;
}

Axis :: enum s32 {
    None    :: -1;
    X       :: 0;
    Y       :: 1;
}

BackendFlags :: enum_flags s32 {
    None                       :: 0;
    HasGamepad                 :: 1 << 0;
    HasMouseCursors            :: 1 << 1;
    HasSetMousePos             :: 1 << 2;
    RendererHasVtxOffset       :: 1 << 3;
    PlatformHasViewports       :: 1 << 10;
    HasMouseHoveredViewport    :: 1 << 11;
    RendererHasViewports       :: 1 << 12;
}

ButtonFlags :: enum_flags s32 {
    None                   :: 0;
    MouseButtonLeft        :: 1 << 0;
    MouseButtonRight       :: 1 << 1;
    MouseButtonMiddle      :: 1 << 2;
    MouseButtonMask_       :: ButtonFlags.MouseButtonLeft | ButtonFlags.MouseButtonRight | ButtonFlags.MouseButtonMiddle;
    MouseButtonDefault_    :: ButtonFlags.MouseButtonLeft;
}

Col :: enum s32 {
    Text                     :: 0;
    TextDisabled             :: 1;
    WindowBg                 :: 2;
    ChildBg                  :: 3;
    PopupBg                  :: 4;
    Border                   :: 5;
    BorderShadow             :: 6;
    FrameBg                  :: 7;
    FrameBgHovered           :: 8;
    FrameBgActive            :: 9;
    TitleBg                  :: 10;
    TitleBgActive            :: 11;
    TitleBgCollapsed         :: 12;
    MenuBarBg                :: 13;
    ScrollbarBg              :: 14;
    ScrollbarGrab            :: 15;
    ScrollbarGrabHovered     :: 16;
    ScrollbarGrabActive      :: 17;
    CheckMark                :: 18;
    SliderGrab               :: 19;
    SliderGrabActive         :: 20;
    Button                   :: 21;
    ButtonHovered            :: 22;
    ButtonActive             :: 23;
    Header                   :: 24;
    HeaderHovered            :: 25;
    HeaderActive             :: 26;
    Separator                :: 27;
    SeparatorHovered         :: 28;
    SeparatorActive          :: 29;
    ResizeGrip               :: 30;
    ResizeGripHovered        :: 31;
    ResizeGripActive         :: 32;
    Tab                      :: 33;
    TabHovered               :: 34;
    TabActive                :: 35;
    TabUnfocused             :: 36;
    TabUnfocusedActive       :: 37;
    DockingPreview           :: 38;
    DockingEmptyBg           :: 39;
    PlotLines                :: 40;
    PlotLinesHovered         :: 41;
    PlotHistogram            :: 42;
    PlotHistogramHovered     :: 43;
    TextSelectedBg           :: 44;
    DragDropTarget           :: 45;
    NavHighlight             :: 46;
    NavWindowingHighlight    :: 47;
    NavWindowingDimBg        :: 48;
    ModalWindowDimBg         :: 49;
    COUNT                    :: 50;
}

ColorEditFlags :: enum_flags s32 {
    None                :: 0;
    NoAlpha             :: 1 << 1;
    NoPicker            :: 1 << 2;
    NoOptions           :: 1 << 3;
    NoSmallPreview      :: 1 << 4;
    NoInputs            :: 1 << 5;
    NoTooltip           :: 1 << 6;
    NoLabel             :: 1 << 7;
    NoSidePreview       :: 1 << 8;
    NoDragDrop          :: 1 << 9;
    NoBorder            :: 1 << 10;
    AlphaBar            :: 1 << 16;
    AlphaPreview        :: 1 << 17;
    AlphaPreviewHalf    :: 1 << 18;
    HDR                 :: 1 << 19;
    DisplayRGB          :: 1 << 20;
    DisplayHSV          :: 1 << 21;
    DisplayHex          :: 1 << 22;
    Uint8               :: 1 << 23;
    Float               :: 1 << 24;
    PickerHueBar        :: 1 << 25;
    PickerHueWheel      :: 1 << 26;
    InputRGB            :: 1 << 27;
    InputHSV            :: 1 << 28;
    _OptionsDefault     :: ColorEditFlags.Uint8 | ColorEditFlags.DisplayRGB | ColorEditFlags.InputRGB | ColorEditFlags.PickerHueBar;
    _DisplayMask        :: ColorEditFlags.DisplayRGB | ColorEditFlags.DisplayHSV | ColorEditFlags.DisplayHex;
    _DataTypeMask       :: ColorEditFlags.Uint8 | ColorEditFlags.Float;
    _PickerMask         :: ColorEditFlags.PickerHueWheel | ColorEditFlags.PickerHueBar;
    _InputMask          :: ColorEditFlags.InputRGB | ColorEditFlags.InputHSV;
}

ColumnsFlags :: enum_flags s32 {
    None                      :: 0;
    NoBorder                  :: 1 << 0;
    NoResize                  :: 1 << 1;
    NoPreserveWidths          :: 1 << 2;
    NoForceWithinWindow       :: 1 << 3;
    GrowParentContentsSize    :: 1 << 4;
}

ComboFlags :: enum_flags s32 {
    None              :: 0;
    PopupAlignLeft    :: 1 << 0;
    HeightSmall       :: 1 << 1;
    HeightRegular     :: 1 << 2;
    HeightLarge       :: 1 << 3;
    HeightLargest     :: 1 << 4;
    NoArrowButton     :: 1 << 5;
    NoPreview         :: 1 << 6;
    HeightMask_       :: ComboFlags.HeightSmall | ComboFlags.HeightRegular | ComboFlags.HeightLarge | ComboFlags.HeightLargest;
}

Cond :: enum s32 {
    None            :: 0;
    Always          :: 1 << 0;
    Once            :: 1 << 1;
    FirstUseEver    :: 1 << 2;
    Appearing       :: 1 << 3;
}

ConfigFlags :: enum_flags s32 {
    None                       :: 0;
    NavEnableKeyboard          :: 1 << 0;
    NavEnableGamepad           :: 1 << 1;
    NavEnableSetMousePos       :: 1 << 2;
    NavNoCaptureKeyboard       :: 1 << 3;
    NoMouse                    :: 1 << 4;
    NoMouseCursorChange        :: 1 << 5;
    DockingEnable              :: 1 << 6;
    ViewportsEnable            :: 1 << 10;
    DpiEnableScaleViewports    :: 1 << 14;
    DpiEnableScaleFonts        :: 1 << 15;
    IsSRGB                     :: 1 << 20;
    IsTouchScreen              :: 1 << 21;
}

DataAuthority :: enum s32 {
    Auto        :: 0;
    DockNode    :: 1;
    Window      :: 2;
}

DataType :: enum s32 {
    S8        :: 0;
    U8        :: 1;
    S16       :: 2;
    U16       :: 3;
    S32       :: 4;
    U32       :: 5;
    S64       :: 6;
    U64       :: 7;
    Float     :: 8;
    Double    :: 9;
    COUNT     :: 10;
}

Dir :: enum s32 {
    None     :: -1;
    Left     :: 0;
    Right    :: 1;
    Up       :: 2;
    Down     :: 3;
    COUNT    :: 4;
}

DockNodeFlags :: enum_flags s32 {
    None                      :: 0;
    KeepAliveOnly             :: 1 << 0;
    NoDockingInCentralNode    :: 1 << 2;
    PassthruCentralNode       :: 1 << 3;
    NoSplit                   :: 1 << 4;
    NoResize                  :: 1 << 5;
    AutoHideTabBar            :: 1 << 6;
}

DockNodeState :: enum s32 {
    Unknown                                      :: 0;
    HostWindowHiddenBecauseSingleWindow          :: 1;
    HostWindowHiddenBecauseWindowsAreResizing    :: 2;
    HostWindowVisible                            :: 3;
}

DragDropFlags :: enum_flags s32 {
    None                        :: 0;
    SourceNoPreviewTooltip      :: 1 << 0;
    SourceNoDisableHover        :: 1 << 1;
    SourceNoHoldToOpenOthers    :: 1 << 2;
    SourceAllowNullID           :: 1 << 3;
    SourceExtern                :: 1 << 4;
    SourceAutoExpirePayload     :: 1 << 5;
    AcceptBeforeDelivery        :: 1 << 10;
    AcceptNoDrawDefaultRect     :: 1 << 11;
    AcceptNoPreviewTooltip      :: 1 << 12;
    AcceptPeekOnly              :: DragDropFlags.AcceptBeforeDelivery | DragDropFlags.AcceptNoDrawDefaultRect;
}

FocusedFlags :: enum_flags s32 {
    None                   :: 0;
    ChildWindows           :: 1 << 0;
    RootWindow             :: 1 << 1;
    AnyWindow              :: 1 << 2;
    RootAndChildWindows    :: FocusedFlags.RootWindow | FocusedFlags.ChildWindows;
}

HoveredFlags :: enum_flags s32 {
    None                            :: 0;
    ChildWindows                    :: 1 << 0;
    RootWindow                      :: 1 << 1;
    AnyWindow                       :: 1 << 2;
    AllowWhenBlockedByPopup         :: 1 << 3;
    AllowWhenBlockedByActiveItem    :: 1 << 5;
    AllowWhenOverlapped             :: 1 << 6;
    AllowWhenDisabled               :: 1 << 7;
    RectOnly                        :: HoveredFlags.AllowWhenBlockedByPopup | HoveredFlags.AllowWhenBlockedByActiveItem | HoveredFlags.AllowWhenOverlapped;
    RootAndChildWindows             :: HoveredFlags.RootWindow | HoveredFlags.ChildWindows;
}

InputReadMode :: enum s32 {
    Down          :: 0;
    Pressed       :: 1;
    Released      :: 2;
    Repeat        :: 3;
    RepeatSlow    :: 4;
    RepeatFast    :: 5;
}

InputSource :: enum s32 {
    None           :: 0;
    Mouse          :: 1;
    Nav            :: 2;
    NavKeyboard    :: 3;
    NavGamepad     :: 4;
    COUNT          :: 5;
}

InputTextFlags :: enum_flags s32 {
    None                   :: 0;
    CharsDecimal           :: 1 << 0;
    CharsHexadecimal       :: 1 << 1;
    CharsUppercase         :: 1 << 2;
    CharsNoBlank           :: 1 << 3;
    AutoSelectAll          :: 1 << 4;
    EnterReturnsTrue       :: 1 << 5;
    CallbackCompletion     :: 1 << 6;
    CallbackHistory        :: 1 << 7;
    CallbackAlways         :: 1 << 8;
    CallbackCharFilter     :: 1 << 9;
    AllowTabInput          :: 1 << 10;
    CtrlEnterForNewLine    :: 1 << 11;
    NoHorizontalScroll     :: 1 << 12;
    AlwaysInsertMode       :: 1 << 13;
    ReadOnly               :: 1 << 14;
    Password               :: 1 << 15;
    NoUndoRedo             :: 1 << 16;
    CharsScientific        :: 1 << 17;
    CallbackResize         :: 1 << 18;
    CallbackEdit           :: 1 << 19;
    Multiline              :: 1 << 20;
    NoMarkEdited           :: 1 << 21;
}

ItemFlags :: enum_flags s32 {
    None                        :: 0;
    NoTabStop                   :: 1 << 0;
    ButtonRepeat                :: 1 << 1;
    Disabled                    :: 1 << 2;
    NoNav                       :: 1 << 3;
    NoNavDefaultFocus           :: 1 << 4;
    SelectableDontClosePopup    :: 1 << 5;
    MixedValue                  :: 1 << 6;
    ReadOnly                    :: 1 << 7;
    Default_                    :: 0;
}

ItemStatusFlags :: enum_flags s32 {
    None                :: 0;
    HoveredRect         :: 1 << 0;
    HasDisplayRect      :: 1 << 1;
    Edited              :: 1 << 2;
    ToggledSelection    :: 1 << 3;
    ToggledOpen         :: 1 << 4;
    HasDeactivated      :: 1 << 5;
    Deactivated         :: 1 << 6;
}

KeyModFlags :: enum_flags s32 {
    None     :: 0;
    Ctrl     :: 1 << 0;
    Shift    :: 1 << 1;
    Alt      :: 1 << 2;
    Super    :: 1 << 3;
}

Key :: enum s32 {
    Tab            :: 0;
    LeftArrow      :: 1;
    RightArrow     :: 2;
    UpArrow        :: 3;
    DownArrow      :: 4;
    PageUp         :: 5;
    PageDown       :: 6;
    Home           :: 7;
    End            :: 8;
    Insert         :: 9;
    Delete         :: 10;
    Backspace      :: 11;
    Space          :: 12;
    Enter          :: 13;
    Escape         :: 14;
    KeyPadEnter    :: 15;
    A              :: 16;
    C              :: 17;
    V              :: 18;
    X              :: 19;
    Y              :: 20;
    Z              :: 21;
    COUNT          :: 22;
}

LayoutType :: enum s32 {
    Horizontal    :: 0;
    Vertical      :: 1;
}

LogType :: enum s32 {
    None         :: 0;
    TTY          :: 1;
    File         :: 2;
    Buffer       :: 3;
    Clipboard    :: 4;
}

MouseButton :: enum s32 {
    Left      :: 0;
    Right     :: 1;
    Middle    :: 2;
    COUNT     :: 5;
}

MouseCursor :: enum s32 {
    None          :: -1;
    Arrow         :: 0;
    TextInput     :: 1;
    ResizeAll     :: 2;
    ResizeNS      :: 3;
    ResizeEW      :: 4;
    ResizeNESW    :: 5;
    ResizeNWSE    :: 6;
    Hand          :: 7;
    NotAllowed    :: 8;
    COUNT         :: 9;
}

NavDirSourceFlags :: enum_flags s32 {
    None         :: 0;
    Keyboard     :: 1 << 0;
    PadDPad      :: 1 << 1;
    PadLStick    :: 1 << 2;
}

NavForward :: enum s32 {
    None             :: 0;
    ForwardQueued    :: 1;
    ForwardActive    :: 2;
}

NavHighlightFlags :: enum_flags s32 {
    None           :: 0;
    TypeDefault    :: 1 << 0;
    TypeThin       :: 1 << 1;
    AlwaysDraw     :: 1 << 2;
    NoRounding     :: 1 << 3;
}

NavInput :: enum s32 {
    Activate          :: 0;
    Cancel            :: 1;
    Input             :: 2;
    Menu              :: 3;
    DpadLeft          :: 4;
    DpadRight         :: 5;
    DpadUp            :: 6;
    DpadDown          :: 7;
    LStickLeft        :: 8;
    LStickRight       :: 9;
    LStickUp          :: 10;
    LStickDown        :: 11;
    FocusPrev         :: 12;
    FocusNext         :: 13;
    TweakSlow         :: 14;
    TweakFast         :: 15;
    KeyMenu_          :: 16;
    KeyLeft_          :: 17;
    KeyRight_         :: 18;
    KeyUp_            :: 19;
    KeyDown_          :: 20;
    COUNT             :: 21;
    InternalStart_    :: NavInput.KeyMenu_;
}

NavLayer :: enum s32 {
    Main     :: 0;
    Menu     :: 1;
    COUNT    :: 2;
}

NavMoveFlags :: enum_flags s32 {
    None                   :: 0;
    LoopX                  :: 1 << 0;
    LoopY                  :: 1 << 1;
    WrapX                  :: 1 << 2;
    WrapY                  :: 1 << 3;
    AllowCurrentNavId      :: 1 << 4;
    AlsoScoreVisibleSet    :: 1 << 5;
    ScrollToEdge           :: 1 << 6;
}

NextItemDataFlags :: enum_flags s32 {
    None        :: 0;
    HasWidth    :: 1 << 0;
    HasOpen     :: 1 << 1;
}

NextWindowDataFlags :: enum_flags s32 {
    None                 :: 0;
    HasPos               :: 1 << 0;
    HasSize              :: 1 << 1;
    HasContentSize       :: 1 << 2;
    HasCollapsed         :: 1 << 3;
    HasSizeConstraint    :: 1 << 4;
    HasFocus             :: 1 << 5;
    HasBgAlpha           :: 1 << 6;
    HasScroll            :: 1 << 7;
    HasViewport          :: 1 << 8;
    HasDock              :: 1 << 9;
    HasWindowClass       :: 1 << 10;
}

PlotType :: enum s32 {
    Lines        :: 0;
    Histogram    :: 1;
}

PopupFlags :: enum_flags s32 {
    None                       :: 0;
    MouseButtonLeft            :: 0;
    MouseButtonRight           :: 1;
    MouseButtonMiddle          :: 2;
    MouseButtonMask_           :: 0x1F;
    MouseButtonDefault_        :: 1;
    NoOpenOverExistingPopup    :: 1 << 5;
    NoOpenOverItems            :: 1 << 6;
    AnyPopupId                 :: 1 << 7;
    AnyPopupLevel              :: 1 << 8;
    AnyPopup                   :: PopupFlags.AnyPopupId | PopupFlags.AnyPopupLevel;
}

PopupPositionPolicy :: enum s32 {
    Default     :: 0;
    ComboBox    :: 1;
}

SelectableFlags :: enum_flags s32 {
    None                :: 0;
    DontClosePopups     :: 1 << 0;
    SpanAllColumns      :: 1 << 1;
    AllowDoubleClick    :: 1 << 2;
    Disabled            :: 1 << 3;
    AllowItemOverlap    :: 1 << 4;
}

SeparatorFlags :: enum_flags s32 {
    None              :: 0;
    Horizontal        :: 1 << 0;
    Vertical          :: 1 << 1;
    SpanAllColumns    :: 1 << 2;
}

SliderFlags :: enum_flags s32 {
    None               :: 0;
    ClampOnInput       :: 1 << 4;
    Logarithmic        :: 1 << 5;
    NoRoundToFormat    :: 1 << 6;
    NoInput            :: 1 << 7;
    InvalidMask_       :: 0x7000000F;
}

StyleVar :: enum s32 {
    Alpha                  :: 0;
    WindowPadding          :: 1;
    WindowRounding         :: 2;
    WindowBorderSize       :: 3;
    WindowMinSize          :: 4;
    WindowTitleAlign       :: 5;
    ChildRounding          :: 6;
    ChildBorderSize        :: 7;
    PopupRounding          :: 8;
    PopupBorderSize        :: 9;
    FramePadding           :: 10;
    FrameRounding          :: 11;
    FrameBorderSize        :: 12;
    ItemSpacing            :: 13;
    ItemInnerSpacing       :: 14;
    IndentSpacing          :: 15;
    ScrollbarSize          :: 16;
    ScrollbarRounding      :: 17;
    GrabMinSize            :: 18;
    GrabRounding           :: 19;
    TabRounding            :: 20;
    ButtonTextAlign        :: 21;
    SelectableTextAlign    :: 22;
    COUNT                  :: 23;
}

TabBarFlags :: enum_flags s32 {
    None                            :: 0;
    Reorderable                     :: 1 << 0;
    AutoSelectNewTabs               :: 1 << 1;
    TabListPopupButton              :: 1 << 2;
    NoCloseWithMiddleMouseButton    :: 1 << 3;
    NoTabListScrollingButtons       :: 1 << 4;
    NoTooltip                       :: 1 << 5;
    FittingPolicyResizeDown         :: 1 << 6;
    FittingPolicyScroll             :: 1 << 7;
    FittingPolicyMask_              :: TabBarFlags.FittingPolicyResizeDown | TabBarFlags.FittingPolicyScroll;
    FittingPolicyDefault_           :: TabBarFlags.FittingPolicyResizeDown;
}

TabItemFlags :: enum_flags s32 {
    None                            :: 0;
    UnsavedDocument                 :: 1 << 0;
    SetSelected                     :: 1 << 1;
    NoCloseWithMiddleMouseButton    :: 1 << 2;
    NoPushId                        :: 1 << 3;
    NoTooltip                       :: 1 << 4;
}

TextFlags :: enum_flags s32 {
    None                          :: 0;
    NoWidthForLargeClippedText    :: 1 << 0;
}

TooltipFlags :: enum_flags s32 {
    None                       :: 0;
    OverridePreviousTooltip    :: 1 << 0;
}

TreeNodeFlags :: enum_flags s32 {
    None                    :: 0;
    Selected                :: 1 << 0;
    Framed                  :: 1 << 1;
    AllowItemOverlap        :: 1 << 2;
    NoTreePushOnOpen        :: 1 << 3;
    NoAutoOpenOnLog         :: 1 << 4;
    DefaultOpen             :: 1 << 5;
    OpenOnDoubleClick       :: 1 << 6;
    OpenOnArrow             :: 1 << 7;
    Leaf                    :: 1 << 8;
    Bullet                  :: 1 << 9;
    FramePadding            :: 1 << 10;
    SpanAvailWidth          :: 1 << 11;
    SpanFullWidth           :: 1 << 12;
    NavLeftJumpsBackHere    :: 1 << 13;
    CollapsingHeader        :: TreeNodeFlags.Framed | TreeNodeFlags.NoTreePushOnOpen | TreeNodeFlags.NoAutoOpenOnLog;
}

ViewportFlags :: enum_flags s32 {
    None                   :: 0;
    NoDecoration           :: 1 << 0;
    NoTaskBarIcon          :: 1 << 1;
    NoFocusOnAppearing     :: 1 << 2;
    NoFocusOnClick         :: 1 << 3;
    NoInputs               :: 1 << 4;
    NoRendererClear        :: 1 << 5;
    TopMost                :: 1 << 6;
    Minimized              :: 1 << 7;
    NoAutoMerge            :: 1 << 8;
    CanHostOtherWindows    :: 1 << 9;
}

WindowFlags :: enum_flags s32 {
    None                         :: 0;
    NoTitleBar                   :: 1 << 0;
    NoResize                     :: 1 << 1;
    NoMove                       :: 1 << 2;
    NoScrollbar                  :: 1 << 3;
    NoScrollWithMouse            :: 1 << 4;
    NoCollapse                   :: 1 << 5;
    AlwaysAutoResize             :: 1 << 6;
    NoBackground                 :: 1 << 7;
    NoSavedSettings              :: 1 << 8;
    NoMouseInputs                :: 1 << 9;
    MenuBar                      :: 1 << 10;
    HorizontalScrollbar          :: 1 << 11;
    NoFocusOnAppearing           :: 1 << 12;
    NoBringToFrontOnFocus        :: 1 << 13;
    AlwaysVerticalScrollbar      :: 1 << 14;
    AlwaysHorizontalScrollbar    :: 1<< 15;
    AlwaysUseWindowPadding       :: 1 << 16;
    NoNavInputs                  :: 1 << 18;
    NoNavFocus                   :: 1 << 19;
    UnsavedDocument              :: 1 << 20;
    NoDocking                    :: 1 << 21;
    NoNav                        :: WindowFlags.NoNavInputs | WindowFlags.NoNavFocus;
    NoDecoration                 :: WindowFlags.NoTitleBar | WindowFlags.NoResize | WindowFlags.NoScrollbar | WindowFlags.NoCollapse;
    NoInputs                     :: WindowFlags.NoMouseInputs | WindowFlags.NoNavInputs | WindowFlags.NoNavFocus;
    NavFlattened                 :: 1 << 23;
    ChildWindow                  :: 1 << 24;
    Tooltip                      :: 1 << 25;
    Popup                        :: 1 << 26;
    Modal                        :: 1 << 27;
    ChildMenu                    :: 1 << 28;
    DockNodeHost                 :: 1 << 29;
}


//
// section: FUNCTIONS
//

AcceptDragDropPayload          :: (type: *u8, flags: DragDropFlags = .None) -> *Payload #foreign imgui_lib "?AcceptDragDropPayload@ImGui@@YAPEBUImGuiPayload@@PEBDH@Z";
AlignTextToFramePadding        :: () #foreign imgui_lib "?AlignTextToFramePadding@ImGui@@YAXXZ";
ArrowButton                    :: (str_id: *u8, dir: Dir) -> bool #foreign imgui_lib "?ArrowButton@ImGui@@YA_NPEBDH@Z";
Begin                          :: (name: *u8, p_open: *bool = null, flags: WindowFlags = .None) -> bool #foreign imgui_lib "?Begin@ImGui@@YA_NPEBDPEA_NH@Z";
BeginChild                     :: (str_id: *u8, size: ImVec2 = ImVec2.{0,0}, border: bool = false, flags: WindowFlags = .None) -> bool {
    _internal_BeginChild :: (str_id: *u8, size: *ImVec2, border: bool, flags: WindowFlags) -> bool #foreign imgui_lib "?BeginChild@ImGui@@YA_NPEBDAEBUImVec2@@_NH@Z";
    return _internal_BeginChild(str_id, *size, border, flags);
            }
BeginChild                     :: (id: ID, size: ImVec2 = ImVec2.{0,0}, border: bool = false, flags: WindowFlags = .None) -> bool {
    _internal_BeginChild :: (id: ID, size: *ImVec2, border: bool, flags: WindowFlags) -> bool #foreign imgui_lib "?BeginChild@ImGui@@YA_NIAEBUImVec2@@_NH@Z";
    return _internal_BeginChild(id, *size, border, flags);
            }
BeginChildFrame                :: (id: ID, size: ImVec2, flags: WindowFlags = .None) -> bool {
    _internal_BeginChildFrame :: (id: ID, size: *ImVec2, flags: WindowFlags) -> bool #foreign imgui_lib "?BeginChildFrame@ImGui@@YA_NIAEBUImVec2@@H@Z";
    return _internal_BeginChildFrame(id, *size, flags);
            }
BeginCombo                     :: (label: *u8, preview_value: *u8, flags: ComboFlags = .None) -> bool #foreign imgui_lib "?BeginCombo@ImGui@@YA_NPEBD0H@Z";
BeginDragDropSource            :: (flags: DragDropFlags = .None) -> bool #foreign imgui_lib "?BeginDragDropSource@ImGui@@YA_NH@Z";
BeginDragDropTarget            :: () -> bool #foreign imgui_lib "?BeginDragDropTarget@ImGui@@YA_NXZ";
BeginGroup                     :: () #foreign imgui_lib "?BeginGroup@ImGui@@YAXXZ";
BeginMainMenuBar               :: () -> bool #foreign imgui_lib "?BeginMainMenuBar@ImGui@@YA_NXZ";
BeginMenu                      :: (label: *u8, enabled: bool = true) -> bool #foreign imgui_lib "?BeginMenu@ImGui@@YA_NPEBD_N@Z";
BeginMenuBar                   :: () -> bool #foreign imgui_lib "?BeginMenuBar@ImGui@@YA_NXZ";
BeginPopup                     :: (str_id: *u8, flags: WindowFlags = .None) -> bool #foreign imgui_lib "?BeginPopup@ImGui@@YA_NPEBDH@Z";
BeginPopupContextItem          :: (str_id: string = "", popup_flags: PopupFlags = .MouseButtonRight) -> bool {
    _internal_BeginPopupContextItem :: (str_id: *u8, popup_flags: PopupFlags) -> bool #foreign imgui_lib "?BeginPopupContextItem@ImGui@@YA_NPEBDH@Z";
    return _internal_BeginPopupContextItem(str_id.data, popup_flags);
            }
BeginPopupContextVoid          :: (str_id: string = "", popup_flags: PopupFlags = .MouseButtonRight) -> bool {
    _internal_BeginPopupContextVoid :: (str_id: *u8, popup_flags: PopupFlags) -> bool #foreign imgui_lib "?BeginPopupContextVoid@ImGui@@YA_NPEBDH@Z";
    return _internal_BeginPopupContextVoid(str_id.data, popup_flags);
            }
BeginPopupContextWindow        :: (str_id: string = "", popup_flags: PopupFlags = .MouseButtonRight) -> bool {
    _internal_BeginPopupContextWindow :: (str_id: *u8, popup_flags: PopupFlags) -> bool #foreign imgui_lib "?BeginPopupContextWindow@ImGui@@YA_NPEBDH@Z";
    return _internal_BeginPopupContextWindow(str_id.data, popup_flags);
            }
BeginPopupModal                :: (name: *u8, p_open: *bool = null, flags: WindowFlags = .None) -> bool #foreign imgui_lib "?BeginPopupModal@ImGui@@YA_NPEBDPEA_NH@Z";
BeginTabBar                    :: (str_id: *u8, flags: TabBarFlags = .None) -> bool #foreign imgui_lib "?BeginTabBar@ImGui@@YA_NPEBDH@Z";
BeginTabItem                   :: (label: *u8, p_open: *bool = null, flags: TabItemFlags = .None) -> bool #foreign imgui_lib "?BeginTabItem@ImGui@@YA_NPEBDPEA_NH@Z";
BeginTooltip                   :: () #foreign imgui_lib "?BeginTooltip@ImGui@@YAXXZ";
Bullet                         :: () #foreign imgui_lib "?Bullet@ImGui@@YAXXZ";
BulletText                     :: (fmt: *u8, args: ..Any) #foreign imgui_lib "?BulletText@ImGui@@YAXPEBDZZ";
Button                         :: (label: *u8, size: ImVec2 = ImVec2.{0,0}) -> bool {
    _internal_Button :: (label: *u8, size: *ImVec2) -> bool #foreign imgui_lib "?Button@ImGui@@YA_NPEBDAEBUImVec2@@@Z";
    return _internal_Button(label, *size);
            }
CalcItemWidth                  :: () -> float #foreign imgui_lib "?CalcItemWidth@ImGui@@YAMXZ";
CalcListClipping               :: (items_count: s32, items_height: float, out_items_display_start: *s32, out_items_display_end: *s32) #foreign imgui_lib "?CalcListClipping@ImGui@@YAXHMPEAH0@Z";
CaptureKeyboardFromApp         :: (want_capture_keyboard_value: bool = true) #foreign imgui_lib "?CaptureKeyboardFromApp@ImGui@@YAX_N@Z";
CaptureMouseFromApp            :: (want_capture_mouse_value: bool = true) #foreign imgui_lib "?CaptureMouseFromApp@ImGui@@YAX_N@Z";
Checkbox                       :: (label: *u8, v: *bool) -> bool #foreign imgui_lib "?Checkbox@ImGui@@YA_NPEBDPEA_N@Z";
CheckboxFlags                  :: (label: *u8, flags: *u32, flags_value: u32) -> bool #foreign imgui_lib "?CheckboxFlags@ImGui@@YA_NPEBDPEAII@Z";
CloseCurrentPopup              :: () #foreign imgui_lib "?CloseCurrentPopup@ImGui@@YAXXZ";
CollapsingHeader               :: (label: *u8, flags: TreeNodeFlags = .None) -> bool #foreign imgui_lib "?CollapsingHeader@ImGui@@YA_NPEBDH@Z";
CollapsingHeader               :: (label: *u8, p_open: *bool, flags: TreeNodeFlags = .None) -> bool #foreign imgui_lib "?CollapsingHeader@ImGui@@YA_NPEBDPEA_NH@Z";
ColorButton                    :: (desc_id: *u8, col: ImVec4, flags: ColorEditFlags = .None, size: ImVec2 = ImVec2.{0,0}) -> bool {
    _internal_ColorButton :: (desc_id: *u8, col: *ImVec4, flags: ColorEditFlags, size: ImVec2) -> bool #foreign imgui_lib "?ColorButton@ImGui@@YA_NPEBDAEBUImVec4@@HUImVec2@@@Z";
    return _internal_ColorButton(desc_id, *col, flags, size);
            }
ColorConvertFloat4ToU32        :: (in: ImVec4) -> u32 {
    _internal_ColorConvertFloat4ToU32 :: (in: *ImVec4) -> u32 #foreign imgui_lib "?ColorConvertFloat4ToU32@ImGui@@YAIAEBUImVec4@@@Z";
    return _internal_ColorConvertFloat4ToU32(*in);
            }
ColorConvertHSVtoRGB           :: (h: float, s: float, v: float, out_r: *float, out_g: *float, out_b: *float) #foreign imgui_lib "?ColorConvertHSVtoRGB@ImGui@@YAXMMMAEAM00@Z";
ColorConvertRGBtoHSV           :: (r: float, g: float, b: float, out_h: *float, out_s: *float, out_v: *float) #foreign imgui_lib "?ColorConvertRGBtoHSV@ImGui@@YAXMMMAEAM00@Z";
ColorEdit3                     :: (label: *u8, col: [3]float, flags: ColorEditFlags = .None) -> bool #foreign imgui_lib "?ColorEdit3@ImGui@@YA_NPEBDQEAMH@Z";
ColorEdit4                     :: (label: *u8, col: [4]float, flags: ColorEditFlags = .None) -> bool #foreign imgui_lib "?ColorEdit4@ImGui@@YA_NPEBDQEAMH@Z";
ColorPicker3                   :: (label: *u8, col: [3]float, flags: ColorEditFlags = .None) -> bool #foreign imgui_lib "?ColorPicker3@ImGui@@YA_NPEBDQEAMH@Z";
ColorPicker4                   :: (label: *u8, col: [4]float, flags: ColorEditFlags = .None, ref_col: *float = null) -> bool #foreign imgui_lib "?ColorPicker4@ImGui@@YA_NPEBDQEAMHPEBM@Z";
Columns                        :: (count: s32 = 1, id: string = "", border: bool = true) {
    _internal_Columns :: (count: s32, id: *u8, border: bool) #foreign imgui_lib "?Columns@ImGui@@YAXHPEBD_N@Z";
    _internal_Columns(count, id.data, border);
            }
Combo                          :: (label: *u8, current_item: *s32, items: *[]u8, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui_lib "?Combo@ImGui@@YA_NPEBDPEAHQEBQEBDHH@Z";
Combo                          :: (label: *u8, current_item: *s32, items_separated_by_zeros: *u8, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui_lib "?Combo@ImGui@@YA_NPEBDPEAH0H@Z";
Combo                          :: (label: *u8, current_item: *s32, items_getter: (data: *void, idx: s32, out_text: **u8) -> bool #c_call, data: *void, items_count: s32, popup_max_height_in_items: s32 = -1) -> bool #foreign imgui_lib "?Combo@ImGui@@YA_NPEBDPEAHP6A_NPEAXHPEAPEBD@Z2HH@Z";
CreateContext                  :: (shared_font_atlas: *ImFontAtlas = null) -> *Context #foreign imgui_lib "?CreateContext@ImGui@@YAPEAUImGuiContext@@PEAUImFontAtlas@@@Z";
DebugCheckVersionAndDataLayout :: (version_str: *u8, sz_io: u64, sz_style: u64, sz_vec2: u64, sz_vec4: u64, sz_drawvert: u64, sz_drawidx: u64) -> bool #foreign imgui_lib "?DebugCheckVersionAndDataLayout@ImGui@@YA_NPEBD_K11111@Z";
DestroyContext                 :: (ctx: *Context = null) #foreign imgui_lib "?DestroyContext@ImGui@@YAXPEAUImGuiContext@@@Z";
DestroyPlatformWindows         :: () #foreign imgui_lib "?DestroyPlatformWindows@ImGui@@YAXXZ";
DockSpace                      :: (id: ID, size: ImVec2 = ImVec2.{0,0}, flags: DockNodeFlags = .None, window_class: *WindowClass = null) {
    _internal_DockSpace :: (id: ID, size: *ImVec2, flags: DockNodeFlags, window_class: *WindowClass) #foreign imgui_lib "?DockSpace@ImGui@@YAXIAEBUImVec2@@HPEBUImGuiWindowClass@@@Z";
    _internal_DockSpace(id, *size, flags, window_class);
            }
DockSpaceOverViewport          :: (viewport: *Viewport = null, flags: DockNodeFlags = .None, window_class: *WindowClass = null) -> ID #foreign imgui_lib "?DockSpaceOverViewport@ImGui@@YAIPEAUImGuiViewport@@HPEBUImGuiWindowClass@@@Z";
DragFloat                      :: (label: *u8, v: *float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_DragFloat :: (label: *u8, v: *float, v_speed: float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragFloat@ImGui@@YA_NPEBDPEAMMMM0H@Z";
    return _internal_DragFloat(label, v, v_speed, v_min, v_max, format.data, flags);
            }
DragFloat2                     :: (label: *u8, v: [2]float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_DragFloat2 :: (label: *u8, v: *float, v_speed: float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragFloat2@ImGui@@YA_NPEBDQEAMMMM0H@Z";
    return _internal_DragFloat2(label, v.data, v_speed, v_min, v_max, format.data, flags);
            }
DragFloat3                     :: (label: *u8, v: [3]float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_DragFloat3 :: (label: *u8, v: *float, v_speed: float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragFloat3@ImGui@@YA_NPEBDQEAMMMM0H@Z";
    return _internal_DragFloat3(label, v.data, v_speed, v_min, v_max, format.data, flags);
            }
DragFloat4                     :: (label: *u8, v: [4]float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_DragFloat4 :: (label: *u8, v: *float, v_speed: float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragFloat4@ImGui@@YA_NPEBDQEAMMMM0H@Z";
    return _internal_DragFloat4(label, v.data, v_speed, v_min, v_max, format.data, flags);
            }
DragFloatRange2                :: (label: *u8, v_current_min: *float, v_current_max: *float, v_speed: float = 1.0, v_min: float = 0.0, v_max: float = 0.0, format: string = "%.3f", format_max: string = "", flags: SliderFlags = .None) -> bool {
    _internal_DragFloatRange2 :: (label: *u8, v_current_min: *float, v_current_max: *float, v_speed: float, v_min: float, v_max: float, format: *u8, format_max: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragFloatRange2@ImGui@@YA_NPEBDPEAM1MMM00H@Z";
    return _internal_DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format.data, format_max.data, flags);
            }
DragInt                        :: (label: *u8, v: *s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_DragInt :: (label: *u8, v: *s32, v_speed: float, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragInt@ImGui@@YA_NPEBDPEAHMHH0H@Z";
    return _internal_DragInt(label, v, v_speed, v_min, v_max, format.data, flags);
            }
DragInt2                       :: (label: *u8, v: [2]s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_DragInt2 :: (label: *u8, v: *s32, v_speed: float, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragInt2@ImGui@@YA_NPEBDQEAHMHH0H@Z";
    return _internal_DragInt2(label, v.data, v_speed, v_min, v_max, format.data, flags);
            }
DragInt3                       :: (label: *u8, v: [3]s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_DragInt3 :: (label: *u8, v: *s32, v_speed: float, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragInt3@ImGui@@YA_NPEBDQEAHMHH0H@Z";
    return _internal_DragInt3(label, v.data, v_speed, v_min, v_max, format.data, flags);
            }
DragInt4                       :: (label: *u8, v: [4]s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_DragInt4 :: (label: *u8, v: *s32, v_speed: float, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragInt4@ImGui@@YA_NPEBDQEAHMHH0H@Z";
    return _internal_DragInt4(label, v.data, v_speed, v_min, v_max, format.data, flags);
            }
DragIntRange2                  :: (label: *u8, v_current_min: *s32, v_current_max: *s32, v_speed: float = 1.0, v_min: s32 = 0, v_max: s32 = 0, format: string = "%d", format_max: string = "", flags: SliderFlags = .None) -> bool {
    _internal_DragIntRange2 :: (label: *u8, v_current_min: *s32, v_current_max: *s32, v_speed: float, v_min: s32, v_max: s32, format: *u8, format_max: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragIntRange2@ImGui@@YA_NPEBDPEAH1MHH00H@Z";
    return _internal_DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format.data, format_max.data, flags);
            }
DragScalar                     :: (label: *u8, data_type: DataType, p_data: *void, v_speed: float, p_min: *void = null, p_max: *void = null, format: string = "", flags: SliderFlags = .None) -> bool {
    _internal_DragScalar :: (label: *u8, data_type: DataType, p_data: *void, v_speed: float, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragScalar@ImGui@@YA_NPEBDHPEAXMPEBX20H@Z";
    return _internal_DragScalar(label, data_type, p_data, v_speed, p_min, p_max, format.data, flags);
            }
DragScalarN                    :: (label: *u8, data_type: DataType, p_data: *void, components: s32, v_speed: float, p_min: *void = null, p_max: *void = null, format: string = "", flags: SliderFlags = .None) -> bool {
    _internal_DragScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, v_speed: float, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?DragScalarN@ImGui@@YA_NPEBDHPEAXHMPEBX20H@Z";
    return _internal_DragScalarN(label, data_type, p_data, components, v_speed, p_min, p_max, format.data, flags);
            }
Dummy                          :: (size: ImVec2) {
    _internal_Dummy :: (size: *ImVec2) #foreign imgui_lib "?Dummy@ImGui@@YAXAEBUImVec2@@@Z";
    _internal_Dummy(*size);
            }
End                            :: () #foreign imgui_lib "?End@ImGui@@YAXXZ";
EndChild                       :: () #foreign imgui_lib "?EndChild@ImGui@@YAXXZ";
EndChildFrame                  :: () #foreign imgui_lib "?EndChildFrame@ImGui@@YAXXZ";
EndCombo                       :: () #foreign imgui_lib "?EndCombo@ImGui@@YAXXZ";
EndDragDropSource              :: () #foreign imgui_lib "?EndDragDropSource@ImGui@@YAXXZ";
EndDragDropTarget              :: () #foreign imgui_lib "?EndDragDropTarget@ImGui@@YAXXZ";
EndFrame                       :: () #foreign imgui_lib "?EndFrame@ImGui@@YAXXZ";
EndGroup                       :: () #foreign imgui_lib "?EndGroup@ImGui@@YAXXZ";
EndMainMenuBar                 :: () #foreign imgui_lib "?EndMainMenuBar@ImGui@@YAXXZ";
EndMenu                        :: () #foreign imgui_lib "?EndMenu@ImGui@@YAXXZ";
EndMenuBar                     :: () #foreign imgui_lib "?EndMenuBar@ImGui@@YAXXZ";
EndPopup                       :: () #foreign imgui_lib "?EndPopup@ImGui@@YAXXZ";
EndTabBar                      :: () #foreign imgui_lib "?EndTabBar@ImGui@@YAXXZ";
EndTabItem                     :: () #foreign imgui_lib "?EndTabItem@ImGui@@YAXXZ";
EndTooltip                     :: () #foreign imgui_lib "?EndTooltip@ImGui@@YAXXZ";
FindViewportByID               :: (id: ID) -> *Viewport #foreign imgui_lib "?FindViewportByID@ImGui@@YAPEAUImGuiViewport@@I@Z";
FindViewportByPlatformHandle   :: (platform_handle: *void) -> *Viewport #foreign imgui_lib "?FindViewportByPlatformHandle@ImGui@@YAPEAUImGuiViewport@@PEAX@Z";
GetBackgroundDrawList          :: () -> *ImDrawList #foreign imgui_lib "?GetBackgroundDrawList@ImGui@@YAPEAUImDrawList@@XZ";
GetBackgroundDrawList          :: (viewport: *Viewport) -> *ImDrawList #foreign imgui_lib "?GetBackgroundDrawList@ImGui@@YAPEAUImDrawList@@PEAUImGuiViewport@@@Z";
GetClipboardText               :: () -> *u8 #foreign imgui_lib "?GetClipboardText@ImGui@@YAPEBDXZ";
GetColorU32                    :: (idx: Col, alpha_mul: float = 1.0) -> u32 #foreign imgui_lib "?GetColorU32@ImGui@@YAIHM@Z";
GetColorU32                    :: (col: ImVec4) -> u32 {
    _internal_GetColorU32 :: (col: *ImVec4) -> u32 #foreign imgui_lib "?GetColorU32@ImGui@@YAIAEBUImVec4@@@Z";
    return _internal_GetColorU32(*col);
            }
GetColorU32                    :: (col: u32) -> u32 #foreign imgui_lib "?GetColorU32@ImGui@@YAII@Z";
GetColumnIndex                 :: () -> s32 #foreign imgui_lib "?GetColumnIndex@ImGui@@YAHXZ";
GetColumnOffset                :: (column_index: s32 = -1) -> float #foreign imgui_lib "?GetColumnOffset@ImGui@@YAMH@Z";
GetColumnWidth                 :: (column_index: s32 = -1) -> float #foreign imgui_lib "?GetColumnWidth@ImGui@@YAMH@Z";
GetColumnsCount                :: () -> s32 #foreign imgui_lib "?GetColumnsCount@ImGui@@YAHXZ";
GetContentRegionMax            :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui_lib "?GetContentRegionMax@ImGui@@YA?AUImVec2@@XZ";
GetCurrentContext              :: () -> *Context #foreign imgui_lib "?GetCurrentContext@ImGui@@YAPEAUImGuiContext@@XZ";
GetCursorPos                   :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui_lib "?GetCursorPos@ImGui@@YA?AUImVec2@@XZ";
GetCursorPosX                  :: () -> float #foreign imgui_lib "?GetCursorPosX@ImGui@@YAMXZ";
GetCursorPosY                  :: () -> float #foreign imgui_lib "?GetCursorPosY@ImGui@@YAMXZ";
GetDragDropPayload             :: () -> *Payload #foreign imgui_lib "?GetDragDropPayload@ImGui@@YAPEBUImGuiPayload@@XZ";
GetDrawData                    :: () -> *ImDrawData #foreign imgui_lib "?GetDrawData@ImGui@@YAPEAUImDrawData@@XZ";
GetDrawListSharedData          :: () -> *ImDrawListSharedData #foreign imgui_lib "?GetDrawListSharedData@ImGui@@YAPEAUImDrawListSharedData@@XZ";
GetFont                        :: () -> *ImFont #foreign imgui_lib "?GetFont@ImGui@@YAPEAUImFont@@XZ";
GetFontSize                    :: () -> float #foreign imgui_lib "?GetFontSize@ImGui@@YAMXZ";
GetForegroundDrawList          :: () -> *ImDrawList #foreign imgui_lib "?GetForegroundDrawList@ImGui@@YAPEAUImDrawList@@XZ";
GetForegroundDrawList          :: (viewport: *Viewport) -> *ImDrawList #foreign imgui_lib "?GetForegroundDrawList@ImGui@@YAPEAUImDrawList@@PEAUImGuiViewport@@@Z";
GetFrameCount                  :: () -> s32 #foreign imgui_lib "?GetFrameCount@ImGui@@YAHXZ";
GetFrameHeight                 :: () -> float #foreign imgui_lib "?GetFrameHeight@ImGui@@YAMXZ";
GetFrameHeightWithSpacing      :: () -> float #foreign imgui_lib "?GetFrameHeightWithSpacing@ImGui@@YAMXZ";
GetID                          :: (str_id: *u8) -> ID #foreign imgui_lib "?GetID@ImGui@@YAIPEBD@Z";
GetID                          :: (str_id_begin: *u8, str_id_end: *u8) -> ID #foreign imgui_lib "?GetID@ImGui@@YAIPEBD0@Z";
GetID                          :: (ptr_id: *void) -> ID #foreign imgui_lib "?GetID@ImGui@@YAIPEBX@Z";
GetIO                          :: () -> *IO #foreign imgui_lib "?GetIO@ImGui@@YAAEAUImGuiIO@@XZ";
GetKeyIndex                    :: (imgui_key: Key) -> s32 #foreign imgui_lib "?GetKeyIndex@ImGui@@YAHH@Z";
GetKeyPressedAmount            :: (key_index: s32, repeat_delay: float, rate: float) -> s32 #foreign imgui_lib "?GetKeyPressedAmount@ImGui@@YAHHMM@Z";
GetMainViewport                :: () -> *Viewport #foreign imgui_lib "?GetMainViewport@ImGui@@YAPEAUImGuiViewport@@XZ";
GetMouseCursor                 :: () -> MouseCursor #foreign imgui_lib "?GetMouseCursor@ImGui@@YAHXZ";
GetPlatformIO                  :: () -> *PlatformIO #foreign imgui_lib "?GetPlatformIO@ImGui@@YAAEAUImGuiPlatformIO@@XZ";
GetScrollMaxX                  :: () -> float #foreign imgui_lib "?GetScrollMaxX@ImGui@@YAMXZ";
GetScrollMaxY                  :: () -> float #foreign imgui_lib "?GetScrollMaxY@ImGui@@YAMXZ";
GetScrollX                     :: () -> float #foreign imgui_lib "?GetScrollX@ImGui@@YAMXZ";
GetScrollY                     :: () -> float #foreign imgui_lib "?GetScrollY@ImGui@@YAMXZ";
GetStateStorage                :: () -> *Storage #foreign imgui_lib "?GetStateStorage@ImGui@@YAPEAUImGuiStorage@@XZ";
GetStyle                       :: () -> *Style #foreign imgui_lib "?GetStyle@ImGui@@YAAEAUImGuiStyle@@XZ";
GetStyleColorName              :: (idx: Col) -> *u8 #foreign imgui_lib "?GetStyleColorName@ImGui@@YAPEBDH@Z";
GetStyleColorVec4              :: (idx: Col) -> *ImVec4 #foreign imgui_lib "?GetStyleColorVec4@ImGui@@YAAEBUImVec4@@H@Z";
GetTextLineHeight              :: () -> float #foreign imgui_lib "?GetTextLineHeight@ImGui@@YAMXZ";
GetTextLineHeightWithSpacing   :: () -> float #foreign imgui_lib "?GetTextLineHeightWithSpacing@ImGui@@YAMXZ";
GetTime                        :: () -> float64 #foreign imgui_lib "?GetTime@ImGui@@YANXZ";
GetTreeNodeToLabelSpacing      :: () -> float #foreign imgui_lib "?GetTreeNodeToLabelSpacing@ImGui@@YAMXZ";
GetVersion                     :: () -> *u8 #foreign imgui_lib "?GetVersion@ImGui@@YAPEBDXZ";
GetWindowContentRegionWidth    :: () -> float #foreign imgui_lib "?GetWindowContentRegionWidth@ImGui@@YAMXZ";
GetWindowDockID                :: () -> ID #foreign imgui_lib "?GetWindowDockID@ImGui@@YAIXZ";
GetWindowDpiScale              :: () -> float #foreign imgui_lib "?GetWindowDpiScale@ImGui@@YAMXZ";
GetWindowDrawList              :: () -> *ImDrawList #foreign imgui_lib "?GetWindowDrawList@ImGui@@YAPEAUImDrawList@@XZ";
GetWindowHeight                :: () -> float #foreign imgui_lib "?GetWindowHeight@ImGui@@YAMXZ";
GetWindowPos                   :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui_lib "?GetWindowPos@ImGui@@YA?AUImVec2@@XZ";
GetWindowSize                  :: () -> ImVec2 #cpp_return_type_is_non_pod #foreign imgui_lib "?GetWindowSize@ImGui@@YA?AUImVec2@@XZ";
GetWindowViewport              :: () -> *Viewport #foreign imgui_lib "?GetWindowViewport@ImGui@@YAPEAUImGuiViewport@@XZ";
GetWindowWidth                 :: () -> float #foreign imgui_lib "?GetWindowWidth@ImGui@@YAMXZ";
Image                          :: (user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2.{0,0}, uv1: ImVec2 = ImVec2.{1,1}, tint_col: ImVec4 = ImVec4.{1,1,1,1}, border_col: ImVec4 = ImVec4.{0,0,0,0}) {
    _internal_Image :: (user_texture_id: ImTextureID, size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, tint_col: *ImVec4, border_col: *ImVec4) #foreign imgui_lib "?Image@ImGui@@YAXPEAXAEBUImVec2@@11AEBUImVec4@@2@Z";
    _internal_Image(user_texture_id, *size, *uv0, *uv1, *tint_col, *border_col);
            }
ImageButton                    :: (user_texture_id: ImTextureID, size: ImVec2, uv0: ImVec2 = ImVec2.{0,0}, uv1: ImVec2 = ImVec2.{1,1}, frame_padding: s32 = -1, bg_col: ImVec4 = ImVec4.{0,0,0,0}, tint_col: ImVec4 = ImVec4.{1,1,1,1}) -> bool {
    _internal_ImageButton :: (user_texture_id: ImTextureID, size: *ImVec2, uv0: *ImVec2, uv1: *ImVec2, frame_padding: s32, bg_col: *ImVec4, tint_col: *ImVec4) -> bool #foreign imgui_lib "?ImageButton@ImGui@@YA_NPEAXAEBUImVec2@@11HAEBUImVec4@@2@Z";
    return _internal_ImageButton(user_texture_id, *size, *uv0, *uv1, frame_padding, *bg_col, *tint_col);
            }
Indent                         :: (indent_w: float = 0.0) #foreign imgui_lib "?Indent@ImGui@@YAXM@Z";
InputDouble                    :: (label: *u8, v: *float64, step: float64 = 0, step_fast: float64 = 0, format: string = "%.6f", flags: InputTextFlags = .None) -> bool {
    _internal_InputDouble :: (label: *u8, v: *float64, step: float64, step_fast: float64, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputDouble@ImGui@@YA_NPEBDPEANNN0H@Z";
    return _internal_InputDouble(label, v, step, step_fast, format.data, flags);
            }
InputFloat                     :: (label: *u8, v: *float, step: float = 0.0, step_fast: float = 0.0, format: string = "%.3f", flags: InputTextFlags = .None) -> bool {
    _internal_InputFloat :: (label: *u8, v: *float, step: float, step_fast: float, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputFloat@ImGui@@YA_NPEBDPEAMMM0H@Z";
    return _internal_InputFloat(label, v, step, step_fast, format.data, flags);
            }
InputFloat2                    :: (label: *u8, v: [2]float, format: string = "%.3f", flags: InputTextFlags = .None) -> bool {
    _internal_InputFloat2 :: (label: *u8, v: *float, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputFloat2@ImGui@@YA_NPEBDQEAM0H@Z";
    return _internal_InputFloat2(label, v.data, format.data, flags);
            }
InputFloat3                    :: (label: *u8, v: [3]float, format: string = "%.3f", flags: InputTextFlags = .None) -> bool {
    _internal_InputFloat3 :: (label: *u8, v: *float, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputFloat3@ImGui@@YA_NPEBDQEAM0H@Z";
    return _internal_InputFloat3(label, v.data, format.data, flags);
            }
InputFloat4                    :: (label: *u8, v: [4]float, format: string = "%.3f", flags: InputTextFlags = .None) -> bool {
    _internal_InputFloat4 :: (label: *u8, v: *float, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputFloat4@ImGui@@YA_NPEBDQEAM0H@Z";
    return _internal_InputFloat4(label, v.data, format.data, flags);
            }
InputInt                       :: (label: *u8, v: *s32, step: s32 = 1, step_fast: s32 = 100, flags: InputTextFlags = .None) -> bool #foreign imgui_lib "?InputInt@ImGui@@YA_NPEBDPEAHHHH@Z";
InputInt2                      :: (label: *u8, v: [2]s32, flags: InputTextFlags = .None) -> bool #foreign imgui_lib "?InputInt2@ImGui@@YA_NPEBDQEAHH@Z";
InputInt3                      :: (label: *u8, v: [3]s32, flags: InputTextFlags = .None) -> bool #foreign imgui_lib "?InputInt3@ImGui@@YA_NPEBDQEAHH@Z";
InputInt4                      :: (label: *u8, v: [4]s32, flags: InputTextFlags = .None) -> bool #foreign imgui_lib "?InputInt4@ImGui@@YA_NPEBDQEAHH@Z";
InputScalar                    :: (label: *u8, data_type: DataType, p_data: *void, p_step: *void = null, p_step_fast: *void = null, format: string = "", flags: InputTextFlags = .None) -> bool {
    _internal_InputScalar :: (label: *u8, data_type: DataType, p_data: *void, p_step: *void, p_step_fast: *void, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputScalar@ImGui@@YA_NPEBDHPEAXPEBX20H@Z";
    return _internal_InputScalar(label, data_type, p_data, p_step, p_step_fast, format.data, flags);
            }
InputScalarN                   :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_step: *void = null, p_step_fast: *void = null, format: string = "", flags: InputTextFlags = .None) -> bool {
    _internal_InputScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_step: *void, p_step_fast: *void, format: *u8, flags: InputTextFlags) -> bool #foreign imgui_lib "?InputScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20H@Z";
    return _internal_InputScalarN(label, data_type, p_data, components, p_step, p_step_fast, format.data, flags);
            }
InputText                      :: (label: *u8, buf: *u8, buf_size: u64, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui_lib "?InputText@ImGui@@YA_NPEBDPEAD_KHP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
InputTextMultiline             :: (label: *u8, buf: *u8, buf_size: u64, size: ImVec2 = ImVec2.{0,0}, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool {
    _internal_InputTextMultiline :: (label: *u8, buf: *u8, buf_size: u64, size: *ImVec2, flags: InputTextFlags, callback: InputTextCallback, user_data: *void) -> bool #foreign imgui_lib "?InputTextMultiline@ImGui@@YA_NPEBDPEAD_KAEBUImVec2@@HP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
    return _internal_InputTextMultiline(label, buf, buf_size, *size, flags, callback, user_data);
            }
InputTextWithHint              :: (label: *u8, hint: *u8, buf: *u8, buf_size: u64, flags: InputTextFlags = .None, callback: InputTextCallback = null, user_data: *void = null) -> bool #foreign imgui_lib "?InputTextWithHint@ImGui@@YA_NPEBD0PEAD_KHP6AHPEAUImGuiInputTextCallbackData@@@ZPEAX@Z";
InvisibleButton                :: (str_id: *u8, size: ImVec2, flags: ButtonFlags = .None) -> bool {
    _internal_InvisibleButton :: (str_id: *u8, size: *ImVec2, flags: ButtonFlags) -> bool #foreign imgui_lib "?InvisibleButton@ImGui@@YA_NPEBDAEBUImVec2@@H@Z";
    return _internal_InvisibleButton(str_id, *size, flags);
            }
IsAnyItemActive                :: () -> bool #foreign imgui_lib "?IsAnyItemActive@ImGui@@YA_NXZ";
IsAnyItemFocused               :: () -> bool #foreign imgui_lib "?IsAnyItemFocused@ImGui@@YA_NXZ";
IsAnyItemHovered               :: () -> bool #foreign imgui_lib "?IsAnyItemHovered@ImGui@@YA_NXZ";
IsAnyMouseDown                 :: () -> bool #foreign imgui_lib "?IsAnyMouseDown@ImGui@@YA_NXZ";
IsItemActivated                :: () -> bool #foreign imgui_lib "?IsItemActivated@ImGui@@YA_NXZ";
IsItemActive                   :: () -> bool #foreign imgui_lib "?IsItemActive@ImGui@@YA_NXZ";
IsItemClicked                  :: (mouse_button: MouseButton = .Left) -> bool #foreign imgui_lib "?IsItemClicked@ImGui@@YA_NH@Z";
IsItemDeactivated              :: () -> bool #foreign imgui_lib "?IsItemDeactivated@ImGui@@YA_NXZ";
IsItemDeactivatedAfterEdit     :: () -> bool #foreign imgui_lib "?IsItemDeactivatedAfterEdit@ImGui@@YA_NXZ";
IsItemEdited                   :: () -> bool #foreign imgui_lib "?IsItemEdited@ImGui@@YA_NXZ";
IsItemFocused                  :: () -> bool #foreign imgui_lib "?IsItemFocused@ImGui@@YA_NXZ";
IsItemHovered                  :: (flags: HoveredFlags = .None) -> bool #foreign imgui_lib "?IsItemHovered@ImGui@@YA_NH@Z";
IsItemToggledOpen              :: () -> bool #foreign imgui_lib "?IsItemToggledOpen@ImGui@@YA_NXZ";
IsItemVisible                  :: () -> bool #foreign imgui_lib "?IsItemVisible@ImGui@@YA_NXZ";
IsKeyDown                      :: (user_key_index: s32) -> bool #foreign imgui_lib "?IsKeyDown@ImGui@@YA_NH@Z";
IsKeyPressed                   :: (user_key_index: s32, repeat: bool = true) -> bool #foreign imgui_lib "?IsKeyPressed@ImGui@@YA_NH_N@Z";
IsKeyReleased                  :: (user_key_index: s32) -> bool #foreign imgui_lib "?IsKeyReleased@ImGui@@YA_NH@Z";
IsMouseClicked                 :: (button: MouseButton, repeat: bool = false) -> bool #foreign imgui_lib "?IsMouseClicked@ImGui@@YA_NH_N@Z";
IsMouseDoubleClicked           :: (button: MouseButton) -> bool #foreign imgui_lib "?IsMouseDoubleClicked@ImGui@@YA_NH@Z";
IsMouseDown                    :: (button: MouseButton) -> bool #foreign imgui_lib "?IsMouseDown@ImGui@@YA_NH@Z";
IsMouseDragging                :: (button: MouseButton, lock_threshold: float = 1.0) -> bool #foreign imgui_lib "?IsMouseDragging@ImGui@@YA_NHM@Z";
IsMouseHoveringRect            :: (r_min: ImVec2, r_max: ImVec2, clip: bool = true) -> bool {
    _internal_IsMouseHoveringRect :: (r_min: *ImVec2, r_max: *ImVec2, clip: bool) -> bool #foreign imgui_lib "?IsMouseHoveringRect@ImGui@@YA_NAEBUImVec2@@0_N@Z";
    return _internal_IsMouseHoveringRect(*r_min, *r_max, clip);
            }
IsMousePosValid                :: (mouse_pos: *ImVec2 = null) -> bool #foreign imgui_lib "?IsMousePosValid@ImGui@@YA_NPEBUImVec2@@@Z";
IsMouseReleased                :: (button: MouseButton) -> bool #foreign imgui_lib "?IsMouseReleased@ImGui@@YA_NH@Z";
IsPopupOpen                    :: (str_id: *u8, flags: PopupFlags = .None) -> bool #foreign imgui_lib "?IsPopupOpen@ImGui@@YA_NPEBDH@Z";
IsRectVisible                  :: (size: ImVec2) -> bool {
    _internal_IsRectVisible :: (size: *ImVec2) -> bool #foreign imgui_lib "?IsRectVisible@ImGui@@YA_NAEBUImVec2@@@Z";
    return _internal_IsRectVisible(*size);
            }
IsRectVisible                  :: (rect_min: ImVec2, rect_max: ImVec2) -> bool {
    _internal_IsRectVisible :: (rect_min: *ImVec2, rect_max: *ImVec2) -> bool #foreign imgui_lib "?IsRectVisible@ImGui@@YA_NAEBUImVec2@@0@Z";
    return _internal_IsRectVisible(*rect_min, *rect_max);
            }
IsWindowAppearing              :: () -> bool #foreign imgui_lib "?IsWindowAppearing@ImGui@@YA_NXZ";
IsWindowCollapsed              :: () -> bool #foreign imgui_lib "?IsWindowCollapsed@ImGui@@YA_NXZ";
IsWindowDocked                 :: () -> bool #foreign imgui_lib "?IsWindowDocked@ImGui@@YA_NXZ";
IsWindowFocused                :: (flags: FocusedFlags = .None) -> bool #foreign imgui_lib "?IsWindowFocused@ImGui@@YA_NH@Z";
IsWindowHovered                :: (flags: HoveredFlags = .None) -> bool #foreign imgui_lib "?IsWindowHovered@ImGui@@YA_NH@Z";
LabelText                      :: (label: *u8, fmt: *u8, args: ..Any) #foreign imgui_lib "?LabelText@ImGui@@YAXPEBD0ZZ";
ListBox                        :: (label: *u8, current_item: *s32, items: *[]u8, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui_lib "?ListBox@ImGui@@YA_NPEBDPEAHQEBQEBDHH@Z";
ListBox                        :: (label: *u8, current_item: *s32, items_getter: (data: *void, idx: s32, out_text: **u8) -> bool #c_call, data: *void, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui_lib "?ListBox@ImGui@@YA_NPEBDPEAHP6A_NPEAXHPEAPEBD@Z2HH@Z";
ListBoxFooter                  :: () #foreign imgui_lib "?ListBoxFooter@ImGui@@YAXXZ";
ListBoxHeader                  :: (label: *u8, size: ImVec2 = ImVec2.{0,0}) -> bool {
    _internal_ListBoxHeader :: (label: *u8, size: *ImVec2) -> bool #foreign imgui_lib "?ListBoxHeader@ImGui@@YA_NPEBDAEBUImVec2@@@Z";
    return _internal_ListBoxHeader(label, *size);
            }
ListBoxHeader                  :: (label: *u8, items_count: s32, height_in_items: s32 = -1) -> bool #foreign imgui_lib "?ListBoxHeader@ImGui@@YA_NPEBDHH@Z";
LoadIniSettingsFromDisk        :: (ini_filename: *u8) #foreign imgui_lib "?LoadIniSettingsFromDisk@ImGui@@YAXPEBD@Z";
LoadIniSettingsFromMemory      :: (ini_data: *u8, ini_size: u64 = 0) #foreign imgui_lib "?LoadIniSettingsFromMemory@ImGui@@YAXPEBD_K@Z";
LogButtons                     :: () #foreign imgui_lib "?LogButtons@ImGui@@YAXXZ";
LogFinish                      :: () #foreign imgui_lib "?LogFinish@ImGui@@YAXXZ";
LogText                        :: (fmt: *u8, args: ..Any) #foreign imgui_lib "?LogText@ImGui@@YAXPEBDZZ";
LogToClipboard                 :: (auto_open_depth: s32 = -1) #foreign imgui_lib "?LogToClipboard@ImGui@@YAXH@Z";
LogToFile                      :: (auto_open_depth: s32 = -1, filename: string = "") {
    _internal_LogToFile :: (auto_open_depth: s32, filename: *u8) #foreign imgui_lib "?LogToFile@ImGui@@YAXHPEBD@Z";
    _internal_LogToFile(auto_open_depth, filename.data);
            }
LogToTTY                       :: (auto_open_depth: s32 = -1) #foreign imgui_lib "?LogToTTY@ImGui@@YAXH@Z";
MemAlloc                       :: (size: u64) -> *void #foreign imgui_lib "?MemAlloc@ImGui@@YAPEAX_K@Z";
MemFree                        :: (ptr: *void) #foreign imgui_lib "?MemFree@ImGui@@YAXPEAX@Z";
MenuItem                       :: (label: *u8, shortcut: string = "", selected: bool = false, enabled: bool = true) -> bool {
    _internal_MenuItem :: (label: *u8, shortcut: *u8, selected: bool, enabled: bool) -> bool #foreign imgui_lib "?MenuItem@ImGui@@YA_NPEBD0_N1@Z";
    return _internal_MenuItem(label, shortcut.data, selected, enabled);
            }
MenuItem                       :: (label: *u8, shortcut: *u8, p_selected: *bool, enabled: bool = true) -> bool #foreign imgui_lib "?MenuItem@ImGui@@YA_NPEBD0PEA_N_N@Z";
NewFrame                       :: () #foreign imgui_lib "?NewFrame@ImGui@@YAXXZ";
NewLine                        :: () #foreign imgui_lib "?NewLine@ImGui@@YAXXZ";
NextColumn                     :: () #foreign imgui_lib "?NextColumn@ImGui@@YAXXZ";
OpenPopup                      :: (str_id: *u8, popup_flags: PopupFlags = .None) #foreign imgui_lib "?OpenPopup@ImGui@@YAXPEBDH@Z";
OpenPopupContextItem           :: (str_id: string = "", popup_flags: PopupFlags = .MouseButtonRight) -> bool {
    _internal_OpenPopupContextItem :: (str_id: *u8, popup_flags: PopupFlags) -> bool #foreign imgui_lib "?OpenPopupContextItem@ImGui@@YA_NPEBDH@Z";
    return _internal_OpenPopupContextItem(str_id.data, popup_flags);
            }
PlotHistogram                  :: (label: *u8, values: *float, values_count: s32, values_offset: s32 = 0, overlay_text: string = "", scale_min: float = 3.402823466e+38, scale_max: float = 3.402823466e+38, graph_size: ImVec2 = ImVec2.{0,0}, stride: s32 = size_of(float)) {
    _internal_PlotHistogram :: (label: *u8, values: *float, values_count: s32, values_offset: s32, overlay_text: *u8, scale_min: float, scale_max: float, graph_size: ImVec2, stride: s32) #foreign imgui_lib "?PlotHistogram@ImGui@@YAXPEBDPEBMHH0MMUImVec2@@H@Z";
    _internal_PlotHistogram(label, values, values_count, values_offset, overlay_text.data, scale_min, scale_max, graph_size, stride);
            }
PlotHistogram                  :: (label: *u8, values_getter: (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32 = 0, overlay_text: string = "", scale_min: float = 3.402823466e+38, scale_max: float = 3.402823466e+38, graph_size: ImVec2 = ImVec2.{0,0}) {
    _internal_PlotHistogram :: (label: *u8, values_getter: (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32, overlay_text: *u8, scale_min: float, scale_max: float, graph_size: ImVec2) #foreign imgui_lib "?PlotHistogram@ImGui@@YAXPEBDP6AMPEAXH@Z1HH0MMUImVec2@@@Z";
    _internal_PlotHistogram(label, values_getter, data, values_count, values_offset, overlay_text.data, scale_min, scale_max, graph_size);
            }
PlotLines                      :: (label: *u8, values: *float, values_count: s32, values_offset: s32 = 0, overlay_text: string = "", scale_min: float = 3.402823466e+38, scale_max: float = 3.402823466e+38, graph_size: ImVec2 = ImVec2.{0,0}, stride: s32 = size_of(float)) {
    _internal_PlotLines :: (label: *u8, values: *float, values_count: s32, values_offset: s32, overlay_text: *u8, scale_min: float, scale_max: float, graph_size: ImVec2, stride: s32) #foreign imgui_lib "?PlotLines@ImGui@@YAXPEBDPEBMHH0MMUImVec2@@H@Z";
    _internal_PlotLines(label, values, values_count, values_offset, overlay_text.data, scale_min, scale_max, graph_size, stride);
            }
PlotLines                      :: (label: *u8, values_getter: (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32 = 0, overlay_text: string = "", scale_min: float = 3.402823466e+38, scale_max: float = 3.402823466e+38, graph_size: ImVec2 = ImVec2.{0,0}) {
    _internal_PlotLines :: (label: *u8, values_getter: (data: *void, idx: s32) -> float #c_call, data: *void, values_count: s32, values_offset: s32, overlay_text: *u8, scale_min: float, scale_max: float, graph_size: ImVec2) #foreign imgui_lib "?PlotLines@ImGui@@YAXPEBDP6AMPEAXH@Z1HH0MMUImVec2@@@Z";
    _internal_PlotLines(label, values_getter, data, values_count, values_offset, overlay_text.data, scale_min, scale_max, graph_size);
            }
PopAllowKeyboardFocus          :: () #foreign imgui_lib "?PopAllowKeyboardFocus@ImGui@@YAXXZ";
PopButtonRepeat                :: () #foreign imgui_lib "?PopButtonRepeat@ImGui@@YAXXZ";
PopClipRect                    :: () #foreign imgui_lib "?PopClipRect@ImGui@@YAXXZ";
PopFont                        :: () #foreign imgui_lib "?PopFont@ImGui@@YAXXZ";
PopID                          :: () #foreign imgui_lib "?PopID@ImGui@@YAXXZ";
PopItemWidth                   :: () #foreign imgui_lib "?PopItemWidth@ImGui@@YAXXZ";
PopStyleColor                  :: (count: s32 = 1) #foreign imgui_lib "?PopStyleColor@ImGui@@YAXH@Z";
PopStyleVar                    :: (count: s32 = 1) #foreign imgui_lib "?PopStyleVar@ImGui@@YAXH@Z";
PopTextWrapPos                 :: () #foreign imgui_lib "?PopTextWrapPos@ImGui@@YAXXZ";
ProgressBar                    :: (fraction: float, size_arg: ImVec2 = ImVec2.{-1,0}, overlay: string = "") {
    _internal_ProgressBar :: (fraction: float, size_arg: *ImVec2, overlay: *u8) #foreign imgui_lib "?ProgressBar@ImGui@@YAXMAEBUImVec2@@PEBD@Z";
    _internal_ProgressBar(fraction, *size_arg, overlay.data);
            }
PushAllowKeyboardFocus         :: (allow_keyboard_focus: bool) #foreign imgui_lib "?PushAllowKeyboardFocus@ImGui@@YAX_N@Z";
PushButtonRepeat               :: (repeat: bool) #foreign imgui_lib "?PushButtonRepeat@ImGui@@YAX_N@Z";
PushClipRect                   :: (clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool) {
    _internal_PushClipRect :: (clip_rect_min: *ImVec2, clip_rect_max: *ImVec2, intersect_with_current_clip_rect: bool) #foreign imgui_lib "?PushClipRect@ImGui@@YAXAEBUImVec2@@0_N@Z";
    _internal_PushClipRect(*clip_rect_min, *clip_rect_max, intersect_with_current_clip_rect);
            }
PushFont                       :: (font: *ImFont) #foreign imgui_lib "?PushFont@ImGui@@YAXPEAUImFont@@@Z";
PushID                         :: (str_id: *u8) #foreign imgui_lib "?PushID@ImGui@@YAXPEBD@Z";
PushID                         :: (str_id_begin: *u8, str_id_end: *u8) #foreign imgui_lib "?PushID@ImGui@@YAXPEBD0@Z";
PushID                         :: (ptr_id: *void) #foreign imgui_lib "?PushID@ImGui@@YAXPEBX@Z";
PushID                         :: (int_id: s32) #foreign imgui_lib "?PushID@ImGui@@YAXH@Z";
PushItemWidth                  :: (item_width: float) #foreign imgui_lib "?PushItemWidth@ImGui@@YAXM@Z";
PushStyleColor                 :: (idx: Col, col: u32) #foreign imgui_lib "?PushStyleColor@ImGui@@YAXHI@Z";
PushStyleColor                 :: (idx: Col, col: ImVec4) {
    _internal_PushStyleColor :: (idx: Col, col: *ImVec4) #foreign imgui_lib "?PushStyleColor@ImGui@@YAXHAEBUImVec4@@@Z";
    _internal_PushStyleColor(idx, *col);
            }
PushStyleVar                   :: (idx: StyleVar, val: float) #foreign imgui_lib "?PushStyleVar@ImGui@@YAXHM@Z";
PushStyleVar                   :: (idx: StyleVar, val: ImVec2) {
    _internal_PushStyleVar :: (idx: StyleVar, val: *ImVec2) #foreign imgui_lib "?PushStyleVar@ImGui@@YAXHAEBUImVec2@@@Z";
    _internal_PushStyleVar(idx, *val);
            }
PushTextWrapPos                :: (wrap_local_pos_x: float = 0.0) #foreign imgui_lib "?PushTextWrapPos@ImGui@@YAXM@Z";
RadioButton                    :: (label: *u8, active: bool) -> bool #foreign imgui_lib "?RadioButton@ImGui@@YA_NPEBD_N@Z";
RadioButton                    :: (label: *u8, v: *s32, v_button: s32) -> bool #foreign imgui_lib "?RadioButton@ImGui@@YA_NPEBDPEAHH@Z";
Render                         :: () #foreign imgui_lib "?Render@ImGui@@YAXXZ";
RenderPlatformWindowsDefault   :: (platform_render_arg: *void = null, renderer_render_arg: *void = null) #foreign imgui_lib "?RenderPlatformWindowsDefault@ImGui@@YAXPEAX0@Z";
ResetMouseDragDelta            :: (button: MouseButton = .Left) #foreign imgui_lib "?ResetMouseDragDelta@ImGui@@YAXH@Z";
SameLine                       :: (offset_from_start_x: float = 0.0, spacing: float = 1.0) #foreign imgui_lib "?SameLine@ImGui@@YAXMM@Z";
SaveIniSettingsToDisk          :: (ini_filename: *u8) #foreign imgui_lib "?SaveIniSettingsToDisk@ImGui@@YAXPEBD@Z";
SaveIniSettingsToMemory        :: (out_ini_size: *u64 = null) -> *u8 #foreign imgui_lib "?SaveIniSettingsToMemory@ImGui@@YAPEBDPEA_K@Z";
Selectable                     :: (label: *u8, selected: bool = false, flags: SelectableFlags = .None, size: ImVec2 = ImVec2.{0,0}) -> bool {
    _internal_Selectable :: (label: *u8, selected: bool, flags: SelectableFlags, size: *ImVec2) -> bool #foreign imgui_lib "?Selectable@ImGui@@YA_NPEBD_NHAEBUImVec2@@@Z";
    return _internal_Selectable(label, selected, flags, *size);
            }
Selectable                     :: (label: *u8, p_selected: *bool, flags: SelectableFlags = .None, size: ImVec2 = ImVec2.{0,0}) -> bool {
    _internal_Selectable :: (label: *u8, p_selected: *bool, flags: SelectableFlags, size: *ImVec2) -> bool #foreign imgui_lib "?Selectable@ImGui@@YA_NPEBDPEA_NHAEBUImVec2@@@Z";
    return _internal_Selectable(label, p_selected, flags, *size);
            }
Separator                      :: () #foreign imgui_lib "?Separator@ImGui@@YAXXZ";
SetAllocatorFunctions          :: (alloc_func: (sz: u64, user_data: *void) -> *void #c_call, free_func: (ptr: *void, user_data: *void) #c_call, user_data: *void = null) #foreign imgui_lib "?SetAllocatorFunctions@ImGui@@YAXP6APEAX_KPEAX@ZP6AX11@Z1@Z";
SetClipboardText               :: (text: *u8) #foreign imgui_lib "?SetClipboardText@ImGui@@YAXPEBD@Z";
SetColorEditOptions            :: (flags: ColorEditFlags) #foreign imgui_lib "?SetColorEditOptions@ImGui@@YAXH@Z";
SetColumnOffset                :: (column_index: s32, offset_x: float) #foreign imgui_lib "?SetColumnOffset@ImGui@@YAXHM@Z";
SetColumnWidth                 :: (column_index: s32, width: float) #foreign imgui_lib "?SetColumnWidth@ImGui@@YAXHM@Z";
SetCurrentContext              :: (ctx: *Context) #foreign imgui_lib "?SetCurrentContext@ImGui@@YAXPEAUImGuiContext@@@Z";
SetCursorPos                   :: (local_pos: ImVec2) {
    _internal_SetCursorPos :: (local_pos: *ImVec2) #foreign imgui_lib "?SetCursorPos@ImGui@@YAXAEBUImVec2@@@Z";
    _internal_SetCursorPos(*local_pos);
            }
SetCursorPosX                  :: (local_x: float) #foreign imgui_lib "?SetCursorPosX@ImGui@@YAXM@Z";
SetCursorPosY                  :: (local_y: float) #foreign imgui_lib "?SetCursorPosY@ImGui@@YAXM@Z";
SetCursorScreenPos             :: (pos: ImVec2) {
    _internal_SetCursorScreenPos :: (pos: *ImVec2) #foreign imgui_lib "?SetCursorScreenPos@ImGui@@YAXAEBUImVec2@@@Z";
    _internal_SetCursorScreenPos(*pos);
            }
SetDragDropPayload             :: (type: *u8, data: *void, sz: u64, cond: Cond = .None) -> bool #foreign imgui_lib "?SetDragDropPayload@ImGui@@YA_NPEBDPEBX_KH@Z";
SetItemAllowOverlap            :: () #foreign imgui_lib "?SetItemAllowOverlap@ImGui@@YAXXZ";
SetItemDefaultFocus            :: () #foreign imgui_lib "?SetItemDefaultFocus@ImGui@@YAXXZ";
SetKeyboardFocusHere           :: (offset: s32 = 0) #foreign imgui_lib "?SetKeyboardFocusHere@ImGui@@YAXH@Z";
SetMouseCursor                 :: (cursor_type: MouseCursor) #foreign imgui_lib "?SetMouseCursor@ImGui@@YAXH@Z";
SetNextItemOpen                :: (is_open: bool, cond: Cond = .None) #foreign imgui_lib "?SetNextItemOpen@ImGui@@YAX_NH@Z";
SetNextItemWidth               :: (item_width: float) #foreign imgui_lib "?SetNextItemWidth@ImGui@@YAXM@Z";
SetNextWindowBgAlpha           :: (alpha: float) #foreign imgui_lib "?SetNextWindowBgAlpha@ImGui@@YAXM@Z";
SetNextWindowClass             :: (window_class: *WindowClass) #foreign imgui_lib "?SetNextWindowClass@ImGui@@YAXPEBUImGuiWindowClass@@@Z";
SetNextWindowCollapsed         :: (collapsed: bool, cond: Cond = .None) #foreign imgui_lib "?SetNextWindowCollapsed@ImGui@@YAX_NH@Z";
SetNextWindowContentSize       :: (size: ImVec2) {
    _internal_SetNextWindowContentSize :: (size: *ImVec2) #foreign imgui_lib "?SetNextWindowContentSize@ImGui@@YAXAEBUImVec2@@@Z";
    _internal_SetNextWindowContentSize(*size);
            }
SetNextWindowDockID            :: (dock_id: ID, cond: Cond = .None) #foreign imgui_lib "?SetNextWindowDockID@ImGui@@YAXIH@Z";
SetNextWindowFocus             :: () #foreign imgui_lib "?SetNextWindowFocus@ImGui@@YAXXZ";
SetNextWindowPos               :: (pos: ImVec2, cond: Cond = .None, pivot: ImVec2 = ImVec2.{0,0}) {
    _internal_SetNextWindowPos :: (pos: *ImVec2, cond: Cond, pivot: *ImVec2) #foreign imgui_lib "?SetNextWindowPos@ImGui@@YAXAEBUImVec2@@H0@Z";
    _internal_SetNextWindowPos(*pos, cond, *pivot);
            }
SetNextWindowSize              :: (size: ImVec2, cond: Cond = .None) {
    _internal_SetNextWindowSize :: (size: *ImVec2, cond: Cond) #foreign imgui_lib "?SetNextWindowSize@ImGui@@YAXAEBUImVec2@@H@Z";
    _internal_SetNextWindowSize(*size, cond);
            }
SetNextWindowSizeConstraints   :: (size_min: ImVec2, size_max: ImVec2, custom_callback: SizeCallback = null, custom_callback_data: *void = null) {
    _internal_SetNextWindowSizeConstraints :: (size_min: *ImVec2, size_max: *ImVec2, custom_callback: SizeCallback, custom_callback_data: *void) #foreign imgui_lib "?SetNextWindowSizeConstraints@ImGui@@YAXAEBUImVec2@@0P6AXPEAUImGuiSizeCallbackData@@@ZPEAX@Z";
    _internal_SetNextWindowSizeConstraints(*size_min, *size_max, custom_callback, custom_callback_data);
            }
SetNextWindowViewport          :: (viewport_id: ID) #foreign imgui_lib "?SetNextWindowViewport@ImGui@@YAXI@Z";
SetScrollFromPosX              :: (local_x: float, center_x_ratio: float = 0.5) #foreign imgui_lib "?SetScrollFromPosX@ImGui@@YAXMM@Z";
SetScrollFromPosY              :: (local_y: float, center_y_ratio: float = 0.5) #foreign imgui_lib "?SetScrollFromPosY@ImGui@@YAXMM@Z";
SetScrollHereX                 :: (center_x_ratio: float = 0.5) #foreign imgui_lib "?SetScrollHereX@ImGui@@YAXM@Z";
SetScrollHereY                 :: (center_y_ratio: float = 0.5) #foreign imgui_lib "?SetScrollHereY@ImGui@@YAXM@Z";
SetScrollX                     :: (scroll_x: float) #foreign imgui_lib "?SetScrollX@ImGui@@YAXM@Z";
SetScrollY                     :: (scroll_y: float) #foreign imgui_lib "?SetScrollY@ImGui@@YAXM@Z";
SetStateStorage                :: (storage: *Storage) #foreign imgui_lib "?SetStateStorage@ImGui@@YAXPEAUImGuiStorage@@@Z";
SetTabItemClosed               :: (tab_or_docked_window_label: *u8) #foreign imgui_lib "?SetTabItemClosed@ImGui@@YAXPEBD@Z";
SetTooltip                     :: (fmt: *u8, args: ..Any) #foreign imgui_lib "?SetTooltip@ImGui@@YAXPEBDZZ";
SetWindowCollapsed             :: (collapsed: bool, cond: Cond = .None) #foreign imgui_lib "?SetWindowCollapsed@ImGui@@YAX_NH@Z";
SetWindowCollapsed             :: (name: *u8, collapsed: bool, cond: Cond = .None) #foreign imgui_lib "?SetWindowCollapsed@ImGui@@YAXPEBD_NH@Z";
SetWindowFocus                 :: () #foreign imgui_lib "?SetWindowFocus@ImGui@@YAXXZ";
SetWindowFocus                 :: (name: *u8) #foreign imgui_lib "?SetWindowFocus@ImGui@@YAXPEBD@Z";
SetWindowFontScale             :: (scale: float) #foreign imgui_lib "?SetWindowFontScale@ImGui@@YAXM@Z";
SetWindowPos                   :: (pos: ImVec2, cond: Cond = .None) {
    _internal_SetWindowPos :: (pos: *ImVec2, cond: Cond) #foreign imgui_lib "?SetWindowPos@ImGui@@YAXAEBUImVec2@@H@Z";
    _internal_SetWindowPos(*pos, cond);
            }
SetWindowPos                   :: (name: *u8, pos: ImVec2, cond: Cond = .None) {
    _internal_SetWindowPos :: (name: *u8, pos: *ImVec2, cond: Cond) #foreign imgui_lib "?SetWindowPos@ImGui@@YAXPEBDAEBUImVec2@@H@Z";
    _internal_SetWindowPos(name, *pos, cond);
            }
SetWindowSize                  :: (size: ImVec2, cond: Cond = .None) {
    _internal_SetWindowSize :: (size: *ImVec2, cond: Cond) #foreign imgui_lib "?SetWindowSize@ImGui@@YAXAEBUImVec2@@H@Z";
    _internal_SetWindowSize(*size, cond);
            }
SetWindowSize                  :: (name: *u8, size: ImVec2, cond: Cond = .None) {
    _internal_SetWindowSize :: (name: *u8, size: *ImVec2, cond: Cond) #foreign imgui_lib "?SetWindowSize@ImGui@@YAXPEBDAEBUImVec2@@H@Z";
    _internal_SetWindowSize(name, *size, cond);
            }
ShowAboutWindow                :: (p_open: *bool = null) #foreign imgui_lib "?ShowAboutWindow@ImGui@@YAXPEA_N@Z";
ShowDemoWindow                 :: (p_open: *bool = null) #foreign imgui_lib "?ShowDemoWindow@ImGui@@YAXPEA_N@Z";
ShowFontSelector               :: (label: *u8) #foreign imgui_lib "?ShowFontSelector@ImGui@@YAXPEBD@Z";
ShowMetricsWindow              :: (p_open: *bool = null) #foreign imgui_lib "?ShowMetricsWindow@ImGui@@YAXPEA_N@Z";
ShowStyleEditor                :: (ref: *Style = null) #foreign imgui_lib "?ShowStyleEditor@ImGui@@YAXPEAUImGuiStyle@@@Z";
ShowStyleSelector              :: (label: *u8) -> bool #foreign imgui_lib "?ShowStyleSelector@ImGui@@YA_NPEBD@Z";
ShowUserGuide                  :: () #foreign imgui_lib "?ShowUserGuide@ImGui@@YAXXZ";
SliderAngle                    :: (label: *u8, v_rad: *float, v_degrees_min: float = 360.0, v_degrees_max: float = 360.0, format: string = "%.0f deg", flags: SliderFlags = .None) -> bool {
    _internal_SliderAngle :: (label: *u8, v_rad: *float, v_degrees_min: float, v_degrees_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderAngle@ImGui@@YA_NPEBDPEAMMM0H@Z";
    return _internal_SliderAngle(label, v_rad, v_degrees_min, v_degrees_max, format.data, flags);
            }
SliderFloat                    :: (label: *u8, v: *float, v_min: float, v_max: float, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_SliderFloat :: (label: *u8, v: *float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderFloat@ImGui@@YA_NPEBDPEAMMM0H@Z";
    return _internal_SliderFloat(label, v, v_min, v_max, format.data, flags);
            }
SliderFloat2                   :: (label: *u8, v: [2]float, v_min: float, v_max: float, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_SliderFloat2 :: (label: *u8, v: *float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderFloat2@ImGui@@YA_NPEBDQEAMMM0H@Z";
    return _internal_SliderFloat2(label, v.data, v_min, v_max, format.data, flags);
            }
SliderFloat3                   :: (label: *u8, v: [3]float, v_min: float, v_max: float, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_SliderFloat3 :: (label: *u8, v: *float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderFloat3@ImGui@@YA_NPEBDQEAMMM0H@Z";
    return _internal_SliderFloat3(label, v.data, v_min, v_max, format.data, flags);
            }
SliderFloat4                   :: (label: *u8, v: [4]float, v_min: float, v_max: float, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_SliderFloat4 :: (label: *u8, v: *float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderFloat4@ImGui@@YA_NPEBDQEAMMM0H@Z";
    return _internal_SliderFloat4(label, v.data, v_min, v_max, format.data, flags);
            }
SliderInt                      :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_SliderInt :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderInt@ImGui@@YA_NPEBDPEAHHH0H@Z";
    return _internal_SliderInt(label, v, v_min, v_max, format.data, flags);
            }
SliderInt2                     :: (label: *u8, v: [2]s32, v_min: s32, v_max: s32, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_SliderInt2 :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderInt2@ImGui@@YA_NPEBDQEAHHH0H@Z";
    return _internal_SliderInt2(label, v.data, v_min, v_max, format.data, flags);
            }
SliderInt3                     :: (label: *u8, v: [3]s32, v_min: s32, v_max: s32, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_SliderInt3 :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderInt3@ImGui@@YA_NPEBDQEAHHH0H@Z";
    return _internal_SliderInt3(label, v.data, v_min, v_max, format.data, flags);
            }
SliderInt4                     :: (label: *u8, v: [4]s32, v_min: s32, v_max: s32, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_SliderInt4 :: (label: *u8, v: *s32, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderInt4@ImGui@@YA_NPEBDQEAHHH0H@Z";
    return _internal_SliderInt4(label, v.data, v_min, v_max, format.data, flags);
            }
SliderScalar                   :: (label: *u8, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: string = "", flags: SliderFlags = .None) -> bool {
    _internal_SliderScalar :: (label: *u8, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderScalar@ImGui@@YA_NPEBDHPEAXPEBX20H@Z";
    return _internal_SliderScalar(label, data_type, p_data, p_min, p_max, format.data, flags);
            }
SliderScalarN                  :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_min: *void, p_max: *void, format: string = "", flags: SliderFlags = .None) -> bool {
    _internal_SliderScalarN :: (label: *u8, data_type: DataType, p_data: *void, components: s32, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?SliderScalarN@ImGui@@YA_NPEBDHPEAXHPEBX20H@Z";
    return _internal_SliderScalarN(label, data_type, p_data, components, p_min, p_max, format.data, flags);
            }
SmallButton                    :: (label: *u8) -> bool #foreign imgui_lib "?SmallButton@ImGui@@YA_NPEBD@Z";
Spacing                        :: () #foreign imgui_lib "?Spacing@ImGui@@YAXXZ";
StyleColorsClassic             :: (dst: *Style = null) #foreign imgui_lib "?StyleColorsClassic@ImGui@@YAXPEAUImGuiStyle@@@Z";
StyleColorsDark                :: (dst: *Style = null) #foreign imgui_lib "?StyleColorsDark@ImGui@@YAXPEAUImGuiStyle@@@Z";
StyleColorsLight               :: (dst: *Style = null) #foreign imgui_lib "?StyleColorsLight@ImGui@@YAXPEAUImGuiStyle@@@Z";
Text                           :: (fmt: *u8, args: ..Any) #foreign imgui_lib "?Text@ImGui@@YAXPEBDZZ";
TextColored                    :: (col: ImVec4, fmt: *u8, args: ..Any) {
    _internal_TextColored :: (col: *ImVec4, fmt: *u8, args: ..Any) #foreign imgui_lib "?TextColored@ImGui@@YAXAEBUImVec4@@PEBDZZ";
    _internal_TextColored(*col, fmt, args);
            }
TextDisabled                   :: (fmt: *u8, args: ..Any) #foreign imgui_lib "?TextDisabled@ImGui@@YAXPEBDZZ";
TextUnformatted                :: (text: *u8, text_end: *u8) #foreign imgui_lib "?TextUnformatted@ImGui@@YAXPEBD0@Z";

// Jai-friendly wrappers
Text :: (fmt: string, args: .. Any) {
    text := tprint(fmt, ..args);
    TextUnformatted(text.data, text.data+text.count);
}
TextDisabled :: (fmt: string, args: .. Any) {
    text := tprint(tprint("%\0", fmt), ..args);
    TextDisabled(text.data);
}

TextWrapped                    :: (fmt: *u8, args: ..Any) #foreign imgui_lib "?TextWrapped@ImGui@@YAXPEBDZZ";
TreeNode                       :: (label: *u8) -> bool #foreign imgui_lib "?TreeNode@ImGui@@YA_NPEBD@Z";
TreeNode                       :: (str_id: *u8, fmt: *u8, args: ..Any) -> bool #foreign imgui_lib "?TreeNode@ImGui@@YA_NPEBD0ZZ";
TreeNode                       :: (ptr_id: *void, fmt: *u8, args: ..Any) -> bool #foreign imgui_lib "?TreeNode@ImGui@@YA_NPEBXPEBDZZ";
TreeNodeEx                     :: (label: *u8, flags: TreeNodeFlags = .None) -> bool #foreign imgui_lib "?TreeNodeEx@ImGui@@YA_NPEBDH@Z";
TreeNodeEx                     :: (str_id: *u8, flags: TreeNodeFlags, fmt: *u8, args: ..Any) -> bool #foreign imgui_lib "?TreeNodeEx@ImGui@@YA_NPEBDH0ZZ";
TreeNodeEx                     :: (ptr_id: *void, flags: TreeNodeFlags, fmt: *u8, args: ..Any) -> bool #foreign imgui_lib "?TreeNodeEx@ImGui@@YA_NPEBXHPEBDZZ";
TreePop                        :: () #foreign imgui_lib "?TreePop@ImGui@@YAXXZ";
TreePush                       :: (str_id: *u8) #foreign imgui_lib "?TreePush@ImGui@@YAXPEBD@Z";
TreePush                       :: (ptr_id: *void = null) #foreign imgui_lib "?TreePush@ImGui@@YAXPEBX@Z";
Unindent                       :: (indent_w: float = 0.0) #foreign imgui_lib "?Unindent@ImGui@@YAXM@Z";
UpdatePlatformWindows          :: () #foreign imgui_lib "?UpdatePlatformWindows@ImGui@@YAXXZ";
VSliderFloat                   :: (label: *u8, size: ImVec2, v: *float, v_min: float, v_max: float, format: string = "%.3f", flags: SliderFlags = .None) -> bool {
    _internal_VSliderFloat :: (label: *u8, size: *ImVec2, v: *float, v_min: float, v_max: float, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?VSliderFloat@ImGui@@YA_NPEBDAEBUImVec2@@PEAMMM0H@Z";
    return _internal_VSliderFloat(label, *size, v, v_min, v_max, format.data, flags);
            }
VSliderInt                     :: (label: *u8, size: ImVec2, v: *s32, v_min: s32, v_max: s32, format: string = "%d", flags: SliderFlags = .None) -> bool {
    _internal_VSliderInt :: (label: *u8, size: *ImVec2, v: *s32, v_min: s32, v_max: s32, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?VSliderInt@ImGui@@YA_NPEBDAEBUImVec2@@PEAHHH0H@Z";
    return _internal_VSliderInt(label, *size, v, v_min, v_max, format.data, flags);
            }
VSliderScalar                  :: (label: *u8, size: ImVec2, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: string = "", flags: SliderFlags = .None) -> bool {
    _internal_VSliderScalar :: (label: *u8, size: *ImVec2, data_type: DataType, p_data: *void, p_min: *void, p_max: *void, format: *u8, flags: SliderFlags) -> bool #foreign imgui_lib "?VSliderScalar@ImGui@@YA_NPEBDAEBUImVec2@@HPEAXPEBX30H@Z";
    return _internal_VSliderScalar(label, *size, data_type, p_data, p_min, p_max, format.data, flags);
            }
Value                          :: (prefix: *u8, b: bool) #foreign imgui_lib "?Value@ImGui@@YAXPEBD_N@Z";
Value                          :: (prefix: *u8, v: s32) #foreign imgui_lib "?Value@ImGui@@YAXPEBDH@Z";
Value                          :: (prefix: *u8, v: u32) #foreign imgui_lib "?Value@ImGui@@YAXPEBDI@Z";
Value                          :: (prefix: *u8, v: float, float_format: string = "") {
    _internal_Value :: (prefix: *u8, v: float, float_format: *u8) #foreign imgui_lib "?Value@ImGui@@YAXPEBDM0@Z";
    _internal_Value(prefix, v, float_format.data);
            }

//
// section: STRUCTS
//

ImColor :: struct {
    Value: ImVec4;
}

ImDrawChannel :: struct {
    _CmdBuffer: ImVector(ImDrawCmd);
    _IdxBuffer: ImVector(ImDrawIdx);
}

ImDrawCmd :: struct {
    ClipRect: ImVec4;
    TextureId: ImTextureID;
    VtxOffset: u32;
    IdxOffset: u32;
    ElemCount: u32;
    UserCallback: ImDrawCallback;
    UserCallbackData: *void;
}

ImDrawData :: struct {
    Valid: bool;
    CmdLists: **ImDrawList;
    CmdListsCount: s32;
    TotalIdxCount: s32;
    TotalVtxCount: s32;
    DisplayPos: ImVec2;
    DisplaySize: ImVec2;
    FramebufferScale: ImVec2;
    OwnerViewport: *Viewport;

    DeIndexAllBuffers     :: (self: *ImDrawData) #foreign imgui_lib "?DeIndexAllBuffers@ImDrawData@@QEAAXXZ";
    ScaleClipRects        :: (self: *ImDrawData, fb_scale: ImVec2) {
    _internal_ScaleClipRects :: (self: *ImDrawData, fb_scale: *ImVec2) #foreign imgui_lib "?ScaleClipRects@ImDrawData@@QEAAXAEBUImVec2@@@Z";
    _internal_ScaleClipRects(self, *fb_scale);
            }
}

ImDrawList :: struct {
    CmdBuffer: ImVector(ImDrawCmd);
    IdxBuffer: ImVector(ImDrawIdx);
    VtxBuffer: ImVector(ImDrawVert);
    Flags: ImDrawListFlags;
    _Data: *ImDrawListSharedData;
    _OwnerName: *u8;
    _VtxCurrentIdx: u32;
    _VtxWritePtr: *ImDrawVert;
    _IdxWritePtr: *ImDrawIdx;
    _ClipRectStack: ImVector(ImVec4);
    _TextureIdStack: ImVector(ImTextureID);
    _Path: ImVector(ImVec2);
    _CmdHeader: ImDrawCmd;
    _Splitter: ImDrawListSplitter;

    AddBezierCurve              :: (self: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: u32, thickness: float, num_segments: s32 = 0) {
    _internal_AddBezierCurve :: (self: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: u32, thickness: float, num_segments: s32) #foreign imgui_lib "?AddBezierCurve@ImDrawList@@QEAAXAEBUImVec2@@000IMH@Z";
    _internal_AddBezierCurve(self, *p1, *p2, *p3, *p4, col, thickness, num_segments);
            }
    AddCircle                   :: (self: *ImDrawList, center: ImVec2, radius: float, col: u32, num_segments: s32 = 0, thickness: float = 1.0) {
    _internal_AddCircle :: (self: *ImDrawList, center: *ImVec2, radius: float, col: u32, num_segments: s32, thickness: float) #foreign imgui_lib "?AddCircle@ImDrawList@@QEAAXAEBUImVec2@@MIHM@Z";
    _internal_AddCircle(self, *center, radius, col, num_segments, thickness);
            }
    AddCircleFilled             :: (self: *ImDrawList, center: ImVec2, radius: float, col: u32, num_segments: s32 = 0) {
    _internal_AddCircleFilled :: (self: *ImDrawList, center: *ImVec2, radius: float, col: u32, num_segments: s32) #foreign imgui_lib "?AddCircleFilled@ImDrawList@@QEAAXAEBUImVec2@@MIH@Z";
    _internal_AddCircleFilled(self, *center, radius, col, num_segments);
            }
    AddConvexPolyFilled         :: (self: *ImDrawList, points: *ImVec2, num_points: s32, col: u32) #foreign imgui_lib "?AddConvexPolyFilled@ImDrawList@@QEAAXPEBUImVec2@@HI@Z";
    AddDrawCmd                  :: (self: *ImDrawList) #foreign imgui_lib "?AddDrawCmd@ImDrawList@@QEAAXXZ";
    AddImage                    :: (self: *ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2 = ImVec2.{0,0}, uv_max: ImVec2 = ImVec2.{1,1}, col: u32 = ((cast(u32)(255)<<24)|(cast(u32)(255)<<16)|(cast(u32)(255)<<8)|(cast(u32)(255)<<0))) {
    _internal_AddImage :: (self: *ImDrawList, user_texture_id: ImTextureID, p_min: *ImVec2, p_max: *ImVec2, uv_min: *ImVec2, uv_max: *ImVec2, col: u32) #foreign imgui_lib "?AddImage@ImDrawList@@QEAAXPEAXAEBUImVec2@@111I@Z";
    _internal_AddImage(self, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col);
            }
    AddImageQuad                :: (self: *ImDrawList, user_texture_id: ImTextureID, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, uv1: ImVec2 = ImVec2.{0,0}, uv2: ImVec2 = ImVec2.{1,0}, uv3: ImVec2 = ImVec2.{1,1}, uv4: ImVec2 = ImVec2.{0,1}, col: u32 = ((cast(u32)(255)<<24)|(cast(u32)(255)<<16)|(cast(u32)(255)<<8)|(cast(u32)(255)<<0))) {
    _internal_AddImageQuad :: (self: *ImDrawList, user_texture_id: ImTextureID, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, uv1: *ImVec2, uv2: *ImVec2, uv3: *ImVec2, uv4: *ImVec2, col: u32) #foreign imgui_lib "?AddImageQuad@ImDrawList@@QEAAXPEAXAEBUImVec2@@1111111I@Z";
    _internal_AddImageQuad(self, user_texture_id, *p1, *p2, *p3, *p4, *uv1, *uv2, *uv3, *uv4, col);
            }
    AddImageRounded             :: (self: *ImDrawList, user_texture_id: ImTextureID, p_min: ImVec2, p_max: ImVec2, uv_min: ImVec2, uv_max: ImVec2, col: u32, rounding: float, rounding_corners: ImDrawCornerFlags = .All) {
    _internal_AddImageRounded :: (self: *ImDrawList, user_texture_id: ImTextureID, p_min: *ImVec2, p_max: *ImVec2, uv_min: *ImVec2, uv_max: *ImVec2, col: u32, rounding: float, rounding_corners: ImDrawCornerFlags) #foreign imgui_lib "?AddImageRounded@ImDrawList@@QEAAXPEAXAEBUImVec2@@111IMH@Z";
    _internal_AddImageRounded(self, user_texture_id, *p_min, *p_max, *uv_min, *uv_max, col, rounding, rounding_corners);
            }
    AddLine                     :: (self: *ImDrawList, p1: ImVec2, p2: ImVec2, col: u32, thickness: float = 1.0) {
    _internal_AddLine :: (self: *ImDrawList, p1: *ImVec2, p2: *ImVec2, col: u32, thickness: float) #foreign imgui_lib "?AddLine@ImDrawList@@QEAAXAEBUImVec2@@0IM@Z";
    _internal_AddLine(self, *p1, *p2, col, thickness);
            }
    AddNgon                     :: (self: *ImDrawList, center: ImVec2, radius: float, col: u32, num_segments: s32, thickness: float = 1.0) {
    _internal_AddNgon :: (self: *ImDrawList, center: *ImVec2, radius: float, col: u32, num_segments: s32, thickness: float) #foreign imgui_lib "?AddNgon@ImDrawList@@QEAAXAEBUImVec2@@MIHM@Z";
    _internal_AddNgon(self, *center, radius, col, num_segments, thickness);
            }
    AddNgonFilled               :: (self: *ImDrawList, center: ImVec2, radius: float, col: u32, num_segments: s32) {
    _internal_AddNgonFilled :: (self: *ImDrawList, center: *ImVec2, radius: float, col: u32, num_segments: s32) #foreign imgui_lib "?AddNgonFilled@ImDrawList@@QEAAXAEBUImVec2@@MIH@Z";
    _internal_AddNgonFilled(self, *center, radius, col, num_segments);
            }
    AddPolyline                 :: (self: *ImDrawList, points: *ImVec2, num_points: s32, col: u32, closed: bool, thickness: float) #foreign imgui_lib "?AddPolyline@ImDrawList@@QEAAXPEBUImVec2@@HI_NM@Z";
    AddQuad                     :: (self: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: u32, thickness: float = 1.0) {
    _internal_AddQuad :: (self: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: u32, thickness: float) #foreign imgui_lib "?AddQuad@ImDrawList@@QEAAXAEBUImVec2@@000IM@Z";
    _internal_AddQuad(self, *p1, *p2, *p3, *p4, col, thickness);
            }
    AddQuadFilled               :: (self: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, p4: ImVec2, col: u32) {
    _internal_AddQuadFilled :: (self: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, col: u32) #foreign imgui_lib "?AddQuadFilled@ImDrawList@@QEAAXAEBUImVec2@@000I@Z";
    _internal_AddQuadFilled(self, *p1, *p2, *p3, *p4, col);
            }
    AddRect                     :: (self: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col: u32, rounding: float = 0.0, rounding_corners: ImDrawCornerFlags = .All, thickness: float = 1.0) {
    _internal_AddRect :: (self: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col: u32, rounding: float, rounding_corners: ImDrawCornerFlags, thickness: float) #foreign imgui_lib "?AddRect@ImDrawList@@QEAAXAEBUImVec2@@0IMHM@Z";
    _internal_AddRect(self, *p_min, *p_max, col, rounding, rounding_corners, thickness);
            }
    AddRectFilled               :: (self: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col: u32, rounding: float = 0.0, rounding_corners: ImDrawCornerFlags = .All) {
    _internal_AddRectFilled :: (self: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col: u32, rounding: float, rounding_corners: ImDrawCornerFlags) #foreign imgui_lib "?AddRectFilled@ImDrawList@@QEAAXAEBUImVec2@@0IMH@Z";
    _internal_AddRectFilled(self, *p_min, *p_max, col, rounding, rounding_corners);
            }
    AddRectFilledMultiColor     :: (self: *ImDrawList, p_min: ImVec2, p_max: ImVec2, col_upr_left: u32, col_upr_right: u32, col_bot_right: u32, col_bot_left: u32) {
    _internal_AddRectFilledMultiColor :: (self: *ImDrawList, p_min: *ImVec2, p_max: *ImVec2, col_upr_left: u32, col_upr_right: u32, col_bot_right: u32, col_bot_left: u32) #foreign imgui_lib "?AddRectFilledMultiColor@ImDrawList@@QEAAXAEBUImVec2@@0IIII@Z";
    _internal_AddRectFilledMultiColor(self, *p_min, *p_max, col_upr_left, col_upr_right, col_bot_right, col_bot_left);
            }
    AddText                     :: (self: *ImDrawList, pos: ImVec2, col: u32, text_begin: *u8, text_end: string = "") {
    _internal_AddText :: (self: *ImDrawList, pos: *ImVec2, col: u32, text_begin: *u8, text_end: *u8) #foreign imgui_lib "?AddText@ImDrawList@@QEAAXAEBUImVec2@@IPEBD1@Z";
    _internal_AddText(self, *pos, col, text_begin, text_end.data);
            }
    AddText                     :: (self: *ImDrawList, font: *ImFont, font_size: float, pos: ImVec2, col: u32, text_begin: *u8, text_end: string = "", wrap_width: float = 0.0, cpu_fine_clip_rect: *ImVec4 = null) {
    _internal_AddText :: (self: *ImDrawList, font: *ImFont, font_size: float, pos: *ImVec2, col: u32, text_begin: *u8, text_end: *u8, wrap_width: float, cpu_fine_clip_rect: *ImVec4) #foreign imgui_lib "?AddText@ImDrawList@@QEAAXPEBUImFont@@MAEBUImVec2@@IPEBD2MPEBUImVec4@@@Z";
    _internal_AddText(self, font, font_size, *pos, col, text_begin, text_end.data, wrap_width, cpu_fine_clip_rect);
            }
    AddTriangle                 :: (self: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: u32, thickness: float = 1.0) {
    _internal_AddTriangle :: (self: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: u32, thickness: float) #foreign imgui_lib "?AddTriangle@ImDrawList@@QEAAXAEBUImVec2@@00IM@Z";
    _internal_AddTriangle(self, *p1, *p2, *p3, col, thickness);
            }
    AddTriangleFilled           :: (self: *ImDrawList, p1: ImVec2, p2: ImVec2, p3: ImVec2, col: u32) {
    _internal_AddTriangleFilled :: (self: *ImDrawList, p1: *ImVec2, p2: *ImVec2, p3: *ImVec2, col: u32) #foreign imgui_lib "?AddTriangleFilled@ImDrawList@@QEAAXAEBUImVec2@@00I@Z";
    _internal_AddTriangleFilled(self, *p1, *p2, *p3, col);
            }
    CloneOutput                 :: (self: *ImDrawList) -> *ImDrawList #foreign imgui_lib "?CloneOutput@ImDrawList@@QEBAPEAU1@XZ";
    PathArcTo                   :: (self: *ImDrawList, center: ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32 = 10) {
    _internal_PathArcTo :: (self: *ImDrawList, center: *ImVec2, radius: float, a_min: float, a_max: float, num_segments: s32) #foreign imgui_lib "?PathArcTo@ImDrawList@@QEAAXAEBUImVec2@@MMMH@Z";
    _internal_PathArcTo(self, *center, radius, a_min, a_max, num_segments);
            }
    PathArcToFast               :: (self: *ImDrawList, center: ImVec2, radius: float, a_min_of_12: s32, a_max_of_12: s32) {
    _internal_PathArcToFast :: (self: *ImDrawList, center: *ImVec2, radius: float, a_min_of_12: s32, a_max_of_12: s32) #foreign imgui_lib "?PathArcToFast@ImDrawList@@QEAAXAEBUImVec2@@MHH@Z";
    _internal_PathArcToFast(self, *center, radius, a_min_of_12, a_max_of_12);
            }
    PathBezierCurveTo           :: (self: *ImDrawList, p2: ImVec2, p3: ImVec2, p4: ImVec2, num_segments: s32 = 0) {
    _internal_PathBezierCurveTo :: (self: *ImDrawList, p2: *ImVec2, p3: *ImVec2, p4: *ImVec2, num_segments: s32) #foreign imgui_lib "?PathBezierCurveTo@ImDrawList@@QEAAXAEBUImVec2@@00H@Z";
    _internal_PathBezierCurveTo(self, *p2, *p3, *p4, num_segments);
            }
    PathRect                    :: (self: *ImDrawList, rect_min: ImVec2, rect_max: ImVec2, rounding: float = 0.0, rounding_corners: ImDrawCornerFlags = .All) {
    _internal_PathRect :: (self: *ImDrawList, rect_min: *ImVec2, rect_max: *ImVec2, rounding: float, rounding_corners: ImDrawCornerFlags) #foreign imgui_lib "?PathRect@ImDrawList@@QEAAXAEBUImVec2@@0MH@Z";
    _internal_PathRect(self, *rect_min, *rect_max, rounding, rounding_corners);
            }
    PopClipRect                 :: (self: *ImDrawList) #foreign imgui_lib "?PopClipRect@ImDrawList@@QEAAXXZ";
    PopTextureID                :: (self: *ImDrawList) #foreign imgui_lib "?PopTextureID@ImDrawList@@QEAAXXZ";
    PrimQuadUV                  :: (self: *ImDrawList, a: ImVec2, b: ImVec2, c: ImVec2, d: ImVec2, uv_a: ImVec2, uv_b: ImVec2, uv_c: ImVec2, uv_d: ImVec2, col: u32) {
    _internal_PrimQuadUV :: (self: *ImDrawList, a: *ImVec2, b: *ImVec2, c: *ImVec2, d: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, uv_c: *ImVec2, uv_d: *ImVec2, col: u32) #foreign imgui_lib "?PrimQuadUV@ImDrawList@@QEAAXAEBUImVec2@@0000000I@Z";
    _internal_PrimQuadUV(self, *a, *b, *c, *d, *uv_a, *uv_b, *uv_c, *uv_d, col);
            }
    PrimRect                    :: (self: *ImDrawList, a: ImVec2, b: ImVec2, col: u32) {
    _internal_PrimRect :: (self: *ImDrawList, a: *ImVec2, b: *ImVec2, col: u32) #foreign imgui_lib "?PrimRect@ImDrawList@@QEAAXAEBUImVec2@@0I@Z";
    _internal_PrimRect(self, *a, *b, col);
            }
    PrimRectUV                  :: (self: *ImDrawList, a: ImVec2, b: ImVec2, uv_a: ImVec2, uv_b: ImVec2, col: u32) {
    _internal_PrimRectUV :: (self: *ImDrawList, a: *ImVec2, b: *ImVec2, uv_a: *ImVec2, uv_b: *ImVec2, col: u32) #foreign imgui_lib "?PrimRectUV@ImDrawList@@QEAAXAEBUImVec2@@000I@Z";
    _internal_PrimRectUV(self, *a, *b, *uv_a, *uv_b, col);
            }
    PrimReserve                 :: (self: *ImDrawList, idx_count: s32, vtx_count: s32) #foreign imgui_lib "?PrimReserve@ImDrawList@@QEAAXHH@Z";
    PrimUnreserve               :: (self: *ImDrawList, idx_count: s32, vtx_count: s32) #foreign imgui_lib "?PrimUnreserve@ImDrawList@@QEAAXHH@Z";
    PushClipRect                :: (self: *ImDrawList, clip_rect_min: ImVec2, clip_rect_max: ImVec2, intersect_with_current_clip_rect: bool = false) #foreign imgui_lib "?PushClipRect@ImDrawList@@QEAAXUImVec2@@0_N@Z";
    PushClipRectFullScreen      :: (self: *ImDrawList) #foreign imgui_lib "?PushClipRectFullScreen@ImDrawList@@QEAAXXZ";
    PushTextureID               :: (self: *ImDrawList, texture_id: ImTextureID) #foreign imgui_lib "?PushTextureID@ImDrawList@@QEAAXPEAX@Z";
    _ClearFreeMemory            :: (self: *ImDrawList) #foreign imgui_lib "?_ClearFreeMemory@ImDrawList@@QEAAXXZ";
    _OnChangedClipRect          :: (self: *ImDrawList) #foreign imgui_lib "?_OnChangedClipRect@ImDrawList@@QEAAXXZ";
    _OnChangedTextureID         :: (self: *ImDrawList) #foreign imgui_lib "?_OnChangedTextureID@ImDrawList@@QEAAXXZ";
    _OnChangedVtxOffset         :: (self: *ImDrawList) #foreign imgui_lib "?_OnChangedVtxOffset@ImDrawList@@QEAAXXZ";
    _PopUnusedDrawCmd           :: (self: *ImDrawList) #foreign imgui_lib "?_PopUnusedDrawCmd@ImDrawList@@QEAAXXZ";
    _ResetForNewFrame           :: (self: *ImDrawList) #foreign imgui_lib "?_ResetForNewFrame@ImDrawList@@QEAAXXZ";
}

ImDrawListSharedData :: struct {
    TexUvWhitePixel: ImVec2;
    Font: *ImFont;
    FontSize: float;
    CurveTessellationTol: float;
    CircleSegmentMaxError: float;
    ClipRectFullscreen: ImVec4;
    InitialFlags: ImDrawListFlags;
    ArcFastVtx: [12*1]ImVec2;
    CircleSegmentCounts: [64]u8;
    TexUvLines: *ImVec4;
}

ImDrawListSplitter :: struct {
    _Current: s32;
    _Count: s32;
    _Channels: ImVector(ImDrawChannel);

    ClearFreeMemory       :: (self: *ImDrawListSplitter) #foreign imgui_lib "?ClearFreeMemory@ImDrawListSplitter@@QEAAXXZ";
    Merge                 :: (self: *ImDrawListSplitter, draw_list: *ImDrawList) #foreign imgui_lib "?Merge@ImDrawListSplitter@@QEAAXPEAUImDrawList@@@Z";
    SetCurrentChannel     :: (self: *ImDrawListSplitter, draw_list: *ImDrawList, channel_idx: s32) #foreign imgui_lib "?SetCurrentChannel@ImDrawListSplitter@@QEAAXPEAUImDrawList@@H@Z";
    Split                 :: (self: *ImDrawListSplitter, draw_list: *ImDrawList, count: s32) #foreign imgui_lib "?Split@ImDrawListSplitter@@QEAAXPEAUImDrawList@@H@Z";
}

ImDrawVert :: struct {
    pos: ImVec2;
    uv: ImVec2;
    col: u32;
}

ImFont :: struct {
    IndexAdvanceX: ImVector(float);
    FallbackAdvanceX: float;
    FontSize: float;
    IndexLookup: ImVector(ImWchar);
    Glyphs: ImVector(ImFontGlyph);
    FallbackGlyph: *ImFontGlyph;
    DisplayOffset: ImVec2;
    ContainerAtlas: *ImFontAtlas;
    ConfigData: *ImFontConfig;
    ConfigDataCount: s16;
    FallbackChar: ImWchar;
    EllipsisChar: ImWchar;
    DirtyLookupTables: bool;
    Scale: float;
    Ascent: float;
    Descent: float;
    MetricsTotalSurface: s32;
    Used4kPagesMap: [(0xFFFF+1)/4096/8]u8;

    AddGlyph                  :: (self: *ImFont, src_cfg: *ImFontConfig, c: ImWchar, x0: float, y0: float, x1: float, y1: float, u0: float, v0: float, u1: float, v1: float, advance_x: float) #foreign imgui_lib "?AddGlyph@ImFont@@QEAAXPEBUImFontConfig@@GMMMMMMMMM@Z";
    AddRemapChar              :: (self: *ImFont, dst: ImWchar, src: ImWchar, overwrite_dst: bool = true) #foreign imgui_lib "?AddRemapChar@ImFont@@QEAAXGG_N@Z";
    BuildLookupTable          :: (self: *ImFont) #foreign imgui_lib "?BuildLookupTable@ImFont@@QEAAXXZ";
    CalcWordWrapPositionA     :: (self: *ImFont, scale: float, text: *u8, text_end: *u8, wrap_width: float) -> *u8 #foreign imgui_lib "?CalcWordWrapPositionA@ImFont@@QEBAPEBDMPEBD0M@Z";
    ClearOutputData           :: (self: *ImFont) #foreign imgui_lib "?ClearOutputData@ImFont@@QEAAXXZ";
    FindGlyph                 :: (self: *ImFont, c: ImWchar) -> *ImFontGlyph #foreign imgui_lib "?FindGlyph@ImFont@@QEBAPEBUImFontGlyph@@G@Z";
    FindGlyphNoFallback       :: (self: *ImFont, c: ImWchar) -> *ImFontGlyph #foreign imgui_lib "?FindGlyphNoFallback@ImFont@@QEBAPEBUImFontGlyph@@G@Z";
    GrowIndex                 :: (self: *ImFont, new_size: s32) #foreign imgui_lib "?GrowIndex@ImFont@@QEAAXH@Z";
    IsGlyphRangeUnused        :: (self: *ImFont, c_begin: u32, c_last: u32) -> bool #foreign imgui_lib "?IsGlyphRangeUnused@ImFont@@QEAA_NII@Z";
    RenderChar                :: (self: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: u32, c: ImWchar) #foreign imgui_lib "?RenderChar@ImFont@@QEBAXPEAUImDrawList@@MUImVec2@@IG@Z";
    RenderText                :: (self: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: u32, clip_rect: ImVec4, text_begin: *u8, text_end: *u8, wrap_width: float = 0.0, cpu_fine_clip: bool = false) {
    _internal_RenderText :: (self: *ImFont, draw_list: *ImDrawList, size: float, pos: ImVec2, col: u32, clip_rect: *ImVec4, text_begin: *u8, text_end: *u8, wrap_width: float, cpu_fine_clip: bool) #foreign imgui_lib "?RenderText@ImFont@@QEBAXPEAUImDrawList@@MUImVec2@@IAEBUImVec4@@PEBD3M_N@Z";
    _internal_RenderText(self, draw_list, size, pos, col, *clip_rect, text_begin, text_end, wrap_width, cpu_fine_clip);
            }
    SetFallbackChar           :: (self: *ImFont, c: ImWchar) #foreign imgui_lib "?SetFallbackChar@ImFont@@QEAAXG@Z";
    SetGlyphVisible           :: (self: *ImFont, c: ImWchar, visible: bool) #foreign imgui_lib "?SetGlyphVisible@ImFont@@QEAAXG_N@Z";
}

ImFontAtlas :: struct {
    Locked: bool;
    Flags: ImFontAtlasFlags;
    TexID: ImTextureID;
    TexDesiredWidth: s32;
    TexGlyphPadding: s32;
    TexPixelsAlpha8: *u8;
    TexPixelsRGBA32: *u32;
    TexWidth: s32;
    TexHeight: s32;
    TexUvScale: ImVec2;
    TexUvWhitePixel: ImVec2;
    Fonts: ImVector(*ImFont);
    CustomRects: ImVector(ImFontAtlasCustomRect);
    ConfigData: ImVector(ImFontConfig);
    TexUvLines: [(63)+1]ImVec4;
    PackIdMouseCursors: s32;
    PackIdLines: s32;

    AddCustomRectFontGlyph                    :: (self: *ImFontAtlas, font: *ImFont, id: ImWchar, width: s32, height: s32, advance_x: float, offset: ImVec2 = ImVec2.{0,0}) -> s32 {
    _internal_AddCustomRectFontGlyph :: (self: *ImFontAtlas, font: *ImFont, id: ImWchar, width: s32, height: s32, advance_x: float, offset: *ImVec2) -> s32 #foreign imgui_lib "?AddCustomRectFontGlyph@ImFontAtlas@@QEAAHPEAUImFont@@GHHMAEBUImVec2@@@Z";
    return _internal_AddCustomRectFontGlyph(self, font, id, width, height, advance_x, *offset);
            }
    AddCustomRectRegular                      :: (self: *ImFontAtlas, width: s32, height: s32) -> s32 #foreign imgui_lib "?AddCustomRectRegular@ImFontAtlas@@QEAAHHH@Z";
    AddFont                                   :: (self: *ImFontAtlas, font_cfg: *ImFontConfig) -> *ImFont #foreign imgui_lib "?AddFont@ImFontAtlas@@QEAAPEAUImFont@@PEBUImFontConfig@@@Z";
    AddFontDefault                            :: (self: *ImFontAtlas, font_cfg: *ImFontConfig = null) -> *ImFont #foreign imgui_lib "?AddFontDefault@ImFontAtlas@@QEAAPEAUImFont@@PEBUImFontConfig@@@Z";
    AddFontFromFileTTF                        :: (self: *ImFontAtlas, filename: *u8, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #foreign imgui_lib "?AddFontFromFileTTF@ImFontAtlas@@QEAAPEAUImFont@@PEBDMPEBUImFontConfig@@PEBG@Z";
    AddFontFromMemoryCompressedBase85TTF      :: (self: *ImFontAtlas, compressed_font_data_base85: *u8, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #foreign imgui_lib "?AddFontFromMemoryCompressedBase85TTF@ImFontAtlas@@QEAAPEAUImFont@@PEBDMPEBUImFontConfig@@PEBG@Z";
    AddFontFromMemoryCompressedTTF            :: (self: *ImFontAtlas, compressed_font_data: *void, compressed_font_size: s32, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #foreign imgui_lib "?AddFontFromMemoryCompressedTTF@ImFontAtlas@@QEAAPEAUImFont@@PEBXHMPEBUImFontConfig@@PEBG@Z";
    AddFontFromMemoryTTF                      :: (self: *ImFontAtlas, font_data: *void, font_size: s32, size_pixels: float, font_cfg: *ImFontConfig = null, glyph_ranges: *ImWchar = null) -> *ImFont #foreign imgui_lib "?AddFontFromMemoryTTF@ImFontAtlas@@QEAAPEAUImFont@@PEAXHMPEBUImFontConfig@@PEBG@Z";
    Build                                     :: (self: *ImFontAtlas) -> bool #foreign imgui_lib "?Build@ImFontAtlas@@QEAA_NXZ";
    CalcCustomRectUV                          :: (self: *ImFontAtlas, rect: *ImFontAtlasCustomRect, out_uv_min: *ImVec2, out_uv_max: *ImVec2) #foreign imgui_lib "?CalcCustomRectUV@ImFontAtlas@@QEBAXPEBUImFontAtlasCustomRect@@PEAUImVec2@@1@Z";
    Clear                                     :: (self: *ImFontAtlas) #foreign imgui_lib "?Clear@ImFontAtlas@@QEAAXXZ";
    ClearFonts                                :: (self: *ImFontAtlas) #foreign imgui_lib "?ClearFonts@ImFontAtlas@@QEAAXXZ";
    ClearInputData                            :: (self: *ImFontAtlas) #foreign imgui_lib "?ClearInputData@ImFontAtlas@@QEAAXXZ";
    ClearTexData                              :: (self: *ImFontAtlas) #foreign imgui_lib "?ClearTexData@ImFontAtlas@@QEAAXXZ";
    GetGlyphRangesChineseFull                 :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesChineseFull@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesChineseSimplifiedCommon     :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesChineseSimplifiedCommon@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesCyrillic                    :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesCyrillic@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesDefault                     :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesDefault@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesJapanese                    :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesJapanese@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesKorean                      :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesKorean@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesThai                        :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesThai@ImFontAtlas@@QEAAPEBGXZ";
    GetGlyphRangesVietnamese                  :: (self: *ImFontAtlas) -> *ImWchar #foreign imgui_lib "?GetGlyphRangesVietnamese@ImFontAtlas@@QEAAPEBGXZ";
    GetMouseCursorTexData                     :: (self: *ImFontAtlas, cursor: MouseCursor, out_offset: *ImVec2, out_size: *ImVec2, out_uv_border: [2]ImVec2, out_uv_fill: [2]ImVec2) -> bool #foreign imgui_lib "?GetMouseCursorTexData@ImFontAtlas@@QEAA_NHPEAUImVec2@@0QEAU2@1@Z";
    GetTexDataAsAlpha8                        :: (self: *ImFontAtlas, out_pixels: **u8, out_width: *s32, out_height: *s32, out_bytes_per_pixel: *s32 = null) #foreign imgui_lib "?GetTexDataAsAlpha8@ImFontAtlas@@QEAAXPEAPEAEPEAH11@Z";
    GetTexDataAsRGBA32                        :: (self: *ImFontAtlas, out_pixels: **u8, out_width: *s32, out_height: *s32, out_bytes_per_pixel: *s32 = null) #foreign imgui_lib "?GetTexDataAsRGBA32@ImFontAtlas@@QEAAXPEAPEAEPEAH11@Z";
}

ImFontAtlasCustomRect :: struct {
    Width: u16;
    Height: u16;
    X: u16;
    Y: u16;
    GlyphID: u32;
    GlyphAdvanceX: float;
    GlyphOffset: ImVec2;
    Font: *ImFont;
}

ImFontConfig :: struct {
    FontData: *void;
    FontDataSize: s32;
    FontDataOwnedByAtlas: bool;
    FontNo: s32;
    SizePixels: float;
    OversampleH: s32;
    OversampleV: s32;
    PixelSnapH: bool;
    GlyphExtraSpacing: ImVec2;
    GlyphOffset: ImVec2;
    GlyphRanges: *ImWchar;
    GlyphMinAdvanceX: float;
    GlyphMaxAdvanceX: float;
    MergeMode: bool;
    RasterizerFlags: u32;
    RasterizerMultiply: float;
    EllipsisChar: ImWchar;
    Name: [40]s8;
    DstFont: *ImFont;
}     

// Mirrors the C++ constructor for ImFontConfig
make_im_font_config :: () -> ImFontConfig {
    cfg : ImFontConfig = ---;
    // @TODO figure out why calling the constructor like this crashses
    // and use it instead of duplicating all the default values below.
    // ImFontConfig_ctor : (this: *ImFontConfig) #foreign imgui_lib "??0ImFontConfig@@QEAA@XZ";
    // ImFontConfig_ctor(*cfg);
    using cfg;
    FontData = null;
    FontDataSize = 0;
    FontDataOwnedByAtlas = true;
    FontNo = 0;
    SizePixels = 0.0;
    OversampleH = 3;
    OversampleV = 1;
    PixelSnapH = false;
    GlyphExtraSpacing = Vector2.{0.0, 0.0};
    GlyphOffset = Vector2.{0.0, 0.0};
    GlyphRanges = null;
    GlyphMinAdvanceX = 0;
    GlyphMaxAdvanceX = FLOAT32_MAX;
    MergeMode = false;
    RasterizerFlags = 0x00;
    RasterizerMultiply = 1.0;
    EllipsisChar = 0; // @TODO default in Imgui C++ is -1, do we want to cast/trunc or something?
    memset(Name.data, 0, size_of(type_of(Name)));
    DstFont = null;
    return cfg;
}


ImFontGlyph :: struct {
    Codepoint: u32;
    #place Codepoint; Visible: u32;
    AdvanceX: float;
    X0: float;
    Y0: float;
    X1: float;
    Y1: float;
    U0: float;
    V0: float;
    U1: float;
    V1: float;
}

ImFontGlyphRangesBuilder :: struct {
    UsedChars: ImVector(u32);

    AddRanges     :: (self: *ImFontGlyphRangesBuilder, ranges: *ImWchar) #foreign imgui_lib "?AddRanges@ImFontGlyphRangesBuilder@@QEAAXPEBG@Z";
    AddText       :: (self: *ImFontGlyphRangesBuilder, text: *u8, text_end: string = "") {
    _internal_AddText :: (self: *ImFontGlyphRangesBuilder, text: *u8, text_end: *u8) #foreign imgui_lib "?AddText@ImFontGlyphRangesBuilder@@QEAAXPEBD0@Z";
    _internal_AddText(self, text, text_end.data);
            }
}

IO :: struct {
    ConfigFlags_: ConfigFlags;
    BackendFlags_: BackendFlags;
    DisplaySize: ImVec2;
    DeltaTime: float;
    IniSavingRate: float;
    IniFilename: *u8;
    LogFilename: *u8;
    MouseDoubleClickTime: float;
    MouseDoubleClickMaxDist: float;
    MouseDragThreshold: float;
    KeyMap: [Key.COUNT]s32;
    KeyRepeatDelay: float;
    KeyRepeatRate: float;
    UserData: *void;
    Fonts: *ImFontAtlas;
    FontGlobalScale: float;
    FontAllowUserScaling: bool;
    FontDefault: *ImFont;
    DisplayFramebufferScale: ImVec2;
    ConfigDockingNoSplit: bool;
    ConfigDockingWithShift: bool;
    ConfigDockingAlwaysTabBar: bool;
    ConfigDockingTransparentPayload: bool;
    ConfigViewportsNoAutoMerge: bool;
    ConfigViewportsNoTaskBarIcon: bool;
    ConfigViewportsNoDecoration: bool;
    ConfigViewportsNoDefaultParent: bool;
    MouseDrawCursor: bool;
    ConfigMacOSXBehaviors: bool;
    ConfigInputTextCursorBlink: bool;
    ConfigWindowsResizeFromEdges: bool;
    ConfigWindowsMoveFromTitleBarOnly: bool;
    ConfigWindowsMemoryCompactTimer: float;
    BackendPlatformName: *u8;
    BackendRendererName: *u8;
    BackendPlatformUserData: *void;
    BackendRendererUserData: *void;
    BackendLanguageUserData: *void;
    GetClipboardTextFn: (user_data: *void) -> *u8 #c_call;
    SetClipboardTextFn: (user_data: *void, text: *u8) #c_call;
    ClipboardUserData: *void;
    RenderDrawListsFnUnused: *void;
    MousePos: ImVec2;
    MouseDown: [5]bool;
    MouseWheel: float;
    MouseWheelH: float;
    MouseHoveredViewport: ID;
    KeyCtrl: bool;
    KeyShift: bool;
    KeyAlt: bool;
    KeySuper: bool;
    KeysDown: [512]bool;
    NavInputs: [NavInput.COUNT]float;
    WantCaptureMouse: bool;
    WantCaptureKeyboard: bool;
    WantTextInput: bool;
    WantSetMousePos: bool;
    WantSaveIniSettings: bool;
    NavActive: bool;
    NavVisible: bool;
    Framerate: float;
    MetricsRenderVertices: s32;
    MetricsRenderIndices: s32;
    MetricsRenderWindows: s32;
    MetricsActiveWindows: s32;
    MetricsActiveAllocations: s32;
    MouseDelta: ImVec2;
    KeyMods: KeyModFlags;
    MousePosPrev: ImVec2;
    MouseClickedPos: [5]ImVec2;
    MouseClickedTime: [5]float64;
    MouseClicked: [5]bool;
    MouseDoubleClicked: [5]bool;
    MouseReleased: [5]bool;
    MouseDownOwned: [5]bool;
    MouseDownWasDoubleClick: [5]bool;
    MouseDownDuration: [5]float;
    MouseDownDurationPrev: [5]float;
    MouseDragMaxDistanceAbs: [5]ImVec2;
    MouseDragMaxDistanceSqr: [5]float;
    KeysDownDuration: [512]float;
    KeysDownDurationPrev: [512]float;
    NavInputsDownDuration: [NavInput.COUNT]float;
    NavInputsDownDurationPrev: [NavInput.COUNT]float;
    PenPressure: float;
    InputQueueSurrogate: ImWchar16;
    InputQueueCharacters: ImVector(ImWchar);

    AddInputCharacter          :: (self: *IO, c: u32) #foreign imgui_lib "?AddInputCharacter@ImGuiIO@@QEAAXI@Z";
    AddInputCharacterUTF16     :: (self: *IO, c: ImWchar16) #foreign imgui_lib "?AddInputCharacterUTF16@ImGuiIO@@QEAAXG@Z";
    AddInputCharactersUTF8     :: (self: *IO, str: *u8) #foreign imgui_lib "?AddInputCharactersUTF8@ImGuiIO@@QEAAXPEBD@Z";
    ClearInputCharacters       :: (self: *IO) #foreign imgui_lib "?ClearInputCharacters@ImGuiIO@@QEAAXXZ";
}

InputTextCallbackData :: struct {
    EventFlag: InputTextFlags;
    Flags: InputTextFlags;
    UserData: *void;
    EventChar: ImWchar;
    EventKey: Key;
    Buf: *u8;
    BufTextLen: s32;
    BufSize: s32;
    BufDirty: bool;
    CursorPos: s32;
    SelectionStart: s32;
    SelectionEnd: s32;

    DeleteChars     :: (self: *InputTextCallbackData, pos: s32, bytes_count: s32) #foreign imgui_lib "?DeleteChars@ImGuiInputTextCallbackData@@QEAAXHH@Z";
    InsertChars     :: (self: *InputTextCallbackData, pos: s32, text: *u8, text_end: string = "") {
    _internal_InsertChars :: (self: *InputTextCallbackData, pos: s32, text: *u8, text_end: *u8) #foreign imgui_lib "?InsertChars@ImGuiInputTextCallbackData@@QEAAXHPEBD0@Z";
    _internal_InsertChars(self, pos, text, text_end.data);
            }
}

ListClipper :: struct {
    DisplayStart: s32;
    DisplayEnd: s32;
    ItemsCount: s32;
    StepNo: s32;
    ItemsHeight: float;
    StartPosY: float;

    Begin     :: (self: *ListClipper, items_count: s32, items_height: float = 1.0) #foreign imgui_lib "?Begin@ImGuiListClipper@@QEAAXHM@Z";
    End       :: (self: *ListClipper) #foreign imgui_lib "?End@ImGuiListClipper@@QEAAXXZ";
    Step      :: (self: *ListClipper) -> bool #foreign imgui_lib "?Step@ImGuiListClipper@@QEAA_NXZ";
}

OnceUponAFrame :: struct {
    RefFrame: s32;
}

Payload :: struct {
    Data: *void;
    DataSize: s32;
    SourceId: ID;
    SourceParentId: ID;
    DataFrameCount: s32;
    DataType: [32+1]s8;
    Preview: bool;
    Delivery: bool;
}

PlatformIO :: struct {
    Platform_CreateWindow: (vp: *Viewport) #c_call;
    Platform_DestroyWindow: (vp: *Viewport) #c_call;
    Platform_ShowWindow: (vp: *Viewport) #c_call;
    Platform_SetWindowPos: (vp: *Viewport, pos: ImVec2) #c_call;
    Platform_GetWindowPos: (vp: *Viewport) -> ImVec2 #c_call;
    Platform_SetWindowSize: (vp: *Viewport, size: ImVec2) #c_call;
    Platform_GetWindowSize: (vp: *Viewport) -> ImVec2 #c_call;
    Platform_SetWindowFocus: (vp: *Viewport) #c_call;
    Platform_GetWindowFocus: (vp: *Viewport) -> bool #c_call;
    Platform_GetWindowMinimized: (vp: *Viewport) -> bool #c_call;
    Platform_SetWindowTitle: (vp: *Viewport, str: *u8) #c_call;
    Platform_SetWindowAlpha: (vp: *Viewport, alpha: float) #c_call;
    Platform_UpdateWindow: (vp: *Viewport) #c_call;
    Platform_RenderWindow: (vp: *Viewport, render_arg: *void) #c_call;
    Platform_SwapBuffers: (vp: *Viewport, render_arg: *void) #c_call;
    Platform_GetWindowDpiScale: (vp: *Viewport) -> float #c_call;
    Platform_OnChangedViewport: (vp: *Viewport) #c_call;
    Platform_SetImeInputPos: (vp: *Viewport, pos: ImVec2) #c_call;
    Platform_CreateVkSurface: (vp: *Viewport, vk_inst: u64, vk_allocators: *void, out_vk_surface: *u64) -> s32 #c_call;
    Renderer_CreateWindow: (vp: *Viewport) #c_call;
    Renderer_DestroyWindow: (vp: *Viewport) #c_call;
    Renderer_SetWindowSize: (vp: *Viewport, size: ImVec2) #c_call;
    Renderer_RenderWindow: (vp: *Viewport, render_arg: *void) #c_call;
    Renderer_SwapBuffers: (vp: *Viewport, render_arg: *void) #c_call;
    Monitors: ImVector(PlatformMonitor);
    MainViewport: *Viewport;
    Viewports: ImVector(*Viewport);
}

PlatformMonitor :: struct {
    MainPos: ImVec2;
    MainSize: ImVec2;
    WorkPos: ImVec2;
    WorkSize: ImVec2;
    DpiScale: float;
}

SizeCallbackData :: struct {
    UserData: *void;
    Pos: ImVec2;
    CurrentSize: ImVec2;
    DesiredSize: ImVec2;
}

Storage :: struct {
    Data: ImVector(StoragePair);

    BuildSortByKey     :: (self: *Storage) #foreign imgui_lib "?BuildSortByKey@ImGuiStorage@@QEAAXXZ";
    GetBool            :: (self: *Storage, key: ID, default_val: bool = false) -> bool #foreign imgui_lib "?GetBool@ImGuiStorage@@QEBA_NI_N@Z";
    GetBoolRef         :: (self: *Storage, key: ID, default_val: bool = false) -> *bool #foreign imgui_lib "?GetBoolRef@ImGuiStorage@@QEAAPEA_NI_N@Z";
    GetFloat           :: (self: *Storage, key: ID, default_val: float = 0.0) -> float #foreign imgui_lib "?GetFloat@ImGuiStorage@@QEBAMIM@Z";
    GetFloatRef        :: (self: *Storage, key: ID, default_val: float = 0.0) -> *float #foreign imgui_lib "?GetFloatRef@ImGuiStorage@@QEAAPEAMIM@Z";
    GetInt             :: (self: *Storage, key: ID, default_val: s32 = 0) -> s32 #foreign imgui_lib "?GetInt@ImGuiStorage@@QEBAHIH@Z";
    GetIntRef          :: (self: *Storage, key: ID, default_val: s32 = 0) -> *s32 #foreign imgui_lib "?GetIntRef@ImGuiStorage@@QEAAPEAHIH@Z";
    GetVoidPtr         :: (self: *Storage, key: ID) -> *void #foreign imgui_lib "?GetVoidPtr@ImGuiStorage@@QEBAPEAXI@Z";
    GetVoidPtrRef      :: (self: *Storage, key: ID, default_val: *void = null) -> **void #foreign imgui_lib "?GetVoidPtrRef@ImGuiStorage@@QEAAPEAPEAXIPEAX@Z";
    SetAllInt          :: (self: *Storage, val: s32) #foreign imgui_lib "?SetAllInt@ImGuiStorage@@QEAAXH@Z";
    SetBool            :: (self: *Storage, key: ID, val: bool) #foreign imgui_lib "?SetBool@ImGuiStorage@@QEAAXI_N@Z";
    SetFloat           :: (self: *Storage, key: ID, val: float) #foreign imgui_lib "?SetFloat@ImGuiStorage@@QEAAXIM@Z";
    SetInt             :: (self: *Storage, key: ID, val: s32) #foreign imgui_lib "?SetInt@ImGuiStorage@@QEAAXIH@Z";
    SetVoidPtr         :: (self: *Storage, key: ID, val: *void) #foreign imgui_lib "?SetVoidPtr@ImGuiStorage@@QEAAXIPEAX@Z";
}

StoragePair :: struct {
    key: ID;
}

Style :: struct {
    Alpha: float;
    WindowPadding: ImVec2;
    WindowRounding: float;
    WindowBorderSize: float;
    WindowMinSize: ImVec2;
    WindowTitleAlign: ImVec2;
    WindowMenuButtonPosition: Dir;
    ChildRounding: float;
    ChildBorderSize: float;
    PopupRounding: float;
    PopupBorderSize: float;
    FramePadding: ImVec2;
    FrameRounding: float;
    FrameBorderSize: float;
    ItemSpacing: ImVec2;
    ItemInnerSpacing: ImVec2;
    TouchExtraPadding: ImVec2;
    IndentSpacing: float;
    ColumnsMinSpacing: float;
    ScrollbarSize: float;
    ScrollbarRounding: float;
    GrabMinSize: float;
    GrabRounding: float;
    LogSliderDeadzone: float;
    TabRounding: float;
    TabBorderSize: float;
    TabMinWidthForUnselectedCloseButton: float;
    ColorButtonPosition: Dir;
    ButtonTextAlign: ImVec2;
    SelectableTextAlign: ImVec2;
    DisplayWindowPadding: ImVec2;
    DisplaySafeAreaPadding: ImVec2;
    MouseCursorScale: float;
    AntiAliasedLines: bool;
    AntiAliasedLinesUseTex: bool;
    AntiAliasedFill: bool;
    CurveTessellationTol: float;
    CircleSegmentMaxError: float;
    Colors: [Col.COUNT]ImVec4;

    ScaleAllSizes     :: (self: *Style, scale_factor: float) #foreign imgui_lib "?ScaleAllSizes@ImGuiStyle@@QEAAXM@Z";
}

TextBuffer :: struct {
    Buf: ImVector(s8);

    append      :: (self: *TextBuffer, str: *u8, str_end: string = "") {
    _internal_append :: (self: *TextBuffer, str: *u8, str_end: *u8) #foreign imgui_lib "?append@ImGuiTextBuffer@@QEAAXPEBD0@Z";
    _internal_append(self, str, str_end.data);
            }
    appendf     :: (self: *TextBuffer, fmt: *u8, args: ..Any) #foreign imgui_lib "?appendf@ImGuiTextBuffer@@QEAAXPEBDZZ";
}

TextFilter :: struct {
    InputBuf: [256]s8;
    Filters: ImVector(TextRange);
    CountGrep: s32;

    Build          :: (self: *TextFilter) #foreign imgui_lib "?Build@ImGuiTextFilter@@QEAAXXZ";
    Draw           :: (self: *TextFilter, label: string = "Filter(inc,-exc)", width: float = 0.0) -> bool {
    _internal_Draw :: (self: *TextFilter, label: *u8, width: float) -> bool #foreign imgui_lib "?Draw@ImGuiTextFilter@@QEAA_NPEBDM@Z";
    return _internal_Draw(self, label.data, width);
            }
    PassFilter     :: (self: *TextFilter, text: *u8, text_end: string = "") -> bool {
    _internal_PassFilter :: (self: *TextFilter, text: *u8, text_end: *u8) -> bool #foreign imgui_lib "?PassFilter@ImGuiTextFilter@@QEBA_NPEBD0@Z";
    return _internal_PassFilter(self, text, text_end.data);
            }
}

TextRange :: struct {
    b: *u8;
    e: *u8;
}

Viewport :: struct {
    ID_: ID;
    Flags: ViewportFlags;
    Pos: ImVec2;
    Size: ImVec2;
    WorkOffsetMin: ImVec2;
    WorkOffsetMax: ImVec2;
    DpiScale: float;
    DrawData: *ImDrawData;
    ParentViewportId: ID;
    RendererUserData: *void;
    PlatformUserData: *void;
    PlatformHandle: *void;
    PlatformHandleRaw: *void;
    PlatformRequestMove: bool;
    PlatformRequestResize: bool;
    PlatformRequestClose: bool;
    GetCenter      :: (using self: *Viewport) -> ImVec2 { return make_ImVec2(Pos.x + Size.x * 0.5, Pos.y + Size.y * 0.5); }
    GetWorkPos     :: (using self: *Viewport) -> ImVec2 { return make_ImVec2(Pos.x + WorkOffsetMin.x, Pos.y + WorkOffsetMin.y); }
    GetWorkSize    :: (using self: *Viewport) -> ImVec2 { return make_ImVec2(Size.x - WorkOffsetMin.x + WorkOffsetMax.x, Size.y - WorkOffsetMin.y + WorkOffsetMax.y); } // This not clamped
}

WindowClass :: struct {
    ClassId: ID;
    ParentViewportId: ID;
    ViewportFlagsOverrideSet: ViewportFlags;
    ViewportFlagsOverrideClear: ViewportFlags;
    DockNodeFlagsOverrideSet: DockNodeFlags;
    DockNodeFlagsOverrideClear: DockNodeFlags;
    DockingAlwaysTabBar: bool;
    DockingAllowUnclassed: bool;
}

USE_MATH_MODULE :: true; // @TODO should be a module parameter?
#if USE_MATH_MODULE {
    #import "Math";
    ImVec2 :: Vector2;
    ImVec4 :: Vector4;
} else {
    ImVec2 :: struct {
        x: float;
        y: float;
    }
    
    ImVec4 :: struct {
        x: float;
        y: float;
        z: float;
        w: float;
    }
}

Context :: struct { data: *void; }

ImVector :: struct(T: Type) {
    Size:     s32;
    Capacity: s32;
    Data:     *T;
}

ImPool :: struct(T: Type) {
    Buf: ImVector(T);
    Map: Storage;
    FreeIdx: ImPoolIdx;
}

ImChunkStream :: struct(T: Type) {
    Buf: ImVector(s8);
}

ImPoolIdx :: s32;
ImTextureID :: *void;
ImDrawIdx :: u16;
ImFileHandle :: *void;
ImGuiID :: u32;
ID :: u32;
ImDrawCallback :: #type (parent_list: *ImDrawList, cmd: *ImDrawCmd) #c_call;
InputTextCallback :: #type (data: *InputTextCallbackData) -> s32 #c_call;
SizeCallback :: #type (data: *SizeCallbackData) #c_call;
ImWchar16 :: u16;
ImWchar32 :: u32;

IMGUI_USE_WCHAR32 :: false; // TODO: Module parameter

#if IMGUI_USE_WCHAR32
    ImWchar :: ImWchar32;
else
    ImWchar :: ImWchar16;

make_ImVec2 :: inline (a: float, b: float) -> ImVec2 {
    v: ImVec2 = ---;
    v.x = a;
    v.y = b;
    return v;
}

TreeNode :: (fmt: string, args: ..Any) -> bool {
    fmt_z := tprint("%\0", fmt);
    txt := tprint(fmt_z, ..args);
    return TreeNode(txt.data);
}

IM_COL32_R_SHIFT  ::  0;
IM_COL32_G_SHIFT  ::  8;
IM_COL32_B_SHIFT  ::  16;
IM_COL32_A_SHIFT  ::  24;
IM_COL32_A_MASK   ::  0xFF000000;
// This is a C preprocessor macro, should it be a Jai macro?
make_col32 :: (R : u32, G: u32, B: u32, A: u32) -> u32 {
    return cast(u32)((A<<IM_COL32_A_SHIFT) | (B<<IM_COL32_B_SHIFT) | 
        (G<<IM_COL32_G_SHIFT) | (R<<IM_COL32_R_SHIFT));
}

#scope_file

#import "Basic";

FLT_MAX :: 0h7F7FFFFF;

#if OS == .WINDOWS
    imgui_lib :: #foreign_library "win/imgui";
else
    #assert(false);


