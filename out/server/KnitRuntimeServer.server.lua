-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
--[[
	Created by: SiriusLatte
	The main executation of Knit framework, simple and reliable.
]]
-- Imports
local Knit = TS.import(script, TS.getModule(script, "@rbxts", "knit").Knit).KnitServer
-- Constants
local _result = script.Parent
if _result ~= nil then
	_result = _result:FindFirstChild("Services")
end
local ServicesFolder = _result
local Start = os.clock()
-- Initializer
Knit.AddServices(ServicesFolder)
Knit.Start():andThen(function()
	local currentTime = os.clock()
	print(string.format("Took %0.3fms to start-up server! 🖥️", 1000 * (currentTime - Start)))
end)
