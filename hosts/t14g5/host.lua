local rb = require("rootbeer")

require("modules.desktop.hyprland")
require("modules.apps.zed")
rb.link_file("hosts/t14g5/hyprland.lua", "~/.config/hypr/host.lua")
