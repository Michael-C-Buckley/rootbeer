require("luasnip").setup()
require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  snippets = { preset = "luasnip" },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust" },
})
