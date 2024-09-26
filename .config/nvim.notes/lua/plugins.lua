return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "latte",
		},
		config = function()
			vim.cmd([[colorscheme catppuccin-latte]])
		end,
	},
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup()
			require("mini.operators").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.move").setup()

			require("mini.jump2d").setup()

			require("mini.notify").setup()
			require("mini.icons").setup()
			require("mini.statusline").setup()
		end,
	},
	{
		"okuuva/auto-save.nvim",
		opts = {
			execution_message = {
				enabled = false
			}
		},
	},
}
