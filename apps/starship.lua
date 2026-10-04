local rb = require("rootbeer")
rb.link_file("configs/starship.toml", "~/.config/starship/config.toml")

rb.profile.when("fallback", function()
  rb.package("starship")
end)
