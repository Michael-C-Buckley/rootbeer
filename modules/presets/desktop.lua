local apps = { "helix", "zed" }
local desktop = { "hyprland", "oxwm" }
local terminals = { "kitty" }

local function import_items(family, dir)
  for _, v in ipairs(family) do
    require("modules." .. dir .. "." .. v)
  end
end

import_items(apps, "apps")
import_items(terminals, "terminals")
import_items(desktop, "desktop")
