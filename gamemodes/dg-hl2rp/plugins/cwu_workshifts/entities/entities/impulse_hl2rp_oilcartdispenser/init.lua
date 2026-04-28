AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local MAX_CARTS = 2

function ENT:Initialize()
	self:SetModel( "models/props_lab/blastdoor001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	if activator:Team() ~= TEAM_CWU and activator:Team() ~= TEAM_CITIZEN then
		activator:Notify("You cannot interact with this.")
		return
	end

	local ws = impulse.OilWorkshift
	if not ws or not ws.active then
		activator:Notify("[CART] No oil workshift is active.")
		return
	end

	local cartCount = #ents.FindByClass("impulse_hl2rp_oilcart")
	if cartCount >= MAX_CARTS then
		activator:Notify("[CART] Maximum carts already in use (" .. MAX_CARTS .. "). Return one first.")
		return
	end

	local cart = ents.Create("impulse_hl2rp_oilcart")
	if not IsValid(cart) then return end
	cart:SetPos(self:GetPos() + Vector(50, 0, 30))
	cart:SetAngles(self:GetAngles())
	cart:Spawn()
	cart:Activate()

	self:EmitSound("physics/metal/metal_box_impact_soft1.wav")
	activator:Notify("[CART] Cart dispensed. Press E on it to grab and push. Load drums by pressing E near them.")
end

function ENT:SpawnFunction(ply, trace, class)
	if not gamemode.Call("PlayerSpawnSENT", ply, class) then return end
	local ent = ents.Create(class)
	ent:SetPos(trace.HitPos)
	ent:SetAngles(Angle(0, ply:EyeAngles().y + 180, 0))
	ent:Spawn()
	ent:Activate()
	return ent
end
