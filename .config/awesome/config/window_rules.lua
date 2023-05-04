local awful = require("awful")
local beautiful = require("beautiful")

local function TAG(tag)
	return function(c)
		c:move_to_tag(awful.tag.find_by_name(nil, tag))
	end
end

return {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			fullscreen = false,
			maximized = false,
			maximized_vertical = false,
			maximized_horizontal = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
				"pinentry-qt",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Dragon-drop",
				"Gcr-prompter",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"KittyPopup",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = {
			floating = true,
			placement = awful.placement.centered,
			raise = true,
			ontop = true,
		},
	},

	-- FreeTube unmaximized
	{
		rule = { class = "FreeTube" },
		properties = {
			floating = false,
			maximized = false,
		},
	},

	-- xpad floating
	{
		rule = { class = "xpad" },
		properties = {
			floating = true,
			ontop = true,
		},
	},

	-- Add titlebars to normal clients and dialogs
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = true },
	},

	-- Custom rules
	{
		rule = { class = "DropdownKitty" },
		properties = {
			floating = true,
			placement = awful.placement.centered,
		},
	},
	{
		rule = { class = "re.sonny.Junction" },
		properties = { placement = awful.placement.centered },
	},
	{
		rule = { instance = "EditorAlacritty" },
		callback = TAG("1"),
	},
	{
		rule = { instance = "ProjectAlacritty" },
		callback = TAG("2"),
	},
	{
		rule = { class = "Firefox Developer Edition", "Firefox" },
		callback = TAG("3"),
	},
	{
		rule = { class = "Brave-browser" },
		callback = TAG("4"),
	},
	{
		rule_any = { class = { "FreeTube" } },
		callback = TAG("5"),
	},
	{
		rule_any = { class = { "Spotify" }, icon_name = { "Shortwave" } },
		callback = TAG("9"),
	},
	{
		rule_any = { class = { "Slack", "Logseq" } },
		callback = TAG("F1"),
	},
	{
		rule_any = {
			class = { "Evolution", "thunderbird-beta", "thunderbird", "Thunderbird", "Mail" },
		},
		callback = TAG("F2"),
	},

	{
		rule_any = {
			class = { "Ferdium", "Signal" },
		},
		callback = TAG("F3"),
	},
}
