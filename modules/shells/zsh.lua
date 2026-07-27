local optional = require("modules.lib.optional")

local dir = "configs/shells/zsh/"

optional.link_files_when_binary("zsh", {
  { dir .. "zshenv", "~/.config/zsh/.zshenv" },
  { dir .. "zshrc", "~/.config/zsh/.zshrc" },
  { dir .. "zprofile", "~/.config/zsh/.zprofile" },
  { dir .. "abbreviations", "~/.config/zsh/.abbreviations" },
})
