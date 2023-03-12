return function(enabled_servers)
  local lsp = require 'lspconfig'
  local util = require 'lspconfig/util'

  local pid = vim.fn.getpid()

  local common_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gk', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<space>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>cf', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  end

  local function javascript_root(filename)
    return util.root_pattern(".eslintrc")(filename)
      or util.root_pattern(".eslintrc.js")(filename)
      or util.root_pattern(".eslintrc.json")(filename)
      or util.root_pattern("package.json")(filename)
      or util.root_pattern(".git")(filename)
  end

  local servers = {
    tsserver = {
      name = 'tsserver',
      on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)

        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
      end,
      params = {
        root_dir = javascript_root,
      }
    },
    svelte = {
      name = 'svelte',
      on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)

        client.server_capabilities.document_formatting = false
      end,
      params = {
        root_dir = javascript_root,
      }
    },
    vuels = {
      name = 'vuels',
      on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)

        client.server_capabilities.document_formatting = false
      end,
      params = {
        root_dir = javascript_root,
      }
    },
    html = {
      name = 'html',
      on_attach = common_on_attach,
    },
    cssls = {
      name = 'cssls',
      on_attach = common_on_attach,
      params = {
        root_dir = javascript_root,
      }
    },
    gopls = {
      name = 'gopls',
      on_attach = common_on_attach,
    },
    dartls = {
      name = 'dartls',
      on_attach = common_on_attach,
    },
    rust_analyzer = {
      name = 'rust_analyzer',
      on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)

        client.server_capabilities.document_formatting = true
      end,
      params = {
        settings = {
          ["rust-analyzer"] = {
            assist = {
              importGranularity = "module",
              importPrefix = "by_self",
            },
            rustfmt = {
              enableRangeFormatting = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      },
    },
    pylsp = {
      name = 'pylsp',
      on_attach = common_on_attach,
    },
    lua_ls = {
      name = 'lua_ls',
      on_attach = function(client, bufnr)
        common_on_attach(client, bufnr)

        -- client.server_capabilities.document_formatting = false
        -- client.server_capabilities.document_range_formatting = false
      end,
      params = {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = {'vim'},
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
              enable = false,
            },
            format = {
              enable = false,
            }
          },
        },
      },
    },
    emmet_ls = {
      name = 'emmet_ls',
      on_attach = common_on_attach,
      params = {
        filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less', 'vue' },
      },
    }
  }

  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  local function handle_server(server)
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

  if enabled_servers then
    for _, server_name in pairs(enabled_servers) do
      local server = servers[server_name]
      if server then handle_server(server) end
    end
  else
    for _, server in pairs(servers) do
      handle_server(server)
    end
  end
end
