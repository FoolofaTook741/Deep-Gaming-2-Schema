impulse.EventMode = false

local entityMeta = FindMetaTable("Entity")

function GetSporeCount()
    local spores = 0
    for k, v in pairs(ents.FindByClass("deep_spore")) do
        spores = spores + 1
    end
    return spores
end

function meta:IsICT()
	if self:Team() == TEAM_CWU and self:GetTeamClass() == CLASS_ICT then
		return true
	end
end

function meta:IsRebel() -- if u want a smarter is rebel then make it SEPERATE to this func, this function should just be based off team,class and bodygroups/skins/models.

	if self:Team() == TEAM_CITIZEN or self:Team() == TEAM_CWU then
		if (self:GetBodygroup(2) == 8) or (self:GetBodygroup(2) == 7) or (self:GetBodygroup(2) == 9) or (self:GetBodygroup(2) == 10) or (self:GetBodygroup(2) == 11) or (self:GetBodygroup(2) == 12) or (self:GetBodygroup(2) == 25) or (self:GetBodygroup(2) == 26) then -- if torso is rebel
			return true
		elseif self:GetBodygroup(3) == 2 or self:GetBodygroup(3) == 3 or self:GetBodygroup(3) == 4 then
			return true
		else
			return false
		end
	elseif self:Team() == TEAM_VORT then
		if self:GetBodygroup(7) != 1 then
			return true
		else
			return false
		end
	end

	return false
end

CRIME_ANTCIITIZEN = 1
CRIME_VORT = 2
CRIME_WEAPON = 3
CRIME_CONTRABAND = 4
CRIME_EVASION = 5
CRIME_CURFEW = 6
CRIME_BOL = 7
CRIME_ZOMBIE = 8
CRIME_ANTCITIZENMEDIC = 8
CRIME_ROGUEUNIT = 9

CRIME_NICENAMES = {
	[CRIME_ANTCIITIZEN] = "Anti-Citizen",
	[CRIME_VORT] = "Unregistered Biotic",
	[CRIME_WEAPON] = "High Tier Contraband",
	[CRIME_EVASION] = "Surveillance Evasion",
	[CRIME_CURFEW] = "Curfew Violation",
	[CRIME_BOL] = "BOL Target",
	[CRIME_ZOMBIE] = "Infected Person",
	[CRIME_ANTCITIZENMEDIC] = "Anti-Citizen Medic",
	[CRIME_ROGUEUNIT] = "Rogue Unit",
}

local allowedWeps = {
	["plutonic_vort"] = true,
	["plutonic_snowball"] = true,
	["plutonic_broom"] = true
}

local strsub = string.sub
function meta:IsRebelSmart()
	local isCriminal = false
	local idKnown = true
	local firstCrime
	local crimes = {}

	if self:IsCP() and not self.IsRogue then
		return false, false, {}
	end

	if self.HasFaceCover then -- has facewrap on
		isCriminal = true
		idKnown = false
		firstCrime = firstCrime or CRIME_EVASION
		crimes[CRIME_EVASION] = true
	end

	--if impulse.Dispatch.GetCityCode() >= CODE_JW and  then this would be too annoying imo
	--	isCriminal = true
	--end

	if idKnown and self:IsDispatchBOL() then
		isCriminal = true
		firstCrime = firstCrime or CRIME_BOL
		crimes[CRIME_BOL] = true
	end

	local wep = self:GetActiveWeapon()

	if IsValid(wep) then
		local wepclass = wep:GetClass()

		if (strsub(wepclass, 1, 3) == "plutonic_" or strsub(wepclass, 1, 3) == "plutonic") and not allowedWeps[wepclass] then
			isCriminal = true
			firstCrime = firstCrime or CRIME_WEAPON
			crimes[CRIME_WEAPON] = true
		end
	end

	local t = self:Team()

	if t == TEAM_CITIZEN and ((self:GetBodygroup(2) == 8) or (self:GetBodygroup(2) == 7) or (self:GetBodygroup(2) == 9) or (self:GetBodygroup(2) == 10) or (self:GetBodygroup(2) == 11) or (self:GetBodygroup(2) == 12) or (self:GetBodygroup(2) == 25) or (self:GetBodygroup(2) == 26)) then -- rebel suit
		isCriminal = true
		firstCrime = firstCrime or CRIME_ANTCIITIZEN
		crimes[CRIME_ANTCIITIZEN] = true
	elseif t == TEAM_CWU and (self.IsARebel or self:GetBodygroup(2) == 10) then -- rebel medic
		isCriminal = true
		firstCrime = firstCrime or CRIME_ANTCITIZENMEDIC
		crimes[CRIME_ANTCITIZENMEDIC] = true
	elseif t == TEAM_VORT and self:GetBodygroup(7) != 1 then -- unshackled vort
		isCriminal = true
		firstCrime = firstCrime or CRIME_VORT
		crimes[CRIME_VORT] = true
	elseif t == TEAM_ZOMBIE then -- zombie
		isCriminal = true
		firstCrime = firstCrime or CRIME_ZOMBIE
		crimes[CRIME_ZOMBIE] = true
	elseif t == TEAM_CP and self.IsRogue then
		isCriminal = true
		firstCrime = firstCrime or CRIME_ROGUEUNIT
		crimes[CRIME_ROGUEUNIT] = true
	end

	if (self.GasSafe and self:GetTeamClass() != CLASS_ICT) or self.HasHelmet or self.HasOTAVest then
		isCriminal = true
		firstCrime = firstCrime or CRIME_ANTCIITIZEN
		crimes[CRIME_ANTCIITIZEN] = true
	end

	return isCriminal, idKnown, crimes, firstCrime
end

function meta:GetDigits()
	if not self:Team() == TEAM_CP then return end
	local startpos, endpos, string = string.find("-", self:Name())

	local digits = string.Right(self:Name(), startpos)
	digits = tonumber(digits)

	if digits and isnumber(digits) then
		return digits
	end
end

function meta:IsCPCommand()
	local rank = self:GetTeamRank()
	if not rank then return false end

	if self:Team() == TEAM_CP then
		if rank >= RANK_OFC then
			return true
		end
	elseif self:Team() == TEAM_OTA then
		if rank >= RANK_OCP then
			return true
		end
	elseif self:Team() == TEAM_CA then
		if rank >= RANK_COUNCILOR then
			return true
		end
	end

	return false
end

function meta:IsCommander()
	local rank = self:GetTeamRank()
	if not rank then return false end

	if self:Team() == TEAM_CP then
		if rank >= RANK_CMD then
			return true
		end
	elseif self:Team() == TEAM_OTA then
		if rank >= RANK_OSC then
			return true
		end
	elseif self:Team() == TEAM_CA then
		if rank >= RANK_CA then
			return true
		end
	end

	return false
end

function meta:IsHighCommand()
	local rank = self:GetTeamRank()
	if not rank then return false end

	if self:Team() == TEAM_CP then
		if rank >= RANK_DVL then
			return true
		end
	elseif self:Team() == TEAM_OTA then
		if rank >= RANK_ORD then
			return true
		end
	elseif self:Team() == TEAM_CA then
		if rank >= RANK_CA then
			return true
		end
	end

	return false
end

function meta:CanUseTerminalConvicts()
	if not self:Team() == TEAM_CP then
		return false
	end

	if self:IsCPCommand() then
		return true
	end

	local class = self:GetTeamClass()

	if self:GetTeamRank() >= RANK_I2 then
		return true
	end

	return false
end

function impulse.CanNexusRaid()
	local cps = #team.GetPlayers(TEAM_CP)
	local otas = #team.GetPlayers(TEAM_OTA)
	local players = player.GetCount()
	local baddies = cps + otas
	local modCount = 0

	for k, ply in ipairs(player.GetHumans()) do
		if ply:IsAdmin() then
			modCount = modCount + 1
		end
	end

	if modCount == 0 then
		impulse.debugPrint("no mods?")
		return false
	end

	if (impulse.BoxRaidBypass or false) then
		return true
	end

	if baddies < 12 then
		return false
	end

	if otas < 3 then
		return false
	end

	if players < 40 then
		return false
	end

	return true
end

local gasMaskTeams = {
	[TEAM_OTA] = true,
	[TEAM_CP] = true
}

function meta:HasGasMask()
	if gasMaskTeams[self:Team()] then
		return true
	end

	if self.GasSafe then
		return true
	end

	if self:GetMoveType() == MOVETYPE_NOCLIP then
		return true
	end

	return false
end

if SERVER then
	function entityMeta:EmitChargedSounds(charges)
		local queueTime = 0
		local duration = 0
		local speechBreak = 0.5

		table.insert(charges, 1, {sound = "npc/overwatch/radiovoice/attentionyouhavebeenchargedwith.wav"})
		table.insert(charges, {sound = "npc/overwatch/radiovoice/youarejudgedguilty.wav"})

		for v,k in pairs(charges) do
			duration = SoundDuration(k.sound)

			timer.Simple(queueTime, function()
				if not IsValid(self) then return end

				self:EmitSound(k.sound)
			end)

			queueTime = queueTime + duration + speechBreak
		end

		return queueTime
	end

	function meta:AddRewardRation(amount)
		if not self.RewardRation then
			self:Notify("Your reward ration is now ready to be collected at the ration distribution center.")
			self:SurfacePlaySound("buttons/blip1.wav")
		end

		self.RewardRation = (self.RewardRation or 0) + amount
	end
end

function GetClassAmount(team, class)
    local people = 0
    for k, v in pairs(player.GetAll()) do
        if v:Team() == team and v:GetTeamClass() == class then
            people = people + 1
        end
    end
    return people
end

function GetRankAmount(team, rank)
    local people = 0
    for k, v in ipairs(player.GetAll()) do
        if v:Team() == team and v:GetTeamRank() == rank then
            people = people + 1
        end
    end
    return people
end

function GetRogueAmount()
    local people = 0
    for k, v in pairs(player.GetAll()) do
        if v:IsCP() and v.IsRogue then
            people = people + 1
        end
    end
    return people
end

function meta:GetTotalE2s()
	local e2s = 0
	for k,v in pairs(ents.FindByClass("gmod_wire_expression2")) do
		if v:CPPIGetOwner() == self then
			e2s = e2s + 1
		end
	end
	return e2s
end

function GetTotalE2sOnServer()
	local e2s = 0
	for k,v in pairs(ents.FindByClass("gmod_wire_expression2")) do
		e2s = e2s + 1
	end
	return e2s
end

function meta:Stalkerize()
	self:UnArrest()
	self:SetTeam(TEAM_STALKER)
	timer.Create(self:SteamID() .. "stalkerization", 1800, 1, function()
		self:SetTeam(TEAM_CITIZEN)
		self:Spawn()
	end)
end

function meta:GetLoyalistLevel()
	self.ApplyLevel = self:GetSyncVar(SYNC_LOYALIST_LEVEL, 0)
	return self.ApplyLevel
end

function meta:GetCivicMerits()
	return self:GetSyncVar(SYNC_CIVIC_MERITS, 0)
end

function meta:GetCivicID()
	return self:GetSyncVar(SYNC_CIVIC_ID, 0)
end

function meta.getItemType(class) --Function to check weapon type for inventory clear-out of same type weapons || Use the below arrays to update vendor weapon clear-outs
    primaryWeapons = {"wep_mp7", "wep_shotgun", "wep_mp7a8", "wep_osisg", "wep_m500", "wep_p90", "wep_pm63", "wep_osiprmk1", "wep_ar2", "wep_ar2e", "wep_ar3", "wep_ar2r", "wep_osr", "wep_omr", "wep_osips", "wep_mini14", "wep_apf", "wep_honeybadger", "wep_mp510"}
	secondaryWeapons = {"wep_pistol", "wep_357", "wep_tt", "wep_sw500", "wep_cz75"}
	weaponOptics = {"att_holosight", "att_reddot", "att_cmore", "att_reflex"}
	weaponAttachments = {"att_slugrounds", "att_pistol_silencer", "att_dragonsbreath"}
	armorItems = {"cos_cpvest1", "cos_cpvest2", "cos_cpvest3", "cos_cpvest4"}
	listedItems = {primaryWeapons, secondaryWeapons, weaponOptics, weaponAttachments, armorItems} --2d array for simpler logic below
	for r, row in ipairs(listedItems) do
		for c, val in ipairs(row) do
			if class == val then
				if r == 1 then
					return primaryWeapons
				elseif r == 2 then 
					return secondaryWeapons
				elseif r == 3 then 
					return weaponOptics
				elseif r == 4 then 
					return weaponAttachments
				elseif r == 5 then 
					return armorItems
				end 
			end 
		end 
	end 
end

local entityMeta = FindMetaTable("Entity")

function entityMeta:SetHairColor(colour)
    self.HairColor = colour

    if SERVER then
        if not self:IsPlayer() then return end

        net.Start("ixSetHairColor")
		net.WriteString(self:SteamID64())
		net.WriteColor(colour, true)
        net.Broadcast()
    end
end

function entityMeta:GetHairColor()
    return self.HairColor or color_white
end

function entityMeta:SetPantsColor(colour)
    self.PantsColor = colour

    if ( SERVER ) then
        net.Start("ixSetPantsColor")
            net.WriteEntity(self)
            net.WriteColor(colour, true)
        net.Broadcast()
    end
end

function entityMeta:GetPantsColor()
    return self.PantsColor or color_white
end

function entityMeta:SetTorsoColor(colour)
    self.TorsoColor = colour

    if ( SERVER ) then
        net.Start("ixSetTorsoColor")
            net.WriteEntity(self)
            net.WriteColor(colour, true)
        net.Broadcast()
    end
end

function entityMeta:GetTorsoColor()
    return self.TorsoColor or color_white
end

function entityMeta:SetShirtColor(colour)
    self.ShirtColor = colour

    if ( SERVER ) then
        net.Start("ixSetShirtColor")
            net.WriteEntity(self)
            net.WriteColor(colour, true)
        net.Broadcast()
    end
end

function entityMeta:GetShirtColor()
    return self.ShirtColor or color_white
end

function entityMeta:SetHeadGearColor(colour)
    self.HeadGearColor = colour

    if ( SERVER ) then
        net.Start("ixSetHeadGearColor")
            net.WriteEntity(self)
            net.WriteColor(colour, true)
        net.Broadcast()
    end
end

function entityMeta:GetHeadGearColor()
    return self.HeadGearColor or color_white
end
