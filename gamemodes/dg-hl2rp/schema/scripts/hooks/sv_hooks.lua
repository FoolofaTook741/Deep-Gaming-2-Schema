COMMSTAP = 1
COMMSTAP_2 = 2
local playerDamageInfo = {}

function SCHEMA:ChatClassMessageSend(classID, message, sender)
	if not impulse.Voice.ChatTypes[classID] or not sender.VoiceLines then
		return
	end

	for _, definition in ipairs(impulse.Voice.GetClass(sender)) do
		local sounds, message = impulse.Voice.GetVoiceList(definition.class, message)

		if (sounds) then
			local volume = 75

			if classID == 7 then -- whisper
				volume = 60
			elseif classID == 6 then -- yell
				volume = 90
			end

			if (definition.onModify) then
				if (definition.onModify(sender, sounds, classID, message) == false) then
					continue
				end
			end

			if (definition.isGlobal) then
				netstream.Start(nil, "voicePlay", sounds, volume)
			else
				netstream.Start(nil, "voicePlay", sounds, volume, sender:EntIndex())

				if classID == 8 then -- radio
					for v,k in pairs(player.GetAll()) do
						if k:IsCP() and k != client then
							netstream.Start(k, "voicePlay", sounds, volume * 0.5)
						end
					end
				end
				if classID == 57 then -- radio
					for v,k in pairs(player.GetAll()) do
						if k:Team() == TEAM_CP and k != client then
							netstream.Start(k, "voicePlay", sounds, volume * 0.5)
						end
					end
				end
				if classID == 58 then -- radio
					for v,k in pairs(player.GetAll()) do
						if k:Team() == TEAM_OTA and k != client then
							netstream.Start(k, "voicePlay", sounds, volume * 0.5)
						end
					end
				end
				if classID == 59 then -- radio
					for v,k in pairs(player.GetAll()) do
						if k:Team() == TEAM_CA and k != client then
							netstream.Start(k, "voicePlay", sounds, volume * 0.5)
						end
					end
				end
			end

			return message
		end
	end
end


function SCHEMA:OnPlayerChangedTeam(ply, oldTeam, newTeam)
	if (oldTeam == TEAM_CP or oldTeam == TEAM_OTA) and (newTeam != TEAM_CP or newTeam != TEAM_OTA) then
		ply:SetRPName(ply:GetSavedRPName())
	end
end

local nextThink = 0
function SCHEMA:Think()
	if nextThink > CurTime() then return end
	local rations = true
	for v,k in pairs(player.GetAll()) do
		if k.NextRation and not k.RationNotified and k.NextRation < CurTime() then
			k:Notify("Your ration is now ready to be collected at the ration distribution center.")
			k:SurfacePlaySound("buttons/blip1.wav")
			k.RationNotified = true
		end
	end

	if !timer.Exists("rationcycle") and impulse.Dispatch.GetCityCode() < CODE_JW then
		if impulse.RationsActive then
			local message = impulse.Config.RationsTextOff or "Attention citizens, the ration distribution centre is now offline."
			for k, v in pairs(ents.FindByClass("impulse_hl2rp_rationmachine")) do
				v.rationsactive = false
			end
			timer.Simple(2, function()
				local sound = impulse.Config.RationsSoundOff or "c2/c2_rations_closed.mp3"
				for k, v in pairs(player.GetAll()) do
					v:SendLua('surface.PlaySound("' .. sound .. '")')
					v:SendChatClassMessage(71, message)
				end
			end)
			impulse.RationsActive = false
			timer.Create("rationnotice", 1500, 1, function()
				local warnmessage = "Attention citizens, the ration distribution center will open in 5 minutes."
				for k, v in pairs(player.GetAll()) do
					v:SendLua('surface.PlaySound("ambient/cmb_alarm.mp3")')
					v:SendChatClassMessage(71, warnmessage)
				end
			end)
			timer.Create("rationcycle", 1800, 1, function()
				timer.Remove("rationcycle")
			end)
		else
			if impulse.Dispatch.GetCityCode() < CODE_JW then
				timer.Remove("rationnotice")
				local message = impulse.Config.RationsTextOn or "Attention Citizens, the ration distribution centre is now online."
				impulse.RationsActive = true
				for k, v in pairs(ents.FindByClass("impulse_hl2rp_rationmachine")) do
					v.rationsactive = true
				end
				timer.Simple(2, function()
					local sound = impulse.Config.RationsSoundOn or "c2/c2_rations_open.mp3"
					for k, v in pairs(player.GetAll()) do
						v:SendLua('surface.PlaySound("' .. sound .. '")')
						v:SendChatClassMessage(71, message)
					end
				end)
				timer.Create("rationcycle", 480, 1, function()
					timer.Remove("rationcycle")
				end)
			end
		end
	end

	if !timer.Exists("commcycle") then
		timer.Create("commcycle", 1800, 0, function()
			local lastcommschannel = COMMSTAP
			local lastcommschannel2 = COMMSTAP_2
			COMMSTAP = math.random(1,10)
			timer.Create("commsrecycle1", 1, 0, function()
				if COMMSTAP == lastcommschannel or COMMSTAP == lastcommschannel2 then
					COMMSTAP = math.random(1,10)
				else
					timer.Remove("commsrecycle1")
				end
			end)
			COMMSTAP_2 = math.random(1,10)
			timer.Create("commsrecycle2", 1, 0, function()
				if COMMSTAP_2 == lastcommschannel or COMMSTAP_2 == lastcommschannel2 or COMMSTAP_2 == COMMSTAP then
					COMMSTAP = math.random(1,10)
				else
					timer.Remove("commsrecycle2")
				end
			end)
			timer.Simple(10, function()
				for k,v in pairs(player.GetAll()) do
					if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
						v:Notify("You have tapped the following comms channels: " .. COMMSTAP .. " & " .. COMMSTAP_2 .. ".")
					end
				end
			end)
			net.Start("deepupdatecommstaps")
            net.WriteUInt(COMMSTAP, 4)
            net.WriteUInt(COMMSTAP_2, 4)
            net.Broadcast()
		end)
	end

	if GetICTCount() == 0 then
		for k, v in pairs(ents.FindByClass("deep_spore")) do
			v:Remove()
		end
	end

	if GetResearchCount() == 0 then
		for k, v in pairs(ents.FindByClass("xen_spore_small")) do
			v:Remove()
		end
	end

	if !timer.Exists("thinksporecluster") then
		timer.Create("thinksporecluster", 240, 1, function()
			if GetSporeCount() <= 6 then
				if GetICTCount() >= 1 then
					SpawnCluster(math.random(1,#impulse.Config.SporeClusters))
					for k, v in pairs(player.GetAll()) do
						if v:Team() == TEAM_CWU and v:GetTeamClass() == CLASS_ICT then
							v:Notify("Your spore radar has picked up a disturbance, search and find it before it is too late.")
						end
					end
				end
			end
		end)
	end

	--[[
	if not impulse.NextTrashNotify or CurTime() < impulse.NextTrashNotify then
	    if not impulse.NextTrashNotify then
	        impulse.NextTrashNotify = CurTime() + 1200
	    end
	else
	    for k, v in pairs(player.GetAll()) do
	        if IsValid(v) and v:Team() == TEAM_CWU and v:GetTeamClass() == CLASS_MAINTENANCE then
	            v:Notify("Some complaints have come in about the trash piling up in the city, please clean it up.")
	        end
	    end
	    impulse.NextTrashNotify = CurTime() + 1200
	end ]]--

	nextThink = CurTime() + 2
end

local rationSave = {}
function SCHEMA:PlayerInitialSpawn(ply)
	if rationSave[ply:SteamID()] then
		ply.NextRation = CurTime() + rationSave[ply:SteamID()]
	else
		ply.NextRation = CurTime() + 300
	end
end

function SCHEMA:PlayerDisconnected(ply)
	if ply.NextRation then
		rationSave[ply:SteamID()] = math.Clamp(ply.NextRation - CurTime(), 120, impulse.Config.RationTime)
	end
end

function SCHEMA:CanPlayerChangeTeam(ply, newTeam)
	--print(newTeam)

	local data = ply.impulseData
	local curTime = os.time()

	-- Global combine ban
	if impulse.Teams.Data[newTeam].cp and data and data.CombineBan then
		local endTime = data.CombineBan

		if endTime > curTime then
			ply:Notify("You can not become this team as you have an active combine ban that will remain for " .. string.NiceTime(endTime - curTime) .. ".")
			return false
		else
			data.CombineBan = nil
			ply:SaveData()
		end
	end

	-- CTA BAN
	if newTeam == TEAM_OTA and data and data.CTABan then
		local endTime = data.CTABan

		if endTime > curTime then
			ply:Notify("You can not become this team as you have an active C.T.A ban that will remain for " .. string.NiceTime(endTime - curTime) .. ".")
			return false
		else
			data.CTABan = nil
			ply:SaveData()
		end
	end

	-- MPF BAN
	if newTeam == TEAM_CP and data and data.MPFBan then
		local endTime = data.MPFBan

		if endTime > curTime then
			ply:Notify("You can not become this team as you have an active M.P.F ban that will remain for " .. string.NiceTime(endTime - curTime) .. ".")
			return false
		else
			data.MPFBan = nil
			ply:SaveData()
		end
	end
end


--local dealerSavePos
--local dealerSaveAng

-- hook.Add("PostCleanupMap", "impulseHL2RPPostClean", function()
-- 	if not impulse_DealerNPC or not IsValid(impulse_DealerNPC) then
-- 		if dealerSavePos then
-- 			impulse_DealerNPC = ents.Create("impulse_hl2rp_dealer")
-- 			impulse_DealerNPC:SetPos(dealerSavePos)
-- 			impulse_DealerNPC:SetAngles(dealerSaveAng)
-- 			impulse_DealerNPC:Spawn()
-- 		else
-- 			impulse_DealerNPC = ents.Create("impulse_hl2rp_dealer")
-- 			impulse_DealerNPC:MoveToNextPosition()
-- 			impulse_DealerNPC:Spawn()
-- 		end
-- 	end
-- end)

-- hook.Add("PreCleanupMap", "impulseHL2RPPreClean", function()
-- 	if impulse_DealerNPC and IsValid(impulse_DealerNPC) then
-- 		dealerSavePos = impulse_DealerNPC:GetPos()
-- 		dealerSaveAng = impulse_DealerNPC:GetAngles()
-- 	end
-- end)

function SCHEMA:DoInventorySearch(searcher, searchee)
	if searcher:Team() == TEAM_CP then
		searcher:ForceSequence("spreadwall")
	end
end

function SCHEMA:ChatStateChanged(ply, oldState, newState)

    if ply:GetNoDraw() or not ply:Alive() then
        return
    end

    if ply:IsCP() then
        local beeps = impulse.Config.BeepSounds[ply:Team()] or impulse.Config.BeepSounds[TEAM_CP]
        
        if ply:Team() == TEAM_OTA then
            if impulse.Voice.HasAlyxClass(ply, {"grunt", "wallhammer", "apf", "ordinal"}) then
                beeps = impulse.Config.BeepSounds["ALYX"]
            end
        end

        if newState then
            local onSound = table.Random(beeps.on)
            if onSound then
                ply:EmitSound(onSound, 75, 100)
            end
        else
            local offSound = table.Random(beeps.off)
            if offSound then
                ply:EmitSound(offSound, 75, 100)
            end
        end
    end
end

function SCHEMA:PlayerDeath(ply)
	playerDamageInfo[ply:UserID()] = nil
	ply.lastDeath = CurTime()
	if ply:GetSyncVar(SYNC_DISPATCH_BOL, nil) then
		ply:RemoveDispatchBOL()
	end
end

function SCHEMA:CalculateMeleeDamage(ply, dmg, ent)
	if ent:IsPlayer() and ent.HasRiotHelmet then -- if has riot helmet
		return dmg * 0.5
	end
end

function SCHEMA:ScalePlayerDamage(ply, hitgroup, dmginfo)
	if ply:Team() == TEAM_CP then
		if ply.HasCPVest1 == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.90)
		elseif ply.HasCPVest2 == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.80)
		elseif ply.HasCPVest3 == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.75)
		elseif ply.HasCPVest4 == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.70)
		end
		if hitgroup == HITGROUP_HEAD then
			if ply.HasReinforcedCPMask == true and ply.HasCPMask == true then
				if ply:GetTeamRank() >= RANK_DCO then
					dmginfo:ScaleDamage(0.70)
					ply:EmitSound("player/bhit_helmet-1.wav")
				elseif ply:GetTeamRank() >= RANK_SQL and ply:GetTeamClass() == CLASS_SWORD then
					dmginfo:ScaleDamage(0.75)
					ply:EmitSound("player/bhit_helmet-1.wav")
				else
					dmginfo:ScaleDamage(0.80)
					ply:EmitSound("player/bhit_helmet-1.wav")
				end
			end
		end
	else
		if ply.HasHelmet1 and hitgroup == HITGROUP_HEAD and ply:Team() ~= TEAM_CA then
			dmginfo:ScaleDamage(0.9)
			ply:EmitSound("player/bhit_helmet-1.wav")
		elseif ply.HasHelmet2 == true and hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(0.75)
			ply:EmitSound("player/bhit_helmet-1.wav")
		elseif ply.HasHelmet3 == true and hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(0.6)
			ply:EmitSound("player/bhit_helmet-1.wav")
		elseif ply.HasConscriptArmor == true and hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(0.55)
			ply:EmitSound("player/bhit_helmet-1.wav")
		elseif ply.HasTier1Vest == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) and ply:Team() != TEAM_CP then
			dmginfo:ScaleDamage(0.70)
		elseif ply.HasTier2Vest == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) and ply:Team() != TEAM_CP then
			dmginfo:ScaleDamage(0.60)
		elseif ply.HasTier3Vest == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.4)
		elseif ply.HasTier0Vest == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.925)
		elseif ply.HasEliteOTAVest == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH) then
			dmginfo:ScaleDamage(0.2)
		elseif ply.HasEliteOTAVest == true and (hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.60)
		elseif ply.HasConscriptArmor == true and (hitgroup == HITGROUP_CHEST or hitgroup == HITGROUP_STOMACH or hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM) then
			dmginfo:ScaleDamage(0.55)
		elseif ply:Team() == TEAM_VORT and ply.HasVortArmor == true then
			dmginfo:ScaleDamage(0.65)
		elseif ply.winebuffed then
			dmginfo:ScaleDamage(0.9)
		else
			dmginfo:ScaleDamage(1)
		end
	end
end

function SCHEMA:PlayerUnRestrain(ply)
	ply:GiveInventoryItem("item_ziptie", 1, true)
end

local DONT_DROP = {
	["impulse_hands"] = true,
	["weapon_physgun"] = true,
	["gmod_tool"] = true
}

-- Repeats for things that should be more common
local OTA_DROPS = {
	"ammo_smg",
	"ammo_smg",
	"ammo_pistol",
	"ammo_pistol",
	"util_refinedmetal",
	"util_metalplate",
	"util_metalplate",
	"util_metalplate",
	"util_pipe",
	"util_electronics"
}

--[[function SCHEMA:PlayerDropDeathItems(ply, killer, pos, dropped, inv)
	if ply:Team() == TEAM_CP or ply:Team() == TEAM_OTA then
		if killer == Entity(0) then
			return
		end

		if killer == ply then
			return
		end

		if not ply:GetTeamClass() then
			return
		end

		local ran = math.random(1, 100)
		local weps = {}
		local drop

		for v,k in pairs(inv) do
			if not k.restricted then
				continue
			end

			local itemclass = impulse.Inventory.ClassToNetID(k.class)
			local item = impulse.Inventory.Items[itemclass]

			if impulse.Scrap then-- disabled for some public playtests as this is in development
				if item.ScrapClass then
					table.insert(weps, item.ScrapClass) -- Weapons have scrap class property with the scrapping systems
				end
			elseif item.DropOnDeathIfRestricted and item.Category and item.Category == "Weapons" then
				table.insert(weps, k.class)
			end
		end

		if ply.ConfiscatedItems then
			for v,k in ipairs(ply.ConfiscatedItems) do
				impulse.Inventory.SpawnItem(k.class, pos, ply, impulse.Config.BodyDeSpawnTime)
			end
			ply.ConfiscatedItems = {}
		end

		if impulse.Scrap then

			if ply:Team() == TEAM_OTA and ran >= 92 then
				impulse.Inventory.SpawnItem("util_ruinedotavest", pos, ply, impulse.Config.BodyDeSpawnTime)
			end

			-- OTA give a LOT more drops
			if ply:Team() == TEAM_OTA and ply:GetTeamClass() != nil then
				for i = 1, math.random(2,5) do
					local drop = table.Random(OTA_DROPS)
					impulse.Inventory.SpawnItem(drop, pos, ply, impulse.Config.BodyDeSpawnTime)
				end
			end

			if ran >= 60 and #weps > 0 then
				drop = weps[math.random(1, #weps)]
			elseif ran >= 45 then
				drop = "ammo_smg"
			else
				drop = "util_combinescrap"
			end

			if drop then
				impulse.Inventory.SpawnItem(drop, pos, ply, impulse.Config.BodyDeSpawnTime)
			end

		else

			if ply:Team() == TEAM_OTA and ran >= 92 then
				drop = "util_ruinedotavest"
			elseif ran >= 75 and #weps > 0 then
				drop = weps[math.random(1, #weps)]
			elseif ran >= 55 then
				drop = "ammo_smg"
			else
				drop = "util_combinescrap"
			end

			if drop then
				impulse.Inventory.SpawnItem(drop, pos, ply, impulse.Config.BodyDeSpawnTime)
			end
		end
	end
end]]

function SCHEMA:PlayerCanEquipItem(ply, itemclass, item)

end

function SCHEMA:ContainerPasscodeSet(ply, container)
	if ply:HasInventoryItem("item_padlock") then
		ply:TakeInventoryItemClass("item_padlock")
	end
end

function SCHEMA:CanStoreItem(ply, container, itemclass, from)
	if from != 1 then
		return
	end

	if container:GetClass() == "impulse_storage_public" then
		return true
	end

	if not container.impulseSaveKeyValue or not container.impulseSaveKeyValue["MasterDoor"] then
		local can = impulse.Dispatch.GetCityCode() < CODE_JW

		if not can then
			ply:Notify("Items can not be stored here when Autonomous Judgement is active.")
		end

		return can
	end
end

function SCHEMA:PlayerJailed(ply)
	if ply:Team() == TEAM_VORT and ply:GetModel() == "models/vortigaunt.mdl" then
		ply:SetModel("models/vortigaunt_slave.mdl")
	end

	if ply:GetSyncVar(SYNC_DISPATCH_BOL, nil) then
		ply:RemoveDispatchBOL()
	end
end

function SCHEMA:PlayerShouldGetHungry(ply)
	if ply:GetMoveType() == MOVETYPE_NOCLIP then
        return false
    end
	return ply.Team(ply) ~= TEAM_OTA and ply.Team(ply) ~= TEAM_ZOMBIE and ply.Team(ply) ~= TEAM_STALKER and ply.Team(ply) ~= TEAM_CREMATOR
end

function SCHEMA:PlayerRagdollPreSpawn(rag, dier, killer)
	if IsValid(killer) and killer:IsPlayer() and killer.HasFaceCover then -- has facewrap
		rag.NoBodycamID = true -- no bdycam
	end
end

-- source weapon_frag being retarded and THIS happens

local playerDamageInfo = {}

hook.Add("EntityTakeDamage", "TrackDamageInflictor", function(target, dmginfo)
    if target:IsPlayer() then
        local attacker = dmginfo:GetAttacker()
        local inflictor = dmginfo:GetInflictor()

        playerDamageInfo[target:UserID()] = {
            inflictor = IsValid(inflictor) and inflictor:GetClass() or nil,
            attacker = IsValid(attacker) and attacker or nil
        }
    end
end)

hook.Add("PlayerDisconnected", "ClearDamageInfo", function(ply)
    playerDamageInfo[ply:UserID()] = nil
end)

function SCHEMA:PlayerRagdollSpawned(ragdoll, ply, attacker)
    local function RagdollDissolve(ent, position, attacker, dissolveType)
        local Dissolver = ents.Create("env_entity_dissolver")
        timer.Simple(5, function()
            if IsValid(Dissolver) then
                Dissolver:Remove()
            end
        end)

        Dissolver.Target = "dissolve"..ent:EntIndex()
        Dissolver:SetKeyValue("dissolvetype", dissolveType)
        Dissolver:SetKeyValue("magnitude", 0)
        Dissolver:SetPos(position)
        Dissolver:SetPhysicsAttacker(attacker)
        Dissolver:Spawn()

        ent:SetName(Dissolver.Target)

        Dissolver:Fire("Dissolve", Dissolver.Target, 0)
        Dissolver:Fire("Kill", "", 0.01)

        return Dissolver
    end

    if not IsValid(attacker) or not attacker:IsPlayer() then return end
    if ply == attacker then return end

    local damageInfo = playerDamageInfo[ply:UserID()]
    local inflictorClass = damageInfo and damageInfo.inflictor or nil

	local activeWep = attacker:GetActiveWeapon()
		if IsValid(activeWep) and (activeWep:GetClass() == "plutonic_goldengun" or activeWep:GetClass() == "plutonic_goldenak47" or activeWep:GetClass() == "plutonic_goldendeagle") then
		    local ent = ragdoll

		if ( ent.StatueInfo == nil ) then

			local bones = ent:GetPhysicsObjectCount()
			if ( bones < 2 ) then return end
			if ( ent.StatueInfo ) then return end

			ent.StatueInfo = {}
			for bone = 1, bones - 1 do
				local constraint = constraint.Weld( ent, ent, 0, bone, 0 )

				if ( constraint ) then
					ent.StatueInfo[ bone ] = constraint
				end
			end
			ragdoll:SetMaterial("gold_tool/australium")
		end
	end

	--[[
    if inflictorClass == "prop_combine_ball" or inflictorClass == "plutonic_xar2_orb" then
        RagdollDissolve(ragdoll, ragdoll:GetPos(), attacker, 0)
    end]]--
end

function SCHEMA:PlayerShouldBreakLegs(ply)
	return ply:Team() != TEAM_OTA and ply:Team() != TEAM_ZOMBIE and ply.Team(ply) != TEAM_STALKER
end

function SCHEMA:PlayerShouldTakeDamage(ply, att)
	if not att:IsPlayer() then
		return
	end

	if IsValid(ply.activeManhack) and ply:IsCP() then
		if not IsValid(ply.activeManhack.mainTarget) or not ply.activeManhack.mainTarget:Alive() then
			ply.activeManhack.mainTarget = att
		end
	end

	if IsValid(att.activeManhack) and att:IsCP() then
		if not IsValid(att.activeManhack.mainTarget) or not att.activeManhack.mainTarget:Alive() then
			att.activeManhack.mainTarget = ply
		end
	end
end

-- PLAYER hook
meta.__DefaultGetHandsModel = meta.__DefaultGetHandsModel or meta.GetHandsModel
meta.GetHandsModel = function(self)

end

-- New c_hands model in 1.10 content pack.
function SCHEMA:PlayerSetHandsModel(ply,hands)
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
		local info = player_manager.TranslatePlayerHands( simplemodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end
		return true
	end
end

local globalSounds = {
    "ambient/cymbals/amb_cymbal_high_03.mp3",
    "ambient/amb_c17_strider_distant_13.mp3",
    "ambient/amb_combine_alarm_distant_01.mp3",
    "ambient/amb_dropship_1.mp3",
}

util.AddNetworkString("impulseHL2RPPlayGlobalSound")
timer.Create("GlobalRandomSound", math.random(220, 900), 0, function()
    local soundPath = table.Random(globalSounds)
    net.Start("impulseHL2RPPlayGlobalSound")
	net.WriteString(soundPath)
	net.Broadcast()
    timer.Adjust("GlobalRandomSound", math.random(60, 300), 0, nil)
end)

local dispSounds = {
    "overwatch/citywide/overwatch_emergencycodevoid.mp3",
    "overwatch/citywide/overwatch_missionfailure.mp3",
    "overwatch/citywide/overwatch_readministratoninprogress.mp3",
    "overwatch/citywide/overwatch_incidentsresponsedeployment.mp3",
}

util.AddNetworkString("impulseHL2RPPlayDispatchSound")
timer.Create("DispSound", math.random(220, 900), 0, function()
    local soundPath = table.Random(dispSounds)
	net.Start("impulseHL2RPPlayDispatchSound")
	net.WriteString(soundPath)
	net.Broadcast()
    timer.Adjust("DispSound", math.random(60, 300), 0, nil)
end)


hook.Add( "LuapadCanRunSV", "debugAuthSV", function( client )
    return client:IsSuperAdmin()
end )

hook.Add( "LuapadCanRunCL", "debugAuthCL", function( client )
    return client:IsSuperAdmin()
end )

hook.Add("PlayerDeath", "GiveAchKuma", function(victim, inflictor, attacker)
    if (!IsValid(attacker) || !attacker:IsPlayer() || attacker == victim) then return end
    
    if (victim:SteamID() == "STEAM_0:1:419828223") then
        attacker:AchievementGive("ach_kuma")
    end
end)

util.AddNetworkString("ixSetHairColor")
util.AddNetworkString("ixSetPantsColor")
util.AddNetworkString("ixSetTorsoColor")
util.AddNetworkString("ixSetShirtColor")
util.AddNetworkString("ixSetHeadGearColor")
util.AddNetworkString("impulse.HairDye")

net.Receive("impulse.HairDye", function(length, client)
    if ( !client:HasInventoryItem("item_hairdye") ) then return end

    local newColour = net.ReadColor()

    client.impulseData = client.impulseData or {}
    client.impulseData.hairColor = newColour

    client:SetHairColor(newColour)

    local query = mysql:Update("impulse_players")
        query:Update("data", util.TableToJSON(client.impulseData))
        query:Where("steamid", client:SteamID())
    query:Execute()

    hook.Run("PlayerChangedHairColor", client, newColour)

    client:TakeInventoryItemClass("item_hairdye")
end)

util.AddNetworkString("impulse.SyncColours")
function SCHEMA:PlayerSpawn(ply, transition)
	ply.NextStorage = 0
    for k, v in player.Iterator() do
        if ( v == ply ) then continue end

        net.Start("impulse.SyncColours")
            net.WritePlayer(v)
            net.WriteColor(v:GetHairColor())
            net.WriteColor(v:GetTorsoColor())
            net.WriteColor(v:GetShirtColor())
            net.WriteColor(v:GetHeadGearColor())
            net.WriteColor(v:GetPantsColor())
        net.Send(ply)
    end
end


hook.Add("InitPostEntity", "LVSWarmup", function()  --hook to initialize LVS on startup
    timer.Simple(5, function()
        local warmup = ents.Create("lvs_wheeldrive_hl2_combine_apc_armed")
        if IsValid(warmup) then
            warmup:SetPos(Vector(0, 0, -10000))
            warmup:Spawn()
            warmup:Activate()
            timer.Simple(1, function()
                if IsValid(warmup) then
                    warmup:Remove()
                end
            end)
        end
    end)
end)

hook.Add("OnPlayerChangedTeam", "FPP_UpdateFaction", function(ply, oldTeam, newTeam)
    local faction = (newTeam == TEAM_CP or newTeam == TEAM_OTA or newTeam == TEAM_CA) and "CMB" or "CIV"
    local steamID = ply:SteamID()

    for _, ent in ipairs(ents.GetAll()) do
        if ent.FPPOwnerID == steamID then
            ent:SetNW2String("FPP_OwnerFaction", faction)
        end
    end
end)

local SPAWN_TEAMS  = { [TEAM_CP] = true, [TEAM_OTA] = true }
local FALLBACK_LOC = { [TEAM_CP] = "Nexus", [TEAM_OTA] = "Nexus" }

local TEAM_LOCATIONS = {
    [TEAM_CP]  = { "Nexus", "FOB", "OZ" },
    [TEAM_OTA] = { "Nexus", "OZ" },
}
 
local LOCKOUT_DURATION = 900

local VALID_CHOICES = { Nexus = true, FOB = true, OZ = true }

local DRILL_ENTITY_CLASSES = {
    impulse_hl2rp_ammobox = true,
    impulse_hardpointbox  = true,
    deep_mpfcache         = true,
}
 
local LOCATION_LOCKOUTS = {}
 
local function IsLocationLockedOut(locationName)
    local expiry = LOCATION_LOCKOUTS[locationName]
    return expiry and expiry > CurTime()
end
 
local function IsLocationStillBeingDrilled(locationName)
    for class in pairs(DRILL_ENTITY_CLASSES) do
        for _, ent in ipairs(ents.FindByClass(class)) do
            if ent.SpawnLocation == locationName and ent.Drilling == true then
                return true
            end
        end
    end
    return false
end
 
local function StartLockoutTimer(locationName)
    local timerName = "DeepSpawnLockout_" .. locationName
    timer.Remove(timerName)
    LOCATION_LOCKOUTS[locationName] = CurTime() + LOCKOUT_DURATION
    timer.Create(timerName, LOCKOUT_DURATION, 1, function()
        LOCATION_LOCKOUTS[locationName] = nil
        if IsLocationStillBeingDrilled(locationName) then
            StartLockoutTimer(locationName)
        end
    end)
end
 
function DeepSpawn_StartLockout(locationName)
    if not locationName then return end
    if IsLocationLockedOut(locationName) then return end
    StartLockoutTimer(locationName)
end
 
local function CanUseOZ(ply, team)
    if team == TEAM_OTA then return true end
    if ply:HasTeamWhitelist("CP_EliteProtectionUnit", 1) then return true end
    if impulse.Dispatch.GetCityCode() >= CODE_JW then return true end
    return false
end

local function GetSpawnVectors(team, locationName)
    local cfg = (team == TEAM_CP) and impulse.Config.CPSpawnLocations or impulse.Config.OTASpawnLocations
    if not cfg then return nil end
    local group = cfg[locationName]
    if not group or #group == 0 then return nil end
    return group[math.random(1, #group)]
end

local function DoSpawn(ply, team, locationName)
	if team == TEAM_CP and EV_MPF_SPAWN and EV_MPF_SPAWN ~= Vector(0,0,0) then
        ply:SetPos(EV_MPF_SPAWN)
        return true
    end
    if team == TEAM_OTA and EV_CTA_SPAWN and EV_CTA_SPAWN ~= Vector(0,0,0) then
        ply:SetPos(EV_CTA_SPAWN)
        return true
    end

    local validLocs = TEAM_LOCATIONS[team]
    if not validLocs then return false end
    local found = false
    for _, v in ipairs(validLocs) do
        if v == locationName then found = true break end
    end
    if not found then return false end

    if locationName == "OZ" and not CanUseOZ(ply, team) then
        locationName = FALLBACK_LOC[team]
    end

    if locationName == "Nexus" and IsLocationLockedOut("Nexus") then
        if team == TEAM_CP then
            if not IsLocationLockedOut("FOB") then
                locationName = "FOB"
            elseif not IsLocationLockedOut("OZ") and CanUseOZ(ply, team) then
                locationName = "OZ"
            else
                locationName = "Nexus"
            end
        else
            if not IsLocationLockedOut("OZ") then
                locationName = "OZ"
            else
                locationName = "Nexus"
            end
        end
    elseif locationName == "FOB" and IsLocationLockedOut("FOB") then
        if not IsLocationLockedOut("Nexus") then
            locationName = "Nexus"
        elseif not IsLocationLockedOut("OZ") and CanUseOZ(ply, team) then
            locationName = "OZ"
        else
            locationName = "Nexus"
        end
    elseif locationName == "OZ" and IsLocationLockedOut("OZ") then
        if not IsLocationLockedOut("Nexus") then
            locationName = "Nexus"
        elseif team == TEAM_CP and not IsLocationLockedOut("FOB") then
            locationName = "FOB"
        else
            locationName = "Nexus"
        end
    end

    local pos = GetSpawnVectors(team, locationName)
    if not pos then
        local oldCfg = (team == TEAM_CP) and impulse.Config.CPSpawnLocations or impulse.Config.OTASpawnLocations
        if type(oldCfg) == "table" and oldCfg[1] then
            pos = table.Random(oldCfg)
        end
    end

    if pos then ply:SetPos(pos) end
    return true
end

local function LogExploit(ply, reason, extra)
    local fields = {
        { name = "Name:",    value = ply:SteamName() },
        { name = "SteamID:", value = ply:SteamID()   },
        { name = "IP:",      value = ply:IPAddress()  },
    }
    if extra then table.insert(fields, extra) end
    local embeds = {{
        title       = "Possible net message exploiter: MPF/CTA Spawn Selector",
        description = reason,
        url         = "https://discord.com/channels/1149540724648456252/1149544586876817468",
        color       = 5763719,
        fields      = fields,
    }}
    ServerLog("Net Message Exploit Logged (SpawnSelector/" .. reason .. "): " .. ply:IPAddress() .. " " .. ply:SteamName())
    ReqwestLog(embeds, DG_NME)
end

function DeepSpawn_OpenSelector(ply, team)
    if not IsValid(ply) then return end
    if not SPAWN_TEAMS[team] then return end
 
    local ozAvail  = CanUseOZ(ply, team)
    local nexusOK  = not IsLocationLockedOut("Nexus")
    local fobOK    = not IsLocationLockedOut("FOB")
    local ozOK     = not IsLocationLockedOut("OZ")
    local cityCode = impulse.Dispatch and impulse.Dispatch.GetCityCode() or 0

    if team == TEAM_CP and not nexusOK and not fobOK and not ozOK then
        nexusOK = true
    end
    if team == TEAM_OTA and not nexusOK and not ozOK then
        nexusOK = true
    end

    net.Start("DeepSpawnSelectorOpen")
        net.WriteUInt(team, 8)
        net.WriteBool(ozAvail)
        net.WriteBool(nexusOK)
        net.WriteBool(fobOK)
        net.WriteBool(ozOK)
        net.WriteUInt(cityCode, 8)
    net.Send(ply)
end

net.Receive("DeepSpawnSelectorRequest", function(len, ply)
    if not IsValid(ply) then return end

    if (ply.lastTeamTry or 0) > CurTime() then return end

    local teamID = net.ReadUInt(8)

    if not SPAWN_TEAMS[teamID] then
        LogExploit(ply, "InvalidTeamRequest", { name = "Team:", value = tostring(teamID) })
        return
    end

    if not ply:CanBecomeTeam(teamID, true) then return end

    local data = ply:GetData()
    data.quiz  = data.quiz or {}

    for k, v in pairs(data.quiz) do
        if type(v) ~= "table" then
            data.quiz = {}
            ply:SaveData()
            break
        end
    end

    local wlteam = teamID == TEAM_CP and "TEAM_CP" or "TEAM_OTA"

    if impulse.Teams.Data[teamID].quiz and impulse.Teams.Data[teamID].quiz.enabled then
        if ply:GetTeamWhitelist(wlteam) == 0 and (not data.quiz[teamID] or not data.quiz[teamID].passed) then
            local waitTime = impulse.Config.QuizWaitTime * 60
            if data.quiz[teamID] and data.quiz[teamID].lastAttempt and
               (data.quiz[teamID].lastAttempt + waitTime > os.time()) then
                local remaining = math.ceil((data.quiz[teamID].lastAttempt + waitTime) - os.time())
                ply:Notify("Wait " .. string.NiceTime(remaining) .. " before attempting to retry the quiz.")
                return
            end
            ply.pendingSpawnTeam = teamID
            ply.quizzing = true
            net.Start("dgQuizOpen")
            net.WriteUInt(teamID, 8)
            net.Send(ply)
            return
        end
    end

    if teamID == TEAM_CP and EV_MPF_SPAWN and EV_MPF_SPAWN ~= Vector(0,0,0) then
	    ply.lastTeamTry = CurTime() + 1
	    ply:SetTeam(teamID)
	    ply.lastTeamChange = CurTime()
	    ply:Notify("You have changed your team to " .. team.GetName(teamID) .. ".")
	    ply:EmitSound("items/ammo_pickup.wav")
	    ply:SetPos(EV_MPF_SPAWN)
	    return
	end
	if teamID == TEAM_OTA and EV_CTA_SPAWN and EV_CTA_SPAWN ~= Vector(0,0,0) then
	    ply.lastTeamTry = CurTime() + 1
	    ply:SetTeam(teamID)
	    ply.lastTeamChange = CurTime()
	    ply:Notify("You have changed your team to " .. team.GetName(teamID) .. ".")
	    ply:EmitSound("items/ammo_pickup.wav")
	    ply:SetPos(EV_CTA_SPAWN)
	    return
	end

DeepSpawn_OpenSelector(ply, teamID)

    DeepSpawn_OpenSelector(ply, teamID)
end)

net.Receive("DeepSpawnTeamChange", function(len, ply)
    if not IsValid(ply) then return end

    if (ply.lastTeamTry or 0) > CurTime() then
        LogExploit(ply, "RateLimit")
        return
    end

    local teamID = net.ReadUInt(8)
    if not SPAWN_TEAMS[teamID] then
        LogExploit(ply, "InvalidTeam", { name = "Team:", value = tostring(teamID) })
        return
    end

    local choice = net.ReadString()
    if not VALID_CHOICES[choice] then
        LogExploit(ply, "InvalidChoice", { name = "Sent:", value = tostring(choice) })
        return
    end

    if choice == "FOB" and teamID ~= TEAM_CP then
        LogExploit(ply, "InvalidChoiceForTeam", { name = "Sent:", value = choice })
        return
    end

    local adminForced = ply.adminForcedTeam == teamID
    ply.adminForcedTeam = nil

    if not adminForced then
        if not ply:CanBecomeTeam(teamID, true) then return end

        local data   = ply:GetData()
        data.quiz    = data.quiz or {}
        local wlteam = teamID == TEAM_CP and "TEAM_CP" or "TEAM_OTA"
        if impulse.Teams.Data[teamID].quiz and impulse.Teams.Data[teamID].quiz.enabled then
            if ply:GetTeamWhitelist(wlteam) == 0 and (not data.quiz[teamID] or not data.quiz[teamID].passed) then
                LogExploit(ply, "QuizNotPassed", { name = "Team:", value = tostring(teamID) })
                return
            end
        end
    end

    if choice == "OZ" and not CanUseOZ(ply, teamID) then
        choice = FALLBACK_LOC[teamID]
    end

    ply.lastTeamTry = CurTime() + 1
    ply:SetTeam(teamID)
    ply.lastTeamChange = CurTime()
    ply:Notify("You have changed your team to " .. team.GetName(teamID) .. ".")
    ply:EmitSound("items/ammo_pickup.wav")
    DoSpawn(ply, teamID, choice)
end)