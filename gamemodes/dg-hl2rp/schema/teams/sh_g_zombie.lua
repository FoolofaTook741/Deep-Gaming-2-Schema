TEAM_ZOMBIE = impulse.Teams.Define({
	name = "Zombified Human",
	color = Color(75, 0, 0, 255),
	description = [[After prolonged exposure of a human head to a "headcrab" they commonly fall into a state where they hold no control over their own bodies and exhibit zombie like traits. This job is a work in progress, more variations of zombies will be added!]],
	loadout = {},
    model = "models/player/zombie_classic.mdl",
    handModel = "models/player/fast_arms.mdl",
	spawnLoc = true,
	salary = 100,
    Health = 400,
    percentLimit = true,
	limit = 0.15,
	xp = 2750,
    donatorOnly = false,
	cp = false,
    runSpeed = 120,
})

local fztable = {
    "npc/fast_zombie/fz_alert_close1.wav",
    "npc/fast_zombie/fz_alert_far1.wav",
    "npc/fast_zombie/idle1.wav",
    "npc/fast_zombie/idle2.wav",
    "npc/fast_zombie/idle3.wav",
    "npc/fast_zombie/wake1.wav"
}



hook.Add("OnPlayerChangedTeam", "zombienameset", function( ply, oldTeam, newTeam )
    local sid = ply:SteamID64()
    local buff = math.Clamp(GetSporeCount() * 15, 0, 200)
    if newTeam == TEAM_ZOMBIE then
        ply:AllowFlashlight(false)
        ply:ClearInventory(1)
        if ply:IsDonator() == true then
            local chance = math.random(1,100)
            if ply:SteamID() == "STEAM_0:1:505333923" then
                local zomleadchance = math.random(1,100)
                if zomleadchance < 50 then
                    timer.Create(sid .. "zombiemoans", 9, 1000, function()
                        local soundchance = math.random(1,2)
                        if soundchance == 1 then
                            ply:EmitSound("npc/zombine/zombine_alert" .. math.random(1,7) .. ".wav")
                        else
                            ply:EmitSound("npc/zombine/zombine_idle" .. math.random(1,4) .. ".wav")
                        end
                    end)
                    timer.Simple(1, function()
                        ply:SetRPName("Zombine Elite")
                    end)
                    ply:SetModel("models/player/combine_zombie_player_new.mdl")
                    ply:SetSkin(3)
                    ply:SetNoTarget(true)
                    ply:GiveInventoryItem("item_corruptedheart", 1, true)
                    ply:GiveInventoryItem("monster_popcorn", 1, true)
                    ply:SetHealth(650 + buff)
                    ply:SetArmor(250)
                    ply:Give("weapon_braaains")
                    ply:SetWalkSpeed(85)
                    ply:SetRunSpeed(160)
                    ply.RegularZombie = false
                    ply.Zombine = true
                    ply.FastZombie = false
                    ply:SetJumpPower( 200 )
                else
                    timer.Create(sid .. "zombiemoans", 9, 1000, function()
                        ply:EmitSound(fztable[math.random(1,6)])
                    end)
                    timer.Simple(1, function()
                        ply:SetRPName("Fast Zombie")
                    end)
                    ply:SetModel("models/player/fast_zombie.mdl")
                    ply:SetNoTarget(true)
                    ply:GiveInventoryItem("item_corruptedheart", 1, true)
                    ply:GiveInventoryItem("monster_speedboost", 1, true)
                    ply:SetHealth(80 + buff)
                    ply:Give("weapon_braaains")
                    ply:SetWalkSpeed(120)
                    ply:SetRunSpeed(170)
                    ply:SetJumpPower( 600 )
                    ply.RegularZombie = false
                    ply.Zombine = false
                    ply.FastZombie = true
                end
            elseif chance < 15 then
                timer.Simple(1, function()
                    ply:SetRPName("Zombified Civilian")
                end)
                ply:SetModel("models/player/classic_zombie_player_new.mdl")
                ply:SetBodygroup(1, 0)
                ply:SetSkin(math.random(0,1))
                ply:GiveInventoryItem("item_corruptedheart", 1, true)
                ply:GiveInventoryItem("monster_corpseeat", 1, true)
                ply:GiveInventoryItem("monster_heavyhands", 1, true)
                ply:SetRunSpeed(120)
                ply:SetWalkSpeed(60)
                ply:SetHealth(225 + buff)
                ply:Give("weapon_zombie")
                ply:SetNoTarget(true)
                ply.RegularZombie = true
                ply.Zombine = false
                ply.FastZombie = false
                ply:SetJumpPower( 200 )
                timer.Create(sid .. "zombiemoans", 9, 1000, function()
                    ply:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1,14) .. ".wav")
                end)
            elseif chance < 35 then
                timer.Simple(1, function()
                    ply:SetRPName("Zombified Rebel")
                end)
                ply:SetModel("models/player/classic_zombie_player_new.mdl")
                ply:SetBodygroup(1, 0)
                ply:SetSkin(math.random(2,5))
                ply:GiveInventoryItem("item_corruptedheart", 1, true)
                ply:GiveInventoryItem("monster_corpseeat", 1, true)
                ply:GiveInventoryItem("monster_enhancedvision", 1, true)
                ply:SetRunSpeed(130)
                ply:SetWalkSpeed(70)
                ply:SetHealth(250 + buff)
                ply:Give("weapon_zombie")
                ply:SetNoTarget(true)
                ply.RegularZombie = true
                ply.Zombine = false
                ply.FastZombie = false
                ply:SetJumpPower( 200 )
                timer.Create(sid .. "zombiemoans", 9, 1000, function()
                    ply:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1,14) .. ".wav")
                end)
            elseif chance < 65 then
                timer.Simple(1, function()
                    ply:SetRPName("Zombified Metrocop")
                end)
                ply:SetModel("models/player/classic_zombie_player_new.mdl")
                ply:SetBodygroup(1, 0)
                ply:SetSkin(6)
                ply:GiveInventoryItem("item_corruptedheart", 1, true)
                ply:GiveInventoryItem("monster_corpseeat", 1, true)
                ply:GiveInventoryItem("monster_shockwave", 1, true)
                ply:SetWalkSpeed(85)
                ply:SetRunSpeed(170)
                ply:SetHealth(200 + buff)
                ply:Give("weapon_braaains")
                ply:SetNoTarget(true)
                ply.RegularZombie = true
                ply.Zombine = false
                ply.FastZombie = false
                ply:SetJumpPower( 200 )
                timer.Create(sid .. "zombiemoans", 9, 1000, function()
                    ply:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1,14) .. ".wav")
                end)
            elseif chance < 80 then -- was80
                timer.Create(sid .. "zombiemoans", 9, 1000, function()
                    local soundchance = math.random(1,2)
                    if soundchance == 1 then
                        ply:EmitSound("npc/zombine/zombine_alert" .. math.random(1,7) .. ".wav")
                    else
                        ply:EmitSound("npc/zombine/zombine_idle" .. math.random(1,4) .. ".wav")
                    end
                end)
                timer.Simple(1, function()
                    ply:SetRPName("Zombine")
                end)
                ply:SetModel("models/player/combine_zombie_player_new.mdl")
                ply:SetSkin(math.random(0, 1))
                ply:SetBodygroup(1, 0)
                ply:SetNoTarget(true)
                ply:GiveInventoryItem("item_corruptedheart", 1, true)
                ply:GiveInventoryItem("monster_kamikaze", 1, true)
                ply:SetHealth(300 + buff)
                ply:SetArmor(150)
                ply:Give("weapon_braaains")
                ply:SetWalkSpeed(100)
                ply:SetRunSpeed(185)
                ply:SetJumpPower( 200 )
                ply.RegularZombie = false
                ply.Zombine = true
                ply.FastZombie = false
            elseif chance < 99 then
                timer.Create(sid .. "zombiemoans", 9, 1000, function()
                    ply:EmitSound(fztable[math.random(1,6)])
                end)
                timer.Simple(1, function()
                    ply:SetRPName("Fast Zombie")
                end)
                ply:SetModel("models/player/fast_zombie.mdl")
                ply:SetNoTarget(true)
                ply:GiveInventoryItem("item_corruptedheart", 1, true)
                ply:GiveInventoryItem("monster_speedboost", 1, true)
                ply:SetHealth(80 + buff)
                ply:Give("weapon_braaains")
                ply:SetWalkSpeed(120)
                ply:SetRunSpeed(190)
                ply:SetJumpPower( 600 )
                ply.RegularZombie = false
                ply.Zombine = false
                ply.FastZombie = true
            else
                timer.Create(sid .. "zombiemoans", 9, 1000, function()
                    local soundchance = math.random(1,2)
                    if soundchance == 1 then
                        ply:EmitSound("npc/zombine/zombine_alert" .. math.random(1,7) .. ".wav")
                    else
                        ply:EmitSound("npc/zombine/zombine_idle" .. math.random(1,4) .. ".wav")
                    end
                end)
                timer.Simple(1, function()
                    ply:SetRPName("Zombine Elite")
                end)
                ply:SetModel("models/player/combine_zombie_player_new.mdl")
                ply:SetSkin(3)
                ply:SetNoTarget(true)
                ply:GiveInventoryItem("item_corruptedheart", 1, true)
                ply:GiveInventoryItem("monster_popcorn", 1, true)
                ply:SetHealth(550 + buff)
                ply:SetArmor(250)
                ply:Give("weapon_braaains")
                ply:SetWalkSpeed(80)
                ply:SetRunSpeed(155)
                ply:SetJumpPower( 200 )
                ply.RegularZombie = false
                ply.Zombine = true
                ply.FastZombie = false
            end
        else
            timer.Simple(1, function()
                ply:SetRPName("Zombified Civilian")
            end)
            ply:SetModel("models/player/classic_zombie_player_new.mdl")
            ply:SetBodygroup(1, 0)
            ply:SetSkin(math.random(0,1))
            ply:GiveInventoryItem("item_corruptedheart", 1, true)
            ply:GiveInventoryItem("monster_corpseeat", 1, true)
            ply:GiveInventoryItem("monster_heavyhands", 1, true)
            ply:SetRunSpeed(120)
            ply:SetWalkSpeed(60)
            ply:SetHealth(150 + buff)
            ply:Give("weapon_zombie")
            ply:SetNoTarget(true)
            ply.RegularZombie = true
            ply.Zombine = false
            ply.FastZombie = false
            ply:SetJumpPower( 200 )
            timer.Create(sid .. "zombiemoans", 9, 1000, function()
				if not IsValid(ply) then return end
                ply:EmitSound("npc/zombie/zombie_voice_idle" .. math.random(1,14) .. ".wav")
            end)
        end
    elseif oldTeam == TEAM_ZOMBIE then
        timer.Remove(sid .. "zombiemoans")
        ply:AllowFlashlight(true)
        ply:SetNoTarget(false) 
        if newTeam ~= TEAM_CREMATOR then
            ply:SetWalkSpeed(120)
            ply:SetJumpPower( 200 )
        end        
        if newTeam ~= TEAM_CREMATOR then
            if (newTeam == TEAM_CITIZEN or newTeam == TEAM_CWU) and ply:IsCharacterFemale() then
                ply:SetHealth(impulse.Config.DefaultFemaleHealth)
                ply:SetMaxHealth(impulse.Config.DefaultFemaleHealth)
            else
                ply:SetHealth(impulse.Config.DefaultMaleHealth)
                ply:SetMaxHealth(impulse.Config.DefaultMaleHealth)
            end
        end
        ply:SetArmor(0)
        ply.RegularZombie = false
        ply.Zombine = false
        ply.FastZombie = false
        if newTeam == TEAM_VORT or newTeam == TEAM_CITIZEN or newTeam == TEAM_CWU then
            local spawnLocation = impulse.Config.CitizenSpawnLocations and #impulse.Config.CitizenSpawnLocations > 0 and impulse.Config.CitizenSpawnLocations[math.random(1, #impulse.Config.CitizenSpawnLocations)] or ents.FindByClass("info_player_start")[math.random(1, #ents.FindByClass("info_player_start"))]:GetPos()
            if spawnLocation then
                ply:SetPos(spawnLocation)
            end
        end
    end
    if buff > 0 and newTeam == TEAM_ZOMBIE then
        ply:Notify("Your health has been increased by " .. buff .. " due to the presence of " .. GetSporeCount() .. " spores.")
    end
end)

hook.Add("OnPlayerChangedTeam", "zombieSpeedFix", function(ply, oldTeam, newTeam)
    if newTeam == TEAM_ZOMBIE or newTeam == TEAM_VORT then return end --zombie and vort hooks handles their own speed
    if oldTeam == TEAM_ZOMBIE then
        timer.Simple(0.1, function()
            if IsValid(ply) and ply:Team() ~= TEAM_ZOMBIE and ply:Team() ~= TEAM_CREMATOR then
                ply:SetRunSpeed(impulse.Config.JogSpeed)
                ply:SetWalkSpeed(impulse.Config.WalkSpeed)
            end
        end)
    end
end)

hook.Add("PlayerFootstep", "feet", function(ply, pos, foot, sound) 
    if ply:Team() == TEAM_ZOMBIE then
        if ply:GetModel() == "models/player/fast_zombie.mdl" then
            ply:EmitSound("npc/fast_zombie/foot" .. math.random(1,4) .. ".wav")
        elseif ply:Name() == "Zombine" or ply:Name() == "Zombine Elite" then
            ply:EmitSound("npc/zombine/gear" .. math.random(1,3) .. ".wav")
        else
            ply:EmitSound("npc/zombie/foot" .. math.random(1,3) .. ".wav")
        end
        return true
    end
end)
