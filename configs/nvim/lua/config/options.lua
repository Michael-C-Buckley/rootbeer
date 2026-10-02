local opt = vim.opt

-- Editing defaults carried over from NVF
opt.autoindent = true
opt.backspace = { "indent", "eol", "start" }
opt.expandtab = true
opt.matchtime = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.smartindent = true
opt.softtabstop = 2
opt.tabstop = 2

-- Keep context visible without adding a custom status column
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false

-- File handling
opt.autochdir = false
opt.autoread = true
opt.autowrite = false
opt.backup = false
opt.exrc = true
opt.swapfile = false
opt.undofile = true
opt.writebackup = false

-- General behavior
opt.clipboard = "unnamedplus"
opt.completeopt = { "menuone", "noselect", "popup" }
opt.confirm = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.ignorecase = true
opt.mouse = "a"
opt.scrollback = 10000
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 300
opt.ttimeoutlen = 0
opt.updatetime = 250

-- Start with a plain empty buffer, not Neovim's intro screen
opt.shortmess:append("I")
