return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local nullLs = require("null-ls")

		nullLs.setup({
			sources = {
				nullLs.builtins.code_actions.eslint_d,
				nullLs.builtins.diagnostics.eslint_d,
				nullLs.builtins.diagnostics.fish,
				nullLs.builtins.diagnostics.jsonlint,
				nullLs.builtins.diagnostics.luacheck,
				nullLs.builtins.diagnostics.yamllint,
				nullLs.builtins.formatting.prettierd,
				nullLs.builtins.formatting.eslint_d,
				nullLs.builtins.formatting.stylua,
			},
		})
	end,
}
