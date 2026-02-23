AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/Items/HealthKit.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	if activator:Team() != TEAM_ZOMBIE then
		activator.NextRebelHeal = activator.NextRebelHeal or 0
		local medSuppliesHas, medSuppliesCount = activator:HasInventoryItem("util_medicalsupplies")
		local xenExtractHas, xenExtractCount = activator:HasInventoryItem("util_xenextract")
		if not medSuppliesCount then
			medSuppliesCount = 0
		end
		if not xenExtractCount then
			xenExtractCount = 0
		end
		if activator:Health() >= 100 and not activator:HasBrokenLegs() then
            if activator.NextRebelHeal > 0 then
                activator:Notify("You do not need to use this device, and cannot for " .. string.NiceTime(activator.NextRebelHeal - CurTime()) .. ".")
                self:EmitSound("hl1/fvox/fuzz.wav")
            else
                activator:Notify("You do not need to use this device.")
                self:EmitSound("hl1/fvox/fuzz.wav")
            end
		elseif activator.NextRebelHeal > CurTime() then
			activator:Notify("You cannot use this for " .. string.NiceTime(activator.NextRebelHeal - CurTime()) .. ".")
		elseif medSuppliesCount >= 2 and xenExtractCount >= 1 then
			if activator:Health() < 100 or activator:HasBrokenLegs() then
				activator.NextRebelHeal = CurTime() + 300
				activator:TakeInventoryItemClass("util_medicalsupplies", nil, 2)
				activator:TakeInventoryItemClass("util_xenextract", nil, 1)
				activator:SetHealth(100)
				activator:FixLegs()  
				self:EmitSound("hl1/fvox/boop.wav")
				activator:Notify("You have used the station to cure your wounds.")
			end
		else
			activator:Notify("You need 2 Medical Supplies and 1 Xen Extract to use this.")
		end
	else
		activator:Notify("You cannot interact with this item.")
		self:EmitSound("hl1/fvox/fuzz.wav")
	end
    return
end