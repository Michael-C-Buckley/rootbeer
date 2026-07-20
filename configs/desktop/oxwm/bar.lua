--@module "oxwm"

oxwm.set_tags({ "1", "2", "3", "4", "5", "6", "7", "8", "9" })
-- oxwm.set_tags({ "", "󰊯", "", "", "󰙯", "󱇤", "", "󱘶", "󰧮" }) -- Example of nerd font icon tags
oxwm.bar.set_font("monospace:style=Bold:size=10")

local colors = require("colors")

oxwm.bar.set_blocks({
  oxwm.bar.block.systray({
    color = "#7aa2f7",
    underline = false,
  }),
  oxwm.bar.block.static({
    text = " │  ",
    interval = 999999999,
    color = colors.lavender,
    underline = false,
  }),
  oxwm.bar.block.datetime({
    format = "{}",
    date_format = "%a, %b %d - %-I:%M %P",
    interval = 1,
    color = colors.cyan,
    underline = true,
  }),
  oxwm.bar.block.static({
    text = " │  ",
    interval = 999999999,
    color = colors.lavender,
    underline = false,
  }),
  oxwm.bar.block.battery({
    format = "Bat: {}%",
    charging = "⚡ Bat: {}%",
    discharging = "- Bat: {}%",
    full = "✓ Bat: {}%",
    interval = 30,
    color = colors.green,
    underline = true,
  }),
})

-- Unoccupied tags
oxwm.bar.set_scheme_normal(colors.fg, colors.bg, "#444444")
-- Occupied tags
oxwm.bar.set_scheme_occupied(colors.cyan, colors.bg, colors.cyan)
-- Currently selected tag
oxwm.bar.set_scheme_selected(colors.cyan, colors.bg, colors.purple)
