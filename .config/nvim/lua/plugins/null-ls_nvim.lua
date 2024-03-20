return {
	"nvimtools/none-ls.nvim",
	config = function()
		local sources = {
			require("null-ls").builtins.diagnostics.fish,
			require("null-ls").builtins.diagnostics.selene,
			require("null-ls").builtins.diagnostics.yamllint,
		}

		local function has_file(...)
			return #vim.fs.find({ ... }, {
				path = vim.fn.getcwd(),
			}) > 0
		end

		require("null-ls").setup({
			sources = sources,
		})
	end,
}
