local rb = require("rootbeer")
local lib = require("lib")

rb.profile.define({
  strategy = function(ctx)
    -- A file called `.profile` at the project root will override the profile
    local ok, dotprofile = pcall(rb.read_file, ".profile")
    if ok and dotprofile then
      dotprofile = dotprofile:match("^%s*(.-)%s*$") -- trim whitespace/newline
      if dotprofile ~= "" then
        return dotprofile
      end
    end

    return ctx.hostname() or ctx.cli() or "fallback"
  end,
  profiles = {
    nixos_desktop = { "x570", "t14g5", "t14g2" },
    nixos_server = { "b550" },
    fallback = {},
  },
})

-- Self-manage the packaging
rb.package("rootbeer")

-- Unconditional modules
require("git")
require("apps/nvim")
require("apps/zsh")

-- For package management via rootbeer
rb.profile.when("fallback", function()
  require("packages")
end)

-- Graphical hosts that aren't servers
rb.profile.when({ "nixos_desktop", "fallback" }, function()
  require("apps/zed")
  require("apps/kitty")

  if rb.host.os == "linux" then
    require("linux/noctalia")
  end
end)

if rb.host.os == "macos" then
  require("apps/ghostty")
  require("macos/packages")
  require("macos/aerospace")
  require("macos/ssh-agent")
  lib.apply_brew()
end
