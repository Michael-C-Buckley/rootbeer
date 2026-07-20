-- Link the entire directory since it's a large setup
local optional = require("modules.lib.optional")
local rb = require("rootbeer")

optional.when_binary("nvim", function()
  rb.link("configs/editor/nvim", "~/.config/nvim")
end)
