-- X570 Specific things

hl.monitor({
  output = "DP-1",
  mode = "3440x1440@144.00",
  position = "0x0",
  scale = 1,
})

hl.monitor({
  output = "HDMI-A-3",
  mode = "2560x1440@74.60",
  position = "3440x-500",
  scale = 1,
  transform = 3,
})

for i = 1, 9 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
end

for i = 9, 11 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-3" })
end
