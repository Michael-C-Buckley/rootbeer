vim.pack.add({ "https://github.com/folke/snacks.nvim" })
require("utility.snacks.picker")
require("utility.snacks.lazygit")

require("snacks").setup({
  picker = { enabled = true },
  lazygit = { enabled = true },
  scroll = { enabled = true },

  indent = { enabled = true, scope = { enabled = false } },
})
