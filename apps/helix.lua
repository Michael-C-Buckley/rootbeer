local rb = require("rootbeer")

require("lib").ensure_package("helix", "hx")

local src_dir = "configs/helix/"
local dst_dir = "~/.config/helix/"

for _, file in ipairs({ "config", "languages", "zen" }) do
  local path = file .. ".toml"
  rb.link_file(src_dir .. path, dst_dir .. path)
end
