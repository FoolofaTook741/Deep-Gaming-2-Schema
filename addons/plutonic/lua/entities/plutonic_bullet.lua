AddCSLuaFile()
ENT.Type = "anim"
ENT.Spawnable = false
function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	--self:SetMoveType(MOVETYPE_VPHYSICS)
	--self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
end

function ENT:DoFire(hit)
	if self.Fired then return end
	self.Fired = true
	if self.FireSound then
		self:EmitSound(self.FireSound)
	end

	self.OnFire(self, self:GetOwner(), hit or nil)
	timer.Simple(
		self.RemoveWait or 0,
		function()
			if IsValid(self) then
				if self.ProjRemove then
					self:ProjRemove()
				end

				self:Remove()
			end
		end
	)
end

function ENT:Think()
	if CLIENT then return end
	if self.Fired and self.ProjThink then
		self:ProjThink()
	end

	if self.Timer and self.Timer < CurTime() then
		self:DoFire()
	end

	-- pitch downward
	local dir = self:GetAngles()
	dir:RotateAroundAxis(self:GetRight(), -0.7)
	self:SetPos(self:GetPos() + (dir:Forward() * 400))
	self:SetAngles(dir)
	self:NextThink(CurTime() + 0.125)
end

function ENT:PhysicsCollide(colData, phys)
	if true then
		if colData and colData.HitEntity and IsValid(colData.HitEntity) then
			if colData.HitEntity == self:GetOwner() then return end
			local a = DamageInfo()
			a:SetDamagePosition(self:GetPos())
			a:SetDamage(self.Damage)
			colData.HitEntity:TakeDamageInfo(a)
			self:Remove()
		else
			self:DoFire()
		end
	elseif self.HitSound then
		self:EmitSound(self.HitSound)
	end
end