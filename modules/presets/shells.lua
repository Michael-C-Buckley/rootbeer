local shells = {  "fish", "nushell", "starship" }

local function import_items(family, dir)
  for _, v in ipairs(family) do
    require("modules." .. dir .. "." .. v)
  end
end

import_items(shells, "shells")
