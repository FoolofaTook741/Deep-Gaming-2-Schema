AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')

util.AddNetworkString("pinnacle_portable_cam_viewer_open")
util.AddNetworkString("pinnacle_portable_cam_viewer_exit")
util.AddNetworkString("pinnacle_portable_cam_viewer_watch")


function ENT:Initialize()
	self:SetModel( "models/props_lab/reciever_cart.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 
function ENT:Use( activator, caller )
	activator.PCamViewer = self
	net.Start("pinnacle_portable_cam_viewer_open")
	net.WriteTable(impulse.PCams[activator:SteamID()] or {})
	net.Send(activator)
end

net.Receive("pinnacle_portable_cam_viewer_exit", function(len, ply)
	if IsValid(ply) then
		ply:SetViewEntity(ply)
		ply.PCamViewer = nil
	end
end)

net.Receive("pinnacle_portable_cam_viewer_watch", function(len, ply)
	local cam = net.ReadEntity()
	if IsValid(cam) and IsValid(ply.PCamViewer) and ply.PCamViewer:GetPos():DistToSqr(ply:GetPos()) <= 22500 and table.HasValue(impulse.PCams[ply:SteamID()] or {}, cam) then
		ply:SetViewEntity(cam)
	end
end)

function ENT:OnRemove()
end
