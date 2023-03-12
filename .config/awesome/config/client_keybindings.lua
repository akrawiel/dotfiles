local awful = require("awful")
local gears = require("gears")

return function()
	local keys = gears.table.join(
		awful.key({ modkey }, "f", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),
		awful.key({ modkey }, "w", function(c)
			c:kill()
		end, { description = "close", group = "client" }),
		awful.key(
			{ modkey },
			"t",
			awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }
		)
	)

  return keys
end
