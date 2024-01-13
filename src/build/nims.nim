#_________________________________________________
# @section Include guards
#_____________________________
when not defined(nimscript) or not defined(nimspry):
  {.error: "This file can only be included/imported into a nimscript or spry configuration file".}
# @deps std
from std/os import `/`, absolutePath, parentDir
from std/strformat import `&`
from std/strutils import join
from std/sets import HashSet, incl, items, len
from std/sequtils import toSeq


#_________________________________________________
# @section Caller Script Configuration
#_____________________________
let rootDir = absolutePath( currentSourcePath().parentDir()/".."/".." )
packageName = projectName()
srcDir      = rootDir/"src"
binDir      = rootDir/"bin"
bin         = @["build"]
let libDir  = srcDir/"lib"
version     = if version != "": version else:"0.0.0"  # Only used for the builder

#_________________________________________________
# @section Helpers Configuration
#_____________________________
when not declared(verbose):
  var verbose = on 
var prefix  = "spry: "
var nimURL  = "https://github.com/nim-lang/Nim"
var nimVer  = "version-2-0"
var nimDir  = binDir/".nim"
var nimBin  = nimDir/"bin"/"nim"
var gitBin  = "git"

#_________________________________________________
# @section Shell tools
#_____________________________
proc sh *(cmd :string; args :varargs[string,`$`]) :void= exec cmd&" "&args.join(" ")
proc git *(args :varargs[string,`$`]) :void= sh gitBin, args.join(" ")
#_________________________________________________
# @section Logging tools
#_____________________________
proc info *(args :varargs[string,`$`]) :void= echo prefix & args.join(" ")
proc dbg *(args :varargs[string,`$`]) :void=
  if verbose: info args.join(" ")
#_________________________________________________
# @section Nim tools
#_____________________________
var deps {.global, threadvar.}:HashSet[string]
proc nim  *(opts :varargs[string,`$`]) :void=
  let cmd = nimBin&" "&opts.join(" ")
  dbg "Running nim with command:\n  ",cmd
  exec cmd
proc nimc *(opts :varargs[string,`$`]) :void=
  if not fileExists(binDir/".gitignore"): writeFile(binDir/".gitignore", "*\n!.gitignore")
  let paths :string= if deps.len > 0: "--path:" & deps.toSeq.join(" --path:") else: ""
  let mode = when defined(release): "-d:release" elif defined(danger): "-d:danger" else: "-d:debug"
  nim &"c {mode} --hints:off --outDir:{binDir} {paths} "&opts.join(" ")
proc nimInstall (vers :string= nimVer) :void=
  if nimDir.dirExists: return
  info "Installing nim",vers
  git "clone", nimURL, nimDir, "-b", vers, "--depth 1"
  withDir nimDir: sh "./build_all.sh"
  info "Done installing nim."

#_________________________________________________
# @section Dependency Management
#_____________________________
proc require *(name :string; url :string= ""; code :string= "src"; shallow :bool= true) :void=
  case name
  of "nim","nim stable", "nim latest" : nimInstall()        ; return
  of "nim devel"                      : nimInstall "devel"  ; return
  else:discard
  deps.incl absolutePath( libDir/name/code )
  if not fileExists(libDir/".gitignore") : writeFile(libDir/".gitignore", "*\n!.gitignore")
  if not dirExists(libDir/name)          : git "clone", &"{url} {libDir/name}", if shallow: " --depth 1" else: ""


#_________________________________________________
# @section Buildsystem Initialization task
#_____________________________
# Build task default
template beforeBuild=
  info &"Starting to build the confy.Builder for {packageName} v{version} ..."
template afterBuild=
  info &"Done building the {packageName}'s confy.Builder."
proc build=
  beforeBuild()
  for it in bin: nimc &"{srcDir/it}"
  afterBuild()

