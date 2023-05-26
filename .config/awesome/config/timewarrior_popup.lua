local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local projects_success, projects_file = pcall(
	loadfile,
	string.format("%s/Projects/projects_timewarrior_data.lua", os.getenv("HOME"))
)

local projects = projects_success and projects_file() or {}

local json = require("libraries.json")

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

local function popen_msg(process)
	local success = popen(process)
	local msg = success and "✅ OK" or "❎ Error"

	return string.format("%s | %s | %s", msg, process, os.date())
end

local last_tasks_count = 20

local task_textboxes = {}

for i = 1, last_tasks_count do
	local textbox_task = wibox.widget.textbox(" ")
	local textbox_from = wibox.widget.textbox(" ")
	local textbox_to = wibox.widget.textbox(" ")

	textbox_from.align = "right"
	textbox_to.align = "right"

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

local local_prompt = wibox.widget.textbox()
local top_message = wibox.widget.textbox()
local bottom_message = wibox.widget.textbox(
	"[c]ontinue [C]⌚ [u]ndo [d]elete [s]tart [S]wap [n]ew [N]⌚"
)

local popup_container = wibox.widget({
	widget = wibox.layout.fixed.vertical,
	spacing = 8,
	forced_width = 600,
	top_message,
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

popup_container:add(wibox.widget({
	forced_height = 1,
	span_ratio = 1,
	widget = wibox.widget.separator,
}))

popup_container:add(bottom_message)

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

	local _, timewarrior_raw_data =
		popen("timew export " .. table.concat(last_ids, " ") .. [[ | jq '
          [.[] | {
            id: .id,
            tags: .tags,
            from: .start,
            to: .end
          }]']])

	timewarrior_data = gears.table.reverse(json.decode(timewarrior_raw_data))

	local _, timewarrior_summary = popen([[timew export today | jq -r -j 'reduce (
      .[]
        | {
          start: (.start // (now | strftime("%Y%m%dT%H%M%SZ"))) | strptime("%Y%m%dT%H%M%SZ") | mktime,
          end: (.end // (now | strftime("%Y%m%dT%H%M%SZ"))) | strptime("%Y%m%dT%H%M%SZ") | mktime
        }
        | .end - .start
    ) as $item (0; . + $item)
    | strftime("%H:%M:%S")']])

	top_message.text =
		string.format("Total time today %s", timewarrior_summary or "-")

	local rows_to_format = {}

	for i = 1, last_tasks_count do
		local row = timewarrior_data[i]

		if row == nil then
			break
		end

		table.insert(rows_to_format, i, {
			from = row.from,
			to = row.to,
		})

		task_textboxes[i].textbox_task.text = row.tags ~= nil
				and table.concat(row.tags, " ")
			or "-"
		task_textboxes[i].textbox_from.text = "..."
		task_textboxes[i].textbox_to.text = "..."
	end

	awful.spawn.easy_async_with_shell(
		string.format(
			[[%s/Applications/date-array-convert.mjs '%s']],
			os.getenv("HOME"),
			json.encode(rows_to_format)
		),
		function(stdout, _stderr, _exitreason, exitcode)
			if exitcode ~= 0 then
				for i, _ in pairs(rows_to_format) do
					task_textboxes[i].textbox_from.text = "-"
					task_textboxes[i].textbox_to.text = "-"
				end
			else
				local result = json.decode(stdout)

				for i, row in pairs(result) do
					task_textboxes[i].textbox_from.text = (row.from or "-"):gsub(
						"%s+$",
						""
					)
					task_textboxes[i].textbox_to.text = (row.to or "TRACKING"):gsub(
						"%s+$",
						""
					)
				end
			end
		end
	)
end

local function refresh_project_data(project)
	for i = 1, last_tasks_count do
		if project[i] then
			task_textboxes[i].textbox_task.text = project[i].shortcut
				.. " - "
				.. project[i].description
		else
			task_textboxes[i].textbox_task.text = " "
		end

		task_textboxes[i].textbox_from.text = " "
		task_textboxes[i].textbox_to.text = " "
	end
end

local index = 1

local function redraw_selection(reset)
	if reset and index < 1 then
		index = 1
	end

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

local state = "awaiting"
local data = {}
local queue = {}
local queue_index = 1

local function clear_queue_data()
	state = "awaiting"
	data = {}
	queue = {}
	queue_index = 1
end

local function special_tasks_with_return(current_data)
	return {
		{
			shortcut = "Enter",
			description = "enter task number",
		},
		table.unpack(current_data.project.special_tasks),
	}
end

local prompt_type_messages = {
	hour = "Enter hour: ",
	task_number = "Enter task number: ",
}

local yesno_type_messages = {
	delete = "Are you sure you want to delete this log?",
}

local function update_popup(action)
	if action == "start" then
		keygrabber:start()

		index = 1
		local_message.text = local_message.default_text

		clear_queue_data()
		refresh_timewarrior_data()
		redraw_selection()

		popup.visible = true
		return
	end

	if action == "stop" then
		popup.visible = false
		return
	end

	if state == "in-yes-no" then
		if action == "y" then
			queue_index = queue_index + 1
		elseif action == "n" then
			local_message.text = "Cancelled"
			clear_queue_data()
			refresh_timewarrior_data()
			redraw_selection(true)
			return
		else
			return
		end
	end

	if state == "in-select" then
		data.project = nil

		if
			data.previous_queue_action.insert_actions
			and data.previous_queue_action.insert_actions[action]
		then
			queue_index = queue_index + 1
			table.insert(
				queue,
				queue_index,
				data.previous_queue_action.insert_actions[action]
			)
		else
			for _, project in pairs(data.projects) do
				if project.shortcut == action then
					data.project = project
					break
				end
			end

			if not data.project then
				return
			end

			data[data.previous_queue_action.field] =
				data.project[data.previous_queue_action.field]
			queue_index = queue_index + 1
		end
	end

	if state == "in-prompt" then
		return
	end

	if state == "awaiting" then
		if action == "j" then
			data = {
				direction = 1,
			}

			queue = {
				{
					type = "move",
				},
			}
		end

		if action == "k" then
			data = {
				direction = -1,
			}

			queue = {
				{
					type = "move",
				},
			}
		end

		if action == "c" then
			data = {
				id = timewarrior_data[index].id,
			}

			queue = {
				{
					type = "exec",
					command = "continue",
				},
			}
		end

		if action == "C" then
			data = {
				id = timewarrior_data[index].id,
			}

			queue = {
				{
					type = "prompt",
					prompt_type = "hour",
					field = "hour",
				},
				{
					type = "exec",
					command = "continue",
				},
			}
		end

		if action == "n" then
			data = {}

			queue = {
				{
					type = "select",
					data = projects,
					field = "tag",
				},
				{
					type = "select",
					data = special_tasks_with_return,
					field = "task",
					insert_actions = {
						Return = {
							type = "prompt",
							prompt_type = "task_number",
							field = "task",
						},
					},
				},
				{
					type = "exec",
					command = "start",
				},
			}
		end

		if action == "N" then
			data = {}

			queue = {
				{
					type = "select",
					data = projects,
					field = "tag",
				},
				{
					type = "select",
					data = special_tasks_with_return,
					field = "task",
					insert_actions = {
						Return = {
							type = "prompt",
							prompt_type = "task_number",
							field = "task",
						},
					},
				},
				{
					type = "prompt",
					prompt_type = "hour",
					field = "hour",
				},
				{
					type = "exec",
					command = "start",
				},
			}
		end

		if action == "S" then
			data = {
				id = timewarrior_data[index].id,
			}

			queue = {
				{
					type = "select",
					data = projects,
					field = "tag",
				},
				{
					type = "select",
					data = special_tasks_with_return,
					field = "task",
					insert_actions = {
						Return = {
							type = "prompt",
							prompt_type = "task_number",
							field = "task",
						},
					},
				},
				{
					type = "exec",
					command = "swap",
				},
			}
		end

		if action == "u" then
			data = {}

			queue = {
				{
					type = "exec",
					command = "undo",
				},
			}
		end

		if action == "s" then
			data = {}

			queue = {
				{
					type = "exec",
					command = "stop",
				},
			}
		end

		if action == "d" then
			data = {
				id = timewarrior_data[index].id,
			}

			queue = {
				{
					type = "yesno",
					yesno_type = "delete",
				},
				{
					type = "exec",
					command = "delete",
				},
			}
		end
	end

	local queue_action = queue[queue_index]

	if not queue_action then
		return
	end

	data.previous_queue_action = queue_action

	if queue_action.type == "move" then
		index = math.max(math.min(index + data.direction, last_tasks_count), 1)
		redraw_selection()
		clear_queue_data()
	end

	if queue_action.type == "exec" then
		if queue_action.command == "continue" then
			local_message.text = popen_msg(
				string.format("timew continue @%s %s", data.id, data.hour or "")
			)
		end

		if queue_action.command == "undo" then
			local_message.text = popen_msg("timew undo")
		end

		if queue_action.command == "stop" then
			local_message.text = popen_msg("timew stop")
		end

		if queue_action.command == "start" then
			local_message.text = popen_msg(
				string.format(
					"timew start %s-%s %s",
					data.tag,
					data.task,
					data.hour or ""
				)
			)
		end

		if queue_action.command == "swap" then
			local current_tags = {}
			local success, string_current_tags_count =
				popen(string.format("timew get dom.tracked.%s.tag.count", data.id))

			if success then
				for i = 1, tonumber(string_current_tags_count) do
					local tag_success, tag =
						popen(string.format("timew get dom.tracked.%s.tag.%s", data.id, i))

					if tag_success then
						table.insert(current_tags, tag)
					end
				end

				popen(
					string.format(
						"timew untag @%s %s",
						data.id,
						table.concat(current_tags, " ")
					)
				)
			end

			local_message.text = popen_msg(
				string.format("timew tag @%s %s-%s", data.id, data.tag, data.task)
			)
		end

		if queue_action.command == "delete" then
			local_message.text = popen_msg(string.format("timew delete @%s", data.id))
		end

		clear_queue_data()
		refresh_timewarrior_data()
		redraw_selection(true)
	end

	if queue_action.type == "prompt" then
		local_message.text = prompt_type_messages[queue_action.prompt_type]
		state = "in-prompt"

		awful.prompt.run({
			textbox = local_prompt,
			done_callback = function()
				if data[queue_action.field] and #data[queue_action.field] > 0 then
					queue_index = queue_index + 1
					state = "awaiting"
					update_popup()
				else
					local_message.text = "Cancelled"
					clear_queue_data()
					refresh_timewarrior_data()
					redraw_selection(true)
				end
			end,
			fg_cursor = "#3f3f3f",
			bg_cursor = "#f0dfaf",
			exe_callback = function(input)
				data[queue_action.field] = input or ""
			end,
		})
	end

	if queue_action.type == "yesno" then
		local_message.text =
			string.format("%s [y/n]", yesno_type_messages[queue_action.yesno_type])
		state = "in-yes-no"
	end

	if queue_action.type == "select" then
		data.projects = type(queue_action.data) == "function"
				and queue_action.data(data)
			or queue_action.data
		state = "in-select"
		index = 0
		redraw_selection()
		refresh_project_data(data.projects)
	end
end

return {
	popup = popup,
	update_popup = update_popup,
}
