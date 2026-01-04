AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_se/computer_03_1970.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(SOLID_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.HP = 200
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
	LGRC_COUNT = math.max((LGRC_COUNT or 0) - 1, 0)
    if not self.CPPIGetOwner then return end
    local owner = self:CPPIGetOwner()
    if not IsValid(owner) then return end
    owner.LGRCs = math.max((owner.LGRCs or 1) - 1, 0)
end

function ENT:OnTakeDamage(dmg)
    local amount = dmg:GetDamage()
    self.HP = self.HP - amount
    if self.HP < 0 then
        self:Remove()
        local droppos = self:GetPos() + Vector(0,0,25)
        impulse.Inventory.SpawnItem("util_metalplate", droppos)
        impulse.Inventory.SpawnItem("util_metalplate", droppos)
        impulse.Inventory.SpawnItem("util_electronics", droppos)
        self:EmitSound("research/machineoverload.ogg")
    end
end
