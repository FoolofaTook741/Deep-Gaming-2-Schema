function PLUGIN:PlayerDeath(ply)
	ply:StopInsane()
end

function PLUGIN:OnPlayerChangedTeam(ply, oldTeam, newTeam)
	if newTeam != TEAM_CITIZEN or newTeam != TEAM_CWU then
		ply:StopInsane()
	end
end

function meta:StopInsane()
	self:SetLocalSyncVar(SYNC_INSANE, nil)

	if timer.Exists("impulseInsanityEvolution"..self:SteamID()) then
		timer.Remove("impulseInsanityEvolution"..self:SteamID())
	end
end

function meta:MakeInsane(level)
	level = level or 1

	self:SetLocalSyncVar(SYNC_INSANE, level)

	local lv = (5 - level)

	if lv != 0 then
		timer.Create("impulseInsanityEvolution"..self:SteamID(), 160, (5 - level), function()
			if IsValid(self) and self:GetSyncVar(SYNC_INSANE, nil) and self:Alive() then
				self:SetLocalSyncVar(SYNC_INSANE, math.Clamp(self:GetSyncVar(SYNC_INSANE, 0) + 1, 1, 5))

				local i = self:GetSyncVar(SYNC_INSANE, 0)
				if i == 5 then
					timer.Simple(math.random(200, 600), function()
						if IsValid(self) and self:GetSyncVar(SYNC_INSANE, nil) and self:Alive() then
							self:SetLocalSyncVar(SYNC_INSANE, 6)
						end
					end)
				elseif i == 2 then
					self:AchievementGive("ach_insane")
				end
			end
		end)
	end
end
