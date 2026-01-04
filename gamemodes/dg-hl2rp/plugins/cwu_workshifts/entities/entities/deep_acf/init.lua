AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/generator-wall/generator-wall.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self.HP = 15000
    self.working = false
    self.finished = false
end

function ENT:Think()
	if not IsValid(self) then return end
    if not timer.Exists(self:EntIndex() .. "lasersnd") and self.working != true then
        self:EmitSound("research/laser.mp3")
        timer.Create(self:EntIndex() .. "lasersnd", 1.28, 0, function()
            self:EmitSound("research/laser.mp3")
        end)
    elseif not timer.Exists(self:EntIndex() .. "spssnd") and self.working == true then
        self:EmitSound("research/sps.mp3")
        timer.Create(self:EntIndex() .. "spssnd", 3.7, 0, function()
            self:EmitSound("research/sps.mp3")
        end)
    end
    self:NextThink( CurTime() + 15)
    return true
end

function ENT:OnRemove()
    timer.Remove(self:EntIndex() .. "lasersnd")
    timer.Remove(self:EntIndex() .. "spssnd")
    self:StopSound("research/laser.mp3")
    self:StopSound("research/sps.mp3")
    if ACF_COUNT then
        ACF_COUNT = math.max(ACF_COUNT - 1, 0)
    end
end

function ENT:OnTakeDamage(dmg)
	if not IsValid(self) then return end
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
        impulse.Inventory.SpawnItem("util_augmentchip", droppos)
        impulse.Inventory.SpawnItem("util_steel", droppos)
        impulse.Inventory.SpawnItem("util_steel", droppos)
        self:EmitSound("research/machineoverload.mp3")
    end
end

function ENT:Use(ply)
    if self.working != true and self.finished != true then
        timer.Remove(self:EntIndex() .. "lasersnd")
        self:StopSound("research/laser.mp3")
        self.working = true
        for k, v in pairs(player.GetAll()) do 
            v:Notify("The A.C.F. has started fabrication. Completion in 30 minutes.")
        end
        timer.Create(self:EntIndex() .. "ACFWorking", 1800, 1, function() 
			if not IsValid(self) then return end
            self.finished = true
            self.working = false
            self:StopSound("research/sps.mp3")
            timer.Remove(self:EntIndex() .. "spssnd")
            for k, v in pairs(player.GetAll()) do 
                v:Notify("The A.C.F. has completed fabrication.")
            end
        end)
        return
    elseif self.finished == true then
        self.finished = false
        ply:GiveInventoryItem("item_augmentchip",1,true)
        ply:Notify("Augment Chip received!")
        return
    else
        ply:Notify("Machine currently working, return in " .. math.floor(timer.TimeLeft(self:EntIndex() .. "ACFWorking")) .. " seconds.")
        return
    end
end