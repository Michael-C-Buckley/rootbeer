local optional = require("modules.lib.optional")

local dir = "configs/desktop/oxwm"

optional.link_files_when_binary("oxwm", {
  { dir .. "/config.lua", "~/.config/oxwm/config.lua" },
  { dir .. "/binds.lua", "~/.config/oxwm/binds.lua" },
  { dir .. "/bar.lua", "~/.config/oxwm/bar.lua" },
  { dir .. "/colors.lua", "~/.config/oxwm/colors.lua" },
})
