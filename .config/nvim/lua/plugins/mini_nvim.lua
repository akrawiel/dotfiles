return {
	"echasnovski/mini.nvim",
	config = function()
		-- jump
		require("mini.jump").setup({})
		require("mini.jump2d").setup({
			view = {
				dim = true,
			},
		})

		-- notify
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

		-- icons
		local mini_icons = require("mini.icons")
		mini_icons.setup()
		mini_icons.mock_nvim_web_devicons()

		-- tabline
		require("mini.tabline").setup()

		-- bufremove
		require("mini.bufremove").setup()

		-- splitjoin
		require("mini.splitjoin").setup()

		-- statusline
		require("mini.statusline").setup()

		-- operators
		require("mini.operators").setup({
			sort = {
				prefix = "",
			},
		})
	end,
}
