local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")

local volumetext = wibox.widget.textbox()

volumetext.font = "monospace 8"
volumetext.align = "center"

vicious.register(volumetext, vicious.widgets.volume, function(_, args)
	local state = { on = "🔉", off = "🔈" }

	return args[2] == state.on and ("O " .. args[1]) or "O M"
end, 2, "Master")

local volumeprogressbar = wibox.container.radialprogressbar()

volumeprogressbar.widget = volumetext
volumeprogressbar.min_value = 0
volumeprogressbar.max_value = 100
volumeprogressbar.border_color = "lime"
volumeprogressbar.color = "#606060"

volumeprogressbar:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
		vicious.force({ volumeprogressbar, volumetext })
	end
	if button == 3 then
		awful.spawn("pavucontrol")
	end
	if button == 4 then
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +2%")
		vicious.force({ volumeprogressbar, volumetext })
	end
	if button == 5 then
		awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -2%")
		vicious.force({ volumeprogressbar, volumetext })
	end
end)

vicious.register(
	volumeprogressbar,
	vicious.widgets.volume,
	function(widget, args)
		local volume = tonumber(args[1])

		local state = { on = "🔉", off = "🔈" }

		local color = "lime"

		if volume > 100 then
			color = "red"
		elseif args[2] == state.off then
			color = "black"
		end

		widget.border_color = color

		return 100 * 100 - volume * 100
	end,
	2,
	"Master"
)

local volumewidget = wibox.container.margin(
	wibox.container.constraint(volumeprogressbar, "exact", 40, 24),
	8,
	2
)

return volumewidget
