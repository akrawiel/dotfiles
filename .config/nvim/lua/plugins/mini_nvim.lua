return {
	"echasnovski/mini.nvim",
	config = function()
		require("mini.jump").setup({})

		local notify = require("mini.notify")
		notify.setup({
			window = {
				max_width_share = 1,
				config = {
					anchor = "SE",
					border = "rounded",
				},
			},
		})

		vim.notify = notify.make_notify()
	end,
}
