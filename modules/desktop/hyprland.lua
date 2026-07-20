local optional = require("modules.lib.optional")
local rb = require("rootbeer")

local hypr = "configs/desktop/hyprland/"
local conf = "~/.config/hypr/"

local files = { "binds", "hyprland", "input", "lookfeel", "dms" }
local links = {}

for _, name in ipairs(files) do
  links[#links + 1] = { hypr .. name .. ".lua", conf .. name .. ".lua" }
end

optional.link_files_when_binary({ "Hyprland", "hyprland" }, links)
optional.link_files_when_binary({ "Hyprland", "hyprland" }, links)

optional.when_binary("dms", function()
  rb.copy_file(
    "configs/desktop/dms-settings.json",
    "~/.config/DankMaterialShell/settings.json"
  )
end)
