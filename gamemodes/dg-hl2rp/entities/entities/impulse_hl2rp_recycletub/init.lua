AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart001.mdl")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:DrawShadow(false)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
		phys:Sleep()
	end
end

function ENT:SpawnFunction(ply, trace, class)
	local ent = ents.Create(class)
	ent:SetPos(trace.HitPos)
	local ang = (trace.HitPos - ply:GetPos()):Angle()
	ang.p = 0
	ang.r = 0
	ang.y = ang.y + 180
	ent:SetAngles(ang)
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Touch(ent)
	if not IsValid(ent) then return end

	local ws = impulse.SmeltingWorkshift
	if not ws or not ws.active then return end

	if not ent:GetNWBool("IsRecycleItem", false) then return end
	if ent.SmeltingRecycled then return end

	ent.SmeltingRecycled = true

	local isTurtle = ent:GetNWBool("IsTurtleItem", false)
	local bonus = isTurtle and impulse.SmeltingTurtleBonus or impulse.SmeltingRecycleBonus

	ent:Remove()
	self:EmitSound("physics/plastic/plastic_box_impact_soft1.wav")

	ws.bonusCredits = (ws.bonusCredits or 0) + bonus

	for _, ply in ipairs(team.GetPlayers(TEAM_CWU)) do
		ply:AddChatText("[REFINERY] Recyclable processed! +" .. bonus .. " cr bonus. Total bonus: " .. ws.bonusCredits .. " cr")
	end
end