require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("bufferline").setup({
  options = {
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
  },
})

require("lualine").setup({
  options = {
    globalstatus = true,
    theme = "auto",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "lsp_status", "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  extensions = { "oil", "quickfix" },
})

require("mini.comment").setup()
