return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		require("catppuccin").setup({
			flavour = "frappe",
			integrations = {
				barbar = true,
				mason = true,
				cmp = true,
				native_lsp = {
					enabled = true,
				},
				mini = {
					enabled = true,
				},
				treesitter = true,
				pounce = true,
				telescope = {
					enabled = true,
				},
			},
		})

		vim.cmd.colorscheme "catppuccin"
	end,
}
