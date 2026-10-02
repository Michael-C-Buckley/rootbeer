vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
  require("config.vscode")
  return
end

require("config.options")
require("config.pack")
require("config.theme")
require("config.ui")
require("config.oil")
require("config.snacks")
require("config.completion")
require("config.editing")
require("config.navigation")
require("config.git")
require("config.lsp_extras")
require("config.dap")
require("config.python")
require("config.visuals")
require("config.keymaps")
require("config.autocmds")
require("config.diagnostics")
require("config.lsp")
require("config.treesitter")
