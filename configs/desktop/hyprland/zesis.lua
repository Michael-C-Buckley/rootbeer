-- Shell overlays
local ZESIS_DEV = "/run/current-system/zesis"
local function zesis_ipc(cmd)
  return string.format(
    "sh -c 'qs -p %s ipc call %s 2>/dev/null || qs ipc call %s'",
    ZESIS_DEV,
    cmd,
    cmd
  )
end
hl.bind(
  "ALT + Tab",
  hl.dsp.exec_cmd(zesis_ipc("appswitcher cycle")),
  { repeating = true, description = "Shell: App switcher next" }
)
hl.bind(
  "ALT + SHIFT + Tab",
  hl.dsp.exec_cmd(zesis_ipc("appswitcher back")),
  { repeating = true, description = "Shell: App switcher prev" }
)
hl.bind(
  "ALT + Alt_L",
  hl.dsp.exec_cmd(zesis_ipc("appswitcher confirm")),
  { release = true }
)
hl.bind(
  "ALT + Escape",
  hl.dsp.exec_cmd(zesis_ipc("appswitcher cancel")),
  { description = "Shell: App switcher cancel" }
)
hl.bind(
  "SUPER" .. " + D",
  hl.dsp.exec_cmd(zesis_ipc("desktop toggleConfig")),
  { description = "Shell: Desktop toggle config" }
)
