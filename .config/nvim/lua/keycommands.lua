local tb = require("telescope.builtin")

local function tmux(cmd)
	return function()
		if os.getenv("TMUX") ~= nil then
			vim.cmd["!"]({
				args = {
					"tmux neww -a",
					unpack(cmd),
				},
			})
		else
			vim.cmd.terminal({
				args = cmd,
			})
		end
	end
end

local function hlcword()
	vim.fn.setreg("/", string.lower(vim.fn.expand("<cword>")))
	vim.opt.hlsearch = true
end

local function hlsword()
	if vim.fn.mode() ~= "v" then
		return
	end

	local _, csrow, cscol, cerow, cecol

	_, csrow, cscol, _ = unpack(vim.fn.getpos("."))
	_, cerow, cecol, _ = unpack(vim.fn.getpos("v"))

	if cerow < csrow then
		csrow, cerow = cerow, csrow
	end
	if cecol < cscol then
		cscol, cecol = cecol, cscol
	end

	local lines = vim.fn.getline(csrow, cerow)
	local n = #lines

	if n <= 0 then
		return ""
	end

	lines[n] = string.sub(lines[n], 1, cecol)
	lines[1] = string.sub(lines[1], cscol)

	vim.fn.setreg("/", string.lower(table.concat(lines, "\\n")))

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

	vim.opt.hlsearch = true
end

local function curbufdiag()
	tb.diagnostics({ bufnr = 0 })
end

local function conflictmarkers()
	tb.grep_string({ search = "<<<<<<<" })
end

local function config()
	require("telescope.builtin").find_files({
		prompt_title = "Config",
		cwd = vim.fn.stdpath("config"),
		file_ignore_patterns = { "undo/.*" },
		follow = true,
	})
end

local function grepstr()
	local search = vim.fn.input("Enter search term: ")

	if #search > 0 then
		require("telescope.builtin").grep_string({ search = search })
	else
		print("No search term provided")
	end
end

local function filescurdir()
	tb.find_files({ hidden = true, follow = true, cwd = require("telescope.utils").buffer_dir(".") })
end

local function files()
	tb.find_files({ find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" } })
end

local function filesnotes()
	tb.find_files({ follow = true, cwd = string.format("%s/Sync/Vault", os.getenv("HOME")) })
end

local function tex(extension, func, ...)
	local arguments = { ... }
	return function()
		require("telescope").extensions[extension][func](arguments)
	end
end

local function mini(module, func, ...)
	local arguments = { ... }
	return function()
		require("mini." .. module)[func](unpack(arguments))
	end
end

local function bufdo(callback)
	return function()
		for _, buf in pairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_valid(buf) then
				callback(buf)
			end
		end
	end
end

return {
	config = config,
	conflictmarkers = conflictmarkers,
	curbufdiag = curbufdiag,
	filescurdir = filescurdir,
	files = files,
	filesnotes = filesnotes,
	grepstr = grepstr,
	hlcword = hlcword,
	hlsword = hlsword,
	tex = tex,
	tmux = tmux,
	mini = mini,
	bufdo = bufdo
}
