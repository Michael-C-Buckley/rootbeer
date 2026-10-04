local rb = require("rootbeer")

local M = {}

local brew_items = {}
local brew_seen = {}

function M.add_brew(items)
  for kind, packages in pairs(items) do
    for _, package in ipairs(packages) do
      brew_items[kind] = brew_items[kind] or {}
      brew_seen[kind] = brew_seen[kind] or {}

      if not brew_seen[kind][package] then
        brew_items[kind][#brew_items[kind] + 1] = package
        brew_seen[kind][package] = true
      end
    end
  end
end

function M.apply_brew()
  if next(brew_items) == nil then
    return
  end

  require("rootbeer.brew").config(brew_items)
  brew_items = {}
  brew_seen = {}
end

return M
