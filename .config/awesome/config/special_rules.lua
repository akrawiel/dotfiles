local awful = require("awful")
local gears = require("gears")

-- Special window treatment
client.connect_signal("property::class", function(c)
  -- Spotify empty boot class
	if c.class == "Spotify" then
		c:move_to_tag(awful.tag.find_by_name(nil, "9"))
	end
end)
