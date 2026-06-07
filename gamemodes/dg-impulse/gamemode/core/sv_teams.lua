meta.OldSetTeam = meta.OldSetTeam or meta.SetTeam
function meta:SetTeam(teamID, forced)
	if not IsValid(self) then return end
	local teamData = impulse.Teams.Data[teamID]
	local teamPlayers = team.NumPlayers(teamID)
	self:ResetSubMaterials()

	if self.DynamicFlashlight then
        self.DynamicFlashlight:Remove()
        self.DynamicFlashlight = nil
        LocalPlayer():EmitSound( "ez2/nvg/nvg_off.wav", SNDLVL_NORM)
    end
    self:SetNWBool("DynamicFlashlight", false)

    self:SetNWBool("IsNVGEquipped", false)

	if teamData.modelScale then
		self:SetModelScale(teamData.modelScale)
	else
		self:SetModelScale(1)
	end

	if teamData.materialSet then
		self:SetMaterial(teamData.materialSet)
	else
		self:SetMaterial("")
	end

	if teamData.model then
		self:SetModel(teamData.model)
	elseif self.defaultModel then
		self:SetModel(self.defaultModel)
	else
		self:SetModel("models/willardnetworks_custom/citizens/male07.mdl")
	end

	if teamData.noTarget then
		self:SetNoTarget(teamData.noTarget)
	else
		self:SetNoTarget(false)
	end

	if teamData.skin then
		self:SetSkin(teamData.skin)
	elseif not teamData.model then
		self:SetSkin(self.defaultSkin or 0)
	end

	if teamData.spawnLoc == true then
		if teamID == TEAM_CITIZEN then
			self:SetPos(table.Random(impulse.Config.CitizenSpawnLocations))
		elseif teamID == TEAM_CWU then
			self:SetPos(table.Random(impulse.Config.CWUSpawnLocations))
		elseif teamID == TEAM_CP then
			self:SetPos(table.Random(impulse.Config.CPSpawnLocations))
		elseif teamID == TEAM_OTA then
			self:SetPos(table.Random(impulse.Config.OTASpawnLocations))
		elseif teamID == TEAM_CA then
			self:SetPos(table.Random(impulse.Config.CASpawnLocations))
		elseif teamID == TEAM_VORT then
			self:SetPos(table.Random(impulse.Config.VortSpawnLocations))
		elseif teamID == TEAM_ZOMBIE then
			self:SetPos(table.Random(impulse.Config.ZombieSpawnLocations))
		elseif teamID == TEAM_STALKER then
			self:SetPos(table.Random(impulse.Config.StalkerSpawnLocations))
		elseif teamID == TEAM_CREMATOR then
    		self:SetPos(table.Random(impulse.Config.CrematorSpawnLocations))
		end
	end	

	if teamData.bodygroups then
		for v, bodygroupData in pairs(teamData.bodygroups) do
			self:SetBodygroup(bodygroupData[1], (bodygroupData[2] or math.random(0, self:GetBodygroupCount(bodygroupData[1]))))
		end
	else
		self:SetBodyGroups("0000000")
	end

	self:ResetSubMaterials()

	if self:IsCP() or teamData.cp then
		self:StripAmmo()
	end
	
	self:UnEquipInventory()
	self:ClearRestrictedInventory()
	self:StripWeapons()
	
	if teamData.loadout then
		for v,weapon in pairs(teamData.loadout) do
			self:Give(weapon)
		end
	end

	if teamData.runSpeed then
		self:SetRunSpeed(teamData.runSpeed)
	else
		self:SetRunSpeed(impulse.Config.JogSpeed)
	end

	if teamData.Health then
		self:SetHealth(teamData.Health)
		self:SetMaxHealth(teamData.Health)
	elseif teamID == TEAM_CITIZEN or teamID == TEAM_CWU or teamID == TEAM_CA then
		if self:IsCharacterFemale() then
			self:SetMaxHealth(impulse.Config.DefaultFemaleHealth)
		else
			self:SetMaxHealth(impulse.Config.DefaultMaleHealth)
		end
	else
		self:SetMaxHealth(100)
	end

	if not teamData.Health and self:Health() > impulse.Config.DefaultMaleHealth and not self:IsCharacterFemale() then
		self:SetHealth(impulse.Config.DefaultMaleHealth)
	elseif not teamData.Health and self:Health() > impulse.Config.DefaultFemaleHealth and self:IsCharacterFemale() then
		if teamID == TEAM_CP or teamID == TEAM_OTA or teamID == TEAM_VORT then
			self:SetHealth(impulse.Config.DefaultMaleHealth)
		else	
			self:SetHealth(impulse.Config.DefaultFemaleHealth)
		end
	end

	if teamData.Armor then
		self:SetArmor(teamData.Armor)
	else
		self:SetArmor(0)
		self:SetMaxArmor(0)
	end

	if teamData.NameReplace then
		self:SetRPName(teamData.NameReplace)
	else
		self:SetRPName(self:GetSavedRPName())
	end

	self.DoorGroups = teamData.doorGroup or {}

	if self:Team() != teamID then
		hook.Run("OnPlayerChangedTeam", self, self:Team(), teamID)
	end

	self:SetLocalSyncVar(SYNC_CLASS, nil, true)
	self:SetLocalSyncVar(SYNC_RANK, nil, true)
	self:OldSetTeam(teamID)
	self:SetupHands()

	hook.Run("UpdatePlayerSync", self)

	if teamData.onBecome then
		teamData.onBecome(self)
	end

	self:SetSubMaterial(2, "") -- reset MPF Rank submat

	return true
end

function meta:SetTeamClass(classID, skipLoadout)
	if not IsValid(self) then return end
	local teamData = impulse.Teams.Data[self:Team()]
	local classData = teamData.classes[classID]
	local classPlayers = 0
	
	if classData.modelScale then
		self:SetModelScale(classData.modelScale)
	else
		self:SetModelScale(1)
	end

	if classData.materialSet then
		self:SetMaterial(classData.materialSet)
	else
		self:SetMaterial("")
	end

	if classData.model then
		self:SetModel(classData.model)
	else
		self:SetModel(teamData.model or self.defaultModel)
	end

	self:SetupHands()

	if classData.skin then
		self:SetSkin(classData.skin)
	else
		self:SetSkin(teamData.skin or self.defaultSkin)
	end

	self:SetBodyGroups("0000000")
	
	if classData.bodygroups then
		for v, bodygroupData in pairs(classData.bodygroups) do
			self:SetBodygroup(bodygroupData[1], (bodygroupData[2] or math.random(0, self:GetBodygroupCount(bodygroupData[1]))))
		end
	elseif teamData.bodygroups then
		for v, bodygroupData in pairs(teamData.bodygroups) do
			self:SetBodygroup(bodygroupData[1], (bodygroupData[2] or math.random(0, self:GetBodygroupCount(bodygroupData[1]))))
		end
	end

	if not skipLoadout then
		self:StripWeapons()

		if classData.loadout then
			for v,weapon in pairs(classData.loadout) do
				self:Give(weapon)
			end
		else
			for v,weapon in pairs(teamData.loadout) do
				self:Give(weapon)
			end

			if classData.loadoutAdd then
				for v,weapon in pairs(classData.loadoutAdd) do
					self:Give(weapon)
				end
			end
		end

		self:ClearRestrictedInventory()

		if classData.items then
			for v,item in pairs(classData.items) do
				for i=1, (item.amount or 1) do
					self:GiveInventoryItem(item.class, 1, true)
				end
			end
		else
			if teamData.items then
				for v,item in pairs(teamData.items) do
					for i=1, (item.amount or 1) do
						self:GiveInventoryItem(item.class, 1, true)
					end
				end
			end

			if classData.itemsAdd then
				for v,item in pairs(classData.itemsAdd) do
					for i=1, (item.amount or 1) do
						self:GiveInventoryItem(item.class, 1, true)
					end
				end
			end
		end
	end

	if classData.armour then
		self:SetArmor(classData.armour)
		self.MaxArmour = classData.armour
	else
		self:SetArmor(0)
		self.MaxArmour = nil
	end

	if classData.Health then
		self:SetHealth(classData.Health)
		self:SetMaxHealth(classData.Health)
	elseif teamID == TEAM_CITIZEN or teamID == TEAM_CWU or teamID == TEAM_CA then
		if self:IsCharacterFemale() then
			if self:Health() > impulse.Config.DefaultFemaleHealth then
				self:SetHealth(impulse.Config.DefaultFemaleHealth)
			end
			self:SetMaxHealth(impulse.Config.DefaultFemaleHealth)
		else
			if self:Health() > impulse.Config.DefaultMaleHealth then
				self:SetHealth(impulse.Config.DefaultMaleHealth)
			end
			self:SetMaxHealth(impulse.Config.DefaultMaleHealth)
		end
	else
		if self:Health() > 100 then
			self:SetHealth(100)
		end
		self:SetMaxHealth(100)
	end

	if classData.doorGroup then
		self.DoorGroups = classData.doorGroup
	else
		self.DoorGroups = teamData.doorGroup or {}
	end

	if classData.onBecome then
		classData.onBecome(self)
	end

	self:SetLocalSyncVar(SYNC_CLASS, classID, true)

	self:SetSubMaterial(2, "") -- reset MPF Rank submat

	hook.Run("PlayerChangeClass", self, classID, classData.name)

	return true
end

function meta:SetTeamRank(rankID)
	if not IsValid(self) then return end
	local teamData = impulse.Teams.Data[self:Team()]
	local classData = teamData.classes[self:GetTeamClass()]
	local rankData = teamData.ranks[rankID]

	if rankData.model then
		self:SetModel(rankData.model)
	else
		if classData.model and self:GetModel() != classData.model then
			self:SetModel(classData.model)
		end
	end

	if rankData.materialSet then
		self:SetMaterial(rankData.materialSet)
	else
		self:SetMaterial("")
	end


	self:SetupHands()

	if rankData.skin then
		self:SetSkin(rankData.skin)
	end

	if rankData.bodygroups then
		for v, bodygroupData in pairs(rankData.bodygroups) do
			self:SetBodygroup(bodygroupData[1], (bodygroupData[2] or math.random(0, self:GetBodygroupCount(bodygroupData[1]))))
		end
	elseif teamData.bodygroups then
		for v, bodygroupData in pairs(teamData.bodygroups) do
			self:SetBodygroup(bodygroupData[1], (bodygroupData[2] or math.random(0, self:GetBodygroupCount(bodygroupData[1]))))
		end
	else
		self:SetBodyGroups("0000000")
	end

	if self:Team() != TEAM_CP then
		if rankData.subMaterial and not classData.noSubMats then
			for v,k in pairs(rankData.subMaterial) do
				self:SetSubMaterial(v - 1, k)
				self.SetSubMats = self.SetSubMats or {}
				self.SetSubMats[v] = true
			end
		elseif self.SetSubMats then
			self:ResetSubMaterials()
		end
	end

	self:StripWeapons()

	if rankData.loadout then
		for v,weapon in pairs(rankData.loadout) do
			self:Give(weapon)
		end
	else
		for v,weapon in pairs(teamData.loadout) do
			self:Give(weapon)
		end

		if classData and classData.loadoutAdd then
			for v,weapon in pairs(classData.loadoutAdd) do
				self:Give(weapon)
			end
		end

		if rankData.loadoutAdd then
			for v,weapon in pairs(rankData.loadoutAdd) do
				self:Give(weapon)
			end
		end
	end

	self:ClearRestrictedInventory()

	if rankData.items then
		for v,item in pairs(rankData.items) do
			for i=1, (item.amount or 1) do
				self:GiveInventoryItem(item.class, 1, true)
			end
		end
	else
		if teamData.items then
			for v,item in pairs(teamData.items) do
				for i=1, (item.amount or 1) do
					self:GiveInventoryItem(item.class, 1, true)
				end
			end
		end

		if classData.itemsAdd then
			for v,item in pairs(classData.itemsAdd) do
				for i=1, (item.amount or 1) do
					self:GiveInventoryItem(item.class, 1, true)
				end
			end
		end

		if rankData.itemsAdd then
			for v,item in pairs(rankData.itemsAdd) do
				for i=1, (item.amount or 1) do
					self:GiveInventoryItem(item.class, 1, true)
				end
			end
		end
	end

	if rankData.doorGroup then
		self.DoorGroups = rankData.doorGroup
	else
		if classData.doorGroup then
			self.DoorGroups = classData.doorGroup
		else
			self.DoorGroups = teamData.doorGroup or {}
		end
	end

	if rankData.canPromote then
		self.canPromote = rankData.ranks
	end

	if rankData.onBecome then
		rankData.onBecome(self)
	end

	self:SetLocalSyncVar(SYNC_RANK, rankID, true)

	self:SetSubMaterial(2, "") -- reset MPF Rank submat

	hook.Run("PlayerChangeRank", self, rankID, rankData.name)

	return true
end

function impulse.Teams.WhitelistSetup(steamid)
	local query = mysql:Insert("impulse_whitelists")
	query:Insert("steamid")
end

function impulse.Teams.SetWhitelist(steamid, team, level)
	local inTable = impulse.Teams.GetWhitelist(steamid, team, function(exists)
		if exists then
			local query = mysql:Update("impulse_whitelists")
			query:Update("level", level)
			query:Where("team", team)
			query:Where("steamid", steamid)
			query:Execute()	
		else
			local query = mysql:Insert("impulse_whitelists")
			query:Insert("level", level)
			query:Insert("team", team)
			query:Insert("steamid", steamid)
			query:Execute()	
		end

		for v, ply in ipairs(player.GetAll()) do
			if ply:SteamID() == steamid then
				ply.Whitelists = ply.Whitelists or {}
				ply.Whitelists[team] = level
				break
			end
		end
	end)
end

function impulse.Teams.GetAllWhitelists(team, callback)
	local query = mysql:Select("impulse_whitelists")
	query:Select("level")
	query:Select("steamid")
	query:Where("team", team)
	query:Callback(function(result)
		if type(result) == "table" and #result > 0 and callback then -- if player exists in db
			callback(result)
		end
	end)
	query:Execute()
end

function impulse.Teams.GetAllWhitelistsPlayer(steamid, callback)
	local query = mysql:Select("impulse_whitelists")
	query:Select("level")
	query:Select("team")
	query:Where("steamid", steamid)
	query:Callback(function(result)
		if (type(result) == "table" and #result > 0) and callback then -- if player exists in db
			callback(result)
		end
	end)
	query:Execute()
end

function impulse.Teams.GetWhitelist(steamid, team, callback)
	local query = mysql:Select("impulse_whitelists")
	query:Select("level")
	query:Where("team", team)
	query:Where("steamid", steamid)
	query:Callback(function(result)
		if type(result) == "table" and #result > 0 and callback then -- if player exists in db
			callback(result[1].level)
		else
			callback()
		end
	end)
	query:Execute()
end

function meta:GetTeamWhitelist(team)
    if self:IsSuperAdmin() and team ~= TEAM_CITIZEN then
        return 999
    end
	if not self.Whitelists[team] then
		return 0
	else
	
	local whitelistLevel = self.Whitelists[team]

	return whitelistLevel
	end
end 

function meta:HasTeamWhitelist(team, level)
	if not self.Whitelists then
		return false
	end
	if self:IsSuperAdmin() then
		return true
	end

	local whitelist = self.Whitelists[team]

	if whitelist then
		if level then
			return whitelist >= level
		else
			return true
		end
	end

	return false
end

function meta:SetupWhitelists()
	self.Whitelists = {}

	impulse.Teams.GetAllWhitelistsPlayer(self:SteamID(), function(result)
		if not result or not IsValid(self) then
			return
		end

		for v,k in pairs(result) do
			local teamName = k.team
			local level = k.level
			local realTeam = impulse.Teams.NameRef[teamName]

			--if not realTeam then -- team does not exist
			--	continue
			--end

			self.Whitelists[realTeam or k.team] = level
		end
	end)
end
