return {
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

			require("mini.base16").setup({
				palette = {
					["base00"] = "#f2e5bc",
					["base01"] = "#ebdbb2",
					["base02"] = "#d5c4a1",
					["base03"] = "#bdae93",
					["base04"] = "#665c54",
					["base05"] = "#504945",
					["base06"] = "#3c3836",
					["base07"] = "#282828",
					["base08"] = "#9d0006",
					["base09"] = "#af3a03",
					["base0A"] = "#b57614",
					["base0B"] = "#79740e",
					["base0C"] = "#427b58",
					["base0D"] = "#076678",
					["base0E"] = "#8f3f71",
					["base0F"] = "#d65d0e",
				},
				plugins = { default = true },
			})
		end,
	},
	{
		"rlane/pounce.nvim",
		keys = {
			{
				"s",
				mode = { "n", "v" },
				function()
					require("pounce").pounce(nil)
				end,
			},
			{
				"z",
				mode = { "o" },
				function()
					require("pounce").pounce(nil)
				end,
			},
		},
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		keys = {
			{
				"-",
				function()
					require("oil").open(nil)
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
