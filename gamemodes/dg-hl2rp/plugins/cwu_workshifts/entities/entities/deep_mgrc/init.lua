AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_se/propper/power_rec_set_1.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.HP = 750
end

function ENT:Think()
    if not timer.Exists(self:EntIndex() .. "snd") then
        self:EmitSound("research/massfabloop.ogg")
        timer.Create(self:EntIndex() .. "snd", 7.195, 0, function()
            self:EmitSound("research/massfabloop.ogg")
        end)
    end
    self:NextThink( CurTime() + 15)
    return true
end

function ENT:OnRemove()
    timer.Remove(self:EntIndex() .. "snd")
    self:StopSound("research/massfabloop.ogg")
	MGRC_COUNT = math.max((MGRC_COUNT or 0) - 1, 0)
end

function ENT:OnTakeDamage(dmg)
    local amount = dmg:GetDamage()
    self.HP = self.HP - amount
    if self.HP < 0 then
        self:Remove()
        local droppos = self:GetPos() + Vector(0,0,25)
        impulse.Inventory.SpawnItem("util_metalplate", droppos)
        impulse.Inventory.SpawnItem("util_pipe", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        impulse.Inventory.SpawnItem("util_pipe", droppos)
        impulse.Inventory.SpawnItem("util_pipe", droppos)
        self:EmitSound("research/machineoverload.ogg")
    end
end