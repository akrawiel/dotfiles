local lsp = require('lspconfig')
local util = require('lspconfig/util')

local common_on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
end

local eslint = {
  lintCommand = 'eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {
    '%f(%l,%c): %tarning %m',
    '%f(%l,%c): %rror %m',
  },
  formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}',
  formatStdin = true,
}

local function javascript_root(filename)
  return util.root_pattern(".eslintrc")(filename)
    or util.root_pattern(".eslintrc.js")(filename)
    or util.root_pattern("package.json")(filename)
    or util.root_pattern(".git")(filename)
end

local servers = {
  {
    name = 'tsserver',
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)

      client.resolved_capabilities.document_formatting = false
    end,
    params = {
      root_dir = javascript_root,
    }
  },
  {
    name = 'svelte',
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)

      client.resolved_capabilities.document_formatting = false
    end,
    params = {
      root_dir = javascript_root,
    }
  },
  {
    name = 'vuels',
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)

      client.resolved_capabilities.document_formatting = false
    end,
    params = {
      root_dir = javascript_root,
    }
  },
  {
    name = 'omnisharp',
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)

      vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 5000)]]

      vim.api.nvim_buf_set_keymap(bufnr, 'n', '<F9>', "<cmd>call jobstart('dotnet run')<CR>", {
        silent = false,
        noremap = true
      })
    end,
    params = {
      cmd = { "omnisharp", "--languageserver" , "--hostPID", tostring(vim.fn.getpid()) };
    }
  },
  {
    name = 'gdscript',
    on_attach = common_on_attach,
  },
  {
    name = 'html',
    on_attach = common_on_attach,
  },
  {
    name = 'haxe_language_server',
    on_attach = common_on_attach,
    params = {
      cmd = { "node", "/home/akrawiel/Applications/haxe-language-server/bin/server.js" },
      filetypes = { "haxe" },
      init_options = {
        displayArguments = { "build.hxml" },
      },
      root_dir = util.root_pattern("*.hxml"),
      settings = {
        haxe = {
          executable = "haxe",
        },
      },
    }
  },
  {
    name = 'efm',
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)

      vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 5000)]]
    end,
    params = {
      filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx', 'svelte', 'vue' },
      init_options = {
        documentFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true,
      },
      root_dir = javascript_root,
      settings = {
        languages = {
          javascript = {eslint},
          javascriptreact = {eslint},
          ["javascript.jsx"] = {eslint},
          typescript = {eslint},
          typescriptreact = {eslint},
          ["typescript.tsx"] = {eslint},
          svelte = {eslint},
          vue = {eslint}
        }
      }
    }
  }
}

for _, server in pairs(servers) do
  local result_params = {
    on_attach = server.on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }

  if server.params then
    for param_key, param in pairs(server.params) do
      result_params[param_key] = param
    end
  end

  lsp[server.name].setup(result_params)
end
