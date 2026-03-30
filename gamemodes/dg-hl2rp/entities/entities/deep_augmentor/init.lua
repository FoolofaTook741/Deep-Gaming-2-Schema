AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local OTA_AUG = {
    [CLASS_ECHO]   = { skin = 0, armor = 180, speed = 190 },
    [CLASS_MACE]   = { skin = 1, armor = 200, speed = 190 },
    [CLASS_RANGER] = { skin = 2, armor = 160, speed = 190 },
    [CLASS_NOMAD]  = { skin = 3, armor = 160, speed = 190 },
}

local OTA_AUG_OWG = {
    [CLASS_ECHO] = { skin = 2, armor = 140, speed = 185 },
    [CLASS_MACE] = { skin = 2, armor = 160, speed = 190 },
}

local OTA_AUG_ORD = {
    armor = 300, maxArmor = 300, health = 130, maxHealth = 130, speed = 200, skin = 0
}

local OTA_AUG_FIST = {
    armor = 250, speed = 200
}

local OTA_AUG_FIST_ORD = {
    armor = 320, health = 140, maxHealth = 140, speed = 200, skin = 0
}

local OTA_AUG_APF = {
    armor = 400, health = 175, maxHealth = 175, skin = 0
}

local OTA_AUG_PAYBACK = {
    armor = 575, health = 300, maxHealth = 300, skin = 2
}

local CP_CLASS_SKIN = {
    [CLASS_UNION] = 1,
    [CLASS_GRID]  = 1,
    [CLASS_HELIX] = 3,
    [CLASS_SWORD] = 4,
    [CLASS_GHOST] = 5,
}

local CP_RANK_NAMES = { "i4", "i3", "i2", "i1", "OfC", "SqL", "DvL", "DcO", "VCmD", "CmD" }
local OTA_RANK_NAMES = { "CGR", "CSO", "ECS" }

local function StartAugProcess(self, ply)
    local sid = ply:SteamID()

    ply:Notify("Augmentation process underway, you will be unable to move for a moment.")

    if ply:HasInventoryItem("item_augmentchip") then
        ply:TakeInventoryItemClass("item_augmentchip", 1, 1)
    end

    self:EmitSound("ambient/machines/thumper_amb.wav")
    ply:Freeze(true)

    net.Start("impulseHL2RPCombineOverlayBoot")
    net.Send(ply)

    return sid
end

local function FinishAugProcess(self, ply)
    ply:Freeze(false)
    self:StopSound("ambient/machines/thumper_amb.wav")
    self:EmitSound("ambient/machines/teleport3.wav")
end

local function ApplyStatData(ply, data)
    if data.skin      then ply:SetSkin(data.skin) end
    if data.armor     then ply:SetArmor(data.armor) end
    if data.maxArmor  then ply:SetMaxArmor(data.maxArmor) end
    if data.health    then ply:SetHealth(data.health) end
    if data.maxHealth then ply:SetMaxHealth(data.maxHealth) end
    if data.speed     then ply:SetRunSpeed(data.speed) end
end

local function ApplyOTAAug(self, ply)
    if not ply:Alive() then
        ply:Notify("You cannot use this on your current class.")
        return
    end

    local sid   = StartAugProcess(self, ply)
    local class = ply:GetTeamClass()
    local rank  = ply:GetTeamRank()

    timer.Create(sid .. "augmentation", 10, 1, function()
        if not IsValid(ply) then return end

        local data

        if class == CLASS_FIST then
            data = (rank >= RANK_ORD) and OTA_AUG_FIST_ORD or OTA_AUG_FIST
        elseif class == CLASS_APF then
            data = OTA_AUG_APF
        elseif class == CLASS_PAYBACK then
            data = OTA_AUG_PAYBACK
        elseif OTA_AUG[class] then
            if rank >= RANK_ORD then
                data = OTA_AUG_ORD
            elseif rank > RANK_OWG then
                data = OTA_AUG[class]
            elseif rank == RANK_OWG then
                data = OTA_AUG_OWG[class]
                if not data then
                    ply:Notify("You cannot use this on your current rank.")
                    FinishAugProcess(self, ply)
                    return
                end
            else
                ply:Notify("You cannot use this on your current rank.")
                FinishAugProcess(self, ply)
                return
            end
        else
            ply:Notify("You cannot use this on your current class.")
            FinishAugProcess(self, ply)
            return
        end

        ApplyStatData(ply, data)
        ply.IsAugmented = true
        ply:Notify("You have received your augmentation.")
        FinishAugProcess(self, ply)
    end)
end

local function ApplyMPFAug(self, ply)
    local sid = StartAugProcess(self, ply)

    timer.Create(sid .. "augmentation", 25, 1, function()
        if not IsValid(ply) or not ply:Alive() or ply:Team() ~= TEAM_CP then
            FinishAugProcess(self, ply)
            return
        end

        local class = ply:GetTeamClass()
        local rank  = ply:GetTeamRank()

        hook.Run("PlayerSetCombineRank", ply, rank, class)

        ply:SetArmor(35)
        ply:SetMaxArmor(35)
        ply:SetWalkSpeed(120)
        ply:SetRunSpeed(240)

        local skin = CP_CLASS_SKIN[class]
        if skin then ply:SetSkin(skin) end

        ply:SetBodygroup(1, (rank >= RANK_DVL) and 6 or 7)
        ply:SetBodygroup(2, 1)
        ply:SetBodygroup(3, 1)
        ply:SetBodygroup(4, 0)
        ply:SetBodygroup(5, 1)
        ply:SetBodygroup(6, 1)
        ply:SetBodygroup(7, 0)
        ply:SetBodygroup(8, (class == CLASS_GHOST or rank == RANK_CMD) and 1 or 0)
        ply:SetBodygroup(9, 15)

        ply:Give("plutonic_mp7a8")
        ply.IsAugmented = true

        local rankName = CP_RANK_NAMES[rank] or "UNK"
        ply:SetRPName("MPF:" .. rankName .. ".SCAR-" .. math.random(1, 999))
        ply:Notify("Augmentation process complete. Take no prisoners.")

        FinishAugProcess(self, ply)
    end)
end

local function ToggleNova(self, ply)
    local class = ply:GetTeamClass()
    local rank  = ply:GetTeamRank()

    if class ~= CLASS_MACE and class ~= CLASS_ECHO then return end

    local rankName  = OTA_RANK_NAMES[rank] or "UNK"
    local className = (class == CLASS_MACE) and "MACE" or "ECHO"

    if ply.NovaTrooper then
        if rank == RANK_ORD then
            ply:SetSkin(0)
        else
            ply:SetSkin(1)
            ply:SetRPName("CTA:" .. rankName .. "." .. className .. "-" .. math.random(1, 99))
        end
        ply.NovaTrooper = false
    else
        local novaSkin = (rank == RANK_OWG) and 0 or 6
        ply:SetSkin(novaSkin)
        ply.NovaTrooper = true

        if rank < RANK_OCP then
            ply:SetRPName("CTA:" .. rankName .. ".NOVA-" .. math.random(1, 99))
        end
    end

    self:EmitSound("items/suitchargeok1.wav")
end

function ENT:Initialize()
    self:SetModel("models/props_combine/combine_intmonitor003.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
    local cityCode   = impulse.Dispatch.GetCityCode()
    local hasChip    = ply:HasInventoryItem("item_augmentchip")
    local augEnabled = cityCode >= CODE_AJ or hasChip

    if ply:Team() == TEAM_OTA and not augEnabled and not ply.IsAugmented then
        ToggleNova(self, ply)
        return
    end

    if not augEnabled then
        ply:Notify("This cannot be used unless the City Code is Judgement Waiver.")
        return
    end

    if not ply:IsCP() or ply:Team() == TEAM_CA then
        ply:Notify("You cannot use this machine.")
        return
    end

    if not ply:GetTeamClass() then
        ply:Notify("You cannot use this machine.")
        return
    end

    if ply.IsAugmented then
        ply:Notify("You are already an augmented unit.")
        return
    end

    if ply:Team() == TEAM_OTA then
        ApplyOTAAug(self, ply)
    elseif ply:Team() == TEAM_CP and ply:GetTeamRank() ~= nil then
        ApplyMPFAug(self, ply)
    else
        ply:Notify("You cannot use this device.")
    end
end