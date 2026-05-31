AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
	self:SetModel( "models/props_lab/blastdoor001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.NextTP = 0
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end


function ENT:Use(activator, caller)
    if activator:IsCP() or activator:Team() == TEAM_ZOMBIE then return end
    if impulse.Dispatch.GetCityCode() < CODE_JW then
        activator:Notify("The door is locked.")
        return
    end
    if (activator.nextMBUse or 0) > CurTime() then
	    activator:Notify("You must wait " .. math.ceil(activator.nextMBUse - CurTime()) .. " seconds to enter.")
	    return
	end

    net.Start("impulseMBBeginUse")
    net.WriteEntity(self)
    net.Send(activator)
    activator:Notify("Opening the Metabase. Stay close OR press SPACE to cancel.")
end

net.Receive("impulseMBCompleteUse", function(len, ply)
    local ent = net.ReadEntity()
    if not IsValid(ent) or ent:GetClass() ~= "deep_mbe" then return end
    if (ply.nextMBUse or 0) > CurTime() then return end
    if ply:IsCP() or ply:Team() == TEAM_ZOMBIE then return end
    if impulse.Dispatch.GetCityCode() < CODE_JW then return end
    if (ply:GetPos() - ent:GetPos()):LengthSqr() > (120 ^ 2) then return end

    ply.nextMBUse = CurTime() + 10
    ply:SetPos(impulse.Config.MBEntrance)
end)

net.Receive("impulseMBCancelUse", function(len, ply)
end)