local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    before_init = function(_, config)
      -- Read from somewhere like .config if available since I do that a lot
      local path = config.root_dir and (config.root_dir .. "/.config/luarc.json")
      if not path or vim.fn.filereadable(path) ~= 1 then
        return
      end

      local project_settings = vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
      local default_library = config.settings.Lua.workspace.library
      project_settings.workspace.library = vim.list_extend(default_library, project_settings.workspace.library)
      config.settings.Lua = vim.tbl_deep_extend("force", config.settings.Lua, project_settings)
    end,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          library = { vim.env.VIMRUNTIME },
        },
      },
    },
  },
  nil_ls = {
    cmd = { "nil" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
      ["nil"] = {
        formatting = { command = { "nixfmt" } },
        nix = {
          flake = {
            autoArchive = true,
            nixpkgsInputName = "nixpkgs",
            maxMemoryMB = 4096,
          },
        },
      },
    },
  },
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    settings = {
      basedpyright = {
        typeCheckingMode = "standard",
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", "setup.py", ".git" },
    on_attach = function(client)
      client.server_capabilities.hoverProvider = false
    end,
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
  },
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh", "zsh" },
    root_markers = { ".git" },
    single_file_support = true,
  },
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
    root_markers = { ".git" },
    single_file_support = true,
  },
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    single_file_support = true,
  },
  nushell = {
    cmd = { "nu", "--lsp" },
    filetypes = { "nu" },
    root_markers = { ".git" },
    single_file_support = true,
  },
}

local missing = {}
for name, config in pairs(servers) do
  config.capabilities = capabilities
  vim.lsp.config(name, config)

  if vim.fn.executable(config.cmd[1]) == 1 then
    vim.lsp.enable(name)
  else
    table.insert(missing, config.cmd[1])
  end
end
table.sort(missing)

vim.api.nvim_create_user_command("LspMissing", function()
  if #missing == 0 then
    vim.notify("All configured language servers are available.")
    return
  end
  vim.notify("Missing language-server commands: " .. table.concat(missing, ", "), vim.log.levels.WARN)
end, { desc = "Show configured language servers missing from PATH" })

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("michael_lsp_attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    local function map(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = event.buf, silent = true, desc = "LSP: " .. desc })
    end

    map("K", vim.lsp.buf.hover, "Hover documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
  end,
})
