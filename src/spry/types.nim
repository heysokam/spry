# @deps std
from std/sets import HashSet

# @section Commands
const CmdKind * = enum Search, Keyword, Passthrough, Compile
type Cmd * = object
  id    *:string
  kind  *:CmdKind
type CmdList = HashSet[Cmd]
