TEAM_CREMATOR = impulse.Teams.Define({
    name = "Cremator",
    spawnLoc = true,
    color = Color(139, 69, 0, 255),
    description = [[A gaunt, silent Combine sanitation unit that prowls city streets, incinerating corpses, contraband, and anything else deemed undesirable.]],
    loadout = {},
    model = "models/player/rtb_cremator_pm.mdl",
    salary = 100,
    Health = 450,
    runSpeed = 60,
    percentLimit = false,
    limit = 3,
    xp = 0,
    donatorOnly = false,
    collaboratorOnly = true,
    cp = true,
    iconFOV = 12.810888252149,
    iconCamPos = Vector(9.1690540313721, 106.36103057861, 79.770774841309),
    iconLookAt = Vector(0, 0, 83.438395415473),
    doorGroup = {1, 2, 3, 7},
})

hook.Add("PlayerFootstep", "CrematorFootsteps", function(ply, pos, foot, soundName)
    if ply:Team() == TEAM_CREMATOR then
        return true
    end
end)

if SERVER then
    hook.Add("Think", "CrematorSprintSoundServer", function()
        for _, ply in ipairs(team.GetPlayers(TEAM_CREMATOR)) do
            if not IsValid(ply) or not ply:Alive() then continue end
            
            local sprinting = ply:KeyDown(IN_SPEED) and ply:OnGround()
            
            if sprinting then
                if not ply._crematorSprintSound then
                    ply._crematorSprintSound = CreateSound(ply, "npc/cremator/amb_loop.wav")
                    ply._crematorSprintSound:Play()
                end
            else
                if ply._crematorSprintSound then
                    ply._crematorSprintSound:Stop()
                    ply._crematorSprintSound = nil
                end
            end
        end
    end)
end

if CLIENT then
    hook.Add("EntityEmitSound", "CrematorFootstepBlock", function(data)
        local ent = data.Entity
        if not IsValid(ent) or not ent:IsPlayer() then return end
        if ent:Team() ~= TEAM_CREMATOR then return end
        if ent ~= LocalPlayer() then return end 
        local snd = data.SoundName:lower()
        if snd:find("npc/cremator/foot") and not ent._playingCrematorFootstep then
            return false
        end
    end)

    hook.Add("Think", "CrematorFootstepsThink", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        if ply:Team() ~= TEAM_CREMATOR then return end
        if not ply:Alive() then return end
        if not ply:OnGround() then return end
        
        local vel = ply:GetVelocity()
        local speed = vel:Length2D()
        
        if speed < 10 then return end
        
        if not ply.NextCrematorFootstep then ply.NextCrematorFootstep = 0 end
        
        local interval = speed > 100 and 0.4 or 0.6
        
        if CurTime() > ply.NextCrematorFootstep then
            ply.NextCrematorFootstep = CurTime() + interval
            ply._playingCrematorFootstep = true
            ply:EmitSound("npc/cremator/foot" .. math.random(1, 3) .. ".wav", 75, 100, 0.4)
            ply._playingCrematorFootstep = false
        end
    end)
end

hook.Add("OnPlayerChangedTeam", "CrematorSetup", function( ply, oldTeam, newTeam )
    if newTeam == TEAM_CREMATOR then
        ply:SetHealth(450)
        ply:SetJumpPower(120)
        ply:SetWalkSpeed(50)
        ply:SetSlowWalkSpeed(35)
        --ply:Give("weapon_immolator_beta_alt")
        ply:GiveInventoryItem("wep_immolator", 1, true)
        ply:Give("impulse_hands")
        ply:SetRPName("CW:CRM-"..math.random(1000,9999))
        --net.Start("impulseHL2RPCombineOverlayBoot")
		--net.Send(ply)
		--hook.Run("PlayerSetCombineRank", ply, rank, division)
    else
        ply:SetJumpPower(160)
        if ply._crematorSprintSound then
            ply._crematorSprintSound:Stop()
            ply._crematorSprintSound = nil
        end
    end
end)