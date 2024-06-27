return {
	"williamboman/mason.nvim",
	cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
	opts = {
		ensure_installed = {
			"biome",
			"css-lsp",
			"cssmodules-language-server",
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
			"lua-language-server",
			"prettierd",
			"python-lsp-server",
			"rust-analyzer",
			"selene",
			"stylelint-lsp",
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
