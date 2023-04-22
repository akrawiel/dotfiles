return function()
	local lsp = require("lspconfig")
	local util = require("lspconfig/util")

	local pid = vim.fn.getpid()

	local common_on_attach = function(client, bufnr)
		local function buf_set_keymap(...)
			vim.api.nvim_buf_set_keymap(bufnr, ...)
		end
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

		local opts = { noremap = true, silent = true }

		buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
		buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
		buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
		buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		buf_set_keymap("n", "<space>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
		buf_set_keymap("n", "<space>cf", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
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
			on_attach = function(client)
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false
			end,
			params = {
				root_dir = javascript_root,
			},
		},
		svelte = {
			on_attach = function(client)
				client.server_capabilities.document_formatting = false
			end,
			params = {
				root_dir = javascript_root,
			},
		},
		volar = {
			params = {
				root_dir = javascript_root,
			},
		},
		html = true,
		cssls = {
			params = {
				root_dir = javascript_root,
			},
		},
		gopls = true,
		dartls = true,
		rust_analyzer = {
			on_attach = function(client)
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
		pylsp = true,
		lua_ls = {
			params = {
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
						format = {
							enable = false,
						},
					},
				},
			},
		},
		denols = {
			params = {
				root_dir = util.root_pattern("deno.json", "deno.jsonc"),
			},
		},
		elixirls = {
			params = {
				cmd = { "/usr/bin/elixir-ls" },
			},
		},
		tailwindcss = true,
	}

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	for name, server in pairs(servers) do
		local result_params = {
			on_attach = function(client, bufnr)
				common_on_attach(client, bufnr)

				if type(server) == "table" and server.on_attach then
					---@diagnostic disable-next-line: redundant-parameter
					server.on_attach(client, bufnr)
				end
			end,
			flags = {
				debounce_text_changes = 500,
			},
			capabilities = capabilities,
		}

		if type(server) == "table" and server.params then
			for param_key, param in pairs(server.params) do
				result_params[param_key] = param
			end
		end

		lsp[name].setup(result_params)
	end
end
