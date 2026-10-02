local dap = require("dap")
local dapui = require("dapui")

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
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticUnnecessary" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk", linehl = "Visual" })

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = "DAP: " .. desc })
end

map("n", "<F5>", dap.continue, "Continue or start")
map("n", "<S-F5>", dap.terminate, "Terminate")
map("n", "<F9>", dap.restart, "Restart")
map("n", "<F10>", dap.step_over, "Step over")
map("n", "<F11>", dap.step_into, "Step into")
map("n", "<F12>", dap.step_out, "Step out")

map("n", "<leader>db", dap.toggle_breakpoint, "Toggle breakpoint")
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Conditional breakpoint")
map("n", "<leader>dl", function()
  dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end, "Set log point")
map("n", "<leader>dC", dap.clear_breakpoints, "Clear breakpoints")
map("n", "<leader>dr", dap.repl.toggle, "Toggle REPL")
map("n", "<leader>dt", dap.run_to_cursor, "Run to cursor")
map("n", "<leader>dx", dap.terminate, "Terminate")
map("n", "<leader>dd", dap.run_last, "Run last")
map({ "n", "t" }, "<M-d>", dapui.toggle, "Toggle UI")
map("n", "<leader>du", dapui.toggle, "Toggle UI")
map({ "n", "x" }, "<leader>dh", dapui.eval, "Evaluate under cursor")
map("n", "<leader>dp", function()
  dapui.eval(vim.fn.input("Expression: "))
end, "Evaluate expression")
