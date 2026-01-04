function meta:DrawWallhammerShield(wep)
	if not IsValid(self) or not IsValid(wep) then
		return
	end

    local ply = self
    local pos = wep:GetBonePosition(41)

    if not pos or not ply:IsWeaponRaised() then
		if IsValid(self.shield) then
        	self.shield:Remove()
		end

    end

    local matrix
	local weppos = wep:GetPos()

    if pos then
	    matrix = wep:GetBoneMatrix(41)
	    weppos = matrix:GetTranslation()
    end
	if (wep:GetClass() != "plutonic_osish" or self.ShieldActive != true) and IsValid(self.shield) then

		self.shield:Remove()
		return
    elseif wep:GetClass() != "plutonic_osish" or self.ShieldActive != true then
        return
	else
		if IsValid(self.shield) then
			if (self.shield:GetModel() and self.shield:GetModel() != "models/hunter/tubes/circle4x4.mdl") or !self.shield:GetModel() then
				self.shield:SetModel("models/hunter/tubes/circle4x4.mdl")
			end

            local shootpos = self:GetShootPos()
            local forward = self:GetForward()
            self.shield:SetModelScale(0.55)

            local forx, fory, forz = forward:Unpack()
            local bonepos = self:GetPos()
            local ZPos = 40

            if self:Crouching() then
                ZPos = 25
            end
			self.shield:SetPos(bonepos + (Vector(forx, fory, 0)* 40) + Vector(0, 0, ZPos))
            self.shield:SetAngles(ply:GetAngles() + Angle(90,0,0))


            local phys = self.shield:GetPhysicsObject()
            phys:EnableMotion(false)
			if self.shield:GetMaterial() != "effects/bluelaser2" then
				self.shield:SetMaterial("effects/bluelaser2")
			end

			if self.shield:GetCollisionGroup() != COLLISION_GROUP_WORLD then
				self.shield:SetCollisionGroup(COLLISION_GROUP_WORLD)
			end
		else
			self.shield = ents.Create("dg_shield")
			self.shield:SetModel("models/hunter/tubes/circle4x4.mdl")
			self.shield:SetPos(pos)
			self.shield:SetMaterial("effects/bluelaser2")
            self.shield:CPPISetOwner(self)
			self.shield:SetCollisionGroup(COLLISION_GROUP_WORLD)
            self.shield:Spawn()

            local phys = self.shield:GetPhysicsObject()
            phys:EnableMotion(false)
		end
	end
end