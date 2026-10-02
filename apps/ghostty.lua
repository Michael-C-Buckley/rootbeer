local rb = require("rootbeer")

local cfg = [[
cursor-opacity = 0.6
font-family = Lilex Nerd Font Mono
background = #000000
keybind = performable:ctrl+shift+h=previous_tab
keybind = performable:ctrl+shift+l=next_tab
tab-inherit-working-directory = false
working-directory = home
]]

local mac_cfg = [[
font-size = 11
font-thicken = true
font-thicken-strength = 255
macos-option-as-alt = left
]]

if rb.host.os == "macos" then
  cfg = cfg .. mac_cfg
end

require("lib").ensure_package("ghostty")
rb.file("~/.config/ghostty/config", cfg)
