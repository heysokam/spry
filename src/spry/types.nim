# @deps std
from std/sets import HashSet

# @section Commands
type CmdKind * = enum Empty, Search, Keyword, Passthrough, Compile
type Cmd * = object
  id    *:string
  kind  *:CmdKind
type CmdList * = HashSet[Cmd]
