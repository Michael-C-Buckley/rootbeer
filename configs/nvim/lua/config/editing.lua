require("nvim-autopairs").setup({
  map_cr = false,
})

require("todo-comments").setup()

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { silent = true, desc = "Next TODO comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { silent = true, desc = "Previous TODO comment" })

vim.keymap.set("n", "<leader>xt", "<Cmd>TodoQuickFix<CR>", {
  silent = true,
  desc = "TODO comments",
})

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap from window" })
