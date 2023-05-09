local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local popup_data = require("config.popup_data")

local textboxes = {}

local x = 4
local y = 3
local maxboxes = x * y

for i = 1, maxboxes do
	local textbox_top = wibox.widget.textbox()
	local textbox_bottom = wibox.widget.textbox()

	local textboxes_container = wibox.widget({
		{
			text = " ",
			widget = wibox.widget.textbox(),
		},
		{
			text = "",
			font = "monospace bold 24",
			widget = textbox_top,
			align = "center",
		},
		{
			text = "",
			font = "monospace 10",
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
		widget = wibox.container.background,
		textbox_top = textbox_top,
		textbox_bottom = textbox_bottom,
		shape = function(cr, w, h)
			return gears.shape.rounded_rect(cr, w, h, 20)
		end,
		shape_border_width = 1,
		shape_border_color = "#f0dfaf",
		visible = false,
	})
end

local popup = awful.popup({
	widget = {
		{
			widget = wibox.layout.grid,
			forced_num_cols = x,
			forced_num_rows = y,
			spacing = 8,
			table.unpack(textboxes),
		},
		widget = wibox.container.margin,
		margins = 8,
	},
	border_color = "#f0dfaf",
	border_width = 1,
	ontop = true,
	placement = awful.placement.centered,
	shape = function(cr, w, h)
		return gears.shape.rounded_rect(cr, w, h, 30)
	end,
	visible = false,
})

local keygrabber = awful.keygrabber({
	keypressed_callback = function(self, mod, key)
		local should_stop = awful.popup_module.update_popup(key, mod)

		if should_stop == true then
			self:stop()
		end
	end,
	stop_key = "Escape",
	stop_callback = function()
		awful.popup_module.update_popup("stop")
	end,
})

local current_state = "main"

local function update_popup(key, mod)
	if key == "start" then
		keygrabber:start()
		popup.visible = true
		current_state = "main"
	end

	if key == "stop" then
		popup.visible = false
		return true
	end

  mod = mod or {}

  if gears.table.hasitem(mod, "Mod1") then
    key = "a-" .. key
  end

  if gears.table.hasitem(mod, "Control") then
    key = "c-" .. key
  end

	local data = popup_data[current_state]

	if data then
		for i = 1, maxboxes do
			local action = data[i]

			if action ~= nil then
				if action.shortcut == key then
					if action.switch then
						current_state = action.switch
						break
					end

					if action.command then
						gears.timer.delayed_call(function()
							require("config.commands")[action.command]()
						end)
						popup.visible = false
						return true
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
		for i = 1, maxboxes do
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
