-- Support for accessory mods

for ply, fx in pairs(VoiceBox_AccessoryStack or {}) do
	if IsValid(ply) then
		for addon, accessories in pairs(VoiceBox_AccessoryStack[ply]) do
			for _, fx in pairs(accessories) do
				ply:RemoveVoiceFX(fx)
			end
		end
	end
end

VoiceBox_AccessoryStack = {}

local VoiceBox_AccessoryStack = VoiceBox_AccessoryStack
local IsValid = IsValid
local processStack = {}

local function getAccessoryFX(id)
	return VoiceBox.FX.Config.AccessoryFX[string.Trim(tostring(id))]
end

local function clearAccessoryStack(ply, addonName)
	if not IsValid(ply) then return end
	if VoiceBox_AccessoryStack[ply] then
		if addonName then
			for addon, accessories in pairs(VoiceBox_AccessoryStack[ply]) do
				for _, fx in pairs(accessories) do
					ply:RemoveVoiceFX(fx)
				end
			end
			VoiceBox_AccessoryStack[ply] = nil
		elseif VoiceBox_AccessoryStack[ply][addonName] then
			for _, fx in pairs(VoiceBox_AccessoryStack[ply][addonName]) do
				ply:RemoveVoiceFX(fx)
			end
			VoiceBox_AccessoryStack[ply][addonName] = nil
		end
	end
end

local function addAccessoryFX(ply, addon, id)
	if not IsValid(ply) then return end

	local fx = getAccessoryFX(id)
	if not fx then return end

	assert(isstring(fx), "FX wasn't a string?")

	local accessories = VoiceBox_AccessoryStack[ply]
	if not accessories then
		accessories = {}
		VoiceBox_AccessoryStack[ply] = accessories
	end
	if not accessories[addon] then
		accessories[addon] = {}
		accessories = accessories[addon]
	end
	if not accessories[id] then
		accessories[id] = fx
		ply:AddVoiceFX(fx)
	end
end

local function processEquippedAccessories(ply)
	clearAccessoryStack(ply)
	for i = 1, #processStack do
		processStack[i](ply)
	end
end

hook.Add("PlayerDeath", "VoiceBox.FX.AccessoryStack", clearAccessoryStack)

hook.Add("PlayerDisconnected", "VoiceBox.FX.AccessoryStack", function(ply)
	VoiceBox_AccessoryStack[ply] = nil
end)

hook.Add("PlayerLoadout", "VoiceBox.FX.AccessoryStack", function(ply)
	local hookName = "VoiceBox.FX.AccessoryStack:" .. ply:SteamID64()
	hook.Add("Tick", hookName, function(ply)
		hook.Remove("Tick", hookName)
		if IsValid(ply) then
			processEquippedAccessories(ply)
		end
	end)
end)

--#######################################################################################################################################--
--#######################################################################################################################################--
--#######################################################################################################################################--

-- Advanced Accessory - The Most Advanced Accessory System
-- https://www.gmodstore.com/market/view/7706
do
	local idCache = {}
	local function process(ply)
		if ply.AASAccessories then
			for category, item in pairs(ply.AASAccessories) do
				if category ~= "offsets" and isnumber(item) then
					local itemTbl = idCache[item]
					if not itemTbl then
						itemTbl = AAS.FormatTable(item)
					end
					if itemTbl and itemTbl.name then
						addAccessoryFX(ply, 7706, itemTbl.name)
					end
				end
			end
		end
	end

	hook.Add("AAS:AccessoryEquiped", "VoiceBox.FX", function(ply, accessory)
		if accessory == nil and not table.IsEmpty(VoiceBox.FX.Config.AccessoryFX) then
			error("Your version of Advanced Accessory by Kobralost is outdated - please update it to use it with VoiceBox FX")
		elseif accessory.name then
			addAccessoryFX(ply, 7706, accessory.name)
		end
	end)

	hook.Add("AAS:RemoveAllAccessory", "VoiceBox.FX", function(ply)
		clearAccessoryStack(ply, 7706)
	end)

	hook.Add("AAS:AccessoryUnEquiped", "VoiceBox.FX", function(ply)
		clearAccessoryStack(ply, 7706)
		process(ply)
	end)

	table.insert(processStack, process)
end