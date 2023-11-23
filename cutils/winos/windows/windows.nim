import pkg/winim/lean
import ./spec




proc `$`*(windowHandle: WindowHandle): string =
  result = $(WindowHandle.hWnd)
proc `==`*(wx, wy: WindowHandle): bool =
  wx.hWnd == wy.hWnd

proc findWindow*(windowName: string): WindowHandle =
  let hwnd = FindWindowW(NULL, windowName)
  return WindowHandle(hWnd: hwnd)
proc isValid*(window: WindowHandle): bool =
  result = IsWindow(window.hWnd)

proc setFocus*(window: WindowHandle): WindowHandle {.discardable.} =
  let hWnd = SetFocus(window.hWnd)
  result = WindowHandle(hWnd: hWnd)
proc getFocus*(): WindowHandle =
  # TODO handle exceptions
  result = WindowHandle(
    hWnd: GetFocus()
  )

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

proc getLayeredWindowAttributes(window: WindowHandle) =
  discard
proc showWindow(window: WindowHandle): bool =
  discard
proc updateLayeredWindow(window: WindowHandle): bool =
  discard
proc bringToTop(window: WindowHandle): bool =
  discard


proc getActiveWindow(): WindowHandle =
  # FIXME this gives an invalid window handle?
  result = WindowHandle(
    hWnd: GetActiveWindow()
  )
proc updateWindow(window: WindowHandle): bool =
  result = UpdateWindow(window.hWnd)
proc setActiveWindow(window: WindowHandle): WindowHandle {.discardable.} =
  let hWnd = SetActiveWindow(window.hWnd)
  result = WindowHandle(hWnd: hWnd)
proc getForegroundWindow(): WindowHandle =
  result = WindowHandle(
    hWnd: GetForegroundWindow()
  )
proc switchToWindow(window: WindowHandle): bool =
  discard
proc setForegroundWindow(window: WindowHandle): bool =
  discard
proc redraw(window: WindowHandle): bool =
  discard


proc setLayeredWindowAttributes(window: WindowHandle): bool {.discardable.} =
  let res = SetLayeredWindowAttributes(window.hWnd, 0x00FFFFFF, 125, LWA_ALPHA or LWA_COLORKEY)
  if res != 0:
    result = true
  else:
    result = false
    echo "Failed to set layered window attributes: ", window.hWnd


proc makeTopMost*(win: WindowHandle) =
  setWindowPos(win, spec.WindowPos.TopMost)
proc undoTopMost*(win: WindowHandle) =
  setWindowPos(win, spec.WindowPos.NotTop)

import std/colors
when isMainModule:
  let window = getForegroundWindow()
  let window2 = getActiveWindow()
  echo window == window2
  echo isValid window
  var windowInfo: PWINDOWINFO = create(WINDOWINFO)
  discard GetWindowInfo(window.hWnd, windowInfo)
  echo repr windowInfo
#   let window = findWindow("winim")
#   makeWindowLayered window
#   setLayeredWindowAttributes window
#   makeTopMost window
#   # makeTopMost(window)
#   # undoTopMost(window)
