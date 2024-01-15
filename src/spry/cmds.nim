# @deps std
from std/sets import HashSet, items, toHashSet
from std/sequtils import anyIt
# @deps ndk
import nstd/opts
# @deps spry
import ./types

# @section Basic functionality for commands
func `==` *(id :string; cmd :Cmd) :bool= cmd.id == id
func contains *(list :CmdList; id :string) :bool=  list.anyIt( it.id == id )

# @section Known commands list
const Known :CmdList= [
  Cmd(id:"nim"      , kind:Passthrough),
  Cmd(id:"zig"      , kind:Passthrough),
  Cmd(id:"nimble"   , kind:Passthrough),
  Cmd(id:"minc"     , kind:Passthrough),
  Cmd(id:"any"      , kind:Compile),
  Cmd(id:"init"     , kind:Keyword), # Search for srcDir/init.nim and run it
  Cmd(id:"build"    , kind:Keyword), # Search for srcDir/build.nim and run it
  Cmd(id:"tests"    , kind:Keyword), # Search for srcDir/tests.nim and run it
  Cmd(id:"example"  , kind:Keyword), # Search for srcDir/examples.nim and run it with the given trg
  Cmd(id:"examples" , kind:Keyword), # Search for srcDir/examples.nim and run it
  Cmd(id:"clean"    , kind:Keyword), # Search for srcDir/clean.nim and run it
  # else: Search for srcDir/clean.nim and run it
  #     : build, tests, examples
  ].toHashSet # << cmds.Known
  # TODO: push & tag : https://github.com/beef331/graffiti/blob/master/src/graffiti.nim
#___________________
func isKnown *(id :string) :bool= id in Known
func isKnown *(cli :opts.CLI) :bool= cli.args[0].isKnown
func isEmpty *(cli :opts.CLI) :bool= cli.args.len == 0

#___________________
func get *(list :CmdList; id :string) :Cmd=
  for it in list:
    if it.id == id: return it
func getFrom *(cli :opts.CLI) :Cmd=
  if   cli.isEmpty: return
  elif cli.args[0] in Known: result = Known.get( cli.args[0] )
  else: result = Cmd(id:cli.args[0], kind:Search)
#___________________
func kind *(id :string) :CmdKind= Known.get(id).kind

