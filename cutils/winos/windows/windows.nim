import pkg/winim/lean

type
  WindowHandle* = object
    hWnd: HWND

# Create enums so that i can hash set this bs
type
  WindowPos* {.pure, size: sizeof(HWND).} = enum
    NotTop = HWND_NOTOPMOST
    TopMost = HWND_TOPMOST
    Top = HWND_TOP
    Bottom = HWND_BOTTOM

  WindowStyle* {.pure, size: sizeof(DWORD).} = enum
    Left = WS_EX_LEFT # 0
    # RightScrollBar = WS_EX_RIGHTSCROLLBAR # 0
    # LtrReading = WS_EX_LTRREADING # 0
    DlgModalFrame = WS_EX_DLGMODALFRAME # 1
    NoParentNotify = WS_EX_NOPARENTNOTIFY # 4
    TopMost = WS_EX_TOPMOST # 8
    AcceptFiles = WS_EX_ACCEPTFILES # 16
    Transparent = WS_EX_TRANSPARENT # 32
    MdiChild = WS_EX_MDICHILD # 64
    ToolWindow = WS_EX_TOOLWINDOW # 128
    WindowEdge = WS_EX_WINDOWEDGE # 256
    ClientEdge = WS_EX_CLIENTEDGE # 512
    ContextHelp = WS_EX_CONTEXTHELP # 1024
    Right = WS_EX_RIGHT # 4096
    RtlReading = WS_EX_RTLREADING # 8192
    LeftScrollBar = WS_EX_LEFTSCROLLBAR # 16384
    ControlParent = WS_EX_CONTROLPARENT # 65536
    StaticEdge = WS_EX_STATICEDGE # 131072
    AppWindow = WS_EX_APPWINDOW # 262144
    Layered = WS_EX_LAYERED # 524288
    NoInheritLayour = WS_EX_NOINHERITLAYOUT # 1048576
    NoRedirectionBitMap = WS_EX_NOREDIRECTIONBITMAP # 2097152
    LayoutRtl = WS_EX_LAYOUTRTL # 4_194_304
    Composited = WS_EX_COMPOSITED # 33_554_432
    NoActivate = WS_EX_NOACTIVATE # 134_217_728

  WindowLong* {.pure, size: sizeof(int).} = enum
    UserData = GWLP_USERDATA
    Style = GWL_EXSTYLE
    oldStyle = GWL_STYLE
    Id = GWLP_ID
    HInstance = GWLP_HINSTANCE
    WndProc = GWLP_WNDPROC
  WindowLongs* = set[WindowLong]

converter toDWORD(windowStyle: WindowStyle): DWORD = DWORD(windowStyle)
proc toWindowStyle(dword: DWORD): WindowStyle = WindowStyle(dword)
converter toHWND(windowPos: WindowPos): HWND = HWND(windowPos)
proc toWindowPos(hwnd: HWND): WindowPos = WindowPos(hwnd)

proc `$`*(windowHandle: WindowHandle): string =
  result = $(WindowHandle.hWnd)

proc findWindow*(windowName: string): WindowHandle =
  let hwnd = FindWindowW(NULL, windowName)
  return WindowHandle(hWnd: hwnd)

proc setWindowPos(window: WindowHandle, pos: HWND; x,y,cx,cy: int32 = 0): bool {.discardable.} =
  let uFlags = SWP_NOMOVE or SWP_NOSIZE
  let res = SetWindowPos(window.hWnd, pos, x,y,cx,cy, UINT(uFlags))

  try:
    result = bool(res)
  except:
    result = false

proc makeWindowLayered(window: WindowHandle): bool {.discardable.} =
  let res = SetWindowLongPtrA(window.hWnd, GWL_EXSTYLE, WS_EX_LAYERED)
  if res != 0:
    result = true
  else:
    result = false
    echo "Failed to make window layered: ", window.hWnd

# Might need to use the SetForegroundWindow function to prelude the SetWindowPos to
# make sure it works as intended. Some interaction where the window must be brought
# to the foreground first or the TOPMOST flag doesnt work?

proc setLayeredWindowAttributes(window: WindowHandle): bool {.discardable.} =
  let res = SetLayeredWindowAttributes(window.hWnd, 0x00FFFFFF, 125, LWA_ALPHA or LWA_COLORKEY)
  if res != 0:
    result = true
  else:
    result = false
    echo "Failed to set layered window attributes: ", window.hWnd


proc makeTopMost*(win: WindowHandle) =
  setWindowPos(win, WindowPos.TopMost)
proc undoTopMost*(win: WindowHandle) =
  setWindowPos(win, WindowPos.NotTop)

# when isMainModule:
#   let window = findWindow("winim")
#   makeWindowLayered window
#   setLayeredWindowAttributes window
#   makeTopMost window
#   # makeTopMost(window)
#   # undoTopMost(window)
