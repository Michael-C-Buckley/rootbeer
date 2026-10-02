local rb = require("rootbeer")

-- Automatically pull in starship to establish my default feel
require("apps/starship")

rb.link_file("configs/zsh/zshrc", "~/.config/zsh/.zshrc")
rb.link_file("configs/zsh/zshenv", "~/.zshenv")
rb.link_file("configs/zsh/zprofile", "~/.config/zsh/.zprofile")
rb.link_file("configs/zsh/zshenv", "~/.config/zsh/.zshenv")
