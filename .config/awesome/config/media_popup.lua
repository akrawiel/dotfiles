local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local json = require("libraries.json")

local N = require("naughty").notify

local players = {}
local sinks = {}
local sources = {}
local default_sink = ""
local default_source = ""

local current_index = 1
local current_tab = "players"

local function popen(process)
	local success, handle = pcall(io.popen, process)

	if success and handle then
		local data = handle:read("*a")
		handle:close()
		return true, data
	else
		return false, nil
	end
end

local function refresh_sinks()
	local sinks_success, sinks_data = popen(
		[[pactl -f json list sinks | jq '[.[] | {index: .index, name: .name, displayName: .properties["device.description"], mute: .mute, volume: .volume | to_entries | first | .value.value_percent}]']]
	)

	if sinks_success then
		sinks = json.decode(sinks_data)
	end
end

local function refresh_sources()
	local sources_success, sources_data = popen(
		[[pactl -f json list sources | jq '[.[] | {index: .index, name: .name, displayName: .properties["device.description"], mute: .mute, volume: .volume | to_entries | first | .value.value_percent}]']]
	)

	if sources_success then
		sources = json.decode(sources_data)
	end
end

local function refresh_players()
	local players_success, players_data = popen(
		[[playerctl -l | jq -Rs '. | split("\n") | map(select(length > 0)) | unique']]
	)

	if players_success then
		local players_names = json.decode(players_data)

		players = {}
		for index, player_name in pairs(players_names) do
			local player_success, player_status =
				popen(string.format("playerctl -p %s status", player_name))

			players[index] = {
				name = player_name,
				status = (player_success and player_status)
						and player_status:gsub("%s+", "")
					or "Unknown",
			}
		end
	end
end

local function refresh_default_sink()
	local sink_success, sink_data = popen([[pactl get-default-sink]])

	if sink_success and sink_data then
		default_sink = sink_data:gsub("%s+", "")
	end
end

local function refresh_default_source()
	local source_success, source_data = popen([[pactl get-default-source]])

	if source_success and source_data then
		default_source = source_data:gsub("%s+", "")
	end
end

local players_container = wibox.widget({
	widget = wibox.layout.fixed.vertical,
	spacing = 4,
})
local sinks_container = wibox.widget({
	widget = wibox.layout.fixed.vertical,
	spacing = 4,
})
local sources_container = wibox.widget({
	widget = wibox.layout.fixed.vertical,
	spacing = 4,
})

local popup_container = wibox.widget({
	widget = wibox.layout.flex.horizontal,
	spacing = 16,
	spacing_widget = wibox.widget.separator,
	{
		widget = wibox.layout.fixed.vertical,
		spacing = 8,
		spacing_widget = wibox.widget.separator,
		wibox.widget.textbox("Players"),
		players_container,
	},
	{
		widget = wibox.layout.fixed.vertical,
		spacing = 8,
		spacing_widget = wibox.widget.separator,
		wibox.widget.textbox("Sinks"),
		sinks_container,
	},
	{
		widget = wibox.layout.fixed.vertical,
		spacing = 8,
		spacing_widget = wibox.widget.separator,
		wibox.widget.textbox("Sources"),
		sources_container,
	},
})

local function redraw_players()
	refresh_players()
	players_container:set_children({})
	for index, player in pairs(players) do
		local textbox = wibox.widget.textbox(
			player.name
				.. (player.status == "Playing" and " " or "")
				.. (player.status == "Paused" and " " or "")
				.. (player.status == "Stopped" and " " or "")
		)
		local container = wibox.widget({
			widget = wibox.container.background,
			fg = "#f0dfaf",
			bg = "#3f3f3f",
			textbox,
		})
		players_container:insert(index, container)
	end
end

local function redraw_sinks()
	refresh_sinks()
	refresh_default_sink()

	sinks_container:set_children({})
	for index, sink in pairs(sinks) do
		local left_textbox = wibox.widget.textbox(
			tostring(sink.displayName)
				.. (sink.name == default_sink and "  " or "")
				.. (sink.mute and " 󰝟 " or "")
		)
		local right_textbox = wibox.widget.textbox(sink.volume)
		local container = wibox.widget({
			widget = wibox.layout.fixed.horizontal,
			fill_space = true,
			{
				widget = left_textbox,
				font = "monospace 8",
			},
			{
				widget = right_textbox,
				align = "right",
			},
		})
		local bg_container = wibox.widget({
			widget = wibox.container.background,
			fg = "#f0dfaf",
			bg = "#3f3f3f",
			container,
		})
		sinks_container:insert(index, bg_container)
	end
end

local function redraw_sources()
	refresh_sources()
	refresh_default_source()

	sources_container:set_children({})
	for index, source in pairs(sources) do
		local left_textbox = wibox.widget.textbox(
			tostring(source.displayName)
				.. (source.name == default_source and "  " or "")
				.. (source.mute and " 󰝟 " or "")
		)
		local right_textbox = wibox.widget.textbox(source.volume)
		local container = wibox.widget({
			widget = wibox.layout.fixed.horizontal,
			fill_space = true,
			{
				widget = left_textbox,
				font = "monospace 8",
			},
			{
				widget = right_textbox,
				align = "right",
			},
		})
		local bg_container = wibox.widget({
			widget = wibox.container.background,
			fg = "#f0dfaf",
			bg = "#3f3f3f",
			container,
		})
		sources_container:insert(index, bg_container)
	end
end

local function redraw_focus()
	for index, child in pairs(players_container:get_children()) do
		if index == current_index and current_tab == "players" then
			child.fg = "#3f3f3f"
			child.bg = "#f0dfaf"
		else
			child.fg = "#f0dfaf"
			child.bg = "#3f3f3f"
		end
	end

	for index, child in pairs(sinks_container:get_children()) do
		if index == current_index and current_tab == "sinks" then
			child.fg = "#3f3f3f"
			child.bg = "#f0dfaf"
		else
			child.fg = "#f0dfaf"
			child.bg = "#3f3f3f"
		end
	end

	for index, child in pairs(sources_container:get_children()) do
		if index == current_index and current_tab == "sources" then
			child.fg = "#3f3f3f"
			child.bg = "#f0dfaf"
		else
			child.fg = "#f0dfaf"
			child.bg = "#3f3f3f"
		end
	end
end

local function increment_index()
	if current_tab == "players" then
		current_index = current_index % #players_container:get_children() + 1
	end

	if current_tab == "sinks" then
		current_index = current_index % #sinks_container:get_children() + 1
	end

	if current_tab == "sources" then
		current_index = current_index % #sources_container:get_children() + 1
	end

	redraw_focus()
end

local function decrement_index()
	current_index = current_index - 1

	if current_index > 0 then
		redraw_focus()
		return
	end

	if current_tab == "players" then
		current_index = #players_container:get_children()
	end

	if current_tab == "sinks" then
		current_index = #sinks_container:get_children()
	end

	if current_tab == "sources" then
		current_index = #sources_container:get_children()
	end

	redraw_focus()
end

local function previous_tab()
	local previous_tabs = {
		players = "sources",
		sinks = "players",
		sources = "sinks",
	}

	current_tab = previous_tabs[current_tab]
	current_index = 1

	redraw_focus()
end

local function next_tab()
	local next_tabs = {
		players = "sinks",
		sinks = "sources",
		sources = "players",
	}

	current_tab = next_tabs[current_tab]
	current_index = 1

	redraw_focus()
end

local function on_space()
	if current_tab == "players" then
		io.popen(
			string.format("playerctl -p %s play-pause", players[current_index].name)
		)
		redraw_players()
		redraw_focus()
	end

	if current_tab == "sinks" then
		io.popen(
			string.format("pactl set-default-sink %s", sinks[current_index].index)
		)
		redraw_sinks()
		redraw_focus()
	end

	if current_tab == "sources" then
		io.popen(
			string.format("pactl set-default-source %s", sources[current_index].index)
		)
		redraw_sources()
		redraw_focus()
	end
end

local function on_s()
	if current_tab == "players" then
		io.popen(string.format("playerctl -p %s stop", players[current_index].name))
		redraw_players()
		redraw_focus()
	end
end

local function on_m()
	if current_tab == "sinks" then
		io.popen(
			string.format("pactl set-sink-mute %s toggle", sinks[current_index].index)
		)
		redraw_sinks()
		redraw_focus()
	end

	if current_tab == "sources" then
		io.popen(
			string.format(
				"pactl set-source-mute %s toggle",
				sources[current_index].index
			)
		)
		redraw_sources()
		redraw_focus()
	end
end

local function on_shift_j()
	if current_tab == "sinks" then
		io.popen(
			string.format("pactl set-sink-volume %s -5%%", sinks[current_index].index)
		)
		redraw_sinks()
		redraw_focus()
	end

	if current_tab == "sources" then
		io.popen(
			string.format(
				"pactl set-source-volume %s -5%%",
				sources[current_index].index
			)
		)
		redraw_sources()
		redraw_focus()
	end
end

local function on_shift_k()
	if current_tab == "sinks" then
		io.popen(
			string.format("pactl set-sink-volume %s +5%%", sinks[current_index].index)
		)
		redraw_sinks()
		redraw_focus()
	end

	if current_tab == "sources" then
		io.popen(
			string.format(
				"pactl set-source-volume %s +5%%",
				sources[current_index].index
			)
		)
		redraw_sources()
		redraw_focus()
	end
end

local keygrabber = awful.keygrabber({
	keybindings = {
		{ {}, "j", increment_index },
		{ {}, "k", decrement_index },
		{ {}, "h", previous_tab },
		{ {}, "l", next_tab },
		{ {}, " ", on_space },
		{ {}, "s", on_s },
		{ {}, "m", on_m },
		{ { "Shift" }, "J", on_shift_j },
		{ { "Shift" }, "K", on_shift_k },
	},
	stop_key = { "Escape", "q" },
	start_callback = function()
		current_index = 1
		current_tab = "players"

		redraw_players()
		redraw_sinks()
		redraw_sources()
		redraw_focus()
	end,
	stop_callback = function()
		awful.media_popup.popup.visible = false
	end,
})

local popup = awful.popup({
	widget = {
		popup_container,
		forced_height = 300,
		forced_width = 1280,
		widget = wibox.container.margin,
		margins = 8,
	},
	border_color = "#f0dfaf",
	border_width = 1,
	ontop = true,
	placement = awful.placement.centered,
	visible = false,
	hide_on_right_click = true,
})

return {
	popup = popup,
	open_popup = function()
		popup.visible = true
		keygrabber:start()
	end,
}
