AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:UpdateTransmitState()
    return TRANSMIT_ALWAYS
end

function ENT:Initialize()
    self:SetModel("models/hunter/tubes/circle4x4.mdl")
    self:SetModelScale(0.55, 0)

    self:SetMoveType(MOVETYPE_NONE)

    self:SetSolid(SOLID_BBOX)

    self:SetCollisionBounds(
        Vector(-60, -48, -80),a
        Vector( 60,  48, 80)
    )

    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    self:SetTrigger(false)

    self.Hitpoints = 450
    self:DrawShadow(false)

    self:CollisionRulesChanged()
end

hook.Add("ShouldCollide", "dg_shield_no_owner_collide", function(a, b)
    if not IsValid(a) or not IsValid(b) then return end

    local owner

    if a:GetClass() == "dg_shield" then
        owner = a:GetParent()
        if IsValid(owner) and owner == b then return false end
    elseif b:GetClass() == "dg_shield" then
        owner = b:GetParent()
        if IsValid(owner) and owner == a then return false end
    end
end)

sound.Add({
    name = "CUST.OSIHS.Shield",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = SNDLVL_GUNFIRE,
    pitch = {65, 145},
    sound = {"weapons/hla_vc/charger/shield_dmg/npc_charger_shield_01.wav"}
})

function ENT:OnTakeDamage(dmginfo)
    local id = self:GetCreationID()
    local ply = self.CPPIGetOwner and self:CPPIGetOwner()

    if not timer.Exists(id .. "shielddmgcd") then
        self:EmitSound("CUST.OSIHS.Shield")
        timer.Create(id .. "shielddmgcd", 0.1, 1, function() end)
    end

    self.Hitpoints = (self.Hitpoints or 450) - dmginfo:GetDamage()

    if self.Hitpoints <= 0 then
        self:Remove()
        if IsValid(ply) then
            ply:TakeInventoryItemClass("att_assault_shield")
            ply.ShieldActive = false
            ply.shield = nil
        end
    end
end
