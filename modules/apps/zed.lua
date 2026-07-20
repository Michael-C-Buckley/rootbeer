local optional = require("modules.lib.optional")
local rb = require("rootbeer")

optional.when_binary({ "zed", "zeditor" }, function()
  rb.copy_file(
    "configs/editor/zed/settings.json",
    "~/.config/zed/settings.json"
  )
end)
