local rb = require("rootbeer")

rb.profile.when("fallback", function()
  rb.package("helix")
end)

local src_dir = "configs/helix/"
local dst_dir = "~/.config/helix/"

for _, file in ipairs({ "config", "languages", "zen" }) do
  local path = file .. ".toml"
  rb.link_file(src_dir .. path, dst_dir .. path)
end
