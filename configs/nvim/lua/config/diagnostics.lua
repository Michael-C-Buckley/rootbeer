vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.INFO] = "●",
      [vim.diagnostic.severity.HINT] = "➜",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
})

local function blend(fg, bg, alpha)
  local fr, fgg, fb = math.floor(fg / 0x10000) % 0x100, math.floor(fg / 0x100) % 0x100, fg % 0x100
  local br, bgg, bb = math.floor(bg / 0x10000) % 0x100, math.floor(bg / 0x100) % 0x100, bg % 0x100
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha))
  end
  return string.format("#%02x%02x%02x", mix(fr, br), mix(fgg, bgg), mix(fb, bb))
end

local function style_virtual_lines()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  if not normal.bg then
    return
  end

  for _, severity in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    local base = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. severity, link = false })
    if base.fg then
      vim.api.nvim_set_hl(
        0,
        "DiagnosticVirtualLines" .. severity,
        vim.tbl_extend("force", base, {
          bold = true,
          bg = blend(base.fg, normal.bg, 0.18),
        })
      )
    end
  end
end

style_virtual_lines()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("michael_diagnostic_colors", { clear = true }),
  callback = style_virtual_lines,
})
