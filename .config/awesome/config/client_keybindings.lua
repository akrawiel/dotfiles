local awful = require("awful")
local gears = require("gears")

return function()
	local keys = gears.table.join(
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end),
		awful.key({ modkey }, "w", function(c)
			c:kill()
		end),
		awful.key({ modkey }, "t", function(c)
			c.floating = not c.floating
			c:raise()
		end)
	)

	return keys
end
