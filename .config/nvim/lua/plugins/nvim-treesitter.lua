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
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vue",
				"yaml",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "org" },
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "ai",
					scope_incremental = "as",
					node_decremental = "ad",
				},
			},
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["aF"] = "@call.outer",
						["iF"] = "@call.inner",
						["ac"] = "@conditional.outer",
						["ic"] = "@conditional.inner",
						["aC"] = "@class.outer",
						["iC"] = "@class.inner",
						["aP"] = "@parameter.outer",
						["iP"] = "@parameter.inner",
					},
				},
			},
		})

		require("treesitter-context").setup({
			enable = true,
			max_lines = 0,
			trim_scope = "outer",
			patterns = {
				default = {
					"class",
					"function",
					"method",
					"for",
					"while",
					"if",
					"switch",
					"case",
				},
				rust = {
					"impl_item",
					"struct",
					"enum",
				},
				markdown = {
					"section",
				},
				json = {
					"pair",
				},
				yaml = {
					"block_mapping_pair",
				},
			},
		})
	end,
}
