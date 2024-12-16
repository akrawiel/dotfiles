return {
	"nvimtools/none-ls.nvim",
	config = function()
		local sources = {
			require("null-ls").builtins.diagnostics.fish,
			require("null-ls").builtins.diagnostics.selene,
			require("null-ls").builtins.diagnostics.yamllint,
		}

		require("null-ls").setup({
			sources = sources,
		})
	end,
}
