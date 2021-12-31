-- Compiled with roblox-ts v1.2.7
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
-- eslint-disable prettier/prettier
--[[
	Created by: SiriusLatte
	Simple ClassData thing which handles ProfileService as I was too lazy to create my own
	wrapper for the DataStoreService as well.
]]
-- Imports
local ProfileService = TS.import(script, TS.getModule(script, "@rbxts", "profileservice").src)
local Players = TS.import(script, TS.getModule(script, "@rbxts", "services")).Players
-- Constants
local Template = {
	Cash = 0,
	PeopleAccepted = 0,
	PeopleDenied = 0,
	TimesLost = 0,
	CurrentDay = 0,
	CurrentTime = 0,
}
local ProfileStore = ProfileService.GetProfileStore({
	Name = "kP#Q%Q@LuGj*",
}, Template)
-- Interfaces & types
-- Class
local DataClass
do
	DataClass = setmetatable({}, {
		__tostring = function()
			return "DataClass"
		end,
	})
	DataClass.__index = DataClass
	function DataClass.new(...)
		local self = setmetatable({}, DataClass)
		return self:constructor(...) or self
	end
	function DataClass:constructor(Client, SignalToFire)
		self.Data = Template
		-- Initialises loading of data
		local _fn = ProfileStore
		local _userId = Client.UserId
		local ProfileData = _fn:LoadProfileAsync(string.format("PlayerUniqueGeneratedId_%d", _userId))
		self.Player = Client
		if ProfileData ~= nil then
			ProfileData:AddUserId(Client.UserId)
			ProfileData:Reconcile()
			-- Gives the data table so it can be easily accessed
			self.Data = ProfileData.Data
			self.PlayerProfile = ProfileData
			self.Signal = SignalToFire
		else
			Client:Kick("Your profile hasn't been released! This may be due to an error while trying to save your data... Join back again!")
		end
	end
	function DataClass:GetData()
		local _condition = self.Data
		if _condition == nil then
			_condition = {}
		end
		return _condition
	end
	function DataClass:WriteData(Stat, NewData)
		if NewData == nil then
			return nil
		end
		local StatTo = Stat
		local Data = self.Data[StatTo]
		local OldData = Data
		if Data ~= nil then
			Data = NewData
			self.Data[StatTo] = Data
			-- Remote
			local _result = self.Signal
			if _result ~= nil then
				_result:Fire(self.Player, OldData, Data)
			end
		else
			warn("[DataManager]: Provide a valid stat to write over!")
			return nil
		end
	end
	function DataClass:IncrementData(Stat, Value)
		if Value == nil then
			return nil
		end
		if Value < 0 or Value == 0 then
			return nil
		end
		local StatTo = Stat
		local Data = self.Data[StatTo]
		if Data == nil then
			warn("[DataManager]: Provide a valid stat to increment!")
			return nil
		end
		if type(Data) ~= "number" then
			warn("[DataManager]: You can only increment number values!")
			return nil
		end
		local oldValue = Data
		Data += Value
		self.Data[StatTo] = Data
		-- Remote
		local _result = self.Signal
		if _result ~= nil then
			_result:Fire(self.Player, oldValue, Data)
		end
	end
	function DataClass:Save()
		-- Saves current profile
		self.PlayerProfile:Release()
		-- Safe kicking
		if self.Player:IsDescendantOf(Players) then
			self.Player:Kick("Manually kicked as your profile has been saved already!")
		end
	end
end
return DataClass
