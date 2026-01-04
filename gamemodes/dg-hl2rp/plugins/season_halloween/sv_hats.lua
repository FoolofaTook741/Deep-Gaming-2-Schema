local function gibSanta(ply)
    if ply:Team() != TEAM_OTA and ply:Team() != TEAM_CP then
        return    
    end

	if ply.beenInvSetup and not ply:HasInventoryItem("cos_hal_pumpkin") then
		ply:GiveInventoryItem("cos_hal_pumpkin", 1, true)
	end
end

hook.Add("PlayerChangeClass", "impulseHL2RPChangedClassSanta", gibSanta)
hook.Add("PlayerChangeRank", "impulseHL2RPChangedClassRankSanta", gibSanta)
hook.Add("PlayerSetCombineRank", "impulseHL2RPChangedCombineRankSanta", gibSanta)