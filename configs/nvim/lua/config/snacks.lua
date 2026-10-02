local snacks = require("snacks")

snacks.setup({
  dashboard = { enabled = false },
  explorer = { enabled = true },
  notifier = {
    enabled = true,
    style = "compact",
    timeout = 3000,
  },
  picker = { enabled = true },
})

-- Render LSP progress through the same popup system as other notifications.
local lsp_progress = vim.defaulttable()
vim.api.nvim_create_autocmd("LspProgress", {
  group = vim.api.nvim_create_augroup("michael_snacks_lsp_progress", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    local value = event.data.params.value
    if not client or type(value) ~= "table" then
      return
    end

    local progress = lsp_progress[client.id]
    for index = 1, #progress + 1 do
      if index == #progress + 1 or progress[index].token == event.data.params.token then
        progress[index] = {
          token = event.data.params.token,
          message = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local messages = {}
    lsp_progress[client.id] = vim.tbl_filter(function(item)
      table.insert(messages, item.message)
      return not item.done
    end, progress)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(messages, "\n"), vim.log.levels.INFO, {
      id = "lsp_progress_" .. client.id,
      title = client.name,
      opts = function(notification)
        notification.icon = #lsp_progress[client.id] == 0 and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- Keep native selectors (including LSP code actions) in the same picker UI.
vim.ui.select = snacks.picker.select

local function map(lhs, callback, desc, mode)
  vim.keymap.set(mode or "n", lhs, callback, { silent = true, desc = desc })
end

-- Files and search.
map("<leader><space>", function()
  snacks.picker.smart()
end, "Smart find files")
map("<leader>f", function()
  snacks.picker.files()
end, "Find files")
map("<leader>e", function()
  snacks.explorer()
end, "File explorer")
map("<leader>q", function()
  snacks.picker()
end, "Browse pickers")
map("<leader>;", function()
  snacks.picker.resume()
end, "Resume last picker")
map("<leader>/", function()
  snacks.picker.grep()
end, "Grep")
map("<leader>b", function()
  snacks.picker.buffers()
end, "Buffers")
map("<leader>cs", function()
  snacks.picker.colorschemes()
end, "Colorschemes")
map("<leader>u", function()
  snacks.picker.undo()
end, "Undo history")
map("<leader>nh", function()
  snacks.notifier.show_history()
end, "Notification history")
map("<leader>nd", function()
  snacks.notifier.hide()
end, "Dismiss notifications")
map("<leader>s", function()
  snacks.picker.lsp_symbols()
end, "Document symbols")
map("<leader>S", function()
  snacks.picker.lsp_workspace_symbols()
end, "Workspace symbols")

-- LSP navigation through the same picker used everywhere else.
map("gd", function()
  snacks.picker.lsp_definitions()
end, "LSP definitions")
map("gD", function()
  snacks.picker.lsp_declarations()
end, "LSP declarations")
map("gr", function()
  snacks.picker.lsp_references()
end, "LSP references")
map("gi", function()
  snacks.picker.lsp_implementations()
end, "LSP implementations")
map("gy", function()
  snacks.picker.lsp_type_definitions()
end, "LSP type definitions")

-- Diagnostic picker equivalents for the old Trouble bindings.
map("<leader>xx", function()
  snacks.picker.diagnostics()
end, "Workspace diagnostics")
map("<leader>xX", function()
  snacks.picker.diagnostics_buffer()
end, "Buffer diagnostics")
map("<leader>xL", function()
  snacks.picker.loclist()
end, "Location list")
map("<leader>xQ", function()
  snacks.picker.qflist()
end, "Quickfix list")

-- Git and terminal utilities already used in the Lua configs.
map("<leader>gg", function()
  snacks.lazygit()
end, "Lazygit")
map("<leader>gf", function()
  snacks.lazygit.log_file()
end, "Lazygit file log")
map("<leader>gs", function()
  snacks.picker.git_status()
end, "Git status")
map("<leader>gd", function()
  snacks.picker.git_diff()
end, "Git diff")
map("<leader>gb", function()
  snacks.picker.git_branches()
end, "Git branches")
map("<M-t>", function()
  snacks.terminal()
end, "Toggle terminal", { "n", "t" })
