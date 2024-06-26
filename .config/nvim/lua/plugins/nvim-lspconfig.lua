return {
	"neovim/nvim-lspconfig",
	config = function()
		local lsp = require("lspconfig")
		local util = require("lspconfig/util")

		local common_on_attach = function(client, bufnr)
			local function buf_set_keymap(...)
				vim.api.nvim_buf_set_keymap(bufnr, ...)
			end
			local function buf_set_option(...)
				vim.api.nvim_buf_set_option(bufnr, ...)
			end

			buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

			local opts = { noremap = true, silent = true }

			buf_set_keymap("n", "<C-S-j>", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
			buf_set_keymap("n", "<C-S-k>", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
			buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
			buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
			buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
			buf_set_keymap("n", "<space>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
			buf_set_keymap("n", "<space>cf", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
		end

		local function has_file(...)
			for _, file in pairs({ ... }) do
				if #vim.fn.findfile(file, string.format("%s/%s", vim.fn.getcwd(), "**1")) > 0 then
					return true
				end
			end

			return false
		end

		local function javascript_root(filename)
			return util.root_pattern(".eslintrc")(filename)
				or util.root_pattern(".eslintrc.js")(filename)
				or util.root_pattern(".eslintrc.json")(filename)
				or util.root_pattern("package.json")(filename)
				or util.root_pattern(".git")(filename)
		end

		local servers = {
			jdtls = false,
			eslint = true,
			biome = has_file("biome.json") or has_file("biome.jsonc"),
			jsonls = true,
			tsserver = {
				on_attach = function(client)
					client.server_capabilities.document_formatting = false
					client.server_capabilities.document_range_formatting = false
				end,
				params = {
					root_dir = javascript_root,
					init_options = {
						preferences = {
							importModuleSpecifierEnding = "minimal",
						},
					},
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
			html = true,
			cssls = {
				params = {
					root_dir = javascript_root,
				},
			},
			gopls = true,
			dartls = true,
			dockerls = true,
			docker_compose_language_service = true,
			rust_analyzer = true,
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
					cmd = { string.format("%s/Bin/elixir-ls/language_server.sh", os.getenv("HOME")) },
				},
			},
			tailwindcss = true,
			emmet_language_server = {
				params = {
					filetypes = {
						"css",
						"eruby",
						"html",
						"htmldjango",
						"javascriptreact",
						"less",
						"pug",
						"sass",
						"scss",
						"svelte",
						"typescriptreact",
						"vue",
					},
				},
			},
			volar = {
				params = {
					init_options = {
						typescript = {
							tsdk = "/usr/local/lib/node_modules/typescript/lib",
						},
					},
				},
			},
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
	end,
}
