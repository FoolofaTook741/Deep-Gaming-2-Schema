AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_canal/rock_riverbed02a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:OnTakeDamage(dmginfo)
	if IsValid(dmginfo) and IsValid(dmginfo:GetAttacker()) then
		if IsValid(dmginfo:GetAttacker():GetActiveWeapon()) then
			if dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "plutonic_pickaxe" then
				ply = dmginfo:GetAttacker()
				local chance = math.random(1, 25)
				if chance + (math.floor(ply:GetSkillLevel("strength")/2)) >= 25 and ply:CanHoldItem("item_rawmetal") then
					if WORKSHIFT_MINING == true then
						ply:GiveInventoryItem("item_rawmetal")
						ply:GiveInventoryItem("item_rawmetal")
						ply:Notify("You have mined 2 pieces of ore.")
					else
						ply:GiveInventoryItem("item_rawmetal")
						ply:Notify("You have mined 1 piece of ore.")
					end
				end
			end
		end
	end
end

function ENT:Use( activator, caller )
	activator:Notify("This is an ore node, perhaps it can be mined for metals. Don't get caught with any though...")
end