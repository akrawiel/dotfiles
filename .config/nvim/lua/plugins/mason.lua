return {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	opts = {
		ensure_installed = {
			"css-lsp",
			"deno",
			"docker-compose-language-service",
			"dockerfile-language-server",
			"elixir-ls",
			"emmet-language-server",
			"eslint-lsp",
			"eslint_d",
			"gopls",
			"html-lsp",
			"json-lsp",
			"jsonlint",
			"lua-language-server",
			"luacheck",
			"prettierd",
			"python-lsp-server",
			"rust-analyzer",
			"stylua",
			"svelte-language-server",
			"tailwindcss-language-server",
			"typescript-language-server",
			"vue-language-server",
			"yamllint",
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)

		vim.api.nvim_create_user_command("MasonInstallAll", function()
			vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
		end, {})

		vim.g.mason_binaries_list = opts.ensure_installed
	end,
}
