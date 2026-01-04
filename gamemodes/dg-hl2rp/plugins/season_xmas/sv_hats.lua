local function gibSanta(ply)
	if ply.beenInvSetup and not ply:HasInventoryItem("cos_santahat") then
		ply:GiveInventoryItem("cos_santahat", 1, true)
	end
end

hook.Add("PlayerLoadout", "impulseHL2RPPlayerSpawnSanta", gibSanta)
hook.Add("PostInventorySetup", "impulseHL2RPInvSetupSanta", gibSanta)
hook.Add("OnPlayerChangedTeam", "impulseHL2RPChangedTeamSanta", gibSanta)
hook.Add("PlayerChangeClass", "impulseHL2RPChangedClassSanta", gibSanta)
hook.Add("PlayerChangeRank", "impulseHL2RPChangedClassRankSanta", gibSanta)
hook.Add("PlayerSetCombineRank", "impulseHL2RPChangedCombineRankSanta", gibSanta)