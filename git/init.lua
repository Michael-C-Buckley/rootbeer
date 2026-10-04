local rb = require("rootbeer")

rb.link_file("git/gitconfig", "~/.config/git/config")
rb.link_file("git/gitignore", "~/.config/git/ignore")

rb.profile.when("fallback", function()
  rb.packages({ "git", "delta" })
end)
