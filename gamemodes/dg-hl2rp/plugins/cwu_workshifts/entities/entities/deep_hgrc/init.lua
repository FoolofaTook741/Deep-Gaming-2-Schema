AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_se/propper/power_rec_set_3.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.HP = 2000
end

function ENT:Think()
    if not timer.Exists(self:EntIndex() .. "snd") then
        self:EmitSound("research/massfabscrapsolo.ogg")
        timer.Create(self:EntIndex() .. "snd", 0.7925, 0, function()
            self:EmitSound("research/massfabscrapsolo.ogg")
        end)
    end
    self:NextThink( CurTime() + 15)
    return true
end

function ENT:OnRemove()
    timer.Remove(self:EntIndex() .. "snd")
	HGRC_COUNT = math.max((HGRC_COUNT or 0) - 1, 0)
    self:StopSound("research/massfabscrapsolo.ogg")
end

function ENT:OnTakeDamage(dmg)
    local amount = dmg:GetDamage()
    self.HP = self.HP - amount
    if self.HP < 0 then
        self:Remove()
        local droppos = self:GetPos() + Vector(0,0,25)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_metalplate", droppos)
        impulse.Inventory.SpawnItem("util_metalplate", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_steel", droppos)
        impulse.Inventory.SpawnItem("util_steel", droppos)
        self:EmitSound("research/machineoverload.ogg")
    end
end