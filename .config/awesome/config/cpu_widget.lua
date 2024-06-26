local spawn = require("vicious.spawn")
local helpers = require("vicious.helpers")

local cpu = {}

function cpu.async(format, warg, callback)
	spawn.easy_async("powerprofilesctl get", function(stdout)
		callback({ string.gsub(stdout, "\n", "") })
	end)
end

return helpers.setasyncall(cpu)
