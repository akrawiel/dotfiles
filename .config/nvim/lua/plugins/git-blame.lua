return {
	"f-person/git-blame.nvim",
	event = "VeryLazy",
	opts = {
		enabled = false,
		message_template = " <date> • <author>",
		date_format = "%m-%d-%Y",
		virtual_text_column = 1,
	},
}
