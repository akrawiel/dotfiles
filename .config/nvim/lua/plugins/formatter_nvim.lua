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

    local eslintd_prettierd_setup = {
			require("formatter.filetypes.javascript").eslint_d,
			require("formatter.filetypes.javascript").prettierd
		}

		local js_setup = {}

		if vim.fn.findfile(".xo-config.json") ~= nil then
			table.insert(js_setup, xo)
		elseif vim.fn.findfile(".eslintrc.js") ~= nil
			or vim.fn.findfile(".eslintrc.json") ~= nil
			or vim.fn.findfile(".eslintrc") ~= nil
		then
			table.insert(
				js_setup,
				require("formatter.filetypes.javascript").eslint_d
			)
		end

		if vim.fn.findfile(".prettierrc") ~= nil
			or vim.fn.findfile(".prettierrc.json") ~= nil
			or vim.fn.findfile(".prettierrc.js") ~= nil
			or vim.fn.findfile("prettier.config.js") ~= nil
		then
			table.insert(
				js_setup,
				require("formatter.filetypes.javascript").prettierd
			)
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
			},
		})
	end,
}
