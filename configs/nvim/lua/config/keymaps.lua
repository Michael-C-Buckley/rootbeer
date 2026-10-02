local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

local all_modes = { "n", "i", "v", "c", "t", "o", "x", "s" }
local active_modes = { "n", "i", "v", "t" }

-- Save and quit.
map("n", "<leader>w", "<Cmd>write<CR>", { desc = "Save" })
map("n", "<leader>qq", "<Cmd>quit<CR>", { desc = "Quit" })
map("n", "<Esc>", "<Cmd>nohlsearch<CR>")
map(all_modes, "<F1>", "<Nop>")
map(active_modes, "<C-s>", "<Cmd>write<CR>", { desc = "Save" })

-- Buffers and windows.
map(active_modes, "<M-,>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map(active_modes, "<M-.>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map(active_modes, "<M-w>", "<Cmd>bdelete<CR>", { desc = "Delete buffer" })
map(active_modes, "<M-a>", "<Cmd>wincmd w<CR>", { desc = "Next window" })
map(active_modes, "<M-v>", "<Cmd>vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>,", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Editing helpers.
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("x", "p", '"_dP', { desc = "Paste without replacing yank" })
map("x", "<", "<gv", { desc = "Indent left and reselect" })
map("x", ">", ">gv", { desc = "Indent right and reselect" })
map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
map("i", "<A-t>", "<C-v><Tab>", { desc = "Insert literal tab" })
map("n", "<C-/>", function()
  MiniComment.toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle comment" })
map("x", "<C-/>", function()
  MiniComment.toggle_lines(vim.fn.line("'<"), vim.fn.line("'>"))
end, { desc = "Toggle comment" })

-- Diagnostics and formatting.
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

local function format()
  vim.lsp.buf.format({ async = false, timeout_ms = 1000 })
end

map({ "n", "x" }, "f<leader>", format, { desc = "Format with LSP" })
map({ "n", "x" }, "<leader>af", format, { desc = "Format with LSP" })

map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal normal mode" })
