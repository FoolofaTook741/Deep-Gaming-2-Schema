TEAM_STALKER = impulse.Teams.Define({
	name = "Stalkerized Human",
	color = Color(0, 0, 0, 255),
	description = [[A human given the ultimate punishment...]],
	loadout = {},
    model = "models/stalker.mdl",
	spawnLoc = true,
	salary = 100,
    Health = 500,
    runSpeed = 110,
    percentLimit = true,
	limit = 0.15,
	xp = 9999999,
    donatorOnly = false,
	cp = true,
})

hook.Add("PlayerFootstep", "StalkerFootsteps", function(ply, pos, foot, sound) 
    if not ply.NextFootstep then
        ply.NextFootstep = 0
    end
    if ply:Team() == TEAM_STALKER and CurTime() > ply.NextFootstep then
        ply:EmitSound("npc/stalker/stalker_footstep_left1.wav")
        ply.NextFootstep = CurTime() + 0.6
        return true
    elseif ply:Team() == TEAM_STALKER then
        return true
    end
end)

hook.Add("OnPlayerChangedTeam", "StalkerSetup", function( ply, oldTeam, newTeam )
    if newTeam == TEAM_STALKER then
        ply:SetHealth(500)
        ply:SetJumpPower(120)
        ply:SetWalkSpeed(80)
        ply:SetSlowWalkSpeed(40)
        ply:Give("weapon_stalker")
        ply:Give("impulse_hands")
        ply:SetRPName("CMB:STLK-"..math.random(1000,9999))
        net.Start("impulseHL2RPCombineOverlayBoot")
		net.Send(ply)
		hook.Run("PlayerSetCombineRank", ply, rank, division)
    else
        ply:SetJumpPower(160)
    end
end)