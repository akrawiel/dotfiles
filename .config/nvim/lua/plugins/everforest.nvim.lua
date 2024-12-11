return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	version = false,
	lazy = false,
	config = function()
		vim.g.everforest_enable_italic = true
		vim.g.everforest_background = "soft"
		vim.g.everforest_better_performance = true

		vim.cmd.colorscheme("everforest")
	end,
}
