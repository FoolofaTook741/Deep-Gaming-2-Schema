util.AddNetworkString("combinecommsnetwork")
util.AddNetworkString("DeepGamingSendDecree")
util.AddNetworkString("DeepTerminalWhitelistChange")
util.AddNetworkString("DeepTerminalBlacklist")
util.AddNetworkString("DeepToggleRogue")
util.AddNetworkString("DeepFundingOperation")
util.AddNetworkString("DeepAdjustFunds")
util.AddNetworkString("DeepSociostabilityScore")
util.AddNetworkString("DeepWorkerTaxRate")
util.AddNetworkString("DeepCivilianTaxRate")
util.AddNetworkString("deepupdatetaxrate")
util.AddNetworkString("deepupdatetaxrate_overlay")
util.AddNetworkString("deepupdatecommstaps")
util.AddNetworkString("deepupdatedecree")
util.AddNetworkString("DeepResetSocioScore")
util.AddNetworkString("DeepTerminalLua")
util.AddNetworkString("DeepRationReward")
util.AddNetworkString("DeepBanIPAddress")
util.AddNetworkString("DGRecentDCs")
util.AddNetworkString("DeepFracturedTimer")
util.AddNetworkString("DeepPutOnBackpack")
util.AddNetworkString("DeepCancelCurrentAction")
util.AddNetworkString("DeepUnloadAmmo")
util.AddNetworkString("DeepUnitMakeup")
util.AddNetworkString("deepPriorityOneSuspect")
util.AddNetworkString("deepPriorityOneBroadcast")
util.AddNetworkString("DeepPlaySound")
util.AddNetworkString("DeepLanguageMessage")
util.AddNetworkString("deepPriorityOneSuspectsv")
util.AddNetworkString("deepupdateawardcredits")
util.AddNetworkString("cuffsDoSearch")
util.AddNetworkString("DeepSetRent")
util.AddNetworkString("deepupdatedoorprice")

print("2")

OCA_CustomDoorPrice = impulse.Config.DoorPrice
TEAM_COOLDOWN_BYPASS = {
    [TEAM_CITIZEN] = false,
    [TEAM_CWU] = false,
    [TEAM_CP] = false,
    [TEAM_OTA] = false,
    [TEAM_CA] = false,
    [TEAM_VORT] = false,
    [TEAM_ZOMBIE] = false,
    [TEAM_STALKER] = false
}

net.Receive("cuffsDoSearch", function(len, ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    if not ply:IsCP() then return end
    if ply.InvSearching and IsValid(ply.InvSearching) then return end

    local targ = net.ReadEntity()
    if not IsValid(targ) or not targ:IsPlayer() then return end

    if not targ:OnGround() then return end
    if not targ.beenInvSetup then return end

    if ply.CanArrest and not ply:CanArrest(targ) then
        ply:Notify("You cannot search this player.")
        return
    end

    if not targ:IsHandcuffed() then
        ply:Notify("You must detain a player before searching them.")
        return
    end

    if ply:GetPos():DistToSqr(targ:GetPos()) > (200 * 200) then
        ply:Notify("No player in search range.")
        return
    end

    targ:Freeze(true)
    targ:Notify("You are currently being searched.")
    ply:Notify("You have started searching " .. targ:Nick() .. ".")
    ply.InvSearching = targ
    hook.Run("DoInventorySearch", ply, targ)

    local inv = targ:GetInventory(1) or {}

    local written = 0
    for invid, slot in pairs(inv) do
        local netid = slot and slot.class and impulse.Inventory.ClassToNetID(slot.class)
        if netid then written = written + 1 end
    end

    net.Start("impulseInvDoSearch")
    net.WriteUInt(targ:EntIndex(), 8)
    net.WriteUInt(written, 16)
    net.WriteUInt(math.Clamp(tonumber(targ:GetMoney()) or 0, 0, 65535), 16)

        for invid, slot in pairs(inv) do
            local netid = slot and slot.class and impulse.Inventory.ClassToNetID(slot.class)
            if netid then
                net.WriteUInt(netid, 10)
                net.WriteUInt(invid, 16)
                net.WriteBool(slot.restricted == true)
            end
        end
    net.Send(ply)
end)


EV_CITIZEN_SPAWN = Vector(0, 0, 0)
EV_CW_SPAWN = Vector(0, 0, 0)
EV_MPF_SPAWN = Vector(0, 0, 0)
EV_CTA_SPAWN = Vector(0, 0, 0)
EV_OCA_SPAWN = Vector(0, 0, 0)
EV_VORT_SPAWN = Vector(0, 0, 0)
EV_ZOMBIE_SPAWN = Vector(0, 0, 0)
EV_STALKER_SPAWN = Vector(0, 0, 0)

PRIORITY_ONE_SUSPECT = nil


net.Receive("deepPriorityOneSuspect", function(len, ply)
    if not ply:IsCPCommand() then
        return
    end
    if timer.Exists("nextPOSCall") then
        ply:Notify("Please wait before declaring another suspect.")
        return
    end
    timer.Create("nextPOSCall", 240, 1, function() end)
    local target = net.ReadEntity()
    local sender = ply
    impulse.Dispatch.Manhunt(target)
    PRIORITY_ONE_SUSPECT = target
    local rf = RecipientFilter()
    for k,v in pairs(player.GetAll()) do
        if v:IsCP() then
            rf:AddPlayer(v)
        end
    end
    local name = target:GetSavedRPName() or ""
    net.Start("deepPriorityOneBroadcast")
    net.WriteString(name)
    net.WriteEntity(ply)
    net.Send(rf)
end)

net.Receive("DeepUnloadAmmo", function(len, ply)
    local weaponclass = net.ReadString()
    for k,v in pairs(ply:GetWeapons()) do
        if v:GetClass() == weaponclass then
            if v:Clip1() > 0 then
                local amount = v:Clip1() 
                local setammo = ply:GetAmmoCount(v:GetPrimaryAmmoType())
                v:SetClip1(0)
                ply:SetAmmo(setammo + amount, v:GetPrimaryAmmoType())
                ply:EmitSound("items/ammo_pickup.wav")
                ply:Notify("You have unloaded " .. amount .. " rounds.")
                break
            end
        end
    end
end)

impulse.RationsServer = true
impulse.CityLockdownServer = false
impulse.SegregationServer = false

OCAAB_CUR_FUNDS = 0
OCAAB_MAX_FUNDS = 30000
OCAAB_INCENDIARY_UPGRADE = false
OCAAB_HEALTHVIALS_UPGRADE = false
OCAAB_CIV_TAXRATE = 0
OCAAB_CW_TAXRATE = 0
DG_CITYLOCKDOWN = false
DG_SEPERATION = false
DG_RATIONS = true

local nextIncumberanceCheck = 0
local nexte2Check = 0
local MASTER_RATE = 0.25

timer.Create("ocaabpassivefunding", 900, 0, function()
    if impulse.Dispatch.GetCityCode() < CODE_JW then
        local fundamount = math.floor(2000 / impulse.Dispatch.GetCityCode())

        if OCAAB_CUR_FUNDS < 0 then
            OCAAB_CUR_FUNDS = 0
        elseif OCAAB_CUR_FUNDS > OCAAB_MAX_FUNDS then
            OCAAB_CUR_FUNDS = OCAAB_MAX_FUNDS
        else
            OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS + fundamount
        end

        net.Start("DeepAdjustFunds")
        net.WriteInt(OCAAB_CUR_FUNDS, 16)
        net.Broadcast()

        for _, v in ipairs(player.GetAll()) do
            if v:Team() == TEAM_CA and v:GetTeamClass() >= CLASS_BASE then
                v:Notify("Funds have been received from Combine Command. " .. fundamount .. " has been added to the stockpile.")
            end
        end
    end
end)

local last = {}

timer.Create("OCAFundsSync", 10, 0, function()
    if OCAAB_CUR_FUNDS < 0 then OCAAB_CUR_FUNDS = 0 end

    local function changed(k, v)
        if last[k] ~= v then
            last[k] = v
            return true
        end
        return false
    end

    if changed("funds", OCAAB_CUR_FUNDS) then
        net.Start("DeepAdjustFunds")
        net.WriteInt(OCAAB_CUR_FUNDS, 16)
        net.Broadcast()
    end

    local civChanged = changed("civtax", OCAAB_CIV_TAXRATE)
    local cwChanged  = changed("cwtax",  OCAAB_CW_TAXRATE)

    if civChanged or cwChanged then
        net.Start("deepupdatetaxrate")
        net.WriteUInt(1, 2)
        net.WriteUInt(OCAAB_CIV_TAXRATE, 6)
        net.Broadcast()

        net.Start("deepupdatetaxrate")
        net.WriteUInt(2, 2)
        net.WriteUInt(OCAAB_CW_TAXRATE, 6)
        net.Broadcast()

        net.Start("deepupdatetaxrate_overlay")
        net.WriteUInt(1, 2)
        net.WriteUInt(OCAAB_CIV_TAXRATE, 6)
        net.Broadcast()

        net.Start("deepupdatetaxrate_overlay")
        net.WriteUInt(2, 2)
        net.WriteUInt(OCAAB_CW_TAXRATE, 6)
        net.Broadcast()
    end

    if changed("doorprice", OCA_CustomDoorPrice) then
        net.Start("deepupdatedoorprice")
        net.WriteUInt(OCA_CustomDoorPrice, 6)
        net.Broadcast()
    end

    if changed("decree_rations", DG_RATIONS) then
        net.Start("deepupdatedecree")
        net.WriteUInt(1, 3)
        net.WriteBool(DG_RATIONS)
        net.Broadcast()
    end

    if changed("decree_lockdown", DG_CITYLOCKDOWN) then
        net.Start("deepupdatedecree")
        net.WriteUInt(2, 3)
        net.WriteBool(DG_CITYLOCKDOWN)
        net.Broadcast()
    end

    if changed("decree_separation", DG_SEPERATION) then
        net.Start("deepupdatedecree")
        net.WriteUInt(3, 3)
        net.WriteBool(DG_SEPERATION)
        net.Broadcast()
    end
end)

timer.Create("ValidOCAFundingTimerCheck", 10, 0, function()
    if impulse.Dispatch.GetCityCode() >= CODE_JW then
        timer.Remove("ocaabpassivefunding")
    end
end)

timer.Create("Deep_IncumberanceCheck", 1.5, 0, function()
    for _, v in ipairs(player.GetAll()) do
        local invw = v.InventoryWeight or 0
        if invw > 25 and v.HasBackpack == false and v:Alive() and v:Team() ~= TEAM_ZOMBIE then
            v:TakeDamage(5)
            v:Notify("You are carrying too much!")
        end

        local sid = v:SteamID()
        if timer.Exists(sid .. "stalkerization") and v:Team() ~= TEAM_STALKER then
            v:SetTeam(TEAM_STALKER)
        end
    end
end)

timer.Create("Deep_UnitMakeup", 10, 0, function()
    local rogues = 0
    for _, v in ipairs(player.GetAll()) do
        if v:IsCP() and v.IsRogue == true then
            rogues = rogues + 1
        end
    end

    net.Start("DeepUnitMakeup")
    net.WriteUInt(GetClassAmount(TEAM_CP, CLASS_UNION), 5)
    net.WriteUInt(GetClassAmount(TEAM_CP, CLASS_HELIX), 5)
    net.WriteUInt(GetClassAmount(TEAM_CP, CLASS_GRID), 5)
    net.WriteUInt(GetClassAmount(TEAM_CP, CLASS_GHOST), 5)
    net.WriteUInt(GetClassAmount(TEAM_CP, CLASS_SWORD), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_ECHO), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_MACE), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_RANGER), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_FIST), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_NOMAD), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_APF), 5)
    net.WriteUInt(GetClassAmount(TEAM_OTA, CLASS_PAYBACK), 5)
    net.WriteUInt(rogues, 5)
    net.Broadcast()

    local rf = RecipientFilter()
    for _, v in ipairs(player.GetAll()) do
        if v:IsCP() then rf:AddPlayer(v) end
    end

    if PRIORITY_ONE_SUSPECT ~= nil then
        net.Start("deepPriorityOneSuspectsv")
        net.WriteEntity(PRIORITY_ONE_SUSPECT)
        net.Send(rf)
    end
end)

timer.Create("RefreshCPBalances", 1800, 0, function()
    for _, v in ipairs(player.GetAll()) do
        if v:Team() == TEAM_CP and v:IsCPCommand() then
            v.AwardBalance = math.Clamp((v.AwardBalance or 0) + 45, 0, 240)
            v:SendCombineMessage("AWARD CREDITS UPDATED. NEW BALANCE: " .. v.AwardBalance .. ". BEGIN DISTRIBUTION TO ENLISTED UNITS.")
            net.Start("deepupdateawardcredits")
            net.WriteUInt(v.AwardBalance, 16)
            net.Send(v)
        end
    end
end)

local function ShieldTimerName(ply)
    return "dg_shield_follow_" .. ply:EntIndex()
end

local function RemoveShield(ply)
    if not IsValid(ply) then return end

    local tname = ShieldTimerName(ply)
    if timer.Exists(tname) then timer.Remove(tname) end

    if IsValid(ply.shield) then
        ply.shield:Remove()
    end

    ply.shield = nil
end

local function ShouldHaveShield(ply)
    if not IsValid(ply) or not ply:Alive() then return false end
    if ply:Team() ~= TEAM_OTA then return false end

    local class = ply.GetTeamClass and ply:GetTeamClass()
    if class ~= CLASS_PAYBACK then return false end

    if ply.ShieldActive ~= true then return false end
    if ply.IsWeaponRaised and not ply:IsWeaponRaised() then return false end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) then return false end
    if wep:GetClass() ~= "plutonic_osish" then return false end

    return true
end

local function EnsureFollowLoop(ply)
    local tname = ShieldTimerName(ply)
    if timer.Exists(tname) then return end

    timer.Create(tname, 0.03, 0, function()
        if not ShouldHaveShield(ply) then
            RemoveShield(ply)
            return
        end

        local wep = ply:GetActiveWeapon()
        if IsValid(wep) then
            ply:DrawWallhammerShield(wep)
        else
            RemoveShield(ply)
        end
    end)
end

timer.Create("Deep_WallhammerShield", MASTER_RATE, 0, function()
    for _, ply in ipairs(team.GetPlayers(TEAM_OTA)) do
        if ShouldHaveShield(ply) then
            EnsureFollowLoop(ply)
        else
            if IsValid(ply.shield) or timer.Exists(ShieldTimerName(ply)) then
                RemoveShield(ply)
            end
        end
    end
end)

hook.Add("PlayerDisconnected", "dg_shield_cleanup_disc", function(ply)
    RemoveShield(ply)
end)

hook.Add("PlayerDeath", "dg_shield_cleanup_death", function(ply)
    RemoveShield(ply)
end)

local function canHearCheck(listener, allPlayers) -- based on darkrps voice chat optomization this is called every 0.5 seconds in the think hook
    if not IsValid(listener) then return end

    listener.CanHear = listener.CanHear or {}
    listener._CanHearPrev = listener._CanHearPrev or {}

    local listPos = listener:GetPos()
    local voiceDistance = impulse.Config.VoiceDistance ^ 2
    local prev = listener._CanHearPrev
    local can = listener.CanHear

    for _, speaker in ipairs(allPlayers) do
        local now = (listPos:DistToSqr(speaker:GetPos()) < voiceDistance)
        can[speaker] = now

        if prev[speaker] ~= now then
            prev[speaker] = now
            hook.Run("PlayerCanHearCheck", listener, speaker)
        end
    end
end
--[[
function GM:PlayerCanHearPlayersVoice(listener, speaker)
	if not speaker:Alive() then return false end

	local canHear = listener.CanHear and listener.CanHear[speaker]
	return canHear, true
end
--]]

timer.Create("impulse_hunger_tick", 0.25, 0, function()
    local ctime = CurTime()
    local allPlayers = player.GetAll()

    for _, ply in ipairs(allPlayers) do
        if not ply.nextHungerUpdate then
            ply.nextHungerUpdate = ctime + impulse.Config.HungerTime
        end

        if ply:Alive() and ply.nextHungerUpdate < ctime then
            local shouldTakeHunger = hook.Run("PlayerShouldGetHungry", ply)
            local sid = ply:SteamID()

            if shouldTakeHunger == nil or shouldTakeHunger then
                if not timer.Exists(sid .. "wellfed") then
                    ply:FeedHunger(-1)
                end
            end
            if ply:SteamID() == "STEAM_0:0:29204032"  or ply:SteamID() == "STEAM_0:1:115345277" then
                ply:SetHunger(100)
            end
            if ply:GetSyncVar(SYNC_HUNGER, 100) < 1 then
                if ply:Health() > 10 then
                    ply:TakeDamage(1, ply, ply)
                end
                ply.nextHungerUpdate = ctime + 1
            else
                ply.nextHungerUpdate = ctime + impulse.Config.HungerTime
            end
        end

        if ply:Alive() and (ply.nextHungerHeal or 0) < ctime then
            local hunger = ply:GetSyncVar(SYNC_HUNGER, 10)

            if hunger >= (82 - ply:GetSkillLevel("vitality")) and ply:Health() < 75 then
                ply:SetHealth(math.Clamp(ply:Health() + 1, 0, 75))
                ply.nextHungerHeal = ctime + impulse.Config.HungerHealTime
            else
                ply.nextHungerHeal = ctime + 2
            end
        end
    end
end)
--[[
timer.Create("impulse_canhear_tick", 0.65, 0, function()
    local allPlayers = player.GetAll()
    for _, listener in ipairs(allPlayers) do
        canHearCheck(listener, allPlayers)
    end
end)
--]]

timer.Create("impulse_drag_tick", 0.2, 0, function()
    for dragged, _ in pairs(impulse.Arrest.Dragged) do
        if not IsValid(dragged) then
            impulse.Arrest.Dragged[dragged] = nil
            continue
        end

        local dragger = dragged.ArrestedDragger
        if not IsValid(dragger) then
            dragged:StopDrag()
            continue
        end

        if (dragger:GetPos() - dragged:GetPos()):LengthSqr() >= (175 * 175) then
            dragged:StopDrag()
        end
    end
end)

timer.Create("impulse_afk_legs_tick", 5, 0, function()
    local ctime = CurTime()
    local allPlayers = player.GetAll()

    for _, ply in ipairs(allPlayers) do
        if ply.AFKTimer and ply.AFKTimer < ctime and not impulse.Arrest.Dragged[ply] and not ply:IsAFK() then
            ply:MakeAFK()
        end

        ply.LastKnownPos = ply:GetPos()

        if ply.BrokenLegs and ply.BrokenLegsTime < ctime and ply:Alive() then
            ply:FixLegs()
            ply:Notify("Your broken legs have healed naturally.")
        end
    end
end)

net.Receive("DeepFundingOperation", function(len,ply)
    if ply:Team() != TEAM_CA or ply:GetTeamRank() < RANK_COUNCILMAN then
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepFundingOperation'.")
            end
        end
        return
    end
    local upgrade = net.ReadString()
    local funds = OCAAB_CUR_FUNDS
    local rationcost = 4000
    local ammocost = 8000
    local armorcost = 12000
    local incendiariescost = 15000
    local healthvialscost = 9000
    local researchfundingamount = 1000
    if upgrade == "Rations" and funds <= rationcost then
        ply:Notify("You cannot afford this upgrade.")
        return
    elseif upgrade == "Armor" and funds <= armorcost then
        ply:Notify("You cannot afford this upgrade.")
        return
    elseif upgrade == "Ammo" and funds <= ammocost then
        ply:Notify("You cannot afford this upgrade.")
        return
    elseif upgrade == "Health" and funds <= healthvialscost then
        ply:Notify("You cannot afford this upgrade.")
        return
    elseif upgrade == "Incendiary" and funds <= incendiariescost then
        ply:Notify("You cannot afford this upgrade.")
        return
    elseif upgrade == "ResearchFunding" and funds <= researchfundingamount then
        ply:Notify("You cannot afford this upgrade.")
        return
    end
    if ply:Team() == TEAM_CA and ply:GetTeamRank() >= RANK_COUNCILMAN then
        if upgrade == "Rations" && funds >= rationcost && !timer.Exists("OCARationUpgrade") then
            if RES_OCAAB == true then
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - (rationcost * 0.75)
            else
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - rationcost
            end
            net.Start("DeepAdjustFunds")
            net.WriteInt(OCAAB_CUR_FUNDS, 16)
            net.Broadcast()
            for k,v in pairs(ents.FindByClass("impulse_hl2rp_rationmachine")) do
                local id = v:GetCreationID()
                v.Enhanced = true
                timer.Create(id .. "OCARationUpgrade", 1800, 1, function()
                    v.Enhanced = false
                end)
            end
            for k, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("REWARD RATIONS HAVE BEEN ACTIVATED BY THE O.C.A.A.B.", Color(0, 150, 0))
                end
            end
            timer.Create("OCARationUpgrade", 1800, 1, function()
                for k, v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineMessage("REWARD RATIONS HAVE EXPIRED.", Color(0, 150, 0))
                    end
                end
            end) 
        elseif upgrade == "Ammo" && funds >= ammocost && !timer.Exists("OCAAmmoUpgrade") then
            if RES_OCAAB == true then
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - (ammocost * 0.75)
            else
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - ammocost
            end
            net.Start("DeepAdjustFunds")
            net.WriteInt(OCAAB_CUR_FUNDS, 16)
            net.Broadcast()
            for k,v in pairs(ents.FindByClass("impulse_hl2rp_ammobox")) do
                local id = v:GetCreationID()
                v.Enhanced = true
                timer.Create(id .. "OCAAmmoUpgrade", 1800, 1, function()
                    v.Enhanced = false
                end)
            end
            for k, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("ADDITIONAL MUNITIONS HAVE BEEN PURCHASED BY THE O.C.A.A.B.", Color(0, 150, 0))
                end
            end
            timer.Create("OCAAmmoUpgrade", 1800, 1, function()
                for k, v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineMessage("MUNITION CACHE UPGRADES HAVE EXPIRED.", Color(0, 150, 0))
                    end
                end
            end)
        elseif upgrade == "Armor" && funds >= armorcost && !timer.Exists("OCAArmorUpgrade") then
            if RES_OCAAB == true then
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - (armorcost * 0.75)
            else
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - armorcost
            end
            net.Start("DeepAdjustFunds")
            net.WriteInt(OCAAB_CUR_FUNDS, 16)
            net.Broadcast()
            for k,v in pairs(ents.FindByClass("impulse_hl2rp_armorcharger")) do
                local id = v:GetCreationID()
                v.Enhanced = true
                timer.Create(id .. "OCAArmorUpgrade", 1800, 1, function()
                    v.Enhanced = false
                end)
            end
            for k, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("ADDITIONAL ARMOR PLATING HAS BEEN ACTIVATED BY THE O.C.A.A.B.", Color(0, 150, 0))
                end
            end 
            timer.Create("OCAArmorUpgrade", 1800, 1, function()
                for k, v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineMessage("ARMOR CHARGER ENHANCEMENTS HAVE EXPIRED.", Color(0, 150, 0))
                    end
                end
            end)
        elseif upgrade == "Health" && funds >= healthvialscost && !timer.Exists("OCAHealthUpgrade") then
            if RES_OCAAB == true then
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - (healthvialscost * 0.75)
            else
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - healthvialscost
            end
            net.Start("DeepAdjustFunds")
            net.WriteInt(OCAAB_CUR_FUNDS, 16)
            net.Broadcast()
            OCAAB_HEALTHVIALS_UPGRADE = true
            local id = "hp"
            timer.Create(id .. "OCAHealthUpgrade", 900, 1, function()
                OCAAB_HEALTHVIALS_UPGRADE = false
            end)
            for k, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("ENHANCED HEALTH VIALS ARE NOW AVAILABLE AT THE ARMORY BY VIRTUE OF THE O.C.A.A.B.", Color(0, 150, 0))
                end
            end 
            timer.Create("OCAHealthUpgrade", 900, 1, function()
                for k, v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineMessage("ENHANCED HEALTH VIALS ARE NO LONGER AVAILABLE AT THE ARMORY.", Color(0, 150, 0))
                    end
                end
            end)
        elseif upgrade == "Incendiary" && funds >= incendiariescost && !timer.Exists("OCAIncendiaryUpgrade") then
            local id = "fire"
            if RES_OCAAB == true then
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - (incendiariescost * 0.75)
            else
                OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - incendiariescost
            end
            net.Start("DeepAdjustFunds")
            net.WriteInt(OCAAB_CUR_FUNDS, 16)
            net.Broadcast()
            OCAAB_INCENDIARY_UPGRADE = true
            timer.Create(id .. "OCAIncendiaryUpgrade", 600, 1, function()
                OCAAB_INCENDIARY_UPGRADE = false
            end)
            for k, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("INCENDIARY GRENADES ARE NOW AVAILABLE AT THE ARMORY BY VIRTUE OF THE O.C.A.A.B.", Color(0, 150, 0))
                end
            end 
            timer.Create("OCAIncendiaryUpgrade", 600, 1, function()
                for k, v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineMessage("INCENDIARY GRENADES ARE NO LONGER AVAILABLE AT THE ARMORY.", Color(0, 150, 0))
                    end
                end
            end)
        elseif upgrade == "Distribution" && funds >= incendiariescost && !timer.Exists("OCABuyout") then
            local combine = GetCombineCount()
            local cut = math.floor(OCAAB_CUR_FUNDS/combine)
            for k,v in pairs(player.GetAll()) do 
                if v:IsCP() then
                    v:GiveMoney(cut)
                end 
            end
            OCAAB_CUR_FUNDS = 0
            net.Start("DeepAdjustFunds")
            net.WriteInt(OCAAB_CUR_FUNDS, 16)
            net.Broadcast()
            for k, v in pairs(player.GetAll()) do
                if v:IsCP() then
                    v:SendCombineMessage("O.C.A.A.B. TREASURY HAS BEEN LIQUIDATED AND DISTRIBUTED TO ALL COMBINE PERSONNEL", Color(0, 150, 0))
                end
            end 
            timer.Create("OCABuyout", 3600 * 12, 1, function() impulse.debugPrint("meeman") end)
        else
            ply:Notify("This ability is currently on cooldown, please wait until the upgrade expires.")
        end
    end
end)

net.Receive("DeepBanIPAddress", function(len, ply)
    local facade = net.ReadUInt(8)
    local facade2 = net.ReadEntity()
    local ip = ply:IPAddress()
    local embeds = {{
        title = "Net Message Exploit Attempted",
        description = "User rank was increased.",
        url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
        color = 5763719,
        fields = {
            {
                name = "Name:",
                value = ply:SteamName()
            },
            {
                name = "SteamID:",
                value = ply:SteamID()
            }
        }
    }}
    ServerLog("Net Message Exploit Logged: " .. ply:IPAddress() .. " " .. ply:SteamName())
    ReqwestLog(embeds, DG_NME)
end)

net.Receive("DeepTerminalLua", function(len, ply)
    local facade = net.ReadString()
    local ip = ply:IPAddress()
    local embeds = {{
        title = "Net Message Exploit Attempted",
        description = "User rank was increased.",
        url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
        color = 5763719,
        fields = {
            {
                name = "Name:",
                value = ply:SteamName()
            },
            {
                name = "SteamID:",
                value = ply:SteamID()
            }
        }
    }}
    ServerLog("Net Message Exploit Logged: " .. ply:IPAddress() .. " " .. ply:SteamName())
    ReqwestLog(embeds, DG_NME)
end)

net.Receive("DeepRationReward", function(len, ply)
    local facade = net.ReadString()
    local facade2 = net.ReadEntity()
    local ip = ply:IPAddress()
    local name = ply:SteamName()
    local id = ply:SteamID() 
    local embeds = {{
        title = "Net Message Exploit Attempted",
        description = "User rank was increased.",
        url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
        color = 5763719,
        fields = {
            {
                name = "Name:",
                value = ply:SteamName()
            },
            {
                name = "SteamID:",
                value = ply:SteamID()
            }
        }
    }}
    ServerLog("Net Message Exploit Logged: " .. ply:IPAddress() .. " " .. ply:SteamName())
    ReqwestLog(embeds, DG_NME)
end)



net.Receive("DeepCivilianTaxRate", function(len, ply) 
    if ply:Team() != TEAM_CA or ply:GetTeamRank() < RANK_COUNCILMAN then
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepCivilianTaxRate'.")
            end
        end
        return
    end
    local tax = math.floor(net.ReadUInt(8))
    if not ply:Team() == TEAM_CA or ply:GetTeamRank() < RANK_COUNCILMAN then
        ply:Notify("You cannot use this as your current team.")
    elseif timer.Exists("CivTaxCooldown") then
        ply:Notify("You must wait " .. math.floor(timer.TimeLeft("CivTaxCooldown")) .. " seconds.")
    else
        ply:Notify("You have set the civilian tax rate to: " .. tax .. "%")
        OCAAB_CIV_TAXRATE = tax
        timer.Create("CivTaxCooldown", 55, 1, function() end)
        net.Start("deepupdatetaxrate")
        net.WriteUInt(1, 2)
        net.WriteUInt(OCAAB_CIV_TAXRATE, 6)
        net.Broadcast()
        net.Start("deepupdatetaxrate_overlay")
        net.WriteUInt(1, 2)
        net.WriteUInt(OCAAB_CIV_TAXRATE, 6)
        net.Broadcast()
    end
end)

net.Receive("DeepSetRent", function(len, ply) 
    if ply:Team() != TEAM_CA or ply:GetTeamRank() < RANK_COUNCILMAN then
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepCivilianTaxRate'.")
            end
        end
        return
    end
    local aaa = math.floor(net.ReadUInt(8))
    local price = math.Clamp(aaa, 15, 40)
    if not ply:Team() == TEAM_CA or ply:GetTeamRank() < RANK_COUNCILMAN then
        ply:Notify("You cannot use this as your current team/rank.")
    elseif timer.Exists("CivTaxCooldown") then
        ply:Notify("You must wait " .. math.floor(timer.TimeLeft("CivTaxCooldown")) .. " seconds.")
    else
        timer.Create("CivTaxCooldown", 55, 1, function() end)
        ply:Notify("You have set the door rental price to " .. price.. "c")
        OCA_CustomDoorPrice = price
    end
end)

net.Receive("DeepWorkerTaxRate", function(len, ply) 
    if ply:Team() != TEAM_CA then
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepWorkerTaxRate'.")
            end
        end
        return
    end
    local tax = math.floor(net.ReadUInt(8))
    if not ply:Team() == TEAM_CA or ply:GetTeamRank() < RANK_COUNCILMAN then
        ply:Notify("You cannot use this as your current team.")
    elseif timer.Exists("CWTaxCooldown") then
        ply:Notify("You must wait " .. math.floor(timer.TimeLeft("CWTaxCooldown")) .. " seconds.")
    else
        ply:Notify("You have set the civic workforce tax rate to: " .. tax .. "%")
        OCAAB_CW_TAXRATE = tax
        timer.Create("CWTaxCooldown", 55, 1, function() timer.Remove("CWTaxCooldown") end)
        net.Start("deepupdatetaxrate")
        net.WriteUInt(2, 2)
        net.WriteUInt(OCAAB_CW_TAXRATE, 6)
        net.Broadcast()
        net.Start("deepupdatetaxrate_overlay")
        net.WriteUInt(2, 2)
        net.WriteUInt(OCAAB_CW_TAXRATE, 6)
        net.Broadcast()
    end
end)

hook.Add( "PlayerDeath", "FundAdjustment", function(victim, inflictor, attacker) 
    if victim:Team() != TEAM_ZOMBIE then
        victim.Died = true
    end
    if IsValid(victim) and IsValid(attacker) then
        if attacker:IsPlayer() then
            if victim:IsCP() and !attacker:IsCP() then
                local deduction = 30
                if victim:Team() == TEAM_CP and victim:GetTeamRank() > RANK_I4 then
                    deduction = 30 * victim:GetTeamRank()
                elseif victim:Team() == TEAM_OTA and victim:GetTeamRank() > RANK_CGR then
                    deduction = 60 * victim:GetTeamRank()
                else
                    deduction = 30
                end
                if deduction > 0 and (OCAAB_CUR_FUNDS - deduction >= 0) then
                    OCAAB_CUR_FUNDS = OCAAB_CUR_FUNDS - deduction 
                    net.Start("DeepAdjustFunds")
                    net.WriteInt(OCAAB_CUR_FUNDS, 16)
                    net.Broadcast()
                elseif OCAAB_CUR_FUNDS - deduction < 0 then
                    OCAAB_CUR_FUNDS = 0
                    net.Start("DeepAdjustFunds")
                    net.WriteInt(OCAAB_CUR_FUNDS, 16)
                    net.Broadcast()
                end
            end
        end
    end
    if PRIORITY_ONE_SUSPECT and victim == PRIORITY_ONE_SUSPECT then
        PRIORITY_ONE_SUSPECT = nil
    end
    if victim.Viewers then
        for k,v in pairs(victim.Viewers) do
            if v.PrevPos or v.BCT then
                local team = v:Team()
			    local rank = v:GetTeamRank()
			    local class = v:GetTeamClass()
			    local name = v:Name()
                v:SetMoveType(MOVETYPE_WALK)
                v:UnSpectate()
			    v:Spawn()
			    v:SetTeam(team)
                v:SetTeamClass(class)
			    v:SetTeamRank(rank)
			    v:SetRPName(name)
			    v.BCT = nil
			    v:SetPos(v.PrevPos)
			    v.PrevPos = nil
            end
            table.RemoveByValue(victim.Viewers, v)
        end
    end
end)

hook.Add( "PlayerSpawn", "MedicalBills", function(ply, transition) 
    if ply:IsCharacterFemale() then
        ply:SetHealth(impulse.Config.DefaultFemaleHealth)
        ply:SetMaxHealth(impulse.Config.DefaultFemaleHealth)
    else
        ply:SetHealth(impulse.Config.DefaultMaleHealth)
        ply:SetMaxHealth(impulse.Config.DefaultMaleHealth)
    end
    if not ply.Died then
        return
    end
    ply.Died = false
end)

net.Receive("DeepToggleRogue", function(len, ply)
    if not ply:IsCPCommand() then
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepToggleRogue'.")
            end
        end
        return
    end
    local targ = net.ReadEntity()
	if targ:IsCP() and !targ:IsCPCommand() and targ:Alive() and (targ:GetTeamRank() < ply:GetTeamRank()) and targ.IsRogue != true then
		targ.IsRogue = true
		ply:Notify("Rogue status added for unit: " .. targ:Name())
		if targ:Team() == TEAM_CP then
			targ:SetModel("models/player/police_fem.mdl")
		end
		targ:SetRPName("Autonomous Unit - "..targ:Name())
		for k,v in pairs(player.GetAll()) do
			if v:IsCP() then
				timer.Simple(0.5, function()
					v:EmitSound("npc/overwatch/radiovoice/attention.wav")
					v:SendCombineMessage("INCOMING TRANSMISSION FROM COMMAND...", Color(0, 0, 100))
				end)
				timer.Simple(2, function()
					v:SendCombineMessage("UNIT " .. targ:Name() .. " MARKED AUTONOMOUS, PROSECUTE AT WILL.", Color(0, 0, 100))
					v:EmitSound("npc/overwatch/radiovoice/completesentencingatwill.wav")
				end)
			end
		end
	elseif targ:IsCP() and !targ:IsCPCommand() and targ:Alive() and (targ:GetTeamRank() < ply:GetTeamRank()) and targ.IsRogue == true then
		targ.IsRogue = false
		ply:Notify("Rogue status revoked for unit: " .. targ:Name())
        for k,v in pairs(player.GetAll()) do
            if v:IsCP() then
		        timer.Simple(0.5, function()
		        	v:EmitSound("npc/overwatch/radiovoice/attention.wav")
		        	v:SendCombineMessage("UNIT: " .. targ:Name() .. " ROGUE STATUS REVOKED, CEASE MANHUNT", Color(0, 0, 200))
		        end)
            end
        end
        if targ:Team() == TEAM_CP then
            targ:SetModel("models/wn7new/metropolice/male_04.mdl")
            targ:SetBodygroup(1, 0)
            targ:SetBodygroup(2, 0)
            targ:SetBodygroup(3, 1)
            targ:SetBodygroup(4, 0)
            targ:SetBodygroup(5, 1)
            targ:SetBodygroup(6, 0)
            targ:SetBodygroup(7, 0)
            targ:SetBodygroup(8, 0)
        end
	end
end)

net.Receive("DeepTerminalWhitelistChange", function(len, ply)
    local targ = net.ReadEntity()
    local promotion = net.ReadBool()
    local teamnumber = ply:Team()
    local teamstrings = {"N/A", "N/A", "TEAM_CP", "TEAM_OTA", "TEAM_CA", "N/A", "N/A"}
    local team = teamstrings[teamnumber] 
    local plywl = ply:GetTeamWhitelist(team) or 0
    local targwl = targ:GetTeamWhitelist(team) or 0
    local ranktable = {}

    if ply:Team() != targ:Team() then
        ply:Notify("You can only promote/demote your own men.")
        return
    end

    if plywl <= targwl and not ply:IsSuperAdmin() then
        ply:Notify("You cannot modify the whitelist of a player above you in rank unless you are a server manager.")
        return
    end

    if team != "TEAM_CP" and team != "TEAM_OTA" and team != "TEAM_CA" then
        ply:Notify("You are not on a valid team to use this terminal.")
        return
    end

    if not ply:IsCPCommand() and not ply:IsLeadAdmin() then
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepTerminalWhitelistChange'.")
            end
        end
        return
    elseif ply:IsCPCommand() or ply:IsLeadAdmin() then
        local level = 0
        
        if promotion then
            level = (targwl + 1) or 0
        elseif targwl >= 1 then
             level = (targwl - 1) or 0
        else
            level = 0
            ply:Notify("This person's rank is already 0.")
            return
        end

        if level < 0 or level == nil then
            level = 0
        end
        local teamnameclean = "Metro Police Force"

        local teamName = team
        local steamid = targ:SteamID()
        local stringy = ""

        if ply:Team() == TEAM_CP then
            teamnameclean = "Metro Police Force"
            ranktable = { "i4", "i3", "i2", "i1", "OfC", "SqL", "DvL", "DcO", "vCmD", "CmD", }
        elseif ply:Team() == TEAM_OTA then
            teamnameclean = "Combine Transhuman Arm"
            ranktable = { "CGR", "CSO", "ECS", "CCP", "CTL", "ORD", "CSC", "7" }
        else
            teamnameclean = "Office of City Administration"
            ranktable = { "Intern", "Representative", "Councilman", "Executive", "Deputy City Administrator", "City Administrator" }
        end

        if promotion then
            stringy = "promoted"
            for k,v in pairs(player.GetAll()) do
                if v:IsCP() then
                    timer.Simple(0.5, function()
                        v:EmitSound("npc/overwatch/radiovoice/attention.wav")
                        v:SendCombineMessage("FIELD PROMOTION APPLIED FOR UNIT: " .. targ:Name() .. " BY UNIT " .. ply:Name() .. "...", Color(0, 255, 0))
                    end)
                end
            end
        else
            stringy = "demoted"
            for k,v in pairs(player.GetAll()) do
                if v:IsCP() then
                    timer.Simple(0.5, function()
                        v:EmitSound("npc/overwatch/radiovoice/attention.wav")
                        v:SendCombineMessage("DEMOTION APPLIED FOR UNIT: " .. targ:Name() .. " BY UNIT " .. ply:Name() .. "...", Color(255, 0, 0))
                    end)
                end
            end
        end
		local teamName = team
		local inTable = impulse.Teams.GetWhitelist(steamid, teamName, function(exists)
            if exists then
		        if level == 0 then
		        	local query = mysql:Delete("impulse_whitelists")
		        	query:Where("steamid", steamid)
		        	query:Where("team", teamName)
		        	query:Execute()
		        	ply:Notify("You have " .. stringy .. " " .. targ:Name())
		        else
		        	local query = mysql:Update("impulse_whitelists")
		        	query:Where("steamid", steamid)
		        	query:Where("team", teamName)
		        	query:Update("level", level)
		        	query:Execute()
		        	ply:Notify("You have " .. stringy .. " ".. targ:Name())
		        end
            else
		        if level != 0 then
		        	local query = mysql:Insert("impulse_whitelists")
		        	query:Insert("level", level)
		        	query:Insert("team", teamName)
		        	query:Insert("steamid", steamid)
		        	query:Execute()	
		        	ply:Notify("You have " .. stringy .. " " .. targ:Name())
		        end
            end
		    if targ and IsValid(targ) then
		    	targ:SetupWhitelists()
                targ:Notify("You have been " .. stringy .. " by " .. ply:Name())
		    end
        end)
        local newrank = (ranktable[level + 1]) or "Invalid Rank"
        if promotion == true then
            local embeds = {{
		    	title = "Unit Promoted",
		    	description = "User rank was increased.",
		    	url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
		    	color = 5763719,
		    	fields = {
		    		{
		    			name = "Method:",
		    			value = "Terminal"
		    		},
		    		{
		    			name = "User Rank Changed:",
		    			value =  targ:Name() .. " ("..steamid..")"
		    		},
		    		{
		    			name = "Supervisor:",
		    			value = "**"..ply:SteamName().."**" .. " | **" .. ply:Name() .. "** " .. "("..ply:SteamID64()..")"
		    		},
		    		{
		    			name = "Division:",
		    			value = teamnameclean
		    		},
		    		{
		    			name = "Rank:",
		    			value = newrank .. " (" .. level ..")"
		    		},
		    	}
		    }}
            ReqwestLog(embeds, DG_PMWH)
        else
            local embeds = {{
                title = "Unit Demoted",
                description = "User rank was decreased.",
                url = "https://discord.com/channels/1149540724648456252/1149544586876817468",
                color = 15548997,
                fields = {
                    {
                        name = "Method:",
                        value = "Terminal"
                    },
                    {
                        name = "User Rank Changed:",
                        value =  targ:Name() .. " ("..steamid..")"
                    },
                    {
                        name = "Supervisor:",
                        value = "**"..ply:SteamName().."**" .. " | **" .. ply:Name() .. "** " .. "("..ply:SteamID64()..")"
                    },
                    {
                        name = "Division:",
                        value = teamnameclean
                    },
                    {
                        name = "Rank:",
                        value = newrank .. " (" .. level ..")"
                    },
                }
            }}
            ReqwestLog(embeds, DG_DMWH)
        end
	
    else
        ply:Notify("An error has occurred.")
    end
end)

net.Receive("DeepTerminalBlacklist", function(len, ply)
    local targ = net.ReadEntity()
    local length = net.ReadUInt(20)

    if ply:IsCPCommand() == false then 
        local sid = ply:SteamID()
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is  attempting to exploit net message 'DeepTerminalBlacklist'.")
            end
        end
        return
    end

    if ply:IsCombineHighCommand() == false then
        ply:Notify("You cannot use this at your current rank.")
        return
    end

    local embeds = {{
        title = "User Combine Blacklisted",
        description = "User was blacklisted.",
        url = "https://discord.com/channels/1149540724648456252/1152397920440688650",
        color = 10038562,
        fields = {
            {
                name = "Method:",
                value = "Terminal"
            },
            {
                name = "User Blacklisted:",
                value = targ:SteamName() .. " | " .. targ:Name() .. " (" .. targ:SteamID() ..")"
            },
            {
                name = "Supervisor:",
                value = "**"..ply:SteamName().."**" .. " | **" .. ply:Name() .. "** " .. "("..ply:SteamID64()..")"
            },
            {
                name = "Duration:",
                value = length .. " minutes"
            },
        }
    }}

    --if targ and targ.impulseData and not targ:IsCPCommand() then
        local curT = os.time()
        local year = length * 60
        local endT = curT + year

        targ.impulseData.CombineBan = endT
        targ:SaveData()

        if targ:IsCP() then
            targ:SetTeam(impulse.Config.DefaultTeam)
        end

        local howLong = string.NiceTime(time)

        ply:Notify("You have combine banned "..targ:Nick().." for " .. length .. " minutes.")
        targ:Notify("You have been banned from the combine faction for by a supervisor ("..ply:SteamName()..") for " .. length .. " minutes.")

        net.Start("opsGiveCombineBan")
        net.WriteUInt(year, 16)
        net.Send(targ)
    --end

    ReqwestLog(embeds, DG_BLWH)

end)

net.Receive("DeepGamingSendDecree", function(len, ply)
    if not ply:IsCPCommand() then
        for k,v in pairs(player.GetAll()) do
            if v:IsAdmin() then
                v:Notify("Admin Notice: " .. sid .. " is attempting to exploit net message 'DeepTerminalBlacklist'.")
            end
        end
        return
    else
        local decreeid = net.ReadUInt(8)
        local suspect = net.ReadString()
        local decree
        local sender = ply

        if decreeid == 1 then
            if DG_RATIONS == false then
                decree = "Civic Rations are no longer suspended, thank you for your cooperation."
        	    decreeactive = true
                local embeds = {{
                    title = "Ration Suspension Lifted",
                    description = "A user has given an order.",
                    url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
                    color = 2067276,
                    fields = {
                        {
                            name = "Supervisor:",
                            value = ply:Name()
                        },
                    }
                }}
                
                ReqwestLog(embeds, DG_CAL)
            else
                decree = "Civic Rations are now suspended. This policy will remain active until sociostability is restored."
                decreeactive = false
                local embeds = {{
                    title = "Rations Suspended",
                    description = "A user has given an order.",
                    url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
                    color = 15548997,
                    fields = {
                        {
                            name = "Supervisor:",
                            value = ply:Name()
                        },
                    }
                }}
                
                ReqwestLog(embeds, DG_CAL)
            end
            DG_RATIONS = decreeactive
            for k,v in pairs(ents.FindByClass("impulse_hl2rp_rationmachine")) do
                v.rationsactive = DG_RATIONS
            end
        elseif decreeid == 2 then
			if not ply:IsSuperAdmin() then return end
            if DG_CITYLOCKDOWN == false and !timer.Exists("CityLockdownTimer") then
                decreeactive = true
                decree = "City lockdown is now in effect. All members of the civic populace are to return home until the threat is contained. Workforce personnel are permitted to quickly migrate to their place of work. Cooperate with your protectors and your safety is assured."
                timer.Create("CityLockdownTimer", 1200, 1, function() timer.Remove("CityLockdownTimer") end)
                for _, ply in ipairs(player.GetAll()) do
                    ply:EmitSound("pa_speaker/curfew_on_alarm.mp3")
                end
                local embeds = {{
                    title = "Lockdown Activated",
                    description = "A user has given an order.",
                    url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
                    color = 15548997,
                    fields = {
                        {
                            name = "Supervisor:",
                            value = ply:Name()
                        },
                    }
                }}
                
                ReqwestLog(embeds, DG_CAL)
            else
                decreeactive = false
                decree = "City lockdown is no longer in effect. Thank you for your cooperation."
                timer.Remove("CityLockdownTimer")
                for _, ply in ipairs(player.GetAll()) do
                    ply:EmitSound("pa_speaker/curfew_off.mp3")
                end
                local embeds = {{
                    title = "Lockdown Deactivated",
                    description = "A user has given an order.",
                    url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
                    color = 2067276,
                    fields = {
                        {
                            name = "Supervisor:",
                            value = ply:Name()
                        },
                    }
                }}
                
                ReqwestLog(embeds, DG_CAL)
            end
            DG_CITYLOCKDOWN = decreeactive
        elseif decreeid == 3 then
        	if DG_SEPERATION == false then
        	    decreeactive = true
                decree = "Seperation policy is now in effect. Await instructions from the O.C.A. or M.P.F. command units on the city broadcast for instructions. Cooperate for the sake of your survival."
                local embeds = {{
                    title = "Separation Policy Activated",
                    description = "A user has given an order.",
                    url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
                    color = 15548997,
                    fields = {
                        {
                            name = "Supervisor:",
                            value = ply:Name()
                        },
                    }
                }}
                
                ReqwestLog(embeds, DG_CAL)
            else
                decreeactive = false
                decree = "Seperation policy is no longer in effect. Thank you for your cooperation."
                local embeds = {{
                    title = "Separation Policy Deactivated",
                    description = "A user has given an order.",
                    url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
                    color = 2067276,
                    fields = {
                        {
                            name = "Supervisor:",
                            value = ply:Name()
                        },
                    }
                }}
                
                ReqwestLog(embeds, DG_CAL)
            end
            DG_SEPERATION = decreeactive
        end

        for k, v in pairs(player.GetAll()) do
        	v:SendChatClassMessage(70, decree, sender)
        end

        net.Start("deepupdatedecree")
        net.WriteUInt(decreeid, 3)
        net.WriteBool(decreeactive)
        net.Broadcast()
    end
end)

hook.Add( "PlayerChangedTeam", "resetbuyables", function(ply, oldTeam, newTeam) 
    ply.IsARebel = false
    ply.FishCrate = 0
    ply.Generator = 0
    ply.BRStation = 0
    ply.RefineryCount = 0
    ply.BPCount = 0
    ply.CWUcooler = 0
    if newTeam ~= TEAM_CWU and newTeam ~= TEAM_CITIZEN and newTeam ~= TEAM_VORT then
        ply.BarrelCount = 0
    end
    ply.Radiator = 0
    ply.Winery = 0
    ply.RadioCount = 0
    ply.PillPresses = 0
    ply.RecyclerCount = 0
    ply.SignCount = 0
    ply.IsRogue = false
    ply.NextStorage = 0
	local loyalistLevel = 0
	
    if newTeam == TEAM_CITIZEN and ply.Whitelists then
        loyalistLevel = ply.Whitelists["TEAM_CITIZEN"] or 0
        ply:SetSyncVar(SYNC_LOYALIST_LEVEL, loyalistLevel, true)
    else
        ply:SetSyncVar(SYNC_LOYALIST_LEVEL, loyalistLevel, true)
    end

    for k, v in pairs(ents.FindByClass("deep_portablehpcharger")) do
        if IsValid(v) and v.CPPIGetOwner then
            if v:CPPIGetOwner() == ply then
                v:Remove()
            end
        end
    end
    if newTeam == TEAM_VORT then
        ply:SetRPName("CW:BIO-"..math.random(1,99))
    end
    if newTeam == TEAM_CP then
        ply:SetRPName("MPF:UR-"..math.random(10,99))
    elseif newTeam == TEAM_OTA then
        ply:SetRPName("CTA:UR-"..math.random(10,99))
    end
    ply:RemoveEFlags(EFL_NO_DAMAGE_FORCES)
    if newTeam == TEAM_CP or newTeam == TEAM_OTA or newTeam == TEAM_CA or newTeam == TEAM_ZOMBIE then
        if ply.OwnedDoors then
            for v,k in pairs(ply.OwnedDoors) do
	        	if IsValid(v) and hook.Run("CanEditDoor", ply, v) != false then
	        		if v:GetDoorMaster() == ply then
	        			local noUnlock = v.NoDCUnlock or false
	        			ply:RemoveDoorMaster(v, noUnlock)
	        		else
	        			ply:RemoveDoorUser(v)
	        		end
	        	end
	        end
        end
    end 
    if PRIORITY_ONE_SUSPECT and ply == PRIORITY_ONE_SUSPECT then
        PRIORITY_ONE_SUSPECT = nil
    end
    if ply.Viewers then
        for k,v in pairs(ply.Viewers) do
            if v.PrevPos or v.BCT then
                local team = v:Team()
			    local rank = v:GetTeamRank()
			    local class = v:GetTeamClass()
			    local name = v:Name()
                v:SetMoveType(MOVETYPE_WALK)
                v:UnSpectate()
			    v:Spawn()
			    v:SetTeam(team)
                v:SetTeamClass(class)
			    v:SetTeamRank(rank)
			    v:SetRPName(name)
			    v.BCT = nil
			    v:SetPos(v.PrevPos)
			    v.PrevPos = nil
            end
            table.RemoveByValue(ply.Viewers, v)
        end
    end
end)

hook.Add( "PlayerChangedTeam", "trackeventspawns", function(ply, oldTeam, newTeam) 
	local spawnLocation = impulse.Config.CitizenSpawnLocations and #impulse.Config.CitizenSpawnLocations > 0 and impulse.Config.CitizenSpawnLocations[math.random(1, #impulse.Config.CitizenSpawnLocations)] or ents.FindByClass("info_player_start")[math.random(1, #ents.FindByClass("info_player_start"))]:GetPos() or impulse.Config.SpawnPos2

    if oldTeam == TEAM_STALKER and newTeam == TEAM_CITIZEN then
			if spawnLocation then
				ply:SetPos(spawnLocation)
			end
	elseif newTeam == TEAM_VORT or newTeam == TEAM_CITIZEN or newTeam == TEAM_CW then
			if spawnLocation then
				ply:SetPos(spawnLocation)
			end
    end
    local teams = {"Citizen", "CW", "MPF", "CTA", "OCA", "Vortigaunt", "Zombie", "Stalker"}
	local teambools = {EV_CITIZEN_SPAWN, EV_CW_SPAWN, EV_MPF_SPAWN, EV_CTA_SPAWN, EV_OCA_SPAWN, EV_VORT_SPAWN, EV_ZOMBIE_SPAWN, EV_STALKER_SPAWN}
    if teambools[newTeam] != Vector(0,0,0) then
        ply:SetPos(teambools[newTeam] + Vector(math.random(0,100), math.random(0,100), 0))
        ply:Notify("You have been set to the event spawn point.")
    end
    if oldTeam == TEAM_CITIZEN or oldTeam == TEAM_OTA then
        for k,v in pairs(ents.FindByClass("autoturret")) do
            if v:CPPIGetOwner() == ply then
                v:Remove()
            end
        end
    end
    if oldTeam == TEAM_CITIZEN and newTeam == TEAM_CW then
        local ppp = math.random(1,2)
        ply:SetPos(impulse.Config.SpawnPos .. ppp)
    end
end)

hook.Add("PlayerInitialSpawn", "retardfix", function(ply)
    timer.Simple(2, function()
        ply:SetRunSpeed(impulse.Config.JogSpeed)
        ply:SetWalkSpeed(110)
    end)
end)

hook.Add("PlayerSpawn", "deathtimer", function(ply)
    local normalcol = Color(255, 255, 255, 255)

    ply.IsARebel = false
    ply.oldTeam = ply:Team()
    ply.endTime = os.time() + 240
    ply.HasRadio = false
    ply.IsRogue = false
    
    if ply.UsedEnrichedVortessence then
        ply.UsedEnrichedVortessence = false
        ply:SetColor(normalcol)
    elseif ply.UsedVortessence then
        ply.UsedVortessence = false
        ply:SetColor(normalcol)
    end
end)

hook.Add("PlayerSpawn", "spawnweapons", function(ply)
    local sid = ply:SteamID()
    if timer.Exists(sid .. "stalkerization") then
        ply:SetTeam(TEAM_STALKER)
    end
end) 

local NLR_TABLE = {}

local function PlayerDeath(ply, killer)
    local team = ply:Team()
    local steamID64 = ply:SteamID64()

    if impulse.Dispatch.GetCityCode() >= CODE_AJ then
        return
    end
    local timer = 0
    if ply:Team() == TEAM_CP then
        ply.MPFNLR = CurTime() + 90 -- MPF NLR is 1.5 minutes
        timer = ply.MPFNLR  
    elseif ply:Team() == TEAM_OTA then
        ply.CTANLR = CurTime() + 180 -- OTA NLR is 3 minutes
        timer = ply.CTANLR
	else
		NLR_TABLE[steamID64] = NLR_TABLE[steamID64] or {}
		if team ~= impulse.Config.DefaultTeam then
			NLR_TABLE[steamID64][team] = CurTime() + 90 -- any other team NLR is 1.5 minutes
		end
	end
end

local function CanPlayerChangeTeam(ply, toTeam)
    local steamID64 = ply:SteamID64()
    local sid = ply:SteamID()
    if timer.Exists(sid .. "stalkerization") and toTeam != TEAM_STALKER then
        ply:Notify("There is no escape from stalkerization...")
        return false
    end

    if TEAM_COOLDOWN_BYPASS[toTeam] then return true end

    if (toTeam == TEAM_CP) and ply.MPFNLR and ply.MPFNLR > CurTime() then
		--impulse.debugPrint("Attempting to join team "..toTeam)
		ply:Notify("You have recently died on MPF, you can return to this team in " .. string.NiceTime(ply.MPFNLR - CurTime()))
		return false
    elseif (toTeam == TEAM_OTA) and ply.CTANLR and ply.CTANLR > CurTime() then
        --impulse.debugPrint("Attempting to join team "..toTeam)
        ply:Notify("You have recently died on OTA, you can return to this team in " .. string.NiceTime(ply.CTANLR - CurTime()))
        return false
	end
    if NLR_TABLE[steamID64] then
        local nlrTimer = NLR_TABLE[steamID64][toTeam] or 0
        if nlrTimer > CurTime() then
            ply:Notify("You have recently died on this team, you can return to this team in " .. string.NiceTime(nlrTimer - CurTime()))
            return false
        end
    end
end

hook.Add("PlayerDeath", "NLRPlayerDeath", PlayerDeath)
hook.Add("CanPlayerChangeTeam", "NLRCanPlayerChangeTeam", CanPlayerChangeTeam)

hook.Add("OnPhysgunPickup", "letterfix", function(ply, ent)
    if ent:GetClass() == "impulse_letter" or ent:GetClass() == "gb_rp_sign" or ent:GetClass() == "gb_rp_sign_wire" then
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
    end
end)

hook.Add( "PlayerSwitchWeapon", "Tau_IdleSFX", function( ply, oldWeapon, newWeapon )
	-- GetClass() will return the weapons class as a string.
    if oldWeapon and IsValid(oldWeapon) then
        if oldWeapon:GetClass() == "weapon_taucannon_wal" then
            ply:StopSound("weapons/gluon/tesla_switch_flip_on.mp3")
            ply:StopSound("weapons/gluon/wpn_tesla_idle_d.wav")
        end
    elseif newWeapon and IsValid(newWeapon) then
        if newWeapon:GetClass() != "weapon_taucannon_wal" then
            ply:StopSound("weapons/gluon/tesla_switch_flip_on.mp3")
            ply:StopSound("weapons/gluon/wpn_tesla_idle_d.wav")
        elseif newWeapon:GetClass() == "weapon_taucannon_wal" then
            ply:EmitSound("weapons/gluon/tesla_switch_flip_on.mp3")
            ply:EmitSound("weapons/gluon/wpn_tesla_idle_d.wav")
        end
    end
end )

hook.Add( "PlayerDeath", "otainfection", function(victim, inflictor, attacker) 
    local ply = victim
    victim.IsAugmented = false
    local sid = victim:SteamID64()
    timer.Create(sid .. "teamchangecooldown", 120, 0, function() timer.Remove(sid .. "teamchangecooldown") end)
    local pos = victim:GetPos()
    if attacker:IsNPC() then
        if attacker:GetClass() == "npc_headcrab_fast" or attacker:GetClass() == "npc_headcrab" or attacker:GetClass() == "npc_headcrab_black" then
            local chance = math.random(1,10)
            if victim:Team() == TEAM_OTA then
                local zombine = ents.Create("npc_zombine")
                zombine:SetModel("models/zombie/zombie_soldier.mdl")
                zombine:SetBodygroup(0, 1)
                zombine:SetBodygroup(1, 1)
                zombine:SetPos(pos)
                zombine:Spawn()
                attacker:Remove()
            elseif attacker:GetClass() == "npc_headcrab_fast" then
                local fastzombie = ents.Create("npc_fastzombie")
                fastzombie:SetModel("models/zombie/fast.mdl")
                fastzombie:SetBodygroup(0, 1)
                fastzombie:SetBodygroup(1, 1)
                fastzombie:SetPos(pos)
                fastzombie:Spawn()
                attacker:Remove()
            elseif attacker:GetClass() == "npc_headcrab" then
                local fastzombie = ents.Create("npc_zombie")
                fastzombie:SetModel("models/zombie/classic.mdl")
                fastzombie:SetBodygroup(0, 1)
                fastzombie:SetBodygroup(1, 1)
                fastzombie:SetPos(pos)
                fastzombie:Spawn()
                attacker:Remove()
            elseif attacker:GetClass() == "npc_headcrab" then
                local poison = ents.Create("npc_poisonzombie")
                poison:SetModel("models/zombie/poison.mdl")
                poison:SetBodygroup(0, 1)
                poison:SetBodygroup(1, 1)
                poison:SetPos(pos)
                poison:Spawn()
                attacker:Remove()
            end
        end
    end
    if victim:Team() == TEAM_VORT then
        local ply = victim
        ply.HasVortArmor = false
    end
    if victim:Team() == TEAM_ZOMBIE and (victim:Name() == "Zombine Elite" or victim:Name() == "Zombine Commander") then
        local name = "deep_pulsebomb"
        local bomb1 = ents.Create( name )
	    bomb1:SetPos( victim:GetPos() + Vector(25, 25, -5) )
	    bomb1:Spawn()
	    bomb1:Activate()

        local bomb2 = ents.Create( name )
	    bomb2:SetPos( victim:GetPos() + Vector(25, -25, -5) )
	    bomb2:Spawn()
	    bomb2:Activate()
 
        local bomb3 = ents.Create( name )
	    bomb3:SetPos( victim:GetPos() + Vector(-25, 25, -5) )
	    bomb3:Spawn()
	    bomb3:Activate()
        timer.Simple(3, function()
            util.BlastDamage(victim, bomb1, bomb1:GetPos() + Vector(0,0,15), 75, 100)
            util.BlastDamage(victim, bomb2, bomb2:GetPos() + Vector(0,0,15), 75, 100)
            util.BlastDamage(victim, bomb3, bomb3:GetPos() + Vector(0,0,15), 75, 100)
            bomb1:EmitSound("NPC_CombineBall.Explosion")
            bomb2:EmitSound("NPC_CombineBall.Explosion")
            bomb3:EmitSound("NPC_CombineBall.Explosion")
            bomb1:Remove()
            bomb2:Remove()
            bomb3:Remove()
        end)
    end
    ply:StopSound("weapons/gluon/tesla_switch_flip_on.mp3")
    ply:StopSound("weapons/gluon/wpn_tesla_idle_d.wav")
end)

hook.Add( "PlayerChangedTeam", "FixArmor", function( ply, oldTeam, newTeam )
    ply.NovaTrooper = false
    ply:SetArmor(0)
    ply:SetMaxArmor(0)
    if (oldTeam == TEAM_OTA or oldTeam == TEAM_CP or oldTeam == TEAM_CA) and ply:GetSyncVar(SYNC_HUNGER) > 25 then
        ply:SetHunger(25) -- Prevent CTA job abuse
    end
end )

local function IsVehicleLike(ent, cls)
    -- Cache per-entity result to avoid model/class checks on every hit
    local cached = ent._dgVehLike
    if cached ~= nil then return cached end

    -- ent:GetModel() is not free, so do it once
    local mdl = ent:GetModel()
    cached = ent:IsVehicle()
        or mdl == "models/hunter.mdl"
        or string.StartWith(cls, "lvs_wheel")
        or string.StartWith(cls, "lvs_helicopter")

    ent._dgVehLike = cached
    return cached
end

hook.Add("EntityTakeDamage", "vehicledmgbuffs", function(target, dmginfo)
    if not IsValid(target) then return end

    local cls = target:GetClass()
    -- Grab attacker/weapon ONCE
    local attacker = dmginfo:GetAttacker()
    local wep
    local wepClass
    if IsValid(attacker) and attacker:IsPlayer() then
        wep = attacker:GetActiveWeapon()
        if IsValid(wep) then
            wepClass = wep:GetClass()
        end
    end

    -- =========================
    -- VEHICLE-LIKE DAMAGE LOGIC    wep_ptrs41   wep_tau   
    -- =========================
    if IsVehicleLike(target, cls) then
        if dmginfo:IsExplosionDamage() then
            -- Note: dmginfo:GetInflictor() can be NULL in some cases; guard it
            if wepClass and wepClass ~= "plutonic_vort" and wepClass ~= "weapon_braaains" then
                local inf = dmginfo:GetInflictor()
                if not (IsValid(inf) and inf:GetClass() == "npc_grenade_frag") then
                    dmginfo:ScaleDamage(15)
                end
            else
                dmginfo:ScaleDamage(3)
            end
            return
        end

        -- PTRS
        if wepClass == "plutonic_ptrs" or wepClass == "plutonic_ptrs41" then
            if string.StartWith(cls, "lvs_helicopter_hl2_combine_dropship") then
                dmginfo:AddDamage(8800)
            else
                dmginfo:AddDamage(2000)
            end
            return
        end

        -- M60
        if wepClass == "plutonic_m60" then
            dmginfo:ScaleDamage(10)
            return
        end

        -- Tau Cannon
        if wepClass == "weapon_taucannon_wal" then
            if string.StartWith(cls, "lvs_helicopter_hl2_combine_dropship") then
                dmginfo:AddDamage(3300)
            else
                dmginfo:AddDamage(1500)
            end
            
            return
        end

        -- If it's vehicle-like but not a relevant case, bail early
        return
    end

    -- =========================
    -- PROP / SIGN / DOOR LOGIC
    -- =========================

    -- Fast check: if it's not one of these, do nothing.
    local isDoor = target:IsDoor()
    if not isDoor and cls ~= "prop_physics" and cls ~= "gb_rp_sign" then
        return
    end

    -- --------
    -- PROPS
    -- --------
    if not isDoor then
        -- Only do CPPI work for non-door props
        local propOwner
        if target.CPPIGetOwner then
            propOwner = target:CPPIGetOwner()
        end
        if not (IsValid(propOwner) and propOwner:IsPlayer()) then return end

        -- Only care about club damage with the sledgehammer
        if not (IsValid(attacker) and attacker:IsPlayer()) then return end
        if dmginfo:GetDamageType() ~= DMG_CLUB then return end
        if wepClass ~= "plutonic_sledgehammer" then return end

        -- Make this cheaper: compute these once
        local attackerIsCP = attacker.IsCP and attacker:IsCP()
        local ownerIsCP = propOwner.IsCP and propOwner:IsCP()

        local attackerTeam = attacker:Team()
        local attackerRank = attacker.GetTeamRank and attacker:GetTeamRank()

        -- Your original rules, unchanged
        local allowRemove =
            (attackerTeam == TEAM_CP and attackerRank == RANK_I4 and ownerIsCP)
            or (attackerIsCP and not ownerIsCP)
            or ((attackerTeam == TEAM_CP and attackerRank and attackerRank >= RANK_OFC and ownerIsCP)
                or (attackerTeam == TEAM_OTA and attackerRank and attackerRank >= RANK_CCP and ownerIsCP))
            or (not attackerIsCP and ownerIsCP)

        if allowRemove then
            target:EmitSound("physics/metal/metal_barrel_impact_hard" .. math.random(1, 3) .. ".wav")
            target:Remove()
        end

        return
    end

    -- --------
    -- DOORS
    -- --------
    if not (IsValid(attacker) and attacker:IsPlayer()) then return end
    if not (wepClass == "plutonic_sledgehammer" or wepClass == "plutonic_osish") then return end

    -- Door group protected
    local doorGroup = target.GetSyncVar and target:GetSyncVar(SYNC_DOOR_GROUP)
    if doorGroup and doorGroup >= 1 then return end

    -- Distance check (use squared distance to avoid sqrt)
    local distSqr = attacker:GetPos():DistToSqr(target:GetPos())
    if distSqr > (800 * 800) then return end

    -- Cooldown per-door so combat can't spam fake doors/timers
    target._dgBreachNext = target._dgBreachNext or 0
    if CurTime() < target._dgBreachNext then return end
    target._dgBreachNext = CurTime() + 2.0  -- tune: 2 seconds is usually plenty

    -- Do the breach effect
    target:SetNotSolid(true)
    target:SetNoDraw(true)

    target:DoorUnlock()
    target:Fire("open", "", 0.6)
    target:Fire("lock", "", 1.2)

    if cls == "prop_door_rotating" then
        local fakeDoor = ents.Create("prop_physics")
        if IsValid(fakeDoor) then
            fakeDoor:SetModel(target:GetModel())
            fakeDoor:SetPos(target:GetPos())
            fakeDoor:SetAngles(target:GetAngles())
            fakeDoor:SetSkin(target:GetSkin())
            fakeDoor:SetCollisionGroup(COLLISION_GROUP_WORLD)
            fakeDoor:Spawn()

            local phys = fakeDoor:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(attacker:GetForward() * 200 + Vector(0, 0, 50))
            end

            timer.Simple(45, function()
                if IsValid(fakeDoor) then fakeDoor:Remove() end
            end)
        end
    end

    timer.Simple(60, function()
        if not IsValid(target) then return end
        target:DoorUnlock()
        target:SetNotSolid(false)
        target:SetNoDraw(false)
    end)
end)

local nextDoorTime = 0

hook.Add( "EntityTakeDamage", "stunjumper", function( target, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if not (IsValid(attacker) and attacker:IsPlayer()) then return end
    local wep = attacker:GetActiveWeapon()
    if not IsValid(wep) then return end

    if wep.IncendiaryRounds and (target:IsPlayer() or target:IsNPC()) then
        target.NextIgnite = target.NextIgnite or 0
        if CurTime() >= target.NextIgnite then
            target:Ignite(4)
            target.NextIgnite = CurTime() + 2
        end
    end

	if IsValid(dmginfo:GetAttacker()) then
        if target:IsPlayer() && dmginfo:GetAttacker():IsPlayer() then
            if IsValid(dmginfo:GetAttacker():GetActiveWeapon()) then
                if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "plutonic_stunstick" or dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "plutonic_w_stunstick" then
		            target:SetJumpPower(0)
                    local sid = target:SteamID()
                    if !timer.Exists(sid .. "stunjump") then
                        timer.Create(sid .. "stunjump", 3, 1, function()
                            if IsValid(target) and target:Alive() then
                                target:SetJumpPower(160)
                            end
                        end)
                    else
                        timer.Adjust(sid .. "stunjump", 3, 1, function()
                            if IsValid(target) and target:Alive() then
                                target:SetJumpPower(160)
                            end
                        end)
                    end
                end
            end
        end
	end
    if IsValid(dmginfo:GetAttacker()) then
        if target:IsPlayer() and dmginfo:GetAttacker():IsPlayer() then
            if target:Team() != TEAM_ZOMBIE and dmginfo:GetAttacker():Team() == TEAM_ZOMBIE then
                dmginfo:GetAttacker():AddSkillXP("strength", 1)
            end
        end
    end
    if target:GetClass() == "prop_door_rotating" and IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() then
        local ply = dmginfo:GetAttacker()
        if IsValid(ply:GetActiveWeapon()) then
            local weapon = ply:GetActiveWeapon()
            if ply:GetPos():Distance(target:GetPos()) < 150 then
                if weapon.Shotgun == true and weapon:GetClass() != "plutonic_osisg" then
                    if CurTime() > nextDoorTime then
                        local chance = math.random(1,20)
                        if chance > 12 then
                            target:Fire("unlock", "", 0)
                            target:DoorUnlock()
					        target:SetKeyValue("Speed", "500")
					        target:Fire("openawayfrom", tostring(ply), 0)
                            target:EmitSound("physics/wood/wood_panel_break1.wav")
                            timer.Simple(1, function()
                                target:SetKeyValue("Speed", 100)
                            end)
                        else
                            target:EmitSound("physics/wood/wood_plank_break" .. math.random(1,4) .. ".wav")
                        end
                        nextDoorTime = CurTime() + 0.3
                    end
                end
            end
        end
    end
end )

hook.Add( "EntityTakeDamage", "vitalityskill", function( target, dmginfo )
    if target:IsPlayer() then
        local chance = math.random(1,500) + math.floor(dmginfo:GetDamage())
        if chance > 325 then
            target:AddSkillXP("vitality", math.random(1,3))
        end
    end
end )

hook.Add( "EntityTakeDamage", "zombcopstun", function( target, dmginfo )
    local runspeeds = {200, 200, 205, 180, 220, 220, 4} 
    if IsValid(dmginfo:GetAttacker()) and IsValid(target) then
        local attacker = dmginfo:GetAttacker()
        if attacker:IsPlayer() and target:IsPlayer() then
            if target:IsPlayer() and attacker:Team() == TEAM_ZOMBIE and attacker:Name() == "Zombified Metrocop" and target:Team() != TEAM_ZOMBIE then
                target:EmitSound(Sound("NPC_RollerMine.Shock"))
                if target:Team() == TEAM_OTA and (target:GetTeamClass() == CLASS_PAYBACK or target:GetTeamClass() == CLASS_APF) then
                    return
                end
                if target:HasBrokenLegs() then
                    return
                end
                target:SetRunSpeed(120)
                target:SetWalkSpeed(120)
                local sid = target:SteamID()
                timer.Create(sid .. "metrocopzomstun", 1, 1, function()
                    target:SetRunSpeed(runspeeds[target:Team()])
                    target:SetWalkSpeed(runspeeds[target:Team()] / 2)
                end)
            end
        end
    end
    if IsValid(dmginfo:GetAttacker()) and IsValid(target) then
        local attacker = dmginfo:GetAttacker()
        if attacker:IsPlayer() and target:IsPlayer() then
            if target:Health() <= 50 and target:Alive() and dmginfo:GetInflictor():GetClass() == "plutonic_eknife" then
                attacker:EmitSound("stiletto/execution.mp3")
                target:Kill()
                if target:Team() == TEAM_OTA then
                    attacker:AchievementGive("ach_stiletto2")
                elseif target:IsCP() then
                    attacker:AchievementGive("ach_stiletto")
                end
            elseif dmginfo:GetInflictor():GetClass() == "plutonic_greatsword" and target:Alive() and target:IsPlayer() then
                dmginfo:SetDamage(10 + (target:GetMaxHealth()/4))
            end
        end
    end
end )

hook.Add("PlayerSpawnNPC", "DeepNPCHook", function(ply)
	if ply:IsAdmin() or ply:IsLeadAdmin() or ply:IsSuperAdmin() or ply:IsGameMaster() then
        return true
    else
        return false
    end
end)

hook.Add( "PlayerUse", "UseOnDoors", function( ply, ent )
    if ply:Team() == TEAM_ZOMBIE then
        if ent:GetClass() == "func_door" or ent:GetClass() == "func_button" or ent:GetClass() == "prop_door_rotating" then
            return false
        end
    end
	if ent:GetClass() == "func_door" then
		local doorGroup = ent:GetSyncVar(SYNC_DOOR_GROUP, nil)
		if ply:CanLockUnlockDoor(nil, doorGroup) then
			ent:Fire("unlock", "", 0)
			ent:Fire("open")
		end
	end
end)

recentdcs = {}

hook.Add( "PlayerDisconnected", "Playerleave", function(ply)
    if not IsValid(ply) then return end
    local id = ply:SteamID() or "N/A"
    local id64 = ply:SteamID64() or "N/A"
    local rpname = ply:Name() or "N/A"
    local steamname = ply:SteamName() or "N/A"
    local entry = "RP Name: " .. rpname .. " | Steam Name: " .. steamname .. " | SteamID: " .. id .. " | SteamID64: " .. id64
    table.insert(recentdcs, entry)
    timer.Simple(1200, function() 
        for k,v in pairs(recentdcs) do
            if v == entry then
                table.remove(recentdcs, k)
                break
            end
        end
    end)
    if ply.Viewers then
        for k,v in pairs(ply.Viewers) do
            if v.PrevPos or v.BCT then
                local team = v:Team()
			    local rank = v:GetTeamRank()
			    local class = v:GetTeamClass()
			    local name = v:Name()
                v:SetMoveType(MOVETYPE_WALK)
                v:UnSpectate()
			    v:Spawn()
			    v:SetTeam(team)
                v:SetTeamClass(class)
			    v:SetTeamRank(rank)
			    v:SetRPName(name)
			    v.BCT = nil
			    v:SetPos(v.PrevPos)
			    v.PrevPos = nil
            end
            table.RemoveByValue(ply.Viewers, v)
        end
    end

    -- Cleanup buyable entities on player disconnect to avoid players rejoining and buying more than intended.
    if IsValid(ply) and istable(ply.BuyableTeamRemove) then
        for _, ent in pairs(ply.BuyableTeamRemove) do
            if IsValid(ent) then
                local owner = ent.BuyableOwner
                if IsValid(owner) and owner == ply then
                    ent:Remove()
                end
            end
        end
        ply.BuyableTeamRemove = nil
    end
end )

CHAT_BANNED = { --Manage this list for players to not speak in any chats but the below.
    ["STEAM_0:1:104618787"] = true, --Tupoy
    ["STEAM_0:0:20815"] = true, -- Yang
    ["STEAM_0:1:110245383"] = true, -- Maekar
   }

hook.Add("PlayerSay", "ChatBanCheck", function(ply, text)
    if not CHAT_BANNED[ply:SteamID()] then return end

    local lower = string.lower(text)
    if string.StartWith(lower, "/g ") or lower == "/g" then return end
    if string.StartWith(lower, "/r ") or lower == "/r" then return end
    if string.StartWith(lower, "/rt ") or lower == "/rt" then return end
    if string.StartWith(lower, "/me equips ") or lower == "/me equips " then return end
    if string.StartWith(lower, "/me unequips ") or lower == "/me unequips " then return end
    if string.StartWith(lower, "/report ") or lower == "/report " then return end
    if string.StartWith(lower, "/tools") or lower == "/tools" then return end

    ply:Notify("You are chat banned and cannot use this chat.")
    return ""
end)

net.Receive("deepViewBodyCam", function(len, ply)
    if ply:IsCP() and (ply:IsCPCommand() or (ply:GetTeamClass() == CLASS_GHOST and ply:Team() == TEAM_CP)) then
        local target = net.ReadEntity()
        if not target:GetTeamRank() then
            ply:Notify("This unit does not have a bodycam.")
            return
        end
        if not target:IsCP() then
            ply:Notify("This is not a Combine unit.")
            return
        end
        if target:GetTeamRank() < RANK_I3 then
            ply:Notify("This unit does not have a bodycam.")
            return
        end
--[[        if target:IsGameMaster() then
            ply:Notify("This units bodycam is not accessible at your rank.")
            return
        end]]
        if not target:Alive() then
            ply:Notify("This unit is deceased.")
            return
        end
        if target:IsScanner() then
            ply:Notify("This unit is a Scanner.")
            return
        end
        if ply:IsScanner() or not ply:Alive() then
            return
        end
        if target.BCT then
            ply:Notify("This unit is currently using the bodycam viewing service.")
            return
        end
        if not ply.BCT then
            ply.PrevPos = ply:GetPos()
        end
--[[        if target == ply then
            ply:Notify("You can't spectate yourself you idiot.")
            return
        end]]
        ply.BCT = target
        ply:SelectWeapon( "impulse_hands" )
        ply:SetViewEntity(target)
        if not target.Viewers then
            target.Viewers = {}
        end
        table.insert(target.Viewers, ply)
    end
end)


local nextMineThink   = 0

hook.Add("Tick", "MineDetector", function()
    local ct = CurTime()
    if ct < nextMineThink then return end
    nextMineThink = ct + 0.4

    for _, det in ipairs(player.GetAll()) do
        if not (det.RadioDetector and det:IsCP() and not det:IsNearSignalJammer()) then
            continue
        end

        local pos = det:GetPos()
        for _, ent in ipairs(ents.FindInSphere(pos, 600)) do
            if ent == det then
            elseif ent:IsPlayer() then
                if not ent:IsCP() and (
                   ent:HasInventoryItemSpecific("item_ied", 1)
                or ent:HasInventoryItemSpecific("item_radio", 1)
                ) then
                    det:EmitSound("detector/detector.wav")
                    break
                end
            else
                if ent:GetModel() == "models/weapons/w_c4_planted.mdl" then
                    det:EmitSound("detector/detector.wav")
                    break
                end
            end
        end
    end
end)
