-- X570 Specific things

hl.monitor({
  output = "DP-1",
  mode = "3440x1440@144.00",
  position = "0x0",
  scale = 1,
})

for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
end
