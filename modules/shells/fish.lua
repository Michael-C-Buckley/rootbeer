local optional = require("modules.lib.optional")
local rb = require("rootbeer")
local dir = "configs/shells/fish/"

rb.link(dir .. "functions", "~/.config/fish/functions")

-- Reconsidering the conditional binary linking pattern
optional.link_files_when_binary("fish", {
  { dir .. "profile", "~/.profile" },
  { dir .. "config.fish", "~/.config/fish/config.fish" },
})
