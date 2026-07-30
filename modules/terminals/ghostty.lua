local optional = require("modules.lib.optional")
local rb = require("rootbeer")

local dir = "configs/terminal/ghostty/"
optional.link_files_when_binary("ghostty", {
  { dir .. rb.host.os, "~/.config/ghostty/config" },
})
