AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
 
	self:SetModel( "models/props_lab/monitor01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
util.AddNetworkString("RegisterPlayerUsage")

function ENT:Use( activator, caller )
    if activator:Team() == TEAM_CWU then
		net.Start("impulseHL2RPRankUse")
		net.Send(activator)
	elseif activator:Team() == TEAM_CA then
        net.Start("impulseHL2RPRankUse")
		net.Send(activator)
	else
		activator:Notify("You cannot use this on your current team.")
    end

    return
end