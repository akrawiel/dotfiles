local awful = require("awful")

return {
	focusLeft = function()
		awful.client.focus.global_bydirection("left")
	end,
	focusDown = function()
		awful.client.focus.global_bydirection("down")
	end,
	focusUp = function()
		awful.client.focus.global_bydirection("up")
	end,
	focusRight = function()
		awful.client.focus.global_bydirection("right")
	end,
	focusPrevious = function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end,

	swapLeft = function()
		awful.client.swap.global_bydirection("left")
	end,
	swapDown = function()
		awful.client.swap.global_bydirection("down")
	end,
	swapUp = function()
		awful.client.swap.global_bydirection("up")
	end,
	swapRight = function()
		awful.client.swap.global_bydirection("right")
	end,

	runTerminal = function()
		awful.spawn(terminal .. " -e fish")
	end,
	runRofi = function()
		awful.spawn("rofi -show combi")
	end,
	runFlameshot = function()
		awful.spawn("flameshot gui")
	end,
	runRofimoji = function()
		awful.spawn("rofimoji --skin-tone neutral")
	end,
	runTenorSelector = function()
		awful.spawn.with_shell("tenorSelector")
	end,
	runChorder = function()
		awful.spawn("chorder")
	end,

	invokePrompt = function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().promptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end,

	toggleDropdown = function()
		local dropdownKitty = function(c)
			return awful.rules.match(c, { class = "DropdownKitty" })
		end

		for c in awful.client.iterate(dropdownKitty) do
			local currentTag = awful.screen.focused().selected_tag

			if currentTag ~= c.first_tag then
				c.hidden = false
				c:move_to_tag(currentTag)
			else
				c.hidden = not c.hidden
			end

			if c.hidden then
				awful.client.focus.history.previous()
			else
				client.focus = c
				awful.placement.centered(c)
				c:raise()
			end
		end
	end,

	focusTag = function(tag)
		return function()
			local foundTag = awful.tag.find_by_name(root.tags(), tag)

			if foundTag then
				foundTag:view_only()
				awful.screen.focus(foundTag.screen)
			end
		end
	end,
	moveToTag = function(tag)
		return function()
			if client.focus then
				local foundTag = awful.tag.find_by_name(root.tags(), tag)
				if foundTag then
					client.focus:move_to_tag(foundTag)
				end
			end
		end
	end,
	pinToTag = function(tag)
		return function()
			if client.focus then
				local foundTag = awful.tag.find_by_name(root.tags(), tag)
				if foundTag then
					client.focus:toggle_tag(foundTag)
				end
			end
		end
	end,

	startResize = function()
		for s in screen do
			s.infobox.visible = true
			s.infobox_text.text = " Resize "
		end

		awful.keygrabber({
			autostart = true,
			keybindings = {
				{
					{},
					"h",
					function()
						awful.tag.incmwfact(-0.05)
					end,
				},
				{
					{},
					"l",
					function()
						awful.tag.incmwfact(0.05)
					end,
				},
			},
			stop_key = "Escape",
			stop_callback = function()
				for s in screen do
					s.infobox.visible = false
				end
			end,
		})
	end,

	lockScreen = function()
		awful.spawn.with_shell(
			"i3lock -c 008040 -k --{time,date,verif,wrong,modif}-color=ffffff --date-str='%A, %d %b %Y'"
		)
	end,

	audioLower = function()
		awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ -5%")
	end,
	audioMute = function()
		awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
	end,
	audioMicMute = function()
		awful.spawn.with_shell("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
	end,
	audioNext = function()
		awful.spawn.with_shell(
			"playerctl -p $(playerctl -l | rofi -dmenu -auto-select) next"
		)
	end,
	audioPlay = function()
		awful.spawn.with_shell(
			"playerctl -p $(playerctl -l | rofi -dmenu -auto-select) play-pause"
		)
	end,
	audioPrev = function()
		awful.spawn.with_shell(
			"playerctl -p $(playerctl -l | rofi -dmenu -auto-select) previous"
		)
	end,
	audioRaise = function()
		awful.spawn.with_shell("pactl set-sink-volume @DEFAULT_SINK@ +5%")
	end,
	audioStop = function()
		awful.spawn.with_shell("playerctl -a stop")
	end,
	audioNextAll = function()
		awful.spawn.with_shell("playerctl -a next")
	end,
	audioPlayAll = function()
		awful.spawn.with_shell("playerctl -a play-pause")
	end,
	audioPrevAll = function()
		awful.spawn.with_shell("playerctl -a previous")
	end,
}
