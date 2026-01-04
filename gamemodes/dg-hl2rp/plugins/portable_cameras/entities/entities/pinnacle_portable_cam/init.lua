AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/bo/weapons/camera spike.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
	if IsValid(activator) and activator:IsPlayer() then
		activator:GiveInventoryItem("portablecam")

		 local sid = activator:SteamID()
        if impulse.PCams and impulse.PCams[sid] then
            for k, v in ipairs(impulse.PCams[sid]) do
                if v == self then
                    table.remove(impulse.PCams[sid], k)
                    break
                end
            end
        end
		self:Remove()
	end
end

function ENT:OnRemove()

end

function ENT:OnTakeDamage(dmg)
    if self:Health() <= 0 then
		if impulse.PCams and impulse.PCams[sid] then
            for k, v in ipairs(impulse.PCams[sid]) do
                if v == self then
                    table.remove(impulse.PCams[sid], k)
                    break
                end
            end
        end
        self:Remove()
    end

end