-- DMS
hl.on("hyprland.start", function()
  hl.exec_cmd("dmr run")
end)

local ipc = "dms ipc "
local mainMod = "SUPER"
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(ipc .. "spotlight toggle"))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd(ipc .. "bar toggle"))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd(ipc .. "lock lock"))
