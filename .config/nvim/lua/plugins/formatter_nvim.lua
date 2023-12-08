return {
	"mhartington/formatter.nvim",
	config = function()
		local formatter = require("formatter")
		local util = require("formatter.util")

		local function xo()
			return {
				exe = "xo",
				try_node_modules = true,
				args = {
					"--stdin",
					"--stdin-filename",
					util.escape_path(util.get_current_buffer_file_path()),
					"--fix",
				},
				stdin = true,
			}
		end

		formatter.setup({
			log_level = vim.log.levels.WARN,
			filetype = {
				javascript = { xo },
				javascriptreact = { xo },
				typescript = { xo },
				typescriptreact = { xo },

				dart = { require("formatter.filetypes.dart").dartformat },
				lua = { require("formatter.filetypes.lua").stylua },
				markdown = { require("formatter.filetypes.markdown").denofmt },

        css = { require("formatter.filetypes.css").prettierd },
        scss = { require("formatter.filetypes.css").prettierd },
        html = { require("formatter.filetypes.html").prettierd },
			},
		})
	end,
}
