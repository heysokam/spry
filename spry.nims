# @section Package Info
author      = "Ivan Mar (.sOkam!)"
description = "ᛊ spry | Nimble, brisk and lively package manager ❣"
license     = "LGPL-3.0-or-later"
include ./src/spry/nims
# @section Dependencies
require "nim"
require "assume",      "https://github.com/disruptek/assume", ""
require "nimscripter", "https://github.com/beef331/nimscripter"
require "zippy",       "https://github.com/treeform/zippy"
require "jsony",       "https://github.com/treeform/jsony"
require "yaml",        "https://github.com/flyx/NimYAML", ""
require "confy",       "https://github.com/heysokam/confy"

when defined(run)   : runTask()
when defined(build) : buildTask()
