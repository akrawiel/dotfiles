return {
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		local sources = {
			require("null-ls").builtins.diagnostics.fish,
			require("null-ls").builtins.diagnostics.jsonlint,
			require("null-ls").builtins.diagnostics.luacheck,
			require("null-ls").builtins.diagnostics.yamllint,
		}

		if vim.fn.findfile(".xo-config.json") ~= nil then
			table.insert(sources, require("null-ls").builtins.code_actions.xo)
			table.insert(sources, require("null-ls").builtins.diagnostics.xo)
		elseif
			vim.fn.findfile(".eslintrc.js") ~= nil
			or vim.fn.findfile(".eslintrc.json") ~= nil
			or vim.fn.findfile(".eslintrc") ~= nil
		then
			table.insert(sources, require("null-ls").builtins.code_actions.eslint_d)
			table.insert(sources, require("null-ls").builtins.diagnostics.eslint_d)
		end

		require("null-ls").setup({
			sources = sources,
		})
	end,
}
