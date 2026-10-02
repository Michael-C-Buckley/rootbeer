require("oil").setup({
  default_file_explorer = true,
  columns = { "icon" },
  win_options = {
    signcolumn = "yes:2",
  },
  view_options = {
    show_hidden = true,
    natural_order = "fast",
  },
})

require("oil-git-status").setup()

vim.keymap.set("n", "-", "<Cmd>Oil<CR>", {
  silent = true,
  desc = "Open parent directory in Oil",
})
