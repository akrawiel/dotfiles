return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"css",
				"dockerfile",
				"elixir",
				"fish",
				"go",
				"heex",
				"javascript",
				"kotlin",
				"json",
				"latex",
				"lua",
				"markdown",
				"org",
				"php",
				"prisma",
				"python",
				"regex",
				"scss",
				"svelte",
				"templ",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"yaml",
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
