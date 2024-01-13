import confy

cfg.verbose = off
cfg.quiet   = on
cfg.libDir  = cfg.srcDir/"lib"

build Program.new(
  src  = srcDir/"spry.nim",
  deps = Dependencies.new(
    submodule( "zippy",       "https://github.com/treeform/zippy"          ),
    submodule( "jsony",       "https://github.com/treeform/jsony"          ),
    submodule( "confy",       "https://github.com/heysokam/confy"          ),
    submodule( "nstd",        "https://github.com/heysokam/nstd"           ),
    submodule( "yaml",        "https://github.com/flyx/NimYAML",        "" ),
    submodule( "assume",      "https://github.com/disruptek/assume",    "" ),
    submodule( "nimscripter", "https://github.com/beef331/nimscripter"     ),
    ) # << Dependencies.new( ... )
  ) # << Program.new( ... )
