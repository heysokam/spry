# @deps std
from std/sets import HashSet, items
# @deps spry
import ./types

# @section Basic functionality for commands
func `==` *(id :string; cmd :Cmd) :bool= cmd.id == id
func contains *(list :CmdList; id :string) :bool=  list.anyIt( it.id == id )

# @section Known commands list
const Known :CmdList= {
  Cmd(id:"nim"      , kind:Passthrough),
  Cmd(id:"zig"      , kind:Passthrough),
  Cmd(id:"nimble"   , kind:Passthrough),
  Cmd(id:"any"      , kind:Compile),
  Cmd(id:"build"    , kind:Keyword), # Search for srcDir/build.nim and run it
  Cmd(id:"tests"    , kind:Keyword), # Search for srcDir/tests.nim and run it
  Cmd(id:"example"  , kind:Keyword), # Search for srcDir/examples.nim and run it with the given trg
  Cmd(id:"examples" , kind:Keyword), # Search for srcDir/examples.nim and run it
  Cmd(id:"clean"    , kind:Keyword), # Search for srcDir/clean.nim and run it
  # else: Search for srcDir/clean.nim and run it
  #     : build, tests, examples
  } # << cmds.Known
func get *(list :CmdList; id :string) :Cmd=
  for it in Known:
    if it.id == id: return it
func kind *(id :string) :CmdKind= Known.get(id).kind
