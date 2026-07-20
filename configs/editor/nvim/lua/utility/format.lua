-- For convenience, I only use formatting when triggered manually to prevent issues
-- and huge diffs in places where I don't use the official formatter for projects

common = {
  async = false,
  timeout_ms = 1000,
  on_error = function(err)
    vim.notify(vim.inspect(err))
  end,
}

vim.keymap.set("n", "f<leader>", function()
  vim.lsp.buf.format(common)
end, { desc = "Format buffer" })

vim.keymap.set("v", "f<leader>", function()
  vim.lsp.buf.format(common)
end, { desc = "Format selection" })
