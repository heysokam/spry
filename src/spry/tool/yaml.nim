# @deps std
import std/streams
# @deps External
import yaml

#______________________________
type YamlCfg = object
  tags     :TagStyle
  handles  :seq[tuple[handle, uriPrefix: string]]
  anchor   :AnchorStyle
  opts     :PresentationOptions
#______________________________
const ycfg = YamlCfg(
  tags              : tsNone,         # tagStyle = tsNone   removes the "!n!system:seq..." stuff
  handles           : @[],            # handles  = @[]      removes the "%TAG..." line
  anchor            : asTidy,         # Anchors will only be generated for objects that occur more than once.
  opts              : defineOptions(
    style           = psDefault,      # As human-readable as possible
    indentationStep = 2,              # Use two spaces as indentation
    newlines        = nlLF,           # Use a single linefeed char as newline.
    outputVersion   = ov1_2           # Use YAML 1.2
    ) # << defineOptions( ... )
  ) # << YamlCfg( ... )

#______________________________
proc dump*[T](value :T; target :Stream; cfg :YamlCfg) :void {.raises: [YamlPresenterJsonError, YamlPresenterOutputError, YamlSerializationError].}=
  ## Dump a Nim value as YAML character stream to the given Stream, using the given YamlCfg options
  yaml.dump(value = value, target = target, tagStyle = cfg.tags, anchorStyle = cfg.anchor, options = cfg.opts, handles = cfg.handles)
#______________________________
proc dump*[T](value :T; target :Stream) :void {.raises: [YamlPresenterJsonError, YamlPresenterOutputError, YamlSerializationError].}=
  ## Dump a Nim value as YAML character stream to the given Stream, using the default YamlCfg options
  dump(value = value, target = target, cfg = ycfg)
#______________________________
proc writeYaml *[T](value :T; file :string) :void {.raises: [YamlPresenterJsonError, YamlPresenterOutputError, YamlSerializationError, Exception].}=
  ## Dump a Nim value as YAML character stream to the given file, using the default YamlCfg options
  var s = newFileStream(file, fmWrite)
  value.dump(s)
  s.close()
