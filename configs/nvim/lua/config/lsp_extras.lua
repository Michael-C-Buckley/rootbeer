require("otter").setup()

vim.keymap.set("n", "<leader>lo", "<Cmd>OtterActivate<CR>", {
  silent = true,
  desc = "Activate embedded-language LSP",
})
