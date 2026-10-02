require("smartcolumn").setup({
  colorcolumn = "80",
  disabled_filetypes = {
    "help",
    "text",
    "markdown",
    "oil",
    "snacks_picker_input",
    "snacks_picker_list",
  },
  custom_colorcolumn = {
    go = "120",
    nix = "110",
    python = { "80", "120" },
  },
})

require("cinnamon").setup({
  keymaps = {
    basic = true,
    extra = false,
  },
  options = {
    mode = "window",
  },
})
