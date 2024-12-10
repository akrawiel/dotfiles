return {
	{
		"catppuccin/nvim",
		lazy = false,
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
		lazy = false,
		config = function()
			require("mini.ai").setup()
			require("mini.operators").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.move").setup()

			require("mini.files").setup()

			require("mini.jump2d").setup({
				view = {
					dim = true,
				},
			})

			require("mini.notify").setup()
			require("mini.icons").setup()
			require("mini.statusline").setup()
		end,
		keys = {
			{
				"-",
				function()
					require("mini.files").open()
				end,
			},
		},
	},
	{
		"okuuva/auto-save.nvim",
		lazy = false,
		opts = {
			enabled = true,
			trigger_events = {
				immediate_save = { "BufLeave", "FocusLost" },
				defer_save = { "InsertLeave", "TextChanged" },
				cancel_deferred_save = { "InsertEnter" },
			},
			condition = nil,
			write_all_buffers = false,
			noautocmd = false,
			lockmarks = false,
			debounce_delay = 1000,
			debug = false,
		},
	},
}
