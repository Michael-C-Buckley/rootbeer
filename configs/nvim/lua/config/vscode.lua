-- Exists exclusively for the Vscode-Neovim Extension
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local nv = { "n", "v" }

local function vscode_action(action)
  return "<Cmd>lua require('vscode').action('" .. action .. "')<CR>"
end

keymap("n", "<Space>", "", opts)

-- Core editing.
keymap(nv, "<leader>y", '"+y', opts)
keymap(nv, "<leader>p", '"+p', opts)
keymap("v", "p", '"_dP', opts)
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("v", "J", ":move '>+1<CR>gv=gv", opts)
keymap("v", "K", ":move '<-2<CR>gv=gv", opts)
keymap("n", "<Esc>", "<Esc>:nohlsearch<CR>", opts)
keymap("n", "n", "nzzzv", opts)
keymap("n", "N", "Nzzzv", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Navigation and diagnostics.
keymap("n", "gd", vscode_action("editor.action.revealDefinition"), opts)
keymap("n", "gD", vscode_action("editor.action.peekDefinition"), opts)
keymap("n", "gr", vscode_action("editor.action.goToReferences"), opts)
keymap("n", "gi", vscode_action("editor.action.goToImplementation"), opts)
keymap("n", "gy", vscode_action("editor.action.goToTypeDefinition"), opts)
keymap("n", "]d", vscode_action("editor.action.marker.next"), opts)
keymap("n", "[d", vscode_action("editor.action.marker.prev"), opts)

-- Files and editors.
keymap(nv, "<leader>ff", vscode_action("workbench.action.quickOpen"), opts)
keymap(nv, "<leader>fg", vscode_action("workbench.action.findInFiles"), opts)
keymap(nv, "<leader>fs", vscode_action("workbench.action.gotoSymbol"), opts)
keymap(nv, "<leader>fS", vscode_action("workbench.action.showAllSymbols"), opts)
keymap("n", "<leader>w", vscode_action("workbench.action.files.save"), opts)
keymap({ "n", "i", "v" }, "<C-s>", vscode_action("workbench.action.files.save"), opts)
keymap("n", "<leader>q", vscode_action("workbench.action.closeActiveEditor"), opts)
keymap("n", "<leader>bd", vscode_action("workbench.action.closeActiveEditor"), opts)

-- Language actions.
keymap(nv, "<leader>la", vscode_action("editor.action.quickFix"), opts)
keymap(nv, "<leader>lc", vscode_action("editor.action.codeAction"), opts)
keymap(nv, "<leader>lr", vscode_action("editor.action.rename"), opts)
keymap(nv, "<leader>ld", vscode_action("editor.action.showHover"), opts)
keymap(nv, "<leader>lf", vscode_action("editor.action.formatDocument"), opts)
keymap(nv, "<leader>lp", vscode_action("workbench.actions.view.problems"), opts)

-- Windows and terminal.
keymap("n", "<C-h>", vscode_action("workbench.action.focusLeftGroup"), opts)
keymap("n", "<C-l>", vscode_action("workbench.action.focusRightGroup"), opts)
keymap("n", "<C-k>", vscode_action("workbench.action.focusAboveGroup"), opts)
keymap("n", "<C-j>", vscode_action("workbench.action.focusBelowGroup"), opts)
keymap("n", "<leader>wh", vscode_action("workbench.action.moveEditorToLeftGroup"), opts)
keymap("n", "<leader>wl", vscode_action("workbench.action.moveEditorToRightGroup"), opts)
keymap(nv, "<leader>tt", vscode_action("workbench.action.terminal.toggleTerminal"), opts)

-- Search, comments, Git, and debugging.
keymap("n", "<leader>ss", vscode_action("workbench.action.findInFiles"), opts)
keymap("n", "<leader>sw", vscode_action("editor.action.addSelectionToNextFindMatch"), opts)
keymap("n", "<C-d>", vscode_action("editor.action.addSelectionToNextFindMatch"), opts)
keymap("n", "<leader>mc", vscode_action("editor.action.insertCursorBelow"), opts)
keymap(nv, "<leader>/", vscode_action("editor.action.commentLine"), opts)
keymap("n", "<leader>gs", vscode_action("workbench.view.scm"), opts)
keymap("n", "<leader>gd", vscode_action("git.openChange"), opts)
keymap(nv, "<leader>db", vscode_action("editor.debug.action.toggleBreakpoint"), opts)
keymap(nv, "<leader>cp", vscode_action("workbench.action.showCommands"), opts)
keymap(nv, "<leader>cn", vscode_action("notifications.clearAll"), opts)

-- VSCode Harpoon.
keymap(nv, "<leader>ha", vscode_action("vscode-harpoon.addEditor"), opts)
keymap(nv, "<leader>ho", vscode_action("vscode-harpoon.editorQuickPick"), opts)
keymap(nv, "<leader>he", vscode_action("vscode-harpoon.editEditors"), opts)
for index = 1, 9 do
  keymap(nv, "<leader>h" .. index, vscode_action("vscode-harpoon.gotoEditor" .. index), opts)
end

-- VSCode Project Manager.
keymap(nv, "<leader>pa", vscode_action("projectManager.saveProject"), opts)
keymap(nv, "<leader>po", vscode_action("projectManager.listProjectsNewWindow"), opts)
keymap(nv, "<leader>pe", vscode_action("projectManager.editProjects"), opts)
