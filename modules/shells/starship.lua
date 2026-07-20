local optional = require("modules.lib.optional")

local dir = "configs/shells/starship"
local dst = "~/.config/starship"
optional.link_files_when_binary("starship", {
  { dir .. "/default.toml", dst .. "/default.toml" },
  { dir .. "/pure.toml", dst .. "/pure.toml" },
})
