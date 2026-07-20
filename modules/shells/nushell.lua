local optional = require("modules.lib.optional")

local dir = "configs/shells/nushell"

optional.link_files_when_binary("nu", {
  { dir .. "/env.nu", "~/.config/nushell/env.nu" },
  { dir .. "/config.nu", "~/.config/nushell/config.nu" },
  { dir .. "/abbreviations.nu", "~/.config/nushell/abbreviations.nu" },
  { dir .. "/git.nu", "~/.config/nushell/git.nu" },
  { dir .. "/prompt.nu", "~/.config/nushell/prompt.nu" },
  { dir .. "/zoxide.nu", "~/.config/nushell/zoxide.nu" },
})
