local optional = require("modules.lib.optional")

local dir = "configs/terminal/kitty"
optional.link_files_when_binary("kitty", {
  { dir .. "/kitty.conf", "~/.config/kitty/kitty.conf" },
})
