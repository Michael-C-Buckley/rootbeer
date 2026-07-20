local rb = require("rootbeer")

local M = {}

local default_binary_paths = {
  "/usr/local/bin",
  "/usr/local/sbin",
  "/usr/bin",
  "/usr/sbin",
  "/bin",
  "/sbin",
  "/opt/bin",
  "/run/current-system/sw/bin",
  "/etc/profiles/per-user/$USER/bin",
  "/home/$USER/.local/bin",
  "/home/$USER/.nix-profile/bin",
  "~/.local/bin",
  "~/.nix-profile/bin",
  "/nix/var/nix/profiles/default/bin",
  "/opt/homebrew/bin",
  "/opt/homebrew/sbin",
}

local function append(list, value)
  if value and value ~= "" then
    list[#list + 1] = value
  end
end

local function as_list(value)
  if value == nil then
    return {}
  end

  if type(value) == "table" then
    return value
  end

  return { value }
end

local function expand_vars(path)
  local home = rb.host.home or ""
  local user = rb.host.user or ""

  if string.sub(path, 1, 2) == "~/" then
    path = home .. string.sub(path, 2)
  end

  path = string.gsub(path, "%$HOME", home)
  path = string.gsub(path, "%$USER", user)

  return path
end

local function unique(paths)
  local seen = {}
  local result = {}

  for _, path in ipairs(paths) do
    local expanded = expand_vars(path)

    if expanded ~= "" and not seen[expanded] then
      seen[expanded] = true
      result[#result + 1] = expanded
    end
  end

  return result
end

local function has_slash(value)
  return string.find(value, "/", 1, true) ~= nil
end

local function candidate_paths(binary, opts)
  local paths = {}

  for _, path in ipairs(as_list(opts.paths)) do
    append(paths, path)
  end

  if opts.defaults ~= false then
    for _, path in ipairs(default_binary_paths) do
      append(paths, path)
    end
  end

  local candidates = {}
  for _, path in ipairs(unique(paths)) do
    candidates[#candidates + 1] = path .. "/" .. binary
  end

  return candidates
end

function M.find_binary(binary, opts)
  opts = opts or {}

  if type(binary) == "table" then
    for _, candidate in ipairs(binary) do
      local path = M.find_binary(candidate, opts)

      if path then
        return path
      end
    end

    return nil
  end

  if has_slash(binary) then
    local path = expand_vars(binary)

    if rb.is_file(path) then
      return path
    end

    return nil
  end

  for _, path in ipairs(candidate_paths(binary, opts)) do
    if rb.is_file(path) then
      return path
    end
  end

  return nil
end

function M.has_binary(binary, opts)
  return M.find_binary(binary, opts) ~= nil
end

function M.when_binary(binary, opts, callback)
  if type(opts) == "function" then
    callback = opts
    opts = nil
  end

  local path = M.find_binary(binary, opts)

  if not path then
    return false
  end

  callback(path)
  return true, path
end

function M.link_files_when_binary(binary, files, opts)
  return M.when_binary(binary, opts, function()
    for _, file in ipairs(files) do
      rb.link_file(file.src or file[1], file.dst or file.target or file[2])
    end
  end)
end

return M
