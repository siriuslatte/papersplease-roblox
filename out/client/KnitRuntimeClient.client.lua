-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier
--[[
	Created by: SiriusLatte
	The main executation of Knit framework, simple and reliable.
]]
-- Imports
local Knit = TS.import(script, TS.getModule(script, "@rbxts", "knit").Knit).KnitClient
-- Types
-- Constants
local _result = script.Parent
if _result ~= nil then
	_result = _result:FindFirstChild("Controllers")
end
local ControllersFolder = _result
local _result_1 = script.Parent
if _result_1 ~= nil then
	_result_1 = _result_1:FindFirstChild("Subroutines")
end
local SubroutinesFolder = _result_1
local Start = os.clock()
-- Initializer
Knit.AddControllers(ControllersFolder)
Knit.Start():andThen(function()
	local currentTime = os.clock()
	print(string.format("Took %0.3fms to start-up client! 💻", 1000 * (currentTime - Start)))
end)
-- Loader of subroutines for facility
Knit.OnStart():andThen(function()
	-- eslint-disable-next-line roblox-ts/no-array-pairs
	for _, module in ipairs(SubroutinesFolder:GetChildren()) do
		if module:IsA("ModuleScript") then
			local Required = require(module)
			coroutine.wrap(function()
				Required:Init()
			end)()
		end
	end
end)
