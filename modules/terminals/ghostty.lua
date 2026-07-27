local rb = require("rootbeer")

local config = [[
cursor-color = #44A3A3
cursor-opacity = 0.6
font-family = Lilex Nerd Font Mono
background = #000000
keybind = performable:ctrl+shift+h=previous_tab
keybind = performable:ctrl+shift+l=next_tab
]]

if rb.host.os == "macos" then
  config = config
    .. [[
font-size = 14
font-thicken = true
font-thicken-strength = 255
]]
else
  config = config .. [[
font-size = 11
]]
end

rb.file("~/.config/ghostty/config", config)
