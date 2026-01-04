
function meta:TearGasEffect()
	if not self.TearGassed then
		local reps = 0
		timer.Create("TearGasPly"..self:SteamID(), 2.66, 10, function()
			if not IsValid(self) then
				return 
			end

			if not self:Alive() then
				self.TearGassed = false
				return timer.Remove("TearGasPly"..self:SteamID())
			end

			if !self.HasGasMask or !self.DeepHazmatSuit or (self:Team() == TEAM_CWU and self:GetTeamClass() == CLASS_ICT) then
				self:EmitSound("ambient/voices/cough"..math.random(1, 4)..".wav")
				self:TakeDamage(1, nil, nil)
			end

			reps = reps + 1

			if reps >= 10 then
				self.TearGassed = false
				return timer.Remove("TearGasPly"..self:SteamID())
			end
		end)
	end

	if not self.TearGasFXed then
		net.Start("impulseHL2RPTearGasFX")
		net.Send(self)

		self:SetSyncVar(SYNC_GASSED, true, true)

		timer.Simple(6, function()
			if IsValid(self) then
				self.TearGasFXed = false
				self:SetSyncVar(SYNC_GASSED, false, true)
			end
		end)
	end

	self.TearGassed = true
	self.TearGasFXed = true
end
