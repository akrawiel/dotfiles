local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
local helpers = require("vicious.helpers")

local battery_box = wibox.widget.textbox("")

local battery_widget = helpers.setcall(function()
	local battery_name = "BAT0"
	local battery = helpers.pathtotable("/sys/class/power_supply/" .. battery_name)

	-- Check if the battery is present
	if battery.present ~= "1\n" then
		return { "Unknown\n", 0, "N/A" }
	end

	-- Get state information
	local state = battery.status or "Unknown\n"

	-- Get capacity information
	local remaining, capacity
	if battery.charge_now then
		remaining, capacity = battery.charge_now, battery.charge_full
	elseif battery.energy_now then
		remaining, capacity = battery.energy_now, battery.energy_full
	else
		return { "Unknown\n", 0, "N/A" }
	end

	-- Calculate capacity and wear percentage (but work around broken BAT/ACPI implementations)
	local percent = math.min(math.floor(remaining / capacity * 100), 100)

	-- Get charge information
	local rate
	if battery.current_now then
		rate = tonumber(battery.current_now)
	elseif battery.power_now then
		rate = tonumber(battery.power_now)
	else
		return { state, percent, "N/A" }
	end

	-- Calculate remaining (charging or discharging) time
	local time = "N/A"

	if rate ~= nil and rate ~= 0 then
		local timeleft
		if state == "Charging\n" then
			timeleft = (tonumber(capacity) - tonumber(remaining)) / tonumber(rate)
		elseif state == "Discharging\n" then
			timeleft = tonumber(remaining) / tonumber(rate)
		else
			return { state, percent, time }
		end

		-- Calculate time
		local hoursleft = math.floor(timeleft)
		local minutesleft = math.floor((timeleft - hoursleft) * 60)

		time = string.format("%d:%02d", hoursleft, minutesleft)
	end

	return { state, percent, time }
end)

vicious.register(battery_box, battery_widget, function(_, args)
	local battery_state = {
		["Full\n"] = "F",
		["Unknown\n"] = "?",
		["Charged\n"] = "✓",
    ["Not charging\n"] = "!",
		["Charging\n"] = "+",
		["Discharging\n"] = "-",
	}

	return string.format(
		" <b>B</b>%s%.0f(%s)",
		battery_state[args[1]],
		args[2],
		tostring(args[3])
	)
end, 5)

return battery_box
