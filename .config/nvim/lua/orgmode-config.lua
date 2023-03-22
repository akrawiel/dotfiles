return function()
	require("orgmode").setup({
		mappings = {
			disable_all = false,
			global = {
				org_agenda = "ga",
				org_capture = "gC",
			},
			capture = {
				org_capture_finalize = "S",
				org_capture_refile = "R",
				org_capture_kill = "Q",
			},
			org = {
				org_schedule = "cis",
				org_deadline = "cid",
				org_change_date = "cii1i",
				org_priority = "ci,",
				org_priority_up = "ciiii",
				org_priority_down = "ciiii",
			},
		},
		win_split_mode = "auto",
		org_agenda_files = { "~/Dropbox/Documents/OrgSync/**/*" },
		org_capture_templates = {
			t = {
				description = "Task",
				template = "* TODO %?",
				target = "~/Dropbox/Documents/OrgSync/Todo Daily.org",
			},
			l = { description = "Link", template = "* %?" },
		},
		org_default_notes_file = "~/Dropbox/Documents/OrgSync/Inbox.org",
		org_priority_highest = "A",
		org_priority_default = "B",
		org_priority_lowest = "E",
		org_tags_column = -64,
		org_todo_keywords = { "TODO(t)", "NEXT(n)", "WAIT(w)", "|", "DONE(d)" },
		org_todo_keyword_faces = {
			TODO = ":foreground orange :weight bold",
			NEXT = ":foreground white :weight bold",
			WAIT = ":foreground red :weight bold",
			DONE = ":foreground lightgreen :weight bold",
		},
		org_blank_before_new_entry = {
			heading = false,
			plain_list_item = false,
		},
	})
end
