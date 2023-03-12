local awful = require("awful")
local gears = require("gears")

local commands = require("config.commands")

local Mod = { modkey }
local ModShift = { modkey, "Shift" }
local ModControl = { modkey, "Control" }
local Hyper = { "Control", "Shift", "Mod1", modkey }
local Meh = { "Control", "Shift", "Mod1" }

return function(options)
	local tags = options.tags or {}

	local keys = gears.table.join(
		-- Focus switching
		awful.key(Mod, "h", commands.focusLeft),
		awful.key(Mod, "j", commands.focusDown),
		awful.key(Mod, "k", commands.focusUp),
		awful.key(Mod, "l", commands.focusRight),
		awful.key(Mod, "Tab", commands.focusPrevious),

		-- Window swapping
		awful.key(ModShift, "h", commands.swapLeft),
		awful.key(ModShift, "j", commands.swapDown),
		awful.key(ModShift, "k", commands.swapUp),
		awful.key(ModShift, "l", commands.swapRight),

		-- Launchers
		awful.key(Mod, "Return", commands.runTerminal),
		awful.key(Mod, "space", commands.runRofi),
		awful.key(Meh, "Tab", commands.runChorder),

		-- Awesome controls
		awful.key(Hyper, "l", commands.lockScreen),
		awful.key(Hyper, "r", awesome.restart),
		awful.key(Hyper, "q", awesome.quit),
		awful.key(Mod, "x", commands.invokePrompt),
		awful.key(Mod, "r", commands.startResize),

		-- Scratchpad
		awful.key({}, "F10", commands.toggleDropdown)
	)

	-- Tags
	for _, tag in pairs(tags) do
		keys = gears.table.join(
			keys,
			awful.key(Mod, tag, commands.focusTag(tag)),
			awful.key(ModShift, tag, commands.moveToTag(tag)),
			awful.key(ModControl, tag, commands.pinToTag(tag))
		)
	end

	return keys
end
