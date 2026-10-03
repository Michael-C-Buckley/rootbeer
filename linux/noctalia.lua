-- Umbriel will have specific monitor configs for my main hosts
-- anything not matching will receive just the default config
local rb = require("rootbeer")

local monitors = {
  x570  = { output = "DP-1",  mode = "3440x1440@165" },
  t14g5 = { output = "eDP-1", mode = "1920x1200@60.001" },
}

rb.link_file("configs/noctalia/config.toml", "~/.config/noctalia/config.toml")

local cfg = rb.read_file("configs/umbriel/config.toml")

local m = monitors[rb.host.hostname]
if m then
  cfg = cfg:gsub("\n*$", "\n") .. string.format([[

[output.%s]
mode = "%s"
workspaces = 10
]], m.output, m.mode)
end

rb.file("~/.config/umbriel/config.toml", cfg)
