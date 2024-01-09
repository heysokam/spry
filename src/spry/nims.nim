#_________________________________________________
# @section Include guards
#_____________________________
when not defined(nimscript) or not defined(nimspry):
  {.error: "This file can only be included/imported into a nimscript or spry configuration file".}

# @deps std
from std/os import `/`, splitFile
from std/strformat import `&`
from std/strutils import join
from std/sets import HashSet, incl, items
from std/sequtils import toSeq


#_________________________________________________
# @section Sane project defaults
#_____________________________
# Default nimscript
packageName = projectName()
version     = "0.0.0"
srcDir      = "src"
binDir      = "bin"
bin         = if packageName != "": @[packageName] else: @[]
#_____________________________
# spry nimscript extensions
when not declared(verbose):
  var verbose * = off
var prefix  * = packageName&": "
var libDir  * = srcDir/"lib"
var nimURL  * = "https://github.com/nim-lang/Nim"
var nimVer  * = "version-2-0"
var nimDir  * = binDir/".nim"
var nimBin  * = nimDir/"bin"/"nim"
var zigDir  * = binDir/".zig"
var zigBin  * = nimDir/"zig"
var gitBin  * = "git"

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
var deps :HashSet[string]
proc nim  *(opts :varargs[string,`$`]) :void=  exec nimBin&" "&opts.join(" ")
proc nimc *(opts :varargs[string,`$`]) :void=
  if not fileExists(binDir/".gitignore"): writeFile(binDir/".gitignore", "*\n!.gitignore")
  let paths :string= "--path:" & deps.toSeq.join(" --path:")
  nim &"c --outDir:{binDir} {paths} "&opts.join(" ")
proc nimInstall (vers :string= nimVer) :void=
  if nimDir.dirExists: return
  info "Installing nim",vers
  git "clone", nimURL, nimDir, "-b", vers, "--depth 1"
  withDir nimDir: sh "./build_all.sh"
  info "Done installing nim."


#_________________________________________________
# @section Dependency management
#_____________________________
proc require *(name :string; url :string= ""; shallow :bool= true) :void=
  case name
  of "nim","nim stable", "nim latest" : nimInstall()        ; return
  of "nim devel"                      : nimInstall "devel"  ; return
  deps.incl url
  if not fileExists(libDir/".gitignore") : writeFile(libDir/".gitignore", "*\n!.gitignore")
  if not dirExists(libDir/name)          : git "clone", &"{url} {libDir/name}", if shallow: " --depth 1" else: ""


#_________________________________________________
# @section Overridable buildsystem tasks
#_____________________________
# Build task default
when not declared(beforeBuild):
  template beforeBuild= discard
when not declared(afterBuild):
  template afterBuild= discard
when not declared(buildTask):
  task build, &"Build {packageName}":
    beforeBuild()
    for it in bin: nimc &"{srcDir/it}"
    afterBuild()
#_____________________________
# Run task default
when not declared(beforeRun):
  template beforeRun= discard
when not declared(afterRun):
  template afterRun= discard
when not declared(runTask):
  task run, &"Build and run {packageName}":
    beforeRun()
    for it in bin: nimc &"-r {srcDir/it}"
    afterRun()

