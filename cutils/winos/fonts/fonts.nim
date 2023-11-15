import pkg/winim/lean

func loadFont*(s: string): bool {.discardable.} =
  ## Loads the font at path 's' and returns a bool val for whether
  ## it was successful or not
  AddFontResourceA(s) > 0

