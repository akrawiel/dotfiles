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
			buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
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
			eslint = true,
			stylelint_lsp = {
				params = {
					filetypes = {
						"css",
						"less",
						"scss",
						"sugarss",
					},
				},
			},
			biome = has_file("biome.json", "biome.jsonc"),
			jsonls = true,
			ts_ls = {
				on_attach = function(client)
					client.server_capabilities.document_formatting = false
					client.server_capabilities.document_range_formatting = false
				end,
				params = {
					root_dir = util.root_pattern("tsconfig.json", "jsconfig.json"),
					enabled = has_file("tsconfig.json", "jsconfig.json"),
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
			denols = has_file("deno.json", "deno.jsonc"),
			elixirls = {
				params = {
					cmd = { "elixir-ls" },
				},
			},
			kotlin_language_server = true,
			tailwindcss = has_file("tailwind.config.js", "tailwind.config.ts"),
			unocss = has_file("unocss.config.js", "unocss.config.ts", "uno.config.js", "uno.config.ts"),
			astro = has_file("astro.config.mjs"),
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
							tsdk = string.format(
								"%s/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib",
								os.getenv("HOME")
							),
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

				lsp[name].setup(result_params)
			end

			if type(server) == "boolean" and server == true then
				lsp[name].setup({})
			end
		end
	end,
}
