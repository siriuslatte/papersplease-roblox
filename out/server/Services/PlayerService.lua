-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier
--[[
	Created by: SiriusLatte
	DataManager module which just handles simple cash that can be earned as a demonstration
	of a small service, the other services are a little bit more complex.
]]
-- Imports
local _knit = TS.import(script, TS.getModule(script, "@rbxts", "knit").Knit)
local Knit = _knit.KnitServer
local RemoteSignal = _knit.RemoteSignal
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
local DataClass = TS.import(script, game:GetService("ServerScriptService"), "Game", "Modules", "DataClass")
-- KnitService
local PlayerService = Knit.CreateService({
	Name = "PlayerService",
	PlayersData = {},
	Client = {
		DataChanged = RemoteSignal.new(),
		SetupCamera = RemoteSignal.new(),
	},
	KnitStart = function(self)
		--[[
			KnitStart() method gets invoked after the Init method, even though
			we don't need the Init method as maybe we would want to invoke different services within Knit
			that's why we set up every connection for the player's here, so there's no
			errors at all! Learn more about the Life cycle Knit here: https://sleitnick.github.io/Knit/docs/executionmodel
		]]
		-- Players connection
		Players.PlayerAdded:Connect(function(Client)
			--[[
				Every single operation that needs to be done within the client/player
				that joint the server, SHOULD be done here for facility, i do avoid the multiple
				connections for a single event that way i just set up different modules/services for
				it!
			]]
			-- Player data loading
			local PlayerData = DataClass.new(Client, self.Client.DataChanged)
			-- ▼ Map.set ▼
			self.PlayersData[Client] = PlayerData
			-- ▲ Map.set ▲
			coroutine.wrap(function()
				while true do
					task.wait(1)
					PlayerData:IncrementData("Cash", 10)
				end
			end)()
			self.Client.SetupCamera:Fire(Client)
		end)
		Players.PlayerRemoving:Connect(function(Client) end)
	end,
})
return PlayerService
