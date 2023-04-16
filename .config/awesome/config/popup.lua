local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local popup_data = require("config.popup_data")

local textboxes = {}

for i = 1, 9 do
	local textbox_top = wibox.widget.textbox()
	local textbox_bottom = wibox.widget.textbox()

	local textboxes_container = wibox.widget({
		{
			text = " ",
			widget = wibox.widget.textbox(),
		},
		{
			text = "",
			font = "monospace 20",
			widget = textbox_top,
			align = "center",
		},
		{
			text = "",
			font = "monospace 8",
			widget = textbox_bottom,
			align = "center",
		},
		inner_fill_strategy = "inner_spacing",
		layout = wibox.layout.ratio.vertical,
	})

	textboxes_container:ajust_ratio(2, 0.2, 0.6, 0.2)

	textboxes[i] = wibox.widget({
		{
			{
				{
					textboxes_container,
					fill_vertical = true,
					content_fill_vertical = true,
					widget = wibox.container.place,
				},
				height = 150,
				width = 150,
				strategy = "exact",
				widget = wibox.container.constraint,
			},
			color = "#f0dfaf",
			margins = 2,
			widget = wibox.container.margin,
		},
		margins = 8,
		widget = wibox.container.margin,
		textbox_top = textbox_top,
		textbox_bottom = textbox_bottom,
		visible = false,
	})
end

local popup = awful.popup({
	widget = {
		widget = wibox.layout.grid,
		forced_num_cols = 3,
		table.unpack(textboxes),
	},
	border_color = "#f0dfaf",
	border_width = 2,
	ontop = true,
	placement = awful.placement.centered,
	shape = gears.shape.rect,
	visible = false,
})

local current_state = "main"

local function update_popup(key)
	if key == "start" then
		popup.visible = true
		current_state = "main"
	end

	if key == "stop" then
		popup.visible = false
		return
	end

	local data = popup_data[current_state]

	if data then
		for i = 1, 9 do
			local action = data[i]

			if action ~= nil then
				if action.shortcut == key then
					if action.switch then
						current_state = action.switch
						break
					end

					if action.script then
						awful.spawn.with_shell(
							string.format("%s/Scripts/%s", os.getenv("HOME"), action.script)
						)
						popup.visible = false
						return true
					end

					if action.project then
						awful.spawn.with_shell(
							string.format("%s/Projects/%s", os.getenv("HOME"), action.project)
						)
						popup.visible = false
						return true
					end

					if action.run then
						awful.spawn(action.run)
						popup.visible = false
						return true
					end

					if action.shell then
						awful.spawn.with_shell(action.run)
						popup.visible = false
						return true
					end
				end
			end
		end
	end

	local new_data = popup_data[current_state]

	if new_data then
		for i = 1, 9 do
			if new_data[i] then
				textboxes[i].textbox_top.text = new_data[i].shortcut
				textboxes[i].textbox_bottom.text = new_data[i].description
				textboxes[i].visible = true
			else
				textboxes[i].visible = false
			end
		end
	end
end

return {
	popup = popup,
	update_popup = update_popup,
}
