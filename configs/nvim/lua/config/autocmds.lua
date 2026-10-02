local function augroup(name)
  return vim.api.nvim_create_augroup("michael_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("write_housekeeping"),
  callback = function(event)
    local path = vim.api.nvim_buf_get_name(event.buf)
    if path ~= "" then
      vim.fn.mkdir(vim.fs.dirname(path), "p")
    end

    if not vim.bo[event.buf].modifiable or vim.bo[event.buf].binary then
      return
    end

    local view = vim.fn.winsaveview()
    vim.cmd([[silent keepjumps keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup("check_external_changes"),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})
