return {
	"nvim-neorg/neorg",
	opts = {
		load = {
			["core.defaults"] = {},
			["core.concealer"] = {
				config = {
					icon_preset = "basic",
				},
			},
			["core.completion"] = {
				config = {
					engine = "nvim-cmp",
					name = "[Neorg]",
				},
			},
			["core.integrations.nvim-cmp"] = {},
			["core.integrations.telescope"] = {},
			["core.dirman"] = {
				config = {
					workspaces = {
						notes = string.format("%s/Sync/Norg", os.getenv("HOME")),
					},
					default_workspace = "notes",
				},
			},
			["core.journal"] = {
				config = {
					journal_folder = "journals",
					strategy = "flat",
				},
			},
		},
	},
	build = ":Neorg sync-parsers",
	dependencies = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
}
