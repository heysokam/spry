# @section Package Info
author      = "Ivan Mar (.sOkam!)"
description = "spry | Nimble, brisk and lively package manager for nim <3"
license     = "LGPL-3.0-or-later"
include ./src/spry/nims
# @section Dependencies
require "nim"
require "assume", "https://github.com/disruptek/assume", ""
require "nimscripter", "https://github.com/beef331/nimscripter"

when defined(run)   : runTask()
when defined(build) : buildTask()
