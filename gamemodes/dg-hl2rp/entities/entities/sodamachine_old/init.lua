AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_equipment/fountain_drinks.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 

function ENT:Use( activator, caller )
	local luck = math.random(1, 250)
	local spawnpos = self:GetPos() + Vector(0, 25, 0)
	if activator:Team() == TEAM_ENTITY then
		activator:Notify("Your team cannot interact with this object.")	
	elseif activator:CanAfford(12) && luck != 19 && luck >= 230 then
		impulse.Inventory.SpawnItem("food_bluesodapop", spawnpos, 60)
		activator:Notify("You have purchased a soda pop for 12 coins. Oh? A rare blue one (8& chance)!")
		activator:TakeMoney(12)
		self:EmitSound("friends/message.wav")
	elseif activator:CanAfford(12) && luck != 19 && luck < 230 then
		impulse.Inventory.SpawnItem("food_sodapop", spawnpos, 60)
		activator:Notify("You have purchased a soda pop for 12 coins.")
		activator:TakeMoney(12)
		self:EmitSound("buttons/button4.wav")
	elseif activator:CanAfford(12) && luck == 19 then
		impulse.Inventory.SpawnItem("food_limsodapop5", spawnpos, 60)
		activator:Notify("You have found a rare item! (0.4% chance)")
		activator:TakeMoney(12)
		self:EmitSound("friends/friend_online.wav")
	else 
		activator:Notify("You need 12 tokens to purchase a drink.")
	end
    return
end