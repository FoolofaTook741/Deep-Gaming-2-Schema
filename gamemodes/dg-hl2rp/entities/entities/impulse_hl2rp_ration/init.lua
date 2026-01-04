AddCSLuaFile("shared.lua") 
include("shared.lua")


function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)  
	self:SetMoveType(SOLID_VPHYSICS)  
	self:SetSolid(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetUseType(SIMPLE_USE)
	timer.Simple(1.5, function()
        if IsValid(self) then
		  self:GetPhysicsObject():Wake()
        end
	end)
end

function ENT:Use(ply)
    if ply != self.Owner then return end

    if self.Reward then
        local amount = self.Reward
        ply:Notify("You have received "..impulse.Config.CurrencyPrefix..amount.." in this reward ration for services to the Combine.")
        ply:EmitBudgetSound("impulse/eat.wav")
        ply:GiveMoney(amount)

        ply.RewardRation = nil
    else
        local amount = impulse.Teams.Data[self.Type].salary
        if not amount then return self:Remove() end

        if ply:IsCP() then
            ply:FeedHunger(50)
        else
            ply:FeedHunger(38)
        end

        ply:Notify("You have picked up your "..team.GetName(self.Type).." ration and have received "..impulse.Config.CurrencyPrefix..amount..".")
        ply:EmitBudgetSound("impulse/eat.wav")
        ply:GiveMoney(amount)
    end

    self:Remove()
end

