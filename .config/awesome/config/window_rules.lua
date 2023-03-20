local awful = require("awful")

-- Special Spotify treatment
client.connect_signal("property::class", function(c)
	if c.class == "Spotify" then
		c:move_to_tag(awful.tag.find_by_name(nil, "9"))
	end
end)

return {
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
		properties = { tag = "1" },
	},
	{
		rule = { instance = "ProjectAlacritty" },
		properties = { tag = "2" },
	},
	{
		rule = { class = "Firefox Developer Edition" },
		properties = { tag = "3" },
	},
	{
		rule = { class = "Brave-browser" },
		properties = { tag = "4" },
	},
	{
		rule = { class = "Firefox" },
		properties = { tag = "5" },
	},
	{
		rule_any = { class = { "Slack" } },
		properties = { tag = "F1" },
	},
	{
		rule = { class = "Evolution" },
		properties = { tag = "F2" },
	},
	{
		rule_any = { class = { "Ferdium", "Signal" } },
		properties = { tag = "F3" },
	},
}
