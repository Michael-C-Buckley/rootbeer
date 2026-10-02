local rb = require("rootbeer")
require("lib").ensure_package("kitty")
rb.link_file("configs/kitty/kitty.conf", "~/.config/kitty/kitty.conf")
