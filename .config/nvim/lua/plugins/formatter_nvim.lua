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
		local css_setup = {}
		local json_setup = {}
		local html_setup = {}

		local function has_file(...)
			for _, file in pairs({ ... }) do
				if #vim.fn.findfile(file, string.format("%s/%s", vim.fn.getcwd(), "**1")) > 0 then
					return true
				end
			end

			return false
		end

		if has_file(".xo-config.json") then
			table.insert(js_setup, xo)
		elseif has_file("biome.json", "biome.jsonc") then
			table.insert(js_setup, require("formatter.filetypes.javascript").biome)
			table.insert(json_setup, require("formatter.filetypes.javascript").biome)
			table.insert(css_setup, require("formatter.filetypes.javascript").biome)
		else
			if has_file(".eslintrc.js", ".eslintrc.json", ".eslintrc") then
				table.insert(js_setup, require("formatter.filetypes.javascript").eslint_d)
			end

			if has_file(".prettierrc", ".prettierrc.json", ".prettierrc.js", "prettier.config.js") then
				table.insert(js_setup, require("formatter.filetypes.javascript").prettierd)
				table.insert(json_setup, require("formatter.filetypes.javascript").prettierd)
				table.insert(css_setup, require("formatter.filetypes.javascript").prettierd)
				table.insert(html_setup, require("formatter.filetypes.javascript").prettierd)
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

				css = css_setup,
				scss = css_setup,
				html = html_setup,
				json = json_setup,
				jsonc = { require("formatter.filetypes.javascript").biome },
				xml = { require("formatter.filetypes.xml").tidy },
			},
		})

		local group = vim.api.nvim_create_augroup("FormatterAutogroup", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			callback = function()
				vim.notify("Formatting...", vim.log.levels.INFO)
			end,
			group = group,
			pattern = "FormatterPre",
		})
		vim.api.nvim_create_autocmd("User", {
			callback = function()
				vim.notify("Formatted", vim.log.levels.INFO)
			end,
			group = group,
			pattern = "FormatterPost",
		})
	end,
}
