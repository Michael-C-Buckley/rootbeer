local ipc = "noctalia msg "
local mainMod = "SUPER"

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
end)

hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd(ipc .. "bar-toggle"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd(ipc .. "session lock"))
