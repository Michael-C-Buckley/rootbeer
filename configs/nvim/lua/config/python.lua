local dap = require("dap")
local dap_python = require("dap-python")

local adapter
if vim.fn.executable("uv") == 1 then
  adapter = "uv"
elseif vim.g.python3_host_prog and vim.fn.executable(vim.g.python3_host_prog) == 1 then
  adapter = vim.g.python3_host_prog
elseif vim.fn.executable("python3") == 1 then
  adapter = "python3"
else
  adapter = "python"
end

dap_python.setup(adapter)
dap_python.test_runner = "pytest"

dap.configurations.python = dap.configurations.python or {}

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Launch file with arguments",
  program = "${file}",
  args = function()
    local input = vim.fn.input("Arguments: ")
    return vim.split(input, " ", { trimempty = true })
  end,
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "launch",
  name = "Launch module (-m)",
  module = function()
    return vim.fn.input("Module name: ")
  end,
})

table.insert(dap.configurations.python, {
  type = "python",
  request = "attach",
  name = "Attach to running process",
  connect = {
    host = "127.0.0.1",
    port = function()
      return tonumber(vim.fn.input("Port [5678]: ")) or 5678
    end,
  },
})

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = "DAP: " .. desc })
end

map("n", "<leader>dm", dap_python.test_method, "Debug Python test method")
map("n", "<leader>dc", dap_python.test_class, "Debug Python test class")
map("x", "<leader>ds", dap_python.debug_selection, "Debug Python selection")
