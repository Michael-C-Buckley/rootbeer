local parsers = {
  "bash",
  "diff",
  "go",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "nix",
  "nu",
  "python",
  "query",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
  "yang",
}

local treesitter = require("nvim-treesitter")
treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Installation is asynchronous and a no-op for parsers already present. The
-- current nvim-treesitter rewrite requires its CLI, so avoid noisy failed
-- builds on machines where that dependency has not been installed yet.
if vim.fn.executable("tree-sitter") == 1 then
  vim.schedule(function()
    treesitter.install(parsers)
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("michael_treesitter", { clear = true }),
  callback = function(event)
    local language = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
    if not language then
      return
    end

    if pcall(vim.treesitter.start, event.buf, language) then
      vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldmethod = "expr"
    end
  end,
})
