return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		vim.api.nvim_command([[:colorscheme catppuccin-frappe]])
	end,
}
