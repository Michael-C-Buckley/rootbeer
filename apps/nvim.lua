local rb = require("rootbeer")

rb.profile.when({ "fallback", "linux_desktop" }, function()
  rb.packages({ "neovim", "tree-sitter" })
end)

rb.link("configs/nvim", "~/.config/nvim")
