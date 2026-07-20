-- Inspiration from Nick Maslov
-- https://medium.com/@nikmas_dev/vscode-neovim-setup-keyboard-centric-powerful-reliable-clean-and-aesthetic-development-582d34297985
-- With lots of additions and some improvements over the base

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local nv = { "n", "v" }

local vsc_action = function(action)
  return "<cmd>lua require('vscode').action('" .. action .. "')<CR>"
end

-- leader
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ====================
-- Core Editing Quality
-- ====================

-- system clipboard
keymap(nv, "<leader>y", '"+y', opts)
keymap(nv, "<leader>p", '"+p', opts)

-- preserve yank on paste
keymap("v", "p", '"_dP', opts)

-- indentation
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- move lines
keymap("v", "J", ":m .+1<CR>==", opts)
keymap("v", "K", ":m .-2<CR>==", opts)
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- search UX
keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)

-- scroll center
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- ====================
-- Navigation (LSP-like)
-- ====================

keymap("n", "gd", vsc_action("editor.action.revealDefinition"), opts)
keymap("n", "gD", vsc_action("editor.action.peekDefinition"), opts)
keymap("n", "gr", vsc_action("editor.action.goToReferences"), opts)
keymap("n", "gi", vsc_action("editor.action.goToImplementation"), opts)
keymap("n", "gy", vsc_action("editor.action.goToTypeDefinition"), opts)

-- diagnostics
keymap("n", "]d", vsc_action("editor.action.marker.next"), opts)
keymap("n", "[d", vsc_action("editor.action.marker.prev"), opts)

-- ====================
-- Leader Groups
-- ====================

-- ---- Files / Find ----
keymap(nv, "<leader>f", vsc_action("workbench.action.quickOpen"), opts)
keymap(nv, "<leader>/", vsc_action("workbench.action.findInFiles"), opts)
keymap(nv, "<leader>s", vsc_action("workbench.action.gotoSymbol"), opts)
keymap(nv, "<leader>S", vsc_action("workbench.action.showAllSymbols"), opts)

-- ---- Buffers / Files ----
keymap("n", "<leader>w", vsc_action("workbench.action.files.save"), opts)
keymap("n", "<leader>q", vsc_action("workbench.action.closeActiveEditor"), opts)
keymap(nv, "<M-w>", vsc_action("workbench.action.closeActiveEditor"), opts)
keymap("n", "<M-.>", vsc_action("workbench.action.nextEditor"), opts)
keymap("n", "<M-,>", vsc_action("workbench.action.previousEditor"), opts)
keymap("n", "<leader>,", vsc_action("workbench.action.previousEditor"), opts)
keymap(
  "n",
  "<leader>bd",
  vsc_action("workbench.action.closeActiveEditor"),
  opts
)

-- ---- LSP / Code ----
keymap(nv, "<leader>la", vsc_action("editor.action.quickFix"), opts)
keymap(nv, "<leader>lc", vsc_action("editor.action.codeAction"), opts)
keymap(nv, "<leader>lr", vsc_action("editor.action.rename"), opts)
keymap(nv, "<leader>ld", vsc_action("editor.action.showHover"), opts)
keymap(nv, "<leader>lf", vsc_action("editor.action.formatDocument"), opts)

-- diagnostics panel
keymap(nv, "<leader>lp", vsc_action("workbench.actions.view.problems"), opts)

-- ---- Windows ----
keymap("n", "<C-h>", vsc_action("workbench.action.focusLeftGroup"), opts)
keymap("n", "<C-l>", vsc_action("workbench.action.focusRightGroup"), opts)

keymap(
  "n",
  "<leader>wh",
  vsc_action("workbench.action.moveEditorToLeftGroup"),
  opts
)
keymap(
  "n",
  "<leader>wl",
  vsc_action("workbench.action.moveEditorToRightGroup"),
  opts
)
keymap(
  "n",
  "<leader>wk",
  vsc_action("workbench.action.moveEditorToAboveGroup"),
  opts
)
keymap(
  "n",
  "<leader>wj",
  vsc_action("workbench.action.moveEditorToBelowGroup"),
  opts
)
keymap("n", "<leader>wv", vsc_action("workbench.action.splitEditorRight"), opts)
keymap("n", "<leader>ws", vsc_action("workbench.action.splitEditorDown"), opts)

-- ---- Terminal ----
keymap(
  nv,
  "<leader>tt",
  vsc_action("workbench.action.terminal.toggleTerminal"),
  opts
)
keymap("n", "<leader>tn", vsc_action("workbench.action.terminal.new"), opts)
keymap("n", "<leader>tf", vsc_action("workbench.action.terminal.focus"), opts)

-- ---- Search / Selection ----
keymap(
  "n",
  "<leader>sw",
  vsc_action("editor.action.addSelectionToNextFindMatch"),
  opts
)

-- multicursor
keymap(
  "n",
  "<C-c>",
  vsc_action("editor.action.addSelectionToNextFindMatch"),
  opts
)
keymap("n", "<leader>mc", vsc_action("editor.action.insertCursorBelow"), opts)

-- ---- Comments ----
keymap(nv, "<C-/>", vsc_action("editor.action.commentLine"), opts)

-- ---- Git ----
keymap("n", "<leader>gs", vsc_action("workbench.view.scm"), opts)
keymap("n", "<leader>gd", vsc_action("git.openChange"), opts)

-- ---- Debug ----
keymap(
  nv,
  "<leader>db",
  vsc_action("editor.debug.action.toggleBreakpoint"),
  opts
)

-- ---- UI / Misc ----
keymap(nv, "<leader>cp", vsc_action("workbench.action.showCommands"), opts)
keymap(nv, "<leader>cn", vsc_action("notifications.clearAll"), opts)

-- ====================
-- Harpoon
-- ====================

keymap(nv, "<leader>ha", vsc_action("vscode-harpoon.addEditor"))
keymap(nv, "<leader>ho", vsc_action("vscode-harpoon.editorQuickPick"))
keymap(nv, "<leader>he", vsc_action("vscode-harpoon.editEditors"))
keymap(nv, "<leader>h1", vsc_action("vscode-harpoon.gotoEditor1"))
keymap(nv, "<leader>h2", vsc_action("vscode-harpoon.gotoEditor2"))
keymap(nv, "<leader>h3", vsc_action("vscode-harpoon.gotoEditor3"))
keymap(nv, "<leader>h4", vsc_action("vscode-harpoon.gotoEditor4"))
keymap(nv, "<leader>h5", vsc_action("vscode-harpoon.gotoEditor5"))
keymap(nv, "<leader>h6", vsc_action("vscode-harpoon.gotoEditor6"))
keymap(nv, "<leader>h7", vsc_action("vscode-harpoon.gotoEditor7"))
keymap(nv, "<leader>h8", vsc_action("vscode-harpoon.gotoEditor8"))
keymap(nv, "<leader>h9", vsc_action("vscode-harpoon.gotoEditor9"))

-- ====================
-- Project Manager
-- ====================

keymap(nv, "<leader>pa", vsc_action("projectManager.saveProject"))
keymap(nv, "<leader>po", vsc_action("projectManager.listProjectsNewWindow"))
keymap(nv, "<leader>pe", vsc_action("projectManager.editProjects"))
