local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local projects = loadfile(
	string.format("%s/Projects/projects_timewarrior_data.lua", os.getenv("HOME"))
)

local json = require("libraries.json")

local last_tasks_count = 20

local task_textboxes = {}

for i = 1, last_tasks_count do
	local textbox_task = wibox.widget({
		text = " ",
		widget = wibox.widget.textbox(),
	})

	local textbox_from = wibox.widget({
		text = " ",
		widget = wibox.widget.textbox(),
	})

	local textbox_to = wibox.widget({
		text = " ",
		widget = wibox.widget.textbox(),
	})

	local ratio_container = wibox.widget({
		textbox_task,
		textbox_from,
		textbox_to,
		inner_fill_strategy = "inner_spacing",
		layout = wibox.layout.ratio.horizontal,
	})

	local row_container = wibox.widget({
		ratio_container,
		widget = wibox.container.background,
		fg = "#f0dfaf",
		bg = "#3f3f3f",
		textbox_task = textbox_task,
		textbox_from = textbox_from,
		textbox_to = textbox_to,
	})

	ratio_container:ajust_ratio(2, 0.5, 0.25, 0.25)

	task_textboxes[i] = row_container
end

local local_message = wibox.widget({
	text = "Recent tasks",
	default_text = "Recent tasks",
	widget = wibox.widget.textbox(),
})

local local_prompt = wibox.widget({
	text = "",
	widget = wibox.widget.textbox(),
})

local popup_container = wibox.widget({
	widget = wibox.layout.fixed.vertical,
	spacing = 8,
	forced_width = 600,
	{
		local_message,
		local_prompt,
		widget = wibox.layout.fixed.horizontal,
	},
	{
		forced_height = 1,
		span_ratio = 1,
		widget = wibox.widget.separator,
	},
	table.unpack(task_textboxes),
})

-- popup_container:ajustratio(2, 0.1, 0.9, 0)

local popup = awful.popup({
	widget = {
		popup_container,
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

local keygrabber = awful.keygrabber({
	keypressed_callback = function(self, mod, key)
		local should_stop = awful.timewarrior_popup.update_popup(key)

		if should_stop == true then
			self:stop()
		end
	end,
	stop_key = { "Escape", "q" },
	stop_callback = function()
		awful.timewarrior_popup.update_popup("stop")
	end,
})

local timewarrior_data = {}

local function refresh_timewarrior_data()
	local last_ids = {}

	for i = 1, last_tasks_count do
		table.insert(last_ids, "@" .. tostring(i))
	end

	local handle = io.popen(
		"timew export "
			.. table.concat(last_ids, " ")
			.. [[ | jq 'def gettime(f): if f != null then f 
          | strptime("%Y%m%dT%H%M%SZ") 
          | mktime | localtime | strftime("%b%d %H:%M:%S")
          else null end;
          [.[] | { 
            id: .id, 
            tags: .tags, 
            from: gettime(.start), 
            to: gettime(.end)
          }]']]
	)

	if handle == nil then
		return
	end

	local timewarrior_raw_data = handle:read("*a")
	handle:close()

	timewarrior_data = gears.table.reverse(json.decode(timewarrior_raw_data))

	for i = 1, last_tasks_count do
		local row = timewarrior_data[i]

		if row == nil then
			break
		end

		task_textboxes[i].textbox_task.text = row.tags ~= nil
				and table.concat(row.tags, " ")
			or "-"
		task_textboxes[i].textbox_from.text = row.from ~= nil and row.from or "-"
		task_textboxes[i].textbox_to.text = row.to ~= nil and row.to or "TRACKING"
	end
end

local index = 1

local function redraw_selection()
	for i = 1, last_tasks_count do
		if index == i then
			task_textboxes[i].fg = "#3f3f3f"
			task_textboxes[i].bg = "#f0dfaf"
		else
			task_textboxes[i].fg = "#f0dfaf"
			task_textboxes[i].bg = "#3f3f3f"
		end
	end
end

local confirm_state = nil
local override_state = nil
local project_state = nil

local transient_data = nil

local function update_popup(action)
	if override_state ~= nil or project_state ~= nil then
		return
	end

	if action == "start" then
		keygrabber:start()

		index = 1
		confirm_state = nil
		override_state = nil

		refresh_timewarrior_data()
		redraw_selection()

		popup.visible = true
		return
	end

	if action == "stop" then
		if project_state then
			return
		end

		popup.visible = false
		confirm_state = nil
		override_state = nil
		return
	end

	if confirm_state then
		if action == "y" then
			if confirm_state == "delete" then
				local handle = io.popen("timew delete @" .. timewarrior_data[index].id)
				if handle == nil then
					local_message.text = "Error: Delete @" .. timewarrior_data[index].id
					return
				end

				handle:close()

				local_message.text = "Delete @" .. timewarrior_data[index].id

				refresh_timewarrior_data()
				redraw_selection()
			end

			confirm_state = nil
		elseif action == "n" then
			local_message.text = local_message.default_text

			confirm_state = nil
		else
			return
		end
	end

	local_prompt.text = ""

	if action == "j" then
		index = math.min(index + 1, last_tasks_count)
		redraw_selection()
	end

	if action == "k" then
		index = math.max(index - 1, 1)
		redraw_selection()
	end

	if action == "c" then
		local handle = io.popen("timew continue @" .. timewarrior_data[index].id)

		if handle == nil then
			local_message.text = "Error: Continue @" .. timewarrior_data[index].id
			return
		end

		handle:close()

		local_message.text = "Continue @" .. timewarrior_data[index].id

		refresh_timewarrior_data()
		redraw_selection()
	end

	if action == "C" then
		override_state = "continue"

		local_message.text = "Enter start hour: "
	end

	if action == "n" and projects ~= nil then
		project_state = true

		local_message.text = "Select project: "
	end

	if action == "N" and projects ~= nil then
		project_state = true
		transient_data = true

		local_message.text = "Select project: "
	end

	if action == "u" then
		local handle = io.popen("timew undo")
		if handle == nil then
			local_message.text = "Error: Undo"
			return
		end

		handle:close()

		local_message.text = "Undo"

		refresh_timewarrior_data()
		redraw_selection()
	end

	if action == "s" then
		local handle = io.popen("timew stop")
		if handle == nil then
			local_message.text = "Error: Stop"

			return
		end

		handle:close()

		local_message.text = "Stop"

		refresh_timewarrior_data()
		redraw_selection()
	end

	if action == "d" then
		confirm_state = "delete"
		local_message.text = "Are you sure you want to delete this log? [y/n]"
	end

	if override_state ~= nil then
		awful.prompt.run({
			textbox = local_prompt,
			done_callback = function()
				override_state = nil
			end,
			fg_cursor = "#3f3f3f",
			bg_cursor = "#f0dfaf",
			exe_callback = function(input)
				if not input or #input == 0 then
					return
				end

				if override_state == "continue" then
					local handle = io.popen(
						"timew continue @" .. timewarrior_data[index].id .. " " .. input
					)

					if handle == nil then
						local_message.text = "Error: Continue @"
							.. timewarrior_data[index].id

						return
					end

					handle:close()

					local_message.text = "Continue @"
						.. timewarrior_data[index].id
						.. " at "
						.. input

					refresh_timewarrior_data()
					redraw_selection()
				end
			end,
		})

		return
	end

	if project_state ~= nil then
		index = 0
		redraw_selection()

		keygrabber:stop()

		local project_data = projects()

		for i = 1, last_tasks_count do
			if project_data[i] then
				task_textboxes[i].textbox_task.text = project_data[i].shortcut
					.. " - "
					.. project_data[i].description
			else
				task_textboxes[i].textbox_task.text = " "
			end

			task_textboxes[i].textbox_from.text = " "
			task_textboxes[i].textbox_to.text = " "
		end

		awful.keygrabber({
			autostart = true,
			keypressed_callback = function(self, mod, key)
				if project_state == true then
					for _, project in pairs(project_data) do
						if project.shortcut == key then
							project_state = project

							task_textboxes[1].textbox_task.text = "Enter - enter task number"
							for i = 2, last_tasks_count do
								if project.special_tasks[i - 1] then
									task_textboxes[i].textbox_task.text = project.special_tasks[i - 1].shortcut
										.. " - "
										.. project.special_tasks[i - 1].description
								else
									task_textboxes[i].textbox_task.text = " "
								end
							end

							break
						end
					end
				else
					if key == "Return" then
						local_message.text = "Enter task number: "

						awful.prompt.run({
							textbox = local_prompt,
							done_callback = function()
								if not transient_data then
									project_state = nil
									self:stop()
								end
							end,
							fg_cursor = "#3f3f3f",
							bg_cursor = "#f0dfaf",
							exe_callback = function(input)
								if input and #input > 0 then
									if transient_data then
										local_message.text = "Enter start hour: "

										awful.prompt.run({
											textbox = local_prompt,
											done_callback = function()
												transient_data = nil
												project_state = nil
												self:stop()
											end,
											fg_cursor = "#3f3f3f",
											bg_cursor = "#f0dfaf",
											exe_callback = function(hour_input)
												if not hour_input or #hour_input == 0 then
													return
												end

												local handle = io.popen(
													"timew start "
														.. project_state.tag
														.. "-"
														.. input
														.. " "
														.. hour_input
												)
												if handle == nil then
													local_message.text = "Error: Start "
														.. project_state.tag
														.. "-"
														.. input
														.. " at "
														.. hour_input
													return
												end

												handle:close()

												local_message.text = "Start "
													.. project_state.tag
													.. "-"
													.. input
													.. " at "
													.. hour_input
											end,
										})
									else
										local handle = io.popen(
											"timew start " .. project_state.tag .. "-" .. input
										)
										if handle == nil then
											local_message.text = "Error: Start "
												.. project_state.tag
												.. "-"
												.. input
											return
										end

										handle:close()

										local_message.text = "Start "
											.. project_state.tag
											.. "-"
											.. input
									end
								end
							end,
						})
						return
					end

					for _, special_task in pairs(project_state.special_tasks) do
						if special_task.shortcut == key then
							if transient_data then
								local_message.text = "Enter start hour: "

								awful.prompt.run({
									textbox = local_prompt,
									done_callback = function()
										transient_data = nil
										project_state = nil
										self:stop()
									end,
									fg_cursor = "#3f3f3f",
									bg_cursor = "#f0dfaf",
									exe_callback = function(hour_input)
										if not hour_input or #hour_input == 0 then
											return
										end

										local handle = io.popen(
											"timew start "
												.. project_state.tag
												.. "-"
												.. special_task.task
												.. " "
												.. hour_input
										)
										if handle == nil then
											local_message.text = "Error: Start "
												.. project_state.tag
												.. "-"
												.. special_task.task
												.. " at "
												.. hour_input
											return
										end

										handle:close()

										local_message.text = "Start "
											.. project_state.tag
											.. "-"
											.. special_task.task
											.. " at "
											.. hour_input
									end,
								})
							else
								local handle = io.popen(
									"timew start "
										.. project_state.tag
										.. "-"
										.. special_task.task
								)
								if handle == nil then
									local_message.text = "Error: Start "
										.. project_state.tag
										.. "-"
										.. special_task.task
									return
								end

								handle:close()

								local_message.text = "Start "
									.. project_state.tag
									.. "-"
									.. special_task.task

								project_state = nil
								self:stop()
							end
							break
						end
					end
				end
			end,
			stop_key = "Escape",
			stop_callback = function()
				project_state = nil
				keygrabber:start()
				index = 1
				refresh_timewarrior_data()
				redraw_selection()

				if local_message.text:find(": $") then
					local_message.text = local_message.default_text
				end
			end,
		})
	end
end

return {
	popup = popup,
	update_popup = update_popup,
}
