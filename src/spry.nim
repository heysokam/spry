# @deps std
from std/os import commandLineParams
from std/strutils import join
# @deps External
# import nimscripter
# @deps ndk
import confy/cfg
import confy/tool/helper
import confy/builder/nim
import confy/builder/zigcc/zcfg as zig
import nstd/opts
# @deps spry
import ./spry/types
import ./spry/cmds

proc run (kind :CmdKind; cli :opts.CLI) :void=
  case kind
  of Passthrough:
    let args :string= " "&os.commandLineParams()[1..^1].join(" ")
    let cmd = case cli.args[0]
      of "nim"    : nim.getRealBin & args
      of "nimble" : nim.getRealNimble & args
      of "zig"    : zig.getRealBin & args
      of "minc"   : "minc "&args
      else:""
    sh cmd
  else: return

when isMainModule:
  let cli = opts.getCLI()
  cmds.getFrom(cli).kind.run(cli)
