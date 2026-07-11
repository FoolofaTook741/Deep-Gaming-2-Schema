AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/dg_models/dg_combine_props/vnl/health_charger002.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	local id = self:GetCreationID()
	if activator:Team() != TEAM_ZOMBIE then
		if timer.Exists(id .. "hpcooldown") then
			activator:Notify("You must wait ".. math.floor(timer.TimeLeft(id.."hpcooldown")) .. " seconds before using this device again.")
		elseif activator:Health() < activator:GetMaxHealth() then
			local hth = math.Clamp(activator:Health() + 15, 0, activator:GetMaxHealth())
			activator:SetHealth(hth)
			activator:FixLegs()
			self:EmitSound("hl1/fvox/boop.wav")
			timer.Create(id .. "hpcooldown", 4, 1, function()
				timer.Remove(id .. "hpcooldown")
			end)
		elseif activator:Health() >= activator:GetMaxHealth() then
			activator:Notify("You do not need to use this device.")
			self:EmitSound("hl1/fvox/fuzz.wav")
		end
	else
		activator:Notify("You cannot interact with this item.")
		self:EmitSound("hl1/fvox/fuzz.wav")
	end
    return
end