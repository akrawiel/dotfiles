return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local sources = {
			require("null-ls").builtins.diagnostics.fish,
			require("null-ls").builtins.diagnostics.jsonlint,
			require("null-ls").builtins.diagnostics.luacheck,
			require("null-ls").builtins.diagnostics.yamllint,
		}

		local function has_file(...)
			return #vim.fs.find({ ... }, {
				path = vim.fn.getcwd(),
			}) > 0
		end

		if has_file(".xo-config.json") then
			table.insert(sources, require("null-ls").builtins.code_actions.xo)
			table.insert(sources, require("null-ls").builtins.diagnostics.xo)
		elseif has_file(".eslintrc.js", ".eslintrc.json", ".eslintrc") then
			table.insert(sources, require("null-ls").builtins.code_actions.eslint_d)
			table.insert(sources, require("null-ls").builtins.diagnostics.eslint_d)
		end

		require("null-ls").setup({
			sources = sources,
		})
	end,
}
