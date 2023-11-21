import pkg/winim/lean

echo repr FindWindowW(NULL, "winim")

type
  WindowHandle = object
    hWnd: HWND

const
    NotTop = HWND_NOTOPMOST
    TopMost = HWND_TOPMOST
    Top = HWND_TOP
    Bottom = HWND_BOTTOM

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

proc makeTopMost*(win: WindowHandle) =
  setWindowPos(win, TopMost)
proc undoTopMost*(win: WindowHandle) =
  setWindowPos(win, NotTop)


when isMainModule:
  let window = findWindow("winim")
  # makeTopMost(window)
  undoTopMost(window)
