# @section Package Info
author      = "Ivan Mar (.sOkam!)"
description = "ᛊ spry | Nimble, brisk and lively package manager ❣"
license     = "LGPL-3.0-or-later"
include ./src/build/nims
# @section Dependencies
require "nim"
require "zippy",       "https://github.com/treeform/zippy"
require "jsony",       "https://github.com/treeform/jsony"
require "confy",       "https://github.com/heysokam/confy"
require "nstd",        "https://github.com/heysokam/nstd"
# @section Build Tasks
when defined(build) : build()
