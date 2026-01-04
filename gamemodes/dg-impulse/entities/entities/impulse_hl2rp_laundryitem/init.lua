AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_bag001a.mdl")
	self:SetMaterial("models/props_c17/FurnitureFabric003a")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetColor(Color(153, 132, 73))
	self.spawnPos = self:GetPos()
	self.killTime = CurTime() + 700
	if not self.workers then self.workers = {} end
	self.state = 1

	local physObj = self:GetPhysicsObject()
	physObj:Wake()
end

function ENT:Use(caller, activator)
	if caller:Team() == TEAM_CWU and caller:GetTeamClass() == CLASS_INDUST then
		if self.state == 2 and self.isFoldable == true and not self.isFolded then
			self.isFolded = true
			self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
			self:SetMaterial("models/props_c17/FurnitureFabric003a")
			self:EmitSound("physics/cardboard/cardboard_box_break3.wav")
			self:SetStage(3)
		end
	end
end

function ENT:OnHandsPickup(ply)
	if not self.workers[ply] then
		self.workers[ply] = true
	end
end

function ENT:CanHandsPickup(ply)
	return ply:Team() == TEAM_CWU and ply:GetTeamClass() == CLASS_INDUST
end

function ENT:Think()
	if self.spawnPos:DistToSqr(self:GetPos()) > 1500 ^ 2 then
		self:Remove()
	end

	if self.killTime < CurTime() then
		self:Remove()
	end

	self:NextThink(CurTime() + 10)
	
	return true
end