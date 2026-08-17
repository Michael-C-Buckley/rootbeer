local optional = require("modules.lib.optional")
local rb = require("rootbeer")

local M = {}

---@class kitty.Config
---@field shell? string Shell command or executable path.
---@field font? string Raw Kitty font specification.
---@field font_size? number Font size in points.
---@field path? string Destination directory. Defaults to `~/.config/kitty`.

local function expect(name, value, expected)
  if value ~= nil and type(value) ~= expected then
    error(
      string.format("kitty.%s must be %s, got %s", name, expected, type(value))
    )
  end
end

---@param cfg? kitty.Config
function M.config(cfg)
  cfg = cfg or {}

  expect("shell", cfg.shell, "string")
  expect("font", cfg.font, "string")
  expect("font_size", cfg.font_size, "number")
  expect("path", cfg.path, "string")

  optional.when_binary("kitty", function()
    local dir = cfg.path or "~/.config/kitty"

    rb.link_file("configs/terminal/kitty/kitty.conf", dir .. "/kitty.conf")

    local options = {}

    if cfg.shell then
      options[#options + 1] = "shell " .. cfg.shell
    end

    if cfg.font then
      options[#options + 1] = "font_family " .. cfg.font
    end

    if cfg.font_size then
      assert(cfg.font_size > 0, "kitty.font_size must be positive")
      options[#options + 1] = "font_size " .. cfg.font_size
    end

    rb.file(
      dir .. "/kitty.d/10-options.conf",
      table.concat(options, "\n") .. "\n"
    )

    if rb.host.os == "macos" then
      rb.link_file(
        "configs/terminal/kitty/macos.conf",
        dir .. "/kitty.d/20-macos.conf"
      )
    end
  end)

  return cfg
end

return M
