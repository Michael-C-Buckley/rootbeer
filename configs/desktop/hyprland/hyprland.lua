-- Main Config Entry Point

require("binds")
require("input")
require("lookfeel")

-- Host files
require("host")
-- File created that determines the desktop shell
-- Controlled by NixOS
require("shell")

hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("KDE_PLATFORM_THEME", "qt6ct")
