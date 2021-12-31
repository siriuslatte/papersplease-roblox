-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier
-- Imports
local Knit = TS.import(script, TS.getModule(script, "@rbxts", "knit").Knit).KnitClient
return {
	Init = function(self)
		Knit.GetService("PlayerService").DataChanged:Connect(function(Old, New)
			print(string.format("Before data changed, the value was: %d and now it is: %d", Old, New))
		end)
	end,
}
