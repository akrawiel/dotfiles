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

		local js_setup = {}

		local function has_file(...)
			return #vim.fs.find({ ... }, {
				path = vim.fn.getcwd(),
			}) > 0
		end

		if has_file(".xo-config.json") then
			table.insert(js_setup, xo)
		else
			if has_file(".eslintrc.js", ".eslintrc.json", ".eslintrc") then
				table.insert(js_setup, require("formatter.filetypes.javascript").eslint_d)
			end

			if has_file(".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js") then
				table.insert(js_setup, require("formatter.filetypes.javascript").prettierd)
			end
		end

		formatter.setup({
			log_level = vim.log.levels.WARN,
			filetype = {
				javascript = js_setup,
				javascriptreact = js_setup,
				typescript = js_setup,
				typescriptreact = js_setup,
				vue = js_setup,
				svelte = js_setup,

				dart = { require("formatter.filetypes.dart").dartformat },
				lua = { require("formatter.filetypes.lua").stylua },
				markdown = { require("formatter.filetypes.markdown").denofmt },

				css = { require("formatter.filetypes.css").prettierd },
				scss = { require("formatter.filetypes.css").prettierd },
				html = { require("formatter.filetypes.html").prettierd },
				json = { require("formatter.filetypes.html").prettierd },
				xml = { require("formatter.filetypes.xml").tidy },
			},
		})
	end,
}
