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

		-- ai (not to be confused with AI)
		require("mini.ai").setup({
			n_lines = 1000,
		})

		-- base16 theme
		require("mini.base16").setup({
			plugins = { default = true },
			palette = {
				["base00"] = "#1c1c1c",
				["base01"] = "#2a2a2a",
				["base02"] = "#383838",
				["base03"] = "#4a4a4a",
				["base04"] = "#b0b0b0",
				["base05"] = "#d0d0d0",
				["base06"] = "#e0e0e0",
				["base07"] = "#ffffff",
				["base08"] = "#e6c300",
				["base09"] = "#c99e00",
				["base0A"] = "#b59400",
				["base0B"] = "#b8c100",
				["base0C"] = "#e1c700",
				["base0D"] = "#d0b600",
				["base0E"] = "#f4db00",
				["base0F"] = "#c7a53a",
			},
		})

		-- operators
		require("mini.operators").setup({
			sort = {
				prefix = "",
			},
		})
	end,
}
