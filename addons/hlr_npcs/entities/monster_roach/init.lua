AddCSLuaFile("shared.lua")

include('shared.lua')

ENT.sModel = "models/decay/cockroach.mdl"
ENT.iBloodType = BLOOD_COLOR_YELLOW
ENT.bNeutral = true
ENT.sSoundDir = "npc/roach/"
ENT.CollisionBounds = Vector(12,12,4)

ENT.tblDeathActivities = {}

ENT.m_tbSounds = {
	["Death"] = "rch_die.wav",
	["Walk"] = "rch_walk.wav"
}

function ENT:OnInit()
	self:NoCollide("monster_roach")
	self:SetHullType(HULL_TINY)
	self:SetHullSizeNormal()
	self:SetCollisionBounds(self.CollisionBounds,Vector(self.CollisionBounds.x *-1,self.CollisionBounds.y *-1,0))
	
	self:SetMaxYawSpeed(10)
	self:CapabilitiesAdd(CAP_MOVE_GROUND)
	self.nextWander = 0
	self:SetHealth(2)
end

function ENT:ApplyCustomEntityDisposition(ent)
	self:AddEntityRelationship(ent,D_LI,100)
	if(ent:IsNPC()) then ent:AddEntityRelationship(self,D_LI,100) end
	return true
end

function ENT:OnThink()
	for k, v in ipairs(ents.FindInSphere(self:GetPos(), 10)) do
		if IsValid(v) && (v:IsNPC() || (v:IsPlayer() && v != self:GetPossessor()) || v:IsPhysicsEntity()) && v != self && v:GetClass() != self:GetClass() then
			self:TakeDamage(2)
		end
	end
end

function ENT:SelectSchedule()
	if self.bDead || tobool(GetConVarNumber("ai_disabled")) || CurTime() < self.schdWait then return end
	if CurTime() >= self.nextWander then
		self.nextWander = CurTime() +math.Rand(4,7)
		if !self:IsPossessed() then self:Wander() end
		self:PlaySound("Walk")
	end
end

function ENT:OnCondition(iCondition)
end

function ENT:DeathDecal()
	local tr = util.TraceLine({start = self:GetPos() +Vector(0,0,10), endpos = self:GetPos() -Vector(0,0,18), filter = self})
	if tr.HitWorld then
		util.Decal("YellowBlood",tr.HitPos +tr.HitNormal,tr.HitPos -tr.HitNormal)  
	end 
end

function ENT:OnTakeDamage(dmginfo)
	self:SetPos(Vector(self:GetPos().x, self:GetPos().y, self:GetPos().z +4))
	self:BloodSplash(self:OBBCenter())
	self:DeathDecal()
	self:EmitSound("npc/roach/rch_smash.wav", 100, 100)
	self:Remove()
end
