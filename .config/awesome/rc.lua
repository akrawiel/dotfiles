pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

require("awful.autofocus")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

-- Startup errors
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Runtime errors
do
	local in_error = false

	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end

		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})

		in_error = false
	end)
end

-- Global variables
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

-- Layouts
awful.layout.layouts = {
	awful.layout.suit.tile.right,
	awful.layout.suit.tile.bottom,
}

-- Theme
beautiful.init(
	string.format(
		"%s/.config/awesome/themes/%s/theme.lua",
		os.getenv("HOME"),
		"zenburn"
	)
)

-- Theme handling
beautiful.bg_systray = beautiful.bg_normal
beautiful.font = "monospace 12"
beautiful.useless_gap = 4
beautiful.wallpaper =
	string.format("%s/Pictures/%s", os.getenv("HOME"), "carina_nebula.jpg")

-- Wallpaper
local function set_wallpaper(s)
	if beautiful.wallpaper and gears.filesystem.file_readable(beautiful.wallpaper) then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
  else
		gears.wallpaper.set("#000000")
	end
end
screen.connect_signal("property::geometry", set_wallpaper)

-- Tag definitions
local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
local ftags = { "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9" }

local tagScreensAssignments = {
	["1"] = "DP1-3",
	["2"] = "DP1-3",
	["3"] = "DP1-2",
	["4"] = "DP1-2",
	["5"] = "DP1-2",
	["6"] = "DP1-2",
	["7"] = "DP1-2",
	["8"] = "DP1-2",
	["9"] = "DP1-2",
	["F1"] = "eDP1",
	["F2"] = "eDP1",
	["F3"] = "eDP1",
	["F4"] = "eDP1",
	["F5"] = "eDP1",
	["F6"] = "eDP1",
	["F7"] = "eDP1",
	["F8"] = "eDP1",
	["F9"] = "eDP1",
}

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

	local geo = s.geometry

	local displays = {}

	for scr in screen do
		for key, _ in pairs(scr.outputs) do
			displays[key] = key
		end
	end

	for filteredTag in
		gears.table.iterate(gears.table.join(tags, ftags), function(tag)
			local tagScreenAssignment = tagScreensAssignments[tag]
			local displaysItems = gears.table.keys(displays)

			if gears.table.hasitem(displaysItems, tagScreenAssignment) then
				return gears.table.keys(s.outputs)[1] == tagScreenAssignment
			end

			return true
		end)
	do
		awful.tag.add(filteredTag, {
			screen = s,
			layout = geo.width > geo.height and awful.layout.layouts[1]
				or awful.layout.layouts[2],
			selected = filteredTag == tags[1],
		})
	end

	-- Wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = 20 })

	-- Promptbox
	s.promptbox = awful.widget.prompt()

	-- Infobox
	s.infobox_text = wibox.widget.textbox("")
	s.infobox = wibox.widget({
		s.infobox_text,
		widget = wibox.container.background,
		bg = "red",
		fg = "black",
		visible = false,
	})

	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{
			layout = wibox.layout.fixed.horizontal,
			awful.widget.taglist({
				screen = s,
				filter = awful.widget.taglist.filter.noempty,
				buttons = gears.table.join(awful.button({}, 1, function(t)
					t:view_only()
				end)),
			}),
		},
		{
			layout = wibox.layout.fixed.horizontal,
			s.promptbox,
			s.infobox,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			require("config.volume_speaker_widget"),
			require("config.volume_microphone_widget"),
			wibox.widget.textclock(),
		},
	})
end)

-- todo
-- master resizing
-- screen switching

-- Key bindings
globalkeys = require("config.global_keybindings")({
	tags = gears.table.join(tags, ftags),
})

clientkeys = require("config.client_keybindings")()

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)

-- Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = gears.table.join(
	require("config.global_rules"),
	require("config.window_rules")
)

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	if not awesome.startup then
		awful.client.setslave(c)
	end
end)

client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- Autostart
awful.spawn.with_shell(
	string.format("bash -c %s/autostart.sh", os.getenv("HOME"))
)
awful.spawn.single_instance([[kitty --class "DropdownKitty" -e fish]], {
	hidden = true,
	floating = true,
	placement = awful.placement.centered,
	width = 960,
	height = 480,
}, nil, "DropdownKitty")

-- Garbage collection
gears.timer({
	timeout = 30,
	autostart = true,
	callback = function()
		collectgarbage()
	end,
})
