local rb = require("rootbeer")
local lib = require("lib")

rb.file("~/.config/git/config", rb.read_file("git/gitconfig"))
rb.link_file("git/gitignore", "~/.config/git/ignore")

lib.ensure_package("git")
lib.ensure_package("delta")
