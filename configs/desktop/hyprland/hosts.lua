local function read_hostname()
  local f = io.open("/etc/hostname", "r")
  if not f then
    return nil
  end

  local hostname = f:read("*l")
  f:close()

  return hostname
end

local hostname = read_hostname()

if hostname == "x570" then
  hl.monitor({
    output = "DP-1",
    mode = "3440x1440@165",
    position = "0x0",
    scale = 1,
  })
else
  hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
  })
end
