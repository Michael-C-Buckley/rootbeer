local rb = require("rootbeer")
require("lib").ensure_package("kitty")
local cfg = "configs/kitty/"
local out = "~.config/kitty/"
rb.link_file(cfg .. "kitty.conf", out .. "kitty.conf")
rb.link_file(cfg .. "tab_bar.py", out .. "tab_bar.py")
