local awful = require("awful")
local gears = require("gears")

local commands = require("config.commands")

local Mod = { modkey }
local ModShift = { modkey, "Shift" }
local ModControl = { modkey, "Control" }

return function(options)
	local tags = options.tags or {}

	local keys = gears.table.join(
		-- XF86 Media keys
		awful.key({ "Shift" }, "XF86AudioNext", commands.audioNextAll),
		awful.key({ "Shift" }, "XF86AudioPlay", commands.audioPlayAll),
		awful.key({ "Shift" }, "XF86AudioPrev", commands.audioPrevAll),
		awful.key({}, "XF86AudioLowerVolume", commands.audioLower),
		awful.key({}, "XF86AudioMicMute", commands.audioMicMute),
		awful.key({}, "XF86AudioMute", commands.audioMute),
		awful.key({}, "XF86AudioNext", commands.audioNext),
		awful.key({}, "XF86AudioPlay", commands.audioPlay),
		awful.key({}, "XF86AudioPrev", commands.audioPrev),
		awful.key({}, "XF86AudioRaiseVolume", commands.audioRaise),
		awful.key({}, "XF86AudioStop", commands.audioStop),

		-- Alternative media keybindings
		awful.key(ModControl, "h", commands.audioPrev),
		awful.key(ModControl, "j", commands.audioPlay),
		awful.key(ModControl, "k", commands.audioPlay),
		awful.key(ModControl, "l", commands.audioNext),

		-- Focus switching
		awful.key(Mod, "h", commands.focusLeft),
		awful.key(Mod, "j", commands.focusDown),
		awful.key(Mod, "k", commands.focusUp),
		awful.key(Mod, "l", commands.focusRight),

		-- Window swapping
		awful.key(ModShift, "h", commands.swapLeft),
		awful.key(ModShift, "j", commands.swapDown),
		awful.key(ModShift, "k", commands.swapUp),
		awful.key(ModShift, "l", commands.swapRight),

		-- Launchers
		awful.key(Mod, "Return", commands.runTerminal),
		awful.key(Mod, ".", commands.runRofimoji),
		awful.key(Mod, "space", commands.runRofi),
		awful.key(Mod, "Tab", commands.runPopup),
		awful.key(Mod, "g", commands.runTenorSelector),

		-- Awesome controls
		awful.key(Mod, "x", commands.invokePrompt),
		awful.key(Mod, "r", commands.startResize),

		-- Window focus
		awful.key(Mod, "s", commands.focusWindowClass("Slack")),
		awful.key(Mod, "d", commands.focusWindowClass("Logseq")),

		-- Other controls
		awful.key({}, "F10", commands.toggleDropdown),
		awful.key({}, "Print", commands.runFlameshot)
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
