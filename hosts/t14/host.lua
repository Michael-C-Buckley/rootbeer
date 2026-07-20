local rb = require("rootbeer")

require("modules.desktop.hyprland")
require("modules.presets.desktop")
rb.link_file("hosts/t14/hyprland.lua", "~/.config/hypr/host.lua")
