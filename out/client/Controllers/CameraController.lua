-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier
--[[
	Created by: SiriusLatte
	Camera controller for locking it in a single position.
]]
-- Imports
local Knit = TS.import(script, TS.getModule(script, "@rbxts", "knit").Knit).KnitClient
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
-- Constants
local Camera = Workspace.CurrentCamera
-- KnitController
local CameraController = Knit.CreateController({
	Name = "CameraController",
	KnitStart = function(self)
		--[[
			Move the camera to the current position
		]]
		Knit.GetService("PlayerService").SetupCamera:Connect(function()
			print("Moving camera!")
			task.wait(2)
			-- Camera CFraming
			Camera.CameraType = Enum.CameraType.Scriptable
			local CameraPosition = Workspace:WaitForChild("playercam")
			Camera.CFrame = CameraPosition.CFrame
		end)
	end,
})
return nil
