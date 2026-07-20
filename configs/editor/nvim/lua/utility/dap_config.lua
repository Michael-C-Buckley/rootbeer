local M = {}
vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/mfussenegger/nvim-dap-python",
})
local dap = require("dap")
local dapui = require("dapui")

local dapui_open = false

-- ── DAP-UI setup + auto open/close ──────────────────────────────────────────

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.4 },
        { id = "breakpoints", size = 0.15 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.2 },
      },
      size = 50,
      position = "left",
    },
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 12,
      position = "bottom",
    },
  },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
  dapui_open = true
end
-- On session end, close only the sidebar (layout 1) but keep the bottom
-- console/repl panel (layout 2) open so print() output persists.
-- Use <leader>du to dismiss it when you're done.
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
  dapui_open = false
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
  dapui_open = false
end

-- ── Breakpoint signs ─────────────────────────────────────────────────────────

vim.fn.sign_define(
  "DapBreakpoint",
  { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapBreakpointCondition",
  { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapLogPoint",
  { text = "◉", texthl = "DapLogPoint", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapBreakpointRejected",
  { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" }
)
vim.fn.sign_define(
  "DapStopped",
  { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" }
)

-- Highlight groups (subtle defaults; your colorscheme may override these)
vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e06c75" })
vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = "#e5c07b" })
vim.api.nvim_set_hl(0, "DapLogPoint", { fg = "#61afef" })
vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#5c6370" })
vim.api.nvim_set_hl(0, "DapStopped", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#2e3b28" })

-- ── Public API ───────────────────────────────────────────────────────────────

--- Close DAP UI if it is currently open.
--- Safe to call even when DAP UI is already closed.
M.close_ui = function()
  if dapui_open then
    dapui.close()
    dapui_open = false
  end
end

-- ── Keymaps ──────────────────────────────────────────────────────────────────

local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = "DAP: " .. desc })
end

-- Session control
map("n", "<F5>", dap.continue, "Continue / Start")
map("n", "<S-F5>", dap.terminate, "Terminate")
map("n", "<F9>", dap.restart, "Restart")
map("n", "<F10>", dap.step_over, "Step Over")
map("n", "<F11>", dap.step_into, "Step Into")
map("n", "<F12>", dap.step_out, "Step Out")

-- Breakpoints
map("n", "<leader>b", dap.toggle_breakpoint, "Toggle Breakpoint")
map("n", "<leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Conditional Breakpoint")
map("n", "<leader>lp", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "Log Point")
map("n", "<leader>bc", dap.clear_breakpoints, "Clear All Breakpoints")

-- Navigation
map("n", "<leader>rc", dap.run_to_cursor, "Run to Cursor")

-- Inspection
map("n", "<leader>dh", dapui.eval, "Hover / Evaluate")
map("v", "<leader>dh", dapui.eval, "Evaluate Selection")
map("n", "<leader>dp", function()
  dapui.eval(vim.fn.input("Expression: "))
end, "Evaluate Expression")

-- UI & REPL
map({ "n", "t" }, "<M-d>", function()
  if dapui_open then
    M.close_ui()
  else
    require("utility.terminal").close()
    dapui.open()
    dapui_open = true
  end
end, "Toggle DAP UI")
map("n", "<leader>dr", dap.repl.toggle, "Toggle REPL")

return M
