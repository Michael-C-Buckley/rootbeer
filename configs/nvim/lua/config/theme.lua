vim.o.background = "dark"

require("oasis").setup({
  style = "moonlight",
  integrations = {
    default_enabled = false,
    plugins = {
      gitsigns = true,
      mini = true,
      snacks = true,
    },
  },
})

vim.cmd.colorscheme("oasis-moonlight")
