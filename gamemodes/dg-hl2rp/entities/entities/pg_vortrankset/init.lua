AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

function ENT:Initialize()
 
	self:SetModel( "models/props_combine/combine_intmonitor001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	self.TerminalType = "Employment"

	net.Start("impulseHL2RPTerminalTypeRequest")
	net.WriteString(self.TerminalType)
	net.Broadcast()
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Think()
	--[[
	self.TerminalType = "Enlistment"

	net.Start("impulseHL2RPTerminalTypeRequest")
	net.WriteString(self.TerminalType)
	net.Broadcast(
	--]]
end
 
util.AddNetworkString("RegisterPlayerUsage")

function ENT:Use( activator, caller )
    if activator:Team() == TEAM_VORT then
		net.Start("impulseHL2RPRankUse")
		net.Send(activator)
	else
		activator:Notify("You cannot use this on your current team.")
    end

    return
end
