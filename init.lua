local rb = require("rootbeer")

rb.profile.define({
  strategy = "cli",
  profiles = {
    personal = {},
    work = {},
  },
})

require("modules.git")

local function host_import(hostname)
  if not hostname then
    return false
  end

  local machine = rb.read_file("/etc/machine-id"):gsub("%s+$", "")

  -- Work machine ID is a better source since the hostname is whacky there
  if machine == "1f17539e5a744835a57ea9fe333ae608" then
    hostname = "x570"
  end

  local host_file = rb.source_dir .. "/hosts/" .. hostname .. "/host.lua"
  if not rb.is_file(host_file) then
    return false
  end

  require("hosts." .. hostname .. ".host")
  return true
end

if rb.host.os == "macos" then
  require("modules.terminals.ghostty")
  require("modules.apps.nvim")
  require("modules.shells.fish")
  require("modules.shells.starship")
  require("modules.desktop.aerospace")
end

if rb.host.os == "linux" then
  -- Unconditionally import as they're detected
  require("modules.shells.fish")
  require("modules.shells.starship")
  require("modules.apps.helix")
  host_import(rb.host.hostname)
end
