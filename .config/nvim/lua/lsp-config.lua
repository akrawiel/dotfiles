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
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>cd', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>cq', '<cmd>lua vim.lsp.diagnostic.set_qflist()<CR>', opts)
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

local prettier = {
  formatCommand = 'prettierd "${INPUT}"',
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
      client.resolved_capabilities.document_range_formatting = false
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
    name = 'html',
    on_attach = common_on_attach,
  },
  {
    name = 'gopls',
    on_attach = common_on_attach,
  },
  {
    name = 'dartls',
    on_attach = common_on_attach,
  },
  {
    name = 'gdscript',
    on_attach = common_on_attach,
  },
  {
    name = 'efm',
    on_attach = function(client, bufnr)
      common_on_attach(client, bufnr)

      client.resolved_capabilities.document_formatting = true
      client.resolved_capabilities.code_action = true

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
          javascript = {prettier, eslint},
          javascriptreact = {prettier, eslint},
          ["javascript.jsx"] = {prettier, eslint},
          typescript = {prettier, eslint},
          typescriptreact = {prettier, eslint},
          ["typescript.tsx"] = {prettier, eslint},
          svelte = {prettier, eslint},
          vue = {prettier, eslint}
        }
      }
    }
  },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for _, server in pairs(servers) do
  local result_params = {
    on_attach = server.on_attach,
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  }

  if server.params then
    for param_key, param in pairs(server.params) do
      result_params[param_key] = param
    end
  end

  lsp[server.name].setup(result_params)
end
