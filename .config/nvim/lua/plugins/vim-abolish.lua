return {
	"tpope/vim-abolish",
	init = function()
		vim.g.abolish_no_mappings = true
	end,
	keys = {
		{ "gs", "<Plug>(abolish-coerce)", mode = { "n", "v" } }
	}
}
