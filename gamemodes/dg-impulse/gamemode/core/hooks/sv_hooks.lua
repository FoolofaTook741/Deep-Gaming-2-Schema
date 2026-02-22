local isValid = IsValid
local mathAbs = math.abs

hook.Add("PlayerConnect", "DBG_PConnect", print, "[impulse] PlayerConnect")
hook.Add("PlayerAuthed", "DBG_PAuthed", print, "[impulse] PlayerAuthed")
hook.Add("PlayerInitialSpawn","DBG_PIS", print, "[impulse] PlayerInitialSpawn")

function GM:PlayerInitialSpawn(ply)
	print("[impulse] Initial Spawn Hook for: " .. ply:Nick() .. " (" .. ply:SteamID() .. ")")
	local isNew = true

	ply:SetCanZoom(false)
	
	-- sync players with all other clients/ents
	impulse.Sync.Data[ply:EntIndex()] = {}
	for v,k in pairs(impulse.Sync.Data) do
		local ent = Entity(v)
		if IsValid(ent) then
			ent:Sync(ply)
		end
	end
	print("[impulse] Starting database lookup for: " .. ply:Nick() .. " (" .. ply:SteamID() .. ")")
	local query = mysql:Select("impulse_players")
	query:Select("id")
	query:Select("rpname")
	query:Select("group")
	query:Select("rpgroup")
	query:Select("rpgrouprank")
	query:Select("xp")
	query:Select("money")
	query:Select("bankmoney")
	query:Select("model")
	query:Select("skin")
	query:Select("data")
	query:Select("skills")
	query:Select("ammo")
	query:Select("firstjoin")
	query:Select("languages")
	query:Select("sterilizedcredits")
	query:Where("steamid", ply:SteamID())
	query:Callback(function(result, ok, err)
		if not ok then
			print("[impulse] SQL failed for "..ply:Nick()..": "..tostring(err))
			timer.Simple( 5, function() 
				ply:Kick("Database error, please reconnect.")
			end)
			return
		end
		if IsValid(ply) and type(result) == "table" and #result > 0 then -- if player exists in db
			print("[impulse] Found data for: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") - Dumping data:")
			isNew = false
			impulse.SetupPlayer(ply, result[1])
		elseif IsValid(ply) then
			print("[impulse] Player not found freezing player.")
			ply:Freeze(true)
		end

		if IsValid(ply) then
			net.Start("impulseJoinData")
			net.WriteBool(isNew)
			net.Send(ply)

			net.Start("impulseGetButtons")
			net.WriteUInt(table.Count(impulse.ActiveButtons), 16)

			for v,k in pairs(impulse.ActiveButtons) do
				net.WriteUInt(v, 16)
				net.WriteUInt(k, 16)
			end

			net.Send(ply)
		end
	end)
	query:Execute()

	timer.Create(ply:UserID().."impulseXP", impulse.Config.XPTime, 0, function()
		if not ply:IsAFK() then
			ply:GiveTimedXP()
		end
	end)

	timer.Create(ply:UserID().."impulseOOCLimit", 1800, 0, function()
		if IsValid(ply) then
			if ply:IsDonator() then
				ply.OOCLimit = impulse.Config.OOCLimitVIP
			else
				ply.OOCLimit = impulse.Config.OOCLimit
			end

			net.Start("impulseUpdateOOCLimit")
			net.WriteUInt(1800, 16)
			net.WriteBool(true)
			net.Send(ply)
		end
	end)

	timer.Create(ply:UserID().."impulseFullLoad", 0.5, 0, function()
		if IsValid(ply) and ply:GetModel() != "player/default.mdl" then
			hook.Run("PlayerInitialSpawnLoaded", ply)
			timer.Remove(ply:UserID().."impulseFullLoad")
		end
	end)

	ply.AFKTimer = CurTime() + 720 -- initial afk time :)
end

function GM:PlayerInitialSpawnLoaded(ply) -- called once player is full loaded
	local jailTime = impulse.Arrest.DCRemember[ply:SteamID()]

	if ply.ammoToGive then
		for v,k in pairs(ply.ammoToGive) do
			if game.GetAmmoID(v) != -1 then
				ply:GiveAmmo(k, v)
			end
		end

		ply.ammoToGive = nil
	end

	if jailTime then
		ply:Arrest()
		ply:Jail(jailTime)
		impulse.Arrest.DCRemember[ply:SteamID()] = nil
	end

	local s64 = ply:SteamID64()

	if GExtension and GExtension.Warnings[s64] then
		local bans = GExtension:GetBans(s64)
		local warns = GExtension.Warnings[s64]

		net.Start("opsGetRecord")
		net.WriteUInt(table.Count(warns), 8)
		net.WriteUInt(table.Count(bans), 8)
		net.Send(ply)
	end

	ply:SetHairColor(Color(ply.impulseData.hairColor.r, ply.impulseData.hairColor.g, ply.impulseData.hairColor.b, ply.impulseData.hairColor.a or 255))
end

function GM:PlayerSpawn(ply)
	local cellID = ply.InJail

	if ply.InJail then
		local pos = impulse.Config.PrisonCells[cellID]
		ply:SetPos(impulse.FindEmptyPos(pos, {self}, 150, 30, Vector(16, 16, 64)))
		ply:SetEyeAngles(impulse.Config.PrisonAngle)
		ply:Arrest()

		return
	end

	local killSilent = ply.IsKillSilent

	if killSilent then
		ply.IsKillSilent = false

		for v,k in pairs(ply.TempWeapons) do
			local wep = ply:Give(k.wep)
			wep:SetClip1(k.clip)
		end

		for v,k in pairs(ply.TempAmmo) do
			ply:SetAmmo(k, v)
		end

		if ply.TempSelected then
			ply:SelectWeapon(ply.TempSelected)
			ply:SetWeaponRaised(ply.TempSelectedRaised)
		end

		return
	end
	
	if ply:GetSyncVar(SYNC_ARRESTED, false) == true then
		ply:SetSyncVar(SYNC_ARRESTED, false, true)
	end

	if ply:HasBrokenLegs() then
		ply:FixLegs()
	end

	if ply.beenSetup then
		ply:SetTeam(impulse.Config.DefaultTeam)
		--ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
		if ply.HasDied then
			ply:SetHunger(50) -- gives them 50 hunger if they died
		else
			ply:SetHunger(70) -- otherwise its 70 if theyve just spawned
		end
	end

	ply.ArrestedWeapons = nil

	ply.SpawnProtection = true
	ply:SetJumpPower(160)

	timer.Simple(10, function()
		if IsValid(ply) then
			ply.SpawnProtection = false
		end
	end)

	hook.Run("PlayerLoadout", ply)
end

function GM:PlayerDisconnected(ply)
	local userID = ply:UserID()
	local steamID = ply:SteamID()
	local entIndex = ply:EntIndex()
	local arrested = ply:GetSyncVar(SYNC_ARRESTED, false)

	ply:SyncRemove()

	local dragger = ply.ArrestedDragger
	if IsValid(dragger) then
		impulse.Arrest.Dragged[ply] = nil
		dragger.ArrestedDragging = nil
	end

	timer.Remove(userID.."impulseXP")
	timer.Remove(userID.."impulseOOCLimit")
	if timer.Exists(userID.."impulseFullLoad") then
		timer.Remove(userID.."impulseFullLoad")
	end

	local jailCell = ply.InJail

	if jailCell then
		timer.Remove(userID.."impulsePrison")
		local duration = impulse.Arrest.Prison[jailCell][entIndex].duration
		impulse.Arrest.Prison[jailCell][entIndex] = nil
		impulse.Arrest.DCRemember[steamID] = duration
	elseif ply.BeingJailed then
		impulse.Arrest.DCRemember[steamID] = ply.BeingJailed
	elseif arrested then
		impulse.Arrest.DCRemember[steamID] = impulse.Config.MaxJailTime
	end

	if ply.CanHear then
		for v,k in ipairs(player.GetAll()) do
			if not k.CanHear then continue end

			k.CanHear[ply] = nil
		end
	end

	if ply.impulseID then
		impulse.Inventory.Data[ply.impulseID] = nil

		if not ply:IsCP() then
			local query = mysql:Update("impulse_players")
			query:Update("ammo", util.TableToJSON(ply:GetAmmo()))
			query:Where("steamid", steamID)
			query:Execute()
		end
	end

	if ply.OwnedDoors then
		for door,k in pairs(ply.OwnedDoors) do
			if IsValid(door) then
				if door:GetDoorMaster() == ply then
					local noUnlock = door.NoDCUnlock or false
					ply:RemoveDoorMaster(door, noUnlock)
				else
					ply:RemoveDoorUser(door)
				end
			end
		end
	end

	if ply.InvSearching and IsValid(ply.InvSearching) then
		ply.InvSearching:Freeze(false)
	end

	for v,k in pairs(ents.FindByClass("impulse_item")) do
		if k.ItemOwner and k.ItemOwner == ply then
			k.RemoveIn = CurTime() + impulse.Config.InventoryItemDeSpawnTime
		end
	end

	impulse.Refunds.RemoveAll(steamID)
end

function GM:PlayerLoadout(ply)
	ply:SetRunSpeed(impulse.Config.JogSpeed)
	ply:SetWalkSpeed(impulse.Config.WalkSpeed)

	return true
end

function impulse.SetupPlayer(ply, dbData)
	local totalCount = player.GetCount()
	local donorCount = 0

	for v,k in pairs(player.GetAll()) do
		if k:IsDonator() then
			donorCount = donorCount + 1
		end
	end

	local userCount = totalCount - donorCount

	if (not ply:IsDonator() and userCount >= (impulse.Config.UserSlots or 9999)) then
		ply:Kick("The server is currently at full user capacity. Donate at https://pinnacle-gaming.xyz/shop to access additional donator slots.")
		return
	end

	ply:SetSyncVar(SYNC_RPNAME, dbData.rpname, true)
	ply:SetSyncVar(SYNC_XP, dbData.xp, true)
	local lang = dbData.languages or 0
	local sc = dbData.sterilizedcredits or 0
	ply.language = lang
	ply.SC = sc
	net.Start("DeepSynchronizeSCCount")  -- sync vars suck
    net.WriteUInt(ply.SC, 20)
    net.Send(ply)
	ply:SetSyncVar(SYNC_LANGUAGE, lang, true)

	ply:SetLocalSyncVar(SYNC_MONEY, dbData.money)
	ply:SetLocalSyncVar(SYNC_BANKMONEY, dbData.bankmoney)

	local data = util.JSONToTable(dbData.data)

	ply.impulseData = data
	ply.impulseID = dbData.id

	if ply.impulseData and ply.impulseData.Achievements then
		local count = table.Count(ply.impulseData.Achievements)

		if count > 0 then
			net.Start("impulseAchievementSync")
			net.WriteUInt(count, 8)

			for v,k in pairs(ply.impulseData.Achievements) do
				net.WriteString(v)
				net.WriteUInt(k, 32)
			end

			net.Send(ply)
		end

		ply:CalculateAchievementPoints()
	end

	local skills = util.JSONToTable(dbData.skills) or {}

	ply.impulseSkills = skills

	for v,k in pairs(ply.impulseSkills) do
		local xp = ply:GetSkillXP(v)
		ply:NetworkSkill(v, xp)
	end

	local query = mysql:Update("impulse_players")
	query:Update("ammo", "{}")
	query:Where("steamid", ply:SteamID())
	query:Execute()

	if ammo then
		local ammo = util.JSONToTable(dbData.ammo) or {}
		local give = {}

		for v,k in pairs(ammo) do
			local ammoName = game.GetAmmoName(v)

			if impulse.Config.SaveableAmmo[ammoName] then
				give[ammoName] = k
			end
		end
	end

	ply.ammoToGive = give or {}

	if not GExtension and not VyHub and (dbData.group and dbData.group != "user") then
		ply:SetUserGroup(dbData.group)
	end

	ply.impulseFirstJoin = dbData.firstjoin

	ply.defaultModel = dbData.model
	ply.defaultSkin = dbData.skin
	ply.defaultRPName = dbData.rpname
	ply:UpdateDefaultModelSkin()
	
	ply:SetFOV(90, 0)
	ply:SetTeam(impulse.Config.DefaultTeam)
	--ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
	ply:AllowFlashlight(true)

	ply:SetBodygroup(ply:FindBodygroupByName("beard"), ply.impulseData.beard)
	ply:SetBodygroup(ply:FindBodygroupByName("hair"), ply.impulseData.hair)

	local id = ply.impulseID
	impulse.Inventory.Data[id] = {}
	impulse.Inventory.Data[id][1] = {} -- inv
	impulse.Inventory.Data[id][2] = {} -- storage

	ply.InventoryWeight = 0
	ply.InventoryWeightStorage = 0
	ply.InventoryRegister = {}
	ply.InventoryStorageRegister = {}
	ply.InventoryEquipGroups = {}

	hook.Run("PreEarlyInventorySetup", ply)

	local query = mysql:Select("impulse_inventory")
	query:Select("id")
	query:Select("uniqueid")
	query:Select("ownerid")
	query:Select("storagetype")
	query:Where("ownerid", dbData.id)
	query:Callback(function(result)
		if IsValid(ply) and type(result) == "table" and #result > 0 then
			local userid = ply.impulseID
			local userInv = impulse.Inventory.Data[userid]

			for v,k in pairs(result) do
				local netid = impulse.Inventory.ClassToNetID(k.uniqueid)
				if not netid then continue end -- when items are removed from a live server we will remove them manually in the db, if an item is broken auto doing this would break peoples items

				local storetype = k.storagetype

				if not userInv[storetype] then
					userInv[storetype] = {}
				end
				
				ply:GiveInventoryItem(k.uniqueid, k.storagetype, false, true)
			end
		end

		if IsValid(ply) then
			ply.beenInvSetup = true
			hook.Run("PostInventorySetup", ply)
		end
	end)

	query:Execute()

	ply:SetupWhitelists()

	local rankCol = impulse.Config.RankColours[ply:GetUserGroup()]

	if rankCol then
		ply:SetWeaponColor(Vector(rankCol.r / 255, rankCol.g / 255, rankCol.b / 255))
	end

	local query = mysql:Select("impulse_refunds")
	query:Select("item")
	query:Where("steamid", ply:SteamID())
	query:Callback(function(result)
		if IsValid(ply) and type(result) == "table" and #result > 0 then
			local sid = ply:SteamID()
			local money = 0
			local names = {}

			for v,k in pairs(result) do
				if string.sub(k.item, 1, 4) == "buy_" then
					local class = string.sub(k.item, 5)
					local buyable = impulse.Business.Data[class]

					impulse.Refunds.Remove(sid, k.item)

					if not buyable then
						continue
					end

					names[class] = (names[class] or 0) + 1
					money = money + (buyable.price or 0) + (buyable.refundAdd or 0)
				end
			end

			if money == 0 then
				return
			end

			ply:GiveBankMoney(money)
			
			net.Start("impulseGetRefund")
			net.WriteUInt(table.Count(names), 8)
			net.WriteUInt(money, 16)

			for v,k in pairs(names) do
				net.WriteString(v)
				net.WriteUInt(k, 8)
			end

			net.Send(ply)
		end
	end)

	query:Execute()

	if dbData.rpgroup then
		ply:GroupLoad(dbData.rpgroup, dbData.rpgrouprank or nil)
	end

	ply.beenSetup = true
	hook.Run("PostSetupPlayer", ply)
end

function GM:PostSetupPlayer(ply)
	ply.impulseData.Achievements = ply.impulseData.Achievements or {}
	for v,k in pairs(impulse.Config.Achievements) do
		ply:AchievementCheck(v)
	end
	ply:SetLocalSyncVar(SYNC_HUNGER, 70)
	--ply:GiveQuest(QUEST_PRIME_DIRECTIVE)
end

function GM:ShowHelp()
	return
end

local talkCol = Color(255, 255, 100)
local infoCol = Color(135, 206, 250)
local strTrim = string.Trim
function GM:PlayerSay(ply, text, teamChat, newChat)
	if not ply.beenSetup then return "" end
	if teamChat == true then return "" end

	text = strTrim(text, " ")
	hook.Run("iPostPlayerSay", ply, text)

	if string.StartWith(text, "/") then
		local space = string.find(text, " ", 1, true)
		local cmdRaw, rest

		if space then
			cmdRaw = string.sub(text, 1, space - 1)
			rest   = string.sub(text, space + 1)
		else
			cmdRaw = text
			rest   = ""
		end

		local command = impulse.chatCommands[string.lower(cmdRaw)]
		if command then
			if command.cooldown and command.lastRan then
				if command.lastRan + command.cooldown > CurTime() then
					return ""
				end
			end

			if command.adminOnly == true and ply:IsAdmin() == false then
				ply:Notify("You must be an admin to use this command.")
				return ""
			end

			if command.leadAdminOnly == true and not ply:IsLeadAdmin() then
				ply:Notify("You must be a lead admin to use this command.")
				return ""
			end

			if command.superAdminOnly == true and ply:IsSuperAdmin() == false then
				ply:Notify("You must be a super admin to use this command.")
				return ""
			end

			if command.gameMasterOnly == true and ply:IsGameMaster() == false then
				ply:Notify("You must be a GM or admin to use this command.")
				return ""
			end

			if command.requiresArg and (rest == "" or string.Trim(rest) == "") then return "" end
			if command.requiresAlive and not ply:Alive() then return "" end

			local args = (rest ~= "" and string.Explode(" ", rest) or {})
			command.onRun(ply, args, rest)
		else
			ply:Notify("The command " .. cmdRaw .. " does not exist.")
		end

	elseif ply:Alive() then
		text = hook.Run("ProcessICChatMessage", ply, text) or text
		text = hook.Run("ChatClassMessageSend", 1, text, ply) or text

		for v,k in pairs(player.GetAll()) do
			if (ply:GetPos() - k:GetPos()):LengthSqr() <= (impulse.Config.TalkDistance ^ 2) then
				k:SendChatClassMessage(1, text, ply)
			end
		end

		if ply:IsNearAudioBug() then
			for k,v in pairs(player.GetAll()) do
				if v:Team() == TEAM_CP and v:GetTeamClass() == CLASS_GHOST then
					if ply:IsNearSignalJammer() == false then
						v:SendChatClassMessage(74, text, ply)
					else
						v:SendChatClassMessage(74, " *SIGNAL JAMMED*", ply)
					end
				end
			end
		end

		hook.Run("PostChatClassMessageSend", 1, text, ply)
	end

	return ""
end

local function canHearCheck(listener) -- based on darkrps voice chat optomization this is called every 0.5 seconds in the think hook
	if not IsValid(listener) then return end

	listener.CanHear = listener.CanHear or {}
	local listPos = listener:GetShootPos()
	local voiceDistance = impulse.Config.VoiceDistance ^ 2

	for _,speaker in ipairs(player.GetAll()) do
		listener.CanHear[speaker] = (listPos:DistToSqr(speaker:GetShootPos()) < voiceDistance)
		hook.Run("PlayerCanHearCheck", listener, speaker)
	end
end

local VOICE_CACHE_TTL = 0.25
local voiceDistSqr = (impulse.Config.VoiceDistance or 600)
voiceDistSqr = voiceDistSqr * voiceDistSqr

function GM:PlayerCanHearPlayersVoice(listener, speaker)
    if not IsValid(listener) or not IsValid(speaker) then return false, false end
    if listener == speaker then return true, false end

    if not speaker:Alive() then return false, false end

    local now = CurTime()

    listener._voiceCache = listener._voiceCache or {}
    local cache = listener._voiceCache

    local sid = speaker:EntIndex()
    local entry = cache[sid]
    if entry and entry.expires > now then
        return entry.canHear, true
    end

    local distSqr = listener:GetShootPos():DistToSqr(speaker:GetShootPos())
    local canHear = (distSqr <= voiceDistSqr)

    cache[sid] = { canHear = canHear, expires = now + VOICE_CACHE_TTL }
    return canHear, true
end

function GM:UpdatePlayerSync(ply)
	for v,k in pairs(impulse.Sync.Data) do
		local ent = Entity(v)

		if IsValid(ent) then
			for id,conditional in pairs(impulse.Sync.VarsConditional) do
				if ent:GetSyncVar(id) and conditional(ply) then
					ent:SyncSingle(id, ply)
				end
			end
		end
	end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
    local ragCount = #ents.FindByClass("prop_ragdoll")
    if ragCount > 64 then
        print("[impulse] Avoiding ragdoll spawn for performance reasons...")
        return
    end

    local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetModel(ply:GetModel())
    ragdoll:SetPos(ply:GetPos())
    ragdoll:SetSkin(ply:GetSkin())
    ragdoll.DeadPlayer = ply
    ragdoll.Killer = attacker
    ragdoll.DmgInfo = dmginfo
    ragdoll.CanConstrain = false
    ragdoll.NoCarry = true

    for _, bg in pairs(ply:GetBodyGroups()) do
        ragdoll:SetBodygroup(bg.id, ply:GetBodygroup(bg.id))
    end

    local lootpackage = ents.Create("impulse_container")
    lootpackage:SetModel("models/props_junk/cardboard_box004a.mdl")
    lootpackage:SetPos(ply:GetPos())
    lootpackage:SetCapacity(75)
	lootpackage.NoCarry = true
    lootpackage.DeadPlayer = ply
    lootpackage.TeamOnDeath = ply:Team()
    lootpackage.Inventory = {}
    lootpackage.Users = {}
    lootpackage.LootPool = {}

	
    local inventoryOnDeath = ply:GetInventory()
	local inventoryOnDeathDrop = {}
	for _, itemData in pairs(inventoryOnDeath) do
	    if itemData.restricted then continue end
	    local item = impulse.Inventory.Items[impulse.Inventory.ClassToNetID(itemData.class)]
	    if not item then continue end
	    local dropOnDeath = item.DropOnDeath == true
	    -- Skip if CP (non-rogue, non-CA) since PlayerDeath handles their drops separately
	    if dropOnDeath and not (ply:IsCP() and ply:Team() != TEAM_CA and not ply.IsRogue) then
	        table.insert(inventoryOnDeathDrop, itemData.class)
	    end
	end
	lootpackage.inventoryOnDeath = inventoryOnDeathDrop

    lootpackage:SetNWBool("IsDeadPlayerRagdoll", true)
    lootpackage:SetNWEntity("DeadPlayer", ply)
    lootpackage:SetNWString("DeadPlayerName", ply:Nick())

    lootpackage:Spawn()
    ragdoll:Spawn()
	lootpackage:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    local velocity = ply:GetVelocity()
    for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
        local phys = ragdoll:GetPhysicsObjectNum(i)
        if IsValid(phys) then
            phys:SetVelocity(velocity)
            local boneIndex = ragdoll:TranslatePhysBoneToBone(i)
            if boneIndex then
                local pos, ang = ply:GetBonePosition(boneIndex)
                phys:SetPos(pos)
                phys:SetAngles(ang)
            end
        end
    end

    hook.Run("PlayerRagdollSpawned", ragdoll, ply, attacker)
    hook.Run("PlayerRagdollPreSpawn", lootpackage, ply, attacker)

	if IsValid(lootpackage) then
		local hasLoot = false
		if lootpackage.Inventory then
			for _, v in pairs(lootpackage.Inventory) do
				if v > 0 then
					hasLoot = true
					break
				end
			end
		end

		if not hasLoot then
			lootpackage:Remove()
		end
end

	timer.Simple(impulse.Config.BodyDeSpawnTime, function()
		if IsValid(lootpackage) then
			lootpackage:Remove()
		end

		if IsValid(ragdoll) then
			ragdoll:Fire("FadeAndRemove", 7)

			timer.Simple(10, function()
				if IsValid(ragdoll) then
					ragdoll:Remove()
				end
			end)
		end
	end)

    timer.Simple(0.1, function()
        if IsValid(ragdoll) and IsValid(ply) then
            net.Start("impulseRagdollLink")
            net.WriteEntity(ragdoll)
            net.Send(ply)
        end
    end)

    return true
end

function GM:PlayerDeath(ply, killer)
	local wait = impulse.Config.RespawnTime

	if ply:IsDonator() then
		wait = impulse.Config.RespawnTimeDonator
	end

	ply.respawnWait = CurTime() + wait

	local money = ply:GetMoney()

	if money > 0 then
		ply:SetMoney(0)
		impulse.SpawnMoney(ply:GetPos(), money)
	end

	if not ply.beenInvSetup then -- people that havent made char or are not loaded in
		return
	end

	ply:UnEquipInventory()

	local inv = ply:GetInventory()
	local restorePoint = {}
	local pos = ply.LocalToWorld(ply, ply:OBBCenter())
	local dropped = 0

	for v,k in pairs(inv) do
		if ply:IsCP() and ply:Team() != TEAM_CA and !ply.IsRogue then
 			local itemclass = impulse.Inventory.ClassToNetID(k.class)
			local item = impulse.Inventory.Items[itemclass]

			if not k.restricted then
				table.insert(restorePoint, k.class)
			end

			if item.DropOnDeath and not k.restricted then
				local ent = impulse.Inventory.SpawnItem(k.class, pos)
				ent.ItemClip = k.clip

				dropped = dropped + 1

				if dropped > 4 then
					break
				end
			end
		elseif ply:Team() != TEAM_ZOMBIE and ply:Team() != TEAM_STALKER then
			local itemclass = impulse.Inventory.ClassToNetID(k.class)
			local item = impulse.Inventory.Items[itemclass]

			if not k.restricted then
				table.insert(restorePoint, k.class)
			end
		end
	end
	
	if ply:IsCP() then
		hook.Run("PlayerDropDeathItems", ply, killer, pos, dropped, inv)
	end

	ply:ClearInventory(1)
	ply.InventoryRestorePoint = restorePoint
	ply.HasDied = true
end

function GM:PlayerSilentDeath(ply)
	ply.IsKillSilent = true
	ply.TempWeapons = {}

	for v,k in pairs(ply:GetWeapons()) do
		ply.TempWeapons[v] = {wep = k:GetClass(), clip = k:Clip1()}
	end

	ply.TempAmmo = ply:GetAmmo()

	local wep = ply:GetActiveWeapon()

	if wep and IsValid(wep) then
		ply.TempSelected = wep:GetClass()
		ply.TempSelectedRaised = ply:IsWeaponRaised()
	end
end

function GM:PlayerDeathThink(ply)
	if not ply.respawnWait then
		ply:Spawn()
		return true
	end

	if ply.respawnWait < CurTime() then
		ply:Spawn()
	end

	return true
end

function GM:PlayerDeathSound()
	return true
end

function GM:CanPlayerSuicide()
	return false
end

function GM:OnPlayerChangedTeam(ply) -- get rid of it logging team changes to console
	if ply.BuyableTeamRemove then
		for v,k in pairs(ply.BuyableTeamRemove) do
			if k and IsValid(k) and k.BuyableOwner == ply then
				k:Remove()
			end
		end
	end
	if ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CWU then
		ply:SetHairColor(Color(ply.impulseData.hairColor.r, ply.impulseData.hairColor.g, ply.impulseData.hairColor.b, ply.impulseData.hairColor.a or 255))
	end
end

function GM:SetupPlayerVisibility(ply)
	if ply.extraPVS then
		AddOriginToPVS(ply.extraPVS)
	end

	if ply.extraPVS2 then
		AddOriginToPVS(ply.extraPVS2)
	end
end

function GM:KeyPress(ply, key)
	if ply:IsAFK() then
		ply:UnMakeAFK()	
	end

	ply.AFKTimer = CurTime() + impulse.Config.AFKTime

	if key == IN_RELOAD then
		timer.Create("impulseRaiseWait"..ply:SteamID(), 0.45, 1, function() -- half a second to raise weapon
			if IsValid(ply) then
				ply:ToggleWeaponRaised()
			end
		end)
	elseif key == IN_USE and not ply:InVehicle() then
		local trace = {}
		trace.start = ply:GetShootPos()
		trace.endpos = trace.start + ply:GetAimVector() * 96
		trace.filter = ply

		local entity = util.TraceLine(trace).Entity

		if IsValid(entity) and entity:IsPlayer() then
			if ply:CanArrest(entity) then
				if not entity.ArrestedDragger then
					ply:DragPlayer(entity)
				else
					entity:StopDrag()
				end
			end
		end
	end
end

function GM:PlayerUse(ply, entity)
    --impulse.debugPrint("PlayerUse called")
    --impulse.debugPrint("Player: %s (%s)", ply:Nick(), ply:SteamID())
    --impulse.debugPrint("Entity: %s, Class: %s", entity, entity:GetClass())
    
    if (ply.useNext or 0) > CurTime() then 
        --impulse.debugPrint("Use cooldown active. Time remaining: %.2f seconds", (ply.useNext or 0) - CurTime())
        return false 
    end
    
    ply.useNext = CurTime() + 0.3
    --impulse.debugPrint("Setting useNext to: %.2f", ply.useNext)
    
    local btnKey = entity.ButtonCheck
    --impulse.debugPrint("ButtonCheck value: %s", tostring(btnKey))
    
    if btnKey and impulse.Config.Buttons[btnKey] then
        --impulse.debugPrint("Button key found in config: %s", btnKey)
        local btnData = impulse.Config.Buttons[btnKey]
        
        --impulse.debugPrint("Button data - DoorGroup: %s", tostring(btnData.doorgroup))
        
        if btnData.customCheck and not btnData.customCheck(ply, entity) then
            --impulse.debugPrint("customCheck failed for button: %s", btnKey)
            ply.useNext = CurTime() + 1
            --impulse.debugPrint("Setting extended cooldown (1 second)")
            return false
        else
            --impulse.debugPrint("customCheck passed or not defined")
        end
        
        if btnData.doorgroup then
            --impulse.debugPrint("Button requires door group: %s", btnData.doorgroup)
            local teamDoorGroups = ply.DoorGroups
            
            if teamDoorGroups then
                --impulse.debugPrint("Player has %d door groups", #teamDoorGroups)
                --impulse.debugPrint("Player door groups: %s", table.concat(teamDoorGroups, ", "))
            else
                --impulse.debugPrint("Player has no door groups (nil)")
            end
            
            if not teamDoorGroups or not table.HasValue(teamDoorGroups, btnData.doorgroup) then
                --impulse.debugPrint("Access DENIED - Player lacks required door group")
                ply.useNext = CurTime() + 1
                --impulse.debugPrint("Setting extended cooldown (1 second)")
                ply:Notify("You don't have access to use this button.")
                return false
            else
                --impulse.debugPrint("Access GRANTED - Player has required door group")
            end
        else
            --impulse.debugPrint("No door group requirement for this button")
        end
    else
        --impulse.debugPrint("No button config found or no ButtonCheck")
    end
    
    --impulse.debugPrint("Use allowed - returning true (default)")
    return true
end

function GM:KeyRelease(ply, key)
	if key == IN_RELOAD then
		timer.Remove("impulseRaiseWait"..ply:SteamID())
	end
end

impulse.ActiveButtons = {}

local function LoadButtons()
    --impulse.debugPrint("LoadButtons", "LoadButtons called")
    
    -- First, clear all ButtonCheck properties
    --impulse.debugPrint("LoadButtons", "Clearing existing ButtonCheck properties from all func_button entities")
    local buttonCount = 0
    for a,button in pairs(ents.FindByClass("func_button")) do
        if button.ButtonCheck then
            --impulse.debugPrint("LoadButtons", "Clearing ButtonCheck from button #%d at %s", button:EntIndex(), tostring(button:GetPos()))
            button.ButtonCheck = nil
            buttonCount = buttonCount + 1
        end
    end
    --impulse.debugPrint("LoadButtons", "Cleared ButtonCheck from %d buttons", buttonCount)
    
    -- Check if impulse.Config.Buttons exists
    if not impulse.Config.Buttons then
        --impulse.debugPrint("LoadButtons", "impulse.Config.Buttons is nil or empty, skipping button assignment")
        return
    end
    
    --impulse.debugPrint("LoadButtons", "impulse.Config.Buttons contains %d button configurations", table.Count(impulse.Config.Buttons))
    
    -- Print all button configs for debugging
    --impulse.debugPrint("LoadButtons", "Available button configurations:")
    for v,k in pairs(impulse.Config.Buttons) do
        --impulse.debugPrint("LoadButtons", "Button ID: %s, Position: %s, DoorGroup: %s", tostring(v), tostring(k.pos), tostring(k.doorgroup))
    end
    
    -- Assign button configurations to physical buttons
    --impulse.debugPrint("LoadButtons", "Searching for func_button entities to assign configurations...")
    local assignedCount = 0
    local totalButtons = 0
    
    for a,button in pairs(ents.FindByClass("func_button")) do
        totalButtons = totalButtons + 1
        
        -- Skip if already assigned
        if button.ButtonCheck then
            --impulse.debugPrint("LoadButtons", "Button #%d already has ButtonCheck: %s", button:EntIndex(), button.ButtonCheck)
            continue
        end
        
        local buttonPos = button:GetPos()
        local assigned = false
        
        -- Try to match this button with a configuration
        for v,k in pairs(impulse.Config.Buttons) do
            if k.pos and k.pos:DistToSqr(buttonPos) < (9 ^ 2) then -- 81 unit squared radius
                button.ButtonCheck = v
                impulse.ActiveButtons[button:EntIndex()] = v
                assigned = true
                assignedCount = assignedCount + 1
                
                --impulse.debugPrint("✓ Matched button #%d at %s with config '%s' at %s (distance: %.2f units)", 
                --    button:EntIndex(), tostring(buttonPos), v, tostring(k.pos), math.sqrt(k.pos:DistToSqr(buttonPos)))
                
                -- Run init function if defined
                if k.init then
                    --impulse.debugPrint("LoadButtons", "Running init function for button '%s'", v)
                    k.init(button)
                end
                
                break -- Found a match, stop searching
            end
        end
        
        if not assigned then
            --impulse.debugPrint("LoadButtons", "✗ Button #%d at %s has no matching configuration", button:EntIndex(), tostring(buttonPos))
        end
    end
    
    --impulse.debugPrint("LoadButtons", "Button assignment complete:")
    --impulse.debugPrint("LoadButtons", "Total func_button entities: %d", totalButtons)
    --impulse.debugPrint("LoadButtons", "Successfully assigned: %d", assignedCount)
    --impulse.debugPrint("LoadButtons", "impulse.ActiveButtons count: %d", table.Count(impulse.ActiveButtons))
    
    -- Debug: Print all active buttons
    --impulse.debugPrint("LoadButtons", "Active buttons mapping:")
    for buttonID, configID in pairs(impulse.ActiveButtons) do
        local button = ents.GetByIndex(buttonID)
        if IsValid(button) then
            --impulse.debugPrint("LoadButtons", "Button #%d -> Config '%s' at %s", buttonID, configID, tostring(button:GetPos()))
        else
            --impulse.debugPrint("LoadButtons", "Button #%d (INVALID) -> Config '%s'", buttonID, configID)
        end
    end
end

function GM:InitPostEntity()
    --impulse.debugPrint("GM:InitPostEntity", "GM:InitPostEntity called")
    
    impulse.Doors.Load()
    --impulse.debugPrint("GM:InitPostEntity", "Doors loaded")
    
    -- Clean up old entities
    --impulse.debugPrint("GM:InitPostEntity", "Cleaning up old impulse entities...")
    local removedCount = 0
    for v,k in pairs(ents.GetAll()) do
        if k.impulseSaveEnt or k.IsZoneTrigger then
            k:Remove()
            removedCount = removedCount + 1
        end
    end
    --impulse.debugPrint("GM:InitPostEntity", "Removed %d old impulse entities", removedCount)
    
    -- Run config load script if exists
    if impulse.Config.LoadScript then
        --impulse.debugPrint("GM:InitPostEntity", "Running impulse.Config.LoadScript")
        impulse.Config.LoadScript()
    end
    
    -- Create zone triggers
    if impulse.Config.Zones then
        --impulse.debugPrint("GM:InitPostEntity", "Creating zone triggers...")
        local zoneCount = 0
        for v,k in pairs(impulse.Config.Zones) do
            --impulse.debugPrint("GM:InitPostEntity", "Creating zone: %s", tostring(v))
            local zone = ents.Create("impulse_zone")
            zone:SetBounds(k.pos1, k.pos2)
            zone.Zone = v
            zoneCount = zoneCount + 1
        end
        --impulse.debugPrint("GM:InitPostEntity", "Created %d zone triggers", zoneCount)
    end
    
    -- Remove blacklisted entities
    if impulse.Config.BlacklistEnts then
        --impulse.debugPrint("GM:InitPostEntity", "Removing blacklisted entities...")
        local blacklistCount = 0
        for v,k in pairs(ents.GetAll()) do
            if impulse.Config.BlacklistEnts[k:GetClass()] then
                k:Remove()
                blacklistCount = blacklistCount + 1
            end
        end
        --impulse.debugPrint("GM:InitPostEntity", "Removed %d blacklisted entities", blacklistCount)
    end
    
    LoadSaveEnts()
    --impulse.debugPrint("GM:InitPostEntity", "Save entities loaded")
    
    LoadButtons()
    --impulse.debugPrint("GM:InitPostEntity", "Buttons loaded")
    
    hook.Run("PostInitPostEntity")
    --impulse.debugPrint("GM:InitPostEntity", "GM:InitPostEntity complete")
end

-- Initial call to LoadButtons
--impulse.debugPrint("Initial", "Initial call to LoadButtons")
LoadButtons()

function GM:PostCleanupMap()
	hook.Run("InitPostEntity")
end

function GM:GetFallDamage(ply, speed)
	if ply:Name() == "Fast Zombie" then
        return 0
    end

	ply.LastFall = CurTime()

	local dmg = speed * 0.05

	if speed > 780 then
		dmg = dmg + 75
	end

	local shouldBreakLegs = hook.Run("PlayerShouldBreakLegs", ply, dmg)

	if shouldBreakLegs != nil and shouldBreakLegs == false then
		return dmg
	end

	local strength = ply:GetSkillLevel("strength")
	local vitality = ply:GetSkillLevel("vitality")
	
	local r = math.random(0, 20 + (strength * 1.5) + (vitality * 3))
	
	if r <= 20 and dmg < ply:Health() then
		ply:BreakLegs()
	end
	
	return dmg
end

local lastAFKScan
local curTime = CurTime
function GM:Think()
	local ctime = curTime()
	local allPlayers = player.GetAll()

	for v,k in pairs(allPlayers) do
		if not k.nextHungerUpdate then k.nextHungerUpdate = ctime + impulse.Config.HungerTime end

		if k:Alive() then
			if k.nextHungerUpdate < ctime then
				local shouldTakeHunger = hook.Run("PlayerShouldGetHungry", k)

				if shouldTakeHunger == nil or shouldTakeHunger then
					k:FeedHunger(-1)
				end

				if k:GetSyncVar(SYNC_HUNGER, 100) < 1 then
					if k:Health() >= 5 then
						k:TakeDamage(1, k, k)
					end
					k.nextHungerUpdate = ctime + 1
				else
					k.nextHungerUpdate = ctime + impulse.Config.HungerTime
				end
			end

			if (k.nextHungerHeal or 0) < ctime then
				local hunger = k:GetSyncVar(SYNC_HUNGER, 10)

				if hunger >= 90 and k:Health() < 75 then
					k:SetHealth(math.Clamp(k:Health() + 1, 0, 75))
					k.nextHungerHeal = ctime + impulse.Config.HungerHealTime
				else
					k.nextHungerHeal = ctime + 2
				end
			end
		end
		--[[
		if not k.nextHearUpdate or k.nextHearUpdate < CurTime() then -- optimized version of canhear hook based upon darkrp
			canHearCheck(k)
			k.nextHearUpdate = ctime + 0.65
		end
		--]]
	end

	for v,k in pairs(impulse.Arrest.Dragged) do
		if not IsValid(v) then
			impulse.Arrest.Dragged[v] = nil
			continue
		end

		local dragger = v.ArrestedDragger

		if IsValid(dragger) then
			if (dragger:GetPos() - v:GetPos()):LengthSqr() >= (175 ^ 2) then
				v:StopDrag()
			end
		else
			v:StopDrag()
		end
	end

	if (lastAFKScan or 0) < ctime then
		lastAFKScan = ctime + 2

		for v,k in pairs(allPlayers) do
			if k.AFKTimer and k.AFKTimer < ctime and not impulse.Arrest.Dragged[k] and not k:IsAFK() then
				k:MakeAFK()
			end

			k.LastKnownPos = k.GetPos(k)

			if k.BrokenLegs and k.BrokenLegsTime < ctime and k:Alive() then
				k:FixLegs()
				k:Notify("Your broken legs have healed naturally.")
			end
		end
	end
end

function GM:DatabaseConnectionFailed(errorText)
	SetGlobalString("impulse_fatalerror", "Failed to connect to database. See server console for error.")
	print("[impulse] [SERIOUS FAULT] DB connection failure... Attempting reconnection...")

	timer.Simple(0.66, function()
		mysql:Connect(impulse.DB.ip, impulse.DB.username, impulse.DB.password, impulse.DB.database, impulse.DB.port)
	end)
end

function GM:PlayerCanPickupWeapon(ply)
	if ply:GetSyncVar(SYNC_ARRESTED, false) then
		return false
	end

	return true
end

local exploitRagBlock = {
	["models/dpfilms/metropolice/zombie_police.mdl"] = true,
	["models/dpfilms/metropolice/playermodels/pm_zombie_police.mdl"] = true,
	["models/zombie/zmanims.mdl"] = true
}

function GM:PlayerSpawnRagdoll(ply, model)
	if exploitRagBlock[model] then
		return false
	end

	return ply:IsGameMaster()
end

function GM:PlayerSpawnSENT(ply)
	return ply:IsLeadAdmin()
end

function GM:PlayerSpawnSWEP(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnedSENT( ply, ent )
	local embeds = {{
		title = "SENT Spawned",
		description = "Manager spawned SENT.",
		url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
		color = 5763719,
		fields = {
			{
				name = "Manager:",
				value = ply:SteamName()
			},
			{
				name = "Steam ID:",
				value = ply:SteamID()
			},
			{
				name = "Entity:",
				value = ent:GetClass()
			},
		}
	}}
	ReqwestLog(embeds, DG_SENT)
end

function GM:PlayerGiveSWEP(ply)
	return ply:IsSuperAdmin()
end

function GM:PlayerSpawnEffect(ply)
	return ply:IsGameMaster()
end

function GM:PlayerSpawnNPC(ply)
	return ply:IsGameMaster()
end

function GM:PlayerSpawnProp(ply, model)
	if ply:GetXP() < 100 and ply:IsDonator() == false then
		return false
	end 

	if not ply:Alive() or not ply.beenSetup or ply:GetSyncVar(SYNC_ARRESTED, false) then
		return false
	end

	if ply:IsGameMaster() then
		return true
	end

	if (ply.NextStorage or 0) > CurTime() then
		ply:Notify("You were recently in a combat engagement. Please wait " .. string.NiceTime(ply.NextStorage - CurTime()) .. ".")
		return false
	end

	local limit
	local price

	if ply:IsDonator() or ply:IsGameMaster() then
		limit = impulse.Config.PropLimitDonator
		price = impulse.Config.PropPriceDonator
	else
		limit = impulse.Config.PropLimit
		price = impulse.Config.PropPrice
	end

	if ply:GetPropCount(true) >= limit then
		ply:Notify("You have reached your prop limit.")
		return false
	end

	if ply:CanAfford(price) then
		ply:TakeMoney(price)
		ply:Notify("You have purchased a prop for "..impulse.Config.CurrencyPrefix..price..".")
	else
		ply:Notify("You need "..impulse.Config.CurrencyPrefix..price.." to spawn this prop.")
		return false
	end

	return true
end

function GM:PlayerSpawnedProp(ply, model, ent)
	ply:AddPropCount(ent)
end

function GM:PlayerSpawnVehicle(ply, model)
	return ply:IsLeadAdmin()
end

function GM:PlayerSpawnedVehicle(ply, ent)
	ply.SpawnedVehicles = ply.SpawnedVehicles or {}
	table.insert(ply.SpawnedVehicles, ent)
end

function GM:CanDrive()
	return false
end

local whitelistProp = {
	["remover"] = true,
	["collision"] = true
}

local allowedProperties = {
	gamemaster = {
		skin = true,
		bodygroups = true,
		ignite = true,
		extinguish = true,
		statue = true,
		statue_stop = true
	}
}

function GM:CanProperty(ply, prop)
	if whitelistProp and whitelistProp[prop] then
		return true
	end

	if ply:IsLeadAdmin() then
		return true
	end

	if ply:IsGameMaster() then
		return allowedProperties.gamemaster[prop] == true
	end

	return false
end

local bannedTools = {
	["duplicator"] = true,
	["imagetool"] = true,
	["physprop"] = true,
	["dynamite"] = true,
	["eyeposer"] = true,
	["faceposer"] = true,
	["fingerposer"] = true,
	["inflator"] = true,
	["trails"] = true,
	["paint"] = true,
	["wire_explosive"] = true,
	["wire_simple_explosive"] = true,
	["wire_turret"] = true,
	["wire_user"] = true,
	["wire_pod"] = true,
	["wire_magnet"] = true,
	["wire_teleporter"] = true,
	["wire_trail"] = true,
	["wire_trigger"] = true,
	["wire_detonators"] = true,
	["wire_detonator"] = true,
	["wire_field_device"] = true,
	["wire_hsranger"] = true,
	["wire_hsholoemitter"] = true,
	["wire_eyepod"] = true,
	["wire_spu"] = true,
	["wnpc"] = true
}

local dupeBannedTools = {
	["weld"] = true,
	["weld_ez"] = true,
	["spawner"] = true,
	["duplicator"] = true,
	["adv_duplicator"] = true
}

local e2donatorTools = {
	["wire_expression2"] = true,
	["wire_egp"] = true,
	["wire_soundemitter"] = true,
	["wire_textscreen"] = true,
	["wire_soundemitter"] = true
}

local adminWorldRemoveWhitelist = {
	["impulse_item"] = true,
	["impulse_money"] = true,
	["impulse_letter"] = true,
	["prop_ragdoll"] = true,
	["prop_physics"] = true
}

local gmTools = {
	["lamp"]     = true,
    ["light"]    = true,
	["imagetool"] = true,
	["wire_light"] = true
}

function GM:CanTool(ply, tr, tool)
	if (not ply:IsAdmin() and not ply:IsGameMaster()) and tool == "spawner" then
		return false
	end
	
    if gmTools[tool] then
        return ply:IsGameMaster() or ply:IsAdmin() or ply:IsSuperAdmin()
    end

	if bannedTools[tool] then
		return false
	end

	if e2donatorTools[tool] and not (ply:IsE2()) then
		ply:Notify("This tool is restricted to E2 donators only.")
		return false
	end

	if tool == "wire_expression2" && GetPlayerCount() >= 90 then
		ply:Notify("Expression 2 is not available with 90 players or more due to performance limitations.")
		return false
	end

    local ent = tr.Entity

    if IsValid(ent) then
        if ent.onlyremover then
            if tool == "remover" then
                return ply:IsAdmin() or ply:IsSuperAdmin()
            else
                return false
            end
        end

        if ent.nodupe and dupeBannedTools[tool] then
            return false
        end

       	if tool == "remover" and ply:IsAdmin() and not ply:IsSuperAdmin() then
    		local owner = ent:CPPIGetOwner()

    		if not owner and not adminWorldRemoveWhitelist[ent:GetClass()] then
    			ply:Notify("You can not remove this entity.")
    			return false
    		end
    	end

    	if string.sub(ent:GetClass(), 1, 8) == "impulse_" then
    		if tool != "remover" and not ply:IsSuperAdmin() then
    			return false
    		end
    	end
	end

	return true
end


local bannedDupeEnts = {
	["gmod_wire_explosive"] = true,
	["gmod_wire_simple_explosive"] = true,
	["gmod_wire_turret"] = true,
	["gmod_wire_user"] = true,
	["gmod_wire_realmagnet"] = true,
	["gmod_wire_teleporter"] = true,
	["gmod_wire_thruster"] = true,
	["gmod_wire_trail"] = true,
	["gmod_wire_trigger"] = true,
	["gmod_wire_trigger_entity"] = true,
	["gmod_wire_rtcam"] = true,
	["gmod_wire_detonator"] = true,
	["gmod_wire_hsranger"] = true,
	["gmod_wire_hsholoemitter"] = true,
	["gmod_wire_eyepod"] = true,
	["gmod_wire_spu"] = true
}

local donatorDupeEnts = {
	["gmod_wire_expression2"] = true,
	["prop_vehicle_prisoner_pod"] = true,
	["gmod_wire_soundemitter"] = true,
	["gmod_wire_epg"] = true
}

local whitelistDupeEnts = {
	["gmod_button"] = true,
	["prop_dynamic"] = true,
	["prop_physics"] = true,
	["prop_door_rotating"] = true -- door tool
}

function GM:ADVDupeIsAllowed(ply, class, entclass) -- adv dupe 2 can be easily exploited, this fixes it. you must have the impulse version of AD2 for this to work
	if bannedDupeEnts[class] then
		return false
	end

	if impulse.Dispatch and impulse.Dispatch.GetCityCode() >= CODE_JW then
		ply:Notify("Advanced Duplicator 2 is not available at this time.")
		return false
	end

	if class == "gmod_wire_expression2" && GetPlayerCount() >= 90 then
		ply:Notify("Expression 2 is not available with 90 players or more due to performance limitations.")
		return false
	end

	if donatorDupeEnts[class] then
		if ply:IsDonator() then
			return true
		else
			ply:Notify("This entity is restricted to donators only.")
			return false
		end
	end

	if whitelistDupeEnts[class] or string.sub(class, 1, 9) == "gmod_wire" then
		return true
	end

	return false
end

function GM:ADVDupeScalePatch(ply, modelscale, entclass)
    if modelscale ~= nil and (modelscale >= 1 or modelscale <= 0) then  
        if VyHub then
            local plyTarget = ply:SteamID64()
            VyHub.Ban:create(plyTarget, 0, "IAC Detected #200")
            ply:Kick("You have been banned from this server!")
        end
        ply:Notify("You may not modify the scale of the model using Adv Dupe 2.")
        return false
    end

    return false
end

function GM:SetupMove(ply, mvData)
	if isValid(ply.ArrestedDragging) then
		mvData:SetMaxClientSpeed(impulse.Config.WalkSpeed - 30)
	end
end

function GM:CanPlayerEnterVehicle(ply, veh)
	if ply:GetSyncVar(SYNC_ARRESTED, false) or ply.ArrestedDragging then
		return false
	end

	return true
end

function GM:CanExitVehicle(veh, ply)
	if ply:GetSyncVar(SYNC_ARRESTED, false) then
		return false
	end

	return true
end

function GM:PlayerSetHandsModel(ply, hands)
	local handModel = impulse.Teams.Data[ply:Team()].handModel

	if handModel then
		hands:SetModel(handModel)
		return
	end

	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)

	if info then
		hands:SetModel(info.model)
		hands:SetSkin(info.skin)
		hands:SetBodyGroups(info.body)
	end
end

function GM:PlayerSpray()
	return true
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	local DR = 0
	if ply.DR and ply.DR != 0 then
		DR = ply.DR/100
	end
	-- More damage if we're shot in the head
	if ( hitgroup == HITGROUP_HEAD ) then
		dmginfo:ScaleDamage( 2 - DR )
	end

	if ( hitgroup == HITGROUP_RIGHTLEG or hitgroup == HITGROUP_LEFTLEG ) then
		dmginfo:ScaleDamage( 0.25 - DR )
	end
	
--[[
	-- Less damage if we're shot in the arms or legs
	if ( hitgroup == HITGROUP_LEFTARM ||
		 hitgroup == HITGROUP_RIGHTARM ||
		 hitgroup == HITGROUP_LEFTLEG ||
		 hitgroup == HITGROUP_RIGHTLEG ||
		 hitgroup == HITGROUP_GEAR ) then

		dmginfo:ScaleDamage( 0.25 )

	end

	Pulled from the base gamemode just disabled the 0.25 scaledamage
	]]--
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if ply:Team() == 0 then
		return false
	end
	
	if ply.SpawnProtection and attacker:IsPlayer() then
		return false
	end

	if attacker and IsValid(attacker) and attacker:IsPlayer() and attacker != Entity(0) and attacker != ply then
		if (ply.NextStorage or 0) < CurTime() then
			ply.NextStorage = CurTime() + 300
		end

		attacker.NextStorage = CurTime() + 300
	end

	return true
end

function GM:LongswordCalculateMeleeDamage(ply, damage, ent)
	local skill = ply:GetSkillLevel("strength")
	local multiplier = 1
	if ply.MeleeMult and ply.MeleeMult != 1 then
		multiplier = ply.MeleeMult
	end
	local dmg = damage * (1 + (skill * .05)) * multiplier
	local override = hook.Run("CalculateMeleeDamage", ply, dmg, ent)

	return override or dmg
end

function GM:LongswordMeleeHit(ply)
	if ply.StrengthUp and ply.StrengthUp > 5 then
		ply:AddSkillXP("strength", math.random(1, 6))
		ply.StrengthUp = 0
		return
	end

	ply.StrengthUp = (ply.StrengthUp or 0) + 1
end

function GM:LongswordHitEntity(ply, ent)
	-- if tree then vood ect.
end

if SERVER then
    util.AddNetworkString("OverheadChatBubbleMessage")
end
