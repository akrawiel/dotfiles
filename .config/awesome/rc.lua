pcall(require, "luarocks.loader")

-- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")
local vicious = require("vicious")

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

awful.util.shell = "/usr/bin/fish"

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
	string.format("%s/Wallpapers/%s", os.getenv("HOME"), "wallpaper.png")
beautiful.notification_icon_size = 64
beautiful.notification_font = "monospace 12"
beautiful.notification_max_width = 536
beautiful.notification_max_height = 536
beautiful.taglist_bg_urgent = "#cc0000"
beautiful.taglist_fg_urgent = "#000000"
beautiful.taglist_squares_sel = string.format(
	"%s/themes/zenburn/taglist/squarefz.png",
	gears.filesystem.get_configuration_dir()
)
beautiful.taglist_squares_unsel = string.format(
	"%s/themes/zenburn/taglist/squarez.png",
	gears.filesystem.get_configuration_dir()
)

-- Notifications config
naughty.config.padding = beautiful.xresources.apply_dpi(8)
naughty.config.spacing = beautiful.xresources.apply_dpi(8)
naughty.config.presets.low.bg = "#008000"
naughty.config.presets.normal.bg = "#8080ff"
naughty.config.presets.critical.bg = "#800000"

-- Wallpaper
local function set_wallpaper(s)
	if
		beautiful.wallpaper and gears.filesystem.file_readable(beautiful.wallpaper)
	then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.tiled(wallpaper, s, { x = 0, y = 0 })
	else
		gears.wallpaper.set("#000000")
	end
end

-- Popups

awful.popup_module = require("config.popup")
awful.timewarrior_popup = require("config.timewarrior_popup")
awful.media_popup = require("config.media_popup")

-- Tag definitions
local tag_names = gears.table.join(
	{ "1", "2", "3", "4", "5", "6", "7", "8", "9" },
	{ "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9" }
)

local function assign_tag_screen(tag_name)
  local number_tag_name = tonumber(tag_name)

  if number_tag_name and number_tag_name <= 2 then
    return { "DP-3-3", "DP1-3" }
  end

  if number_tag_name and number_tag_name >= 2 then
    return { "DP-3-2", "DP1-2" }
  end

  return { "eDP1" }
end

for _, tagName in pairs(tag_names) do
	awful.tag.add(tagName, {
		master_width_factor = gears.string.startswith(tagName, "F") and 0.7 or 0.6,
	})
end

local function handle_tag_assignments()
	local connected_display_names = {}
	local connected_displays = {}

	for s in screen do
		for key, _ in pairs(s.outputs) do
			if not gears.table.hasitem(connected_display_names, key) then
				table.insert(connected_display_names, key)
				connected_displays[key] = s
			end
		end
	end

	for _, tag in pairs(root.tags()) do
		local screen_assignments = assign_tag_screen(tag.name)

		local s = screen.primary

    for _, screen_assignment in pairs(screen_assignments) do
      if gears.table.hasitem(connected_display_names, screen_assignment) then
        s = connected_displays[screen_assignment]
        break
      end
    end

		tag.screen = s
		tag.layout = s.geometry.width > s.geometry.height
				and awful.layout.layouts[1]
			or awful.layout.layouts[2]
	end

	for s in screen do
    if s and s.tags and s.tags[1] then
      s.tags[1].selected = true
      set_wallpaper(s)
    end
	end
end

handle_tag_assignments()

awful.screen.connect_for_each_screen(function(s)
	set_wallpaper(s)

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

	-- CPU & RAM
	local cpu_usage_box = wibox.widget.textbox("")
	vicious.register(cpu_usage_box, vicious.widgets.cpu, function(_, args)
		return "<b>C</b>" .. string.format("%03d", args[1])
	end, 1)

	local cpu_governor = wibox.widget.textbox("")
	vicious.register(cpu_governor, vicious.widgets.cpufreq, function(_, args)
		local governor_state = {
			["↯"] = "OND",
			["⌁"] = "POW",
			["¤"] = "USR",
			["⚡"] = "PRF",
			["⊚"] = "CON",
		}

		return "<b>G</b>" .. governor_state[args[5]]
	end, 5, "cpu0")

	local ram_usage_box = wibox.widget.textbox("")
	vicious.register(ram_usage_box, vicious.widgets.mem, function(_, args)
		return "<b>R</b>" .. string.format("%03d", args[1])
	end, 1)

	-- Currency
	local currency_box = wibox.widget.textbox("")
	local function get_currencies()
		local currencies = { "usd", "eur" }

		awful.spawn.easy_async_with_shell(
			"qalc -t -e '["
				.. table.concat(
					gears.table.map(function(currency)
						return "1 " .. currency
					end, currencies),
					", "
				)
				.. "] to pln'",
			function(out)
				local textout = ""
				local index = 1

				for w in out:gmatch("%b()") do
					local currency = currencies[index]:upper():gsub("(.).*", "%1")
					local parsedprice = w:gsub("[^%d.]", "")
					local price = tonumber(parsedprice)

					textout = textout
						.. " <b>"
						.. currency
						.. "</b>"
						.. string.format("%.3f", price)
					index = index + 1
				end

				currency_box.markup = textout:gsub("^%s", "")
			end
		)

		return true
	end

	gears.timer.start_new(60 * 15, get_currencies)
	get_currencies()

	-- Tasklist
	local tasklist_buttons = gears.table.join(
		awful.button({}, 1, function(c)
			if c == client.focus then
				c.minimized = true
			else
				c:emit_signal("request::activate", "tasklist", { raise = true })
			end
		end),
		awful.button({}, 3, function()
			awful.menu.client_list({ theme = { width = 250 } })
		end)
	)

	local tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			align = "center",
		},
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
			layout = wibox.layout.align.horizontal,
			wibox.widget({
				s.infobox,
				s.promptbox,
				layout = wibox.layout.fixed.horizontal,
			}),
			tasklist,
		},
		{
			layout = wibox.layout.fixed.horizontal,
			wibox.widget.systray(),
			wibox.container.margin(currency_box, 8, 2),
			require("config.battery_widget"),
			wibox.container.margin(cpu_governor, 8, 2),
			wibox.container.margin(cpu_usage_box, 8, 2),
			wibox.container.margin(ram_usage_box, 8, 2),
			require("config.volume_speaker_widget"),
			require("config.volume_microphone_widget"),
			wibox.widget.textclock(),
		},
	})
end)

-- Screen signals
screen.connect_signal("property::geometry", handle_tag_assignments)

-- Key bindings
globalkeys = require("config.global_keybindings")({
	tags = tag_names,
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
awful.rules.rules = require("config.window_rules")
require("config.special_rules")

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
awful.spawn.with_shell(string.format("%s/autostart.fish", os.getenv("HOME")))
awful.spawn.single_instance([[kitty --class "DropdownKitty" -e fish]], {
	hidden = true,
	floating = true,
	placement = awful.placement.centered,
	width = 960,
	height = 480,
	ontop = true,
	modal = true,
	urgent = false,
}, nil, "DropdownKitty")

-- Garbage collection
gears.timer({
	timeout = 30,
	autostart = true,
	callback = function()
		collectgarbage()
	end,
})
