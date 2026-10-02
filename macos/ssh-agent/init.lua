local rb = require("rootbeer")

-- Explicitly package via rootbeer to get a consistent experience
rb.package("openssh")

local home = rb.host.home
local label = "local.rootbeer.ssh-agent"
local runner = home .. "/.local/libexec/rootbeer/ssh-agent"
local askpass = home .. "/.local/libexec/rootbeer/ssh-askpass"
local controller = home .. "/.local/bin/rootbeer-ssh-agent"
local plist = home .. "/Library/LaunchAgents/" .. label .. ".plist"

rb.scripts.sh(runner, rb.read_file("macos/ssh-agent/ssh-agent.sh"))
rb.scripts.sh(askpass, rb.read_file("macos/ssh-agent/ssh-askpass.sh"))
rb.scripts.sh(controller, rb.read_file("macos/ssh-agent/rootbeer-ssh-agent.sh"))

rb.plist.write(plist, {
  Label = label,
  ProgramArguments = { runner },
  RunAtLoad = true,
  KeepAlive = true,
  ProcessType = "Background",
  ThrottleInterval = 5,
  StandardOutPath = home .. "/Library/Logs/rootbeer-ssh-agent.log",
  StandardErrorPath = home .. "/Library/Logs/rootbeer-ssh-agent.err.log",
})
