local rb = require("rootbeer")
local lib = require("lib")

local personal = { "x570", "t14g5", "t14g2" }

rb.profile.define({
  strategy = "hostname",
  profiles = {
    personal = personal,
    fallback = {},
  },
})

require("packages")
require("git")
require("apps/kitty")
require("apps/nvim")
require("apps/zsh")

for _, v in ipairs(personal) do
  if rb.host.hostname == v then
    require("linux/noctalia")
    require("apps/zed")
  end
end

if rb.host.os == "macos" then
  require("apps/ghostty")
  require("apps/zed")
  require("macos/packages")
  require("macos/aerospace")
  require("macos/ssh-agent")
  lib.apply_brew()
end
