-- Native Nvim Completion

vim.o.autocomplete = true
vim.opt.completeopt = { "menuone", "noselect" }

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))

    if client:supports_method("textDocument/completion") then
      -- Skip non-file buffers (picker prompts, terminals, etc.)
      if vim.bo[ev.buf].buftype ~= "" then
        return
      end

      -- Enable autocomplete only for this buffer
      vim.bo[ev.buf].autocomplete = true
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "snacks_picker_list", "snacks_picker_input" },
  callback = function(ev)
    vim.bo[ev.buf].autocomplete = false
    vim.lsp.completion.enable(false, nil, ev.buf)
  end,
})

-- QOL Binds
vim.keymap.set("i", "<Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true })

vim.keymap.set("i", "<S-Tab>", function()
  return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true })

vim.keymap.set("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true })
