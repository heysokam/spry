# @deps std
from std/os import commandLineParams
from std/strutils import join
from std/strformat import `&`
# @deps External
# import nimscripter
# @deps ndk
from   confy/cfg import nil
import confy/types
import confy/builder/nim
import confy/builder/zigcc/zcfg as zig
import confy/task/deps
import nstd/opts
import nstd/shell
import nstd/paths
from   nstd/logger as l import nil
# @deps spry
import ./spry/types
import ./spry/cmds

# @section Error Management
type SpryRunError * = object of CatchableError
proc err (args :varargs[string, `$`]) :void=  l.fatal( args.join(" ") ); quit(142)

# @section MinC Managemen.
#  TODO: Move to confy
proc mincGetRealBin :Path=
  if cfg.mincDir.dirExists: cfg.mincDir/"bin"/"minc" else: Path"minc"

# @section Entry Point Logic
proc run (cli :opts.CLI) :void=
  var cmd  :string
  let args :string=
    if os.commandLineParams().len > 1: " "&os.commandLineParams()[1..^1].join(" ")
    else:""
  case cmds.getFrom(cli).kind
  of Passthrough:
    cmd = case cli.args[0]
      of "nim"    : nim.getRealBin & args
      of "nimble" : nim.getRealNimble & args
      of "zig"    : zig.getRealBin & args
      of "minc"   : mincGetRealBin().string & args
      else:""
  of Keyword:
    # This section is technically a generic build.nim file
    # Instead of building the user app directly, this task builds and runs the user's confy builder named `keyword`
    if not cfg.libDir.dirExists: md cfg.libDir
    let paths :string= Dependencies.new(
      deps.submodule( "zippy", "https://github.com/treeform/zippy" ),
      deps.submodule( "jsony", "https://github.com/treeform/jsony" ),
      deps.submodule( "confy", "https://github.com/heysokam/confy" ),
      deps.submodule( "nstd",  "https://github.com/heysokam/nstd"  ),
      ).to(Nim) # << Dependencies.new( ... )
    cmd = nim.getRealBin & &" c -r --hints:off {paths} --outDir:{cfg.binDir} {cfg.srcDir/cli.args[0]}"
  of Compile:
    cmd = nim.getRealBin & &" c -r --hints:off --outDir:{cfg.binDir} {cfg.rootDir/cli.args[1]}"
  else: return
  if cmd == "": return
  sh cmd
  if cli.args[0] == "any":
    rm cfg.binDir/Path(cli.args[1]).splitFile.name

# @section Entry Point
when isMainModule:
  # Initialize Confy configuration
  cfg.rootDir       = getCurrentDir()
  cfg.srcDir        = cfg.rootDir/"src"
  cfg.binDir        = cfg.rootDir/"bin"
  cfg.libDir        = cfg.binDir/".lib"  # Hide libDir inside binDir for confy
  cfg.mincDir       = cfg.binDir/".minc"
  cfg.nim.systemBin = off
  # Run the process
  let cli = opts.getCLI()
  cli.run()

