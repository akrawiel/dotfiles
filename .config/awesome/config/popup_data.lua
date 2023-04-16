local projects = loadfile(
	string.format("%s/Projects/projects_popup_data.lua", os.getenv("HOME"))
)

return {
	main = {
		{
			shortcut = "a",
			switch = "apps",
			description = "apps",
		},
		{
			shortcut = "p",
			switch = "projects",
			description = "projects",
		},
		{
			shortcut = "w",
			switch = "work",
			description = "work",
		},
		{
			shortcut = "b",
			switch = "browsers",
			description = "browsers",
		},
		{
			shortcut = "c",
			switch = "config",
			description = "config",
		},
		{
			shortcut = "s",
			switch = "system",
			description = "system",
		},
		{
			shortcut = "n",
			switch = "notes",
			description = "notes",
		},
	},
	work = {
		{
			shortcut = "r",
			script = "report-jira-time.sh",
			description = "Report Jira time",
		},
	},
	system = {
		{
			shortcut = "P",
			script = "poweroff.sh",
			description = "Power off",
		},
		{
			shortcut = "R",
			script = "reboot.sh",
			description = "Reboot",
		},
		{
			shortcut = "c",
			switch = "cpu-governors",
			description = "CPU governors",
		},
		{
			shortcut = "d",
			script = "autorandr.sh",
			description = "Autorandr cycle",
		},
	},
	browsers = {
		{
			shortcut = "b",
			script = "boot-brave-work.sh",
			description = "Run Main Brave",
		},
		{
			shortcut = "a",
			script = "boot-brave-alt.sh",
			description = "Run Alt Brave",
		},
	},
	["cpu-governors"] = {
		{
			shortcut = "s",
			script = "cpu-governor-powersave.sh",
			description = "Powersave governor",
		},
		{
			shortcut = "p",
			script = "cpu-governor-performance.sh",
			description = "Performance governor",
		},
	},
	apps = {
		{
			shortcut = "d",
			script = "boot-default-apps.fish",
			description = "Boot default apps",
		},
		{
			shortcut = "s",
			run = "xfce4-settings-manager",
			description = "Run xfce4 settings manager",
		},
		{
			shortcut = "v",
			run = "pavucontrol",
			description = "Run pavucontrol",
		},
	},
	config = {
		{
			shortcut = "3",
			script = "edit-i3-config.sh",
			description = "i3 config",
		},
		{
			shortcut = "a",
			script = "edit-awesome-config.sh",
			description = "awesome config",
		},
		{
			shortcut = "q",
			script = "edit-qtile-config.sh",
			description = "Qtile config",
		},
		{
			shortcut = "c",
			script = "edit-chorder-config.sh",
			description = "Chorder config",
		},
		{
			shortcut = "f",
			script = "edit-fish-config.sh",
			description = "Fish config",
		},
	},
	notes = {
		{
			shortcut = "T",
			script = "edit-todo-note.sh",
			description = "Org Todo",
		},
		{
			shortcut = "t",
			command = "quickTodo",
			description = "Quick todo",
		},
		{
			shortcut = "n",
			command = "quickInbox",
			description = "Quick inbox",
		},
	},
	projects = (function()
		if projects ~= nil then
			return projects()
		end
		return {}
	end)(),
}