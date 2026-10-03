if vim.fn.has("nvim-0.12") == 0 then
  error("This configuration requires Neovim 0.12 or newer (vim.pack and native LSP config).")
end

local plugins = {
  {
    src = "https://github.com/uhs-robert/oasis.nvim",
    version = "v6.1.0",
  },
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  {
    src = "https://github.com/Saghen/blink.cmp",
    version = vim.version.range("^1"),
  },
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/windwp/nvim-autopairs",
  "https://github.com/folke/todo-comments.nvim",
  "https://codeberg.org/andyg/leap.nvim",
  "https://github.com/stevearc/aerial.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/refractalize/oil-git-status.nvim",
  "https://github.com/jmbuhr/otter.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/mfussenegger/nvim-dap-python",
  "https://github.com/m4xshen/smartcolumn.nvim",
  "https://github.com/declancm/cinnamon.nvim",
  "https://github.com/Shatur/neovim-ayu",
  "https://github.com/webhooked/kanso.nvim",
  "https://github.com/t-b-t-nchos/aquavium.nvim",
}

-- Set this flag before loading init.lua when Nix supplies the plugin,
-- parsers, and queries on runtimepath.
if not vim.g.nix_treesitter then
  plugins[#plugins + 1] = "https://github.com/nvim-treesitter/nvim-treesitter"
end

vim.pack.add(plugins, {
  confirm = false,
  load = true,
})

vim.api.nvim_create_user_command("PackUpdate", function()
  local names = {
    "oasis.nvim",
    "snacks.nvim",
    "mini.nvim",
    "lualine.nvim",
    "bufferline.nvim",
    "oil.nvim",
    "plenary.nvim",
    "blink.cmp",
    "LuaSnip",
    "friendly-snippets",
    "nvim-autopairs",
    "todo-comments.nvim",
    "leap.nvim",
    "aerial.nvim",
    "gitsigns.nvim",
    "oil-git-status.nvim",
    "otter.nvim",
    "nvim-dap",
    "nvim-nio",
    "nvim-dap-ui",
    "nvim-dap-python",
    "smartcolumn.nvim",
    "cinnamon.nvim",
    "neovim-ayu",
    "kanso.nvim",
    "aquavium.nvim",
  }

  if not vim.g.nix_treesitter then
    names[#names + 1] = "nvim-treesitter"
  end

  vim.pack.update(names)
end, { desc = "Review updates for this config's active plugins" })
