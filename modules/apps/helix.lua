local optional = require("modules.lib.optional")

local dir = "configs/editor/helix"

optional.link_files_when_binary("hx", {
  { dir .. "/config.toml", "~/.config/helix/config.toml" },
  { dir .. "/languages.toml", "~/.config/helix/languages.toml" },
  { dir .. "/zen.toml", "~/.config/helix/themes/zen.toml" },
})
