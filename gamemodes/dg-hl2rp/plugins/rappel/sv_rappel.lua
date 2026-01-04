-- ALL CUSTOM WRRITEN BY YOURS TRULY (sophie THE SMARTEST MOTHERFUCKER)

meta.Rappel = nil

function meta:StartRappel(fStartLength, fDamping)

	if not self:OnGround() then
		return self:Notify("Please stand on the ground.")
	end

	self.Rappel = {}

	local myPos = self.GetPos( self )

	self.Rappel.Anchor = myPos
	self.Rappel.Length = fStartLength or 100
	self.Rappel.Damping = fDamping or 1.2
	local boneI
	if self:Team() == TEAM_VORT then
		boneI = self:LookupBone("ValveBiped.spine1")
	else
		boneI = self:LookupBone("ValveBiped.Bip01_Spine2")
	end
	local bonePos = self:GetBonePosition(boneI)
	bonePos = WorldToLocal(bonePos, Angle(), myPos, Angle())

	self.Rappel.Rope = constraint.Rope(
		self,
		Entity(0),
		0,
		0,
		bonePos,
		myPos,
		self.Rappel.Length,
		0,
		0,
		2,
		"cable/cable2"
	)

	local myIndex = self.EntIndex( self ) 

	timer.Create("landisRappel" .. myIndex, 0.05, 0, function()

		if not IsValid(self) then
			timer.Remove("landisRappel" .. myIndex)
			return
		end
		
		if not self:Alive() then
			self:StopRappel()
			return
		end

		if IsValid(self.Rappel.Rope) then
			self.Rappel.Rope:Remove()
		end

		local myPos2 = self.GetPos( self )
		local bonePos = self:GetBonePosition(boneI)

		self.Rappel.Rope = constraint.Rope(
			Entity(0),
			Entity(0),
			0,
			0,
			bonePos,
			myPos,
			self.Rappel.Length,
			0,
			0,
			2,
			"cable/cable2"
		)

	end)

end

function meta:StopRappel()

	if self.Rappel and IsValid(self.Rappel.Rope) then
		self.Rappel.Rope:Remove()
	end

	timer.Remove("landisRappel" .. self.EntIndex(self))

	self.Rappel = nil

end

function PLUGIN:SetupMove(ply, mv, cmd)

	if not ply.Rappel then return end
	if not istable(ply.Rappel) then return end

	local point = ply.Rappel.Anchor
	local leng = ply.Rappel.Length

	if not point then return end
	if not leng then return end

	if ply:KeyDown(IN_JUMP) then
		ply.Rappel.Length = ply.Rappel.Length - (FrameTime()*150)
	end

	if ply:KeyDown(IN_SPEED) then
		ply.Rappel.Length = ply.Rappel.Length + (FrameTime()*150)
	end
	
	local leng = ply.Rappel.Length

	local dirTo = (  point-ply:GetPos() ):GetNormalized()
	local len = math.max(ply:GetPos():Distance( point ) - leng, 0) 

	dirTo = dirTo * len

	local ovel = mv:GetVelocity()

	dirTo = dirTo + ovel

	if dirTo[3 ] > 0 then
		dirTo[3] = dirTo[3] / 1.2
	end

	mv:SetVelocity(dirTo)
end

function PLUGIN:OnPlayerChangedTeam(ply, oldTeam, newTeam)

	if ply.Rappel then
		ply:StopRappel()
	end

end