AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_unique/wheelchair01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
 
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end
 


function ENT:Use( activator, caller )
    if !timer.Exists("spawnwarpcooldown") then
		local tplocid = math.random(0,8)
		local loctab = {Vector(2171.6022949219, 4528.6860351563, 4248.03125), 
		Vector(4299.2241210938, 3847.4670410156, 4096.03125), 
		Vector(1387.5118408203, 3493.8974609375, 4096.03125), 
		Vector(106.73504638672, 4196.9248046875, 4096.03125), 
		Vector(2751.5617675781, 4005.4462890625, 2968.03125),
		Vector(2804.6352539063, 4285.5693359375, 4096.03125),
		Vector(8816.904296875, 5737.9116210938, 4352.03125),
		Vector(7259.6416015625, 11289.110351563, 4096.03125),
		Vector(7585.5693359375, 13943.749023438, 4096.03125),
		Vector(-151.34730529785, 322.75604248047, 5888.03125)}
        activator:SetPos( loctab[tplocid] )
        timer.Create("spawnwarpcooldown", 3, 0, function() timer.Remove("spawnwarpcooldown") end)
    end
    return
end