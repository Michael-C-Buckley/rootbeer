vim.pack.add({
  "https://github.com/lewis6991/gitsigns.nvim",
})

require("utility.autocmds")
require("utility.completion")
require("utility.diagnostics")
require("utility.format")
require("utility.oil")
require("utility.terminal")
require("utility.vim")
require("utility.snacks")

-- Lazy load gitsigns and to-do
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  once = true,
  callback = function()
    require("gitsigns").setup()
  end,
})

--
-- Load DAP only for debuggable filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua", "c", "cpp", "rust" }, -- your targets
  once = true,
  callback = function()
    require("utility.dap_config")
  end,
})
