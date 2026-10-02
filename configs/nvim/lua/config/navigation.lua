require("aerial").setup()

vim.keymap.set("n", "<leader>a", "<Cmd>AerialToggle!<CR>", {
  silent = true,
  desc = "Toggle code outline",
})
