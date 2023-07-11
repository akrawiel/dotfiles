return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		require("null-ls").setup({
			sources = {
				require("null-ls").builtins.code_actions.eslint_d,
				require("null-ls").builtins.diagnostics.eslint_d,
				require("null-ls").builtins.diagnostics.fish,
				require("null-ls").builtins.diagnostics.jsonlint,
				require("null-ls").builtins.diagnostics.luacheck,
				require("null-ls").builtins.diagnostics.yamllint,
				require("null-ls").builtins.formatting.prettierd,
				require("null-ls").builtins.formatting.eslint_d,
				require("null-ls").builtins.formatting.stylua,
			},
		})
	end,
}
