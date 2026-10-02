-- Packages that will be added if they aren't already in path
local lib = require("lib")

local packages = {
  "age",
  "bat",
  "direnv",
  "eza",
  "dust",
  "fd",
  "fzf",
  { package = "ripgrep", command = "rg" },
  "jq",
  { package = "rootbeer", command = "rb" },
  "rsync",
  "telnet",
  "uv",
  "yq",
  "zoxide",
}

for _, item in ipairs(packages) do
  if type(item) == "string" then
    lib.ensure_package(item)
  else
    lib.ensure_package(item.package, item.command)
  end
end
