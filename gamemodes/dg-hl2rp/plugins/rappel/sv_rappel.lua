-- ALL CUSTOM WRRITEN BY YOURS TRULY (sophie THE SMARTEST MOTHERFUCKER)

util.AddNetworkString("landisRappelStart")
util.AddNetworkString("landisRappelStop")
util.AddNetworkString("landisRappelUpdate")

meta.Rappel = nil

function meta:StartRappel(fStartLength, fDamping)

	if not self:OnGround() then
		return self:Notify("Please stand on the ground.")
	end

	if self.Rappel then
		self:StopRappel()
	end

	local myPos = self:GetPos()
	local myIndex = self:EntIndex()

	local boneName

	if self:Team() == TEAM_VORT then
		boneName = "ValveBiped.spine1"
	else
		boneName = "ValveBiped.Bip01_Spine2"
	end

	local boneI = self:LookupBone(boneName)

	if not boneI then
		return self:Notify("Could not start rappel: missing bone.")
	end

	self.Rappel = {}
	self.Rappel.Anchor = myPos
	self.Rappel.Length = fStartLength or 100
	self.Rappel.Damping = fDamping or 1.2
	self.Rappel.BoneName = boneName
	self.Rappel.LastNetLength = self.Rappel.Length

	net.Start("landisRappelStart")
		net.WriteEntity(self)
		net.WriteVector(self.Rappel.Anchor)
		net.WriteString(self.Rappel.BoneName)
		net.WriteFloat(self.Rappel.Length)
	net.Broadcast()

	timer.Create("landisRappel" .. myIndex, 0.2, 0, function()

		if not IsValid(self) then
			timer.Remove("landisRappel" .. myIndex)
			return
		end

		if not self.Rappel then
			timer.Remove("landisRappel" .. myIndex)
			return
		end

		if not self:Alive() then
			self:StopRappel()
			return
		end

		if math.abs((self.Rappel.LastNetLength or 0) - self.Rappel.Length) >= 2 then
			self.Rappel.LastNetLength = self.Rappel.Length

			net.Start("landisRappelUpdate")
				net.WriteEntity(self)
				net.WriteFloat(self.Rappel.Length)
			net.Broadcast()
		end

	end)

end

function meta:StopRappel()

	timer.Remove("landisRappel" .. self:EntIndex())

	self.Rappel = nil

	net.Start("landisRappelStop")
		net.WriteEntity(self)
	net.Broadcast()

end

function PLUGIN:SetupMove(ply, mv, cmd)

	if not ply.Rappel then return end
	if not istable(ply.Rappel) then return end

	local point = ply.Rappel.Anchor
	local leng = ply.Rappel.Length

	if not point then return end
	if not leng then return end

	if ply:KeyDown(IN_JUMP) then
		ply.Rappel.Length = math.max(ply.Rappel.Length - (FrameTime() * 150), 30)
	end

	if ply:KeyDown(IN_SPEED) then
		ply.Rappel.Length = math.min(ply.Rappel.Length + (FrameTime() * 150), 2000)
	end
	
	leng = ply.Rappel.Length

	local dirTo = (point - ply:GetPos()):GetNormalized()
	local len = math.max(ply:GetPos():Distance(point) - leng, 0)

	dirTo = dirTo * len

	local ovel = mv:GetVelocity()

	dirTo = dirTo + ovel

	if dirTo[3] > 0 then
		dirTo[3] = dirTo[3] / (ply.Rappel.Damping or 1.2)
	end

	mv:SetVelocity(dirTo)

end

function PLUGIN:OnPlayerChangedTeam(ply, oldTeam, newTeam)

	if ply.Rappel then
		ply:StopRappel()
	end

end

hook.Add("PlayerDisconnected", "landisStopRappelDisconnect", function(ply)
	if ply.Rappel then
		ply:StopRappel()
	end
end)

hook.Add("PlayerDeath", "landisStopRappelDeath", function(ply)
	if ply.Rappel then
		ply:StopRappel()
	end
end)