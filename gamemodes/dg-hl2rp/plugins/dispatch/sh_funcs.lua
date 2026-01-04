function impulse.Dispatch.AnnounceBlockSearch(block)
    impulse.Dispatch.Announce(3)
    block:Notify("Your block is under civil inspection, Assume your inspection position.")

    for v,k in pairs(team.GetPlayers(TEAM_CP)) do
        timer.Simple(2, function()
            k:SendCombineMessage("ALL AVAILABLE PROTECTION TEAMS, PREPARE FOR RESIDENTIAL INSPECTION OF ".. string.upper(block.name), Color(216, 159, 45))
        end)
    end

    timer.Simple(30, function() 
        impulse.Dispatch.Announce(4)  
    end)
end
 
function impulse.Dispatch.Manhunt(ply)  
    if !IsValid(ply) then return end
    ply.IsWanted = true
    local msg = "Individual (" .. ply:GetSavedRPName() .. ") you are convicted of multi anti-civil violations. Implicit citizenship revoked. Status: Malignant."
    local msg2 = "Individual (" .. ply:GetSavedRPName() .. "), you are charged with socio-endangerment level 1. Protection units, prosecution code: DUTY, SWORD, MIDNIGHT."
    for k,v in pairs(player.GetAll()) do
        v:SendChatClassMessage(168, msg, ply)
    end
    for v,k in pairs(team.GetPlayers(TEAM_CP)) do
        timer.Simple(2, function()
            k:SendCombineMessage("ALL PROTECTION TEAM MEMBERS, ".. string.upper(ply:GetSavedRPName()) .." HAS BEEN MARKED PRIORITY ONE SUSPECT, BOL FOR TARGET.")
        end)
    end
    timer.Simple(60, function()
        for k,v in pairs(player.GetAll()) do
            v:SendChatClassMessage(168, msg2, ply)
        end
    end)  
    net.Start("DeepPlaySound")
    net.WriteString("npc/overwatch/cityvoice/f_citizenshiprevoked_6_spkr.wav")
    net.WriteUInt(0, 10)
    net.Broadcast()
    net.Start("DeepPlaySound")
    net.WriteString("npc/overwatch/cityvoice/f_sociolevel1_4_spkr.wav")
    net.WriteUInt(60, 10)
    net.Broadcast()
    local embeds = {{
        title = "Manhunt Issued",
        description = "A user has given an order.",
        url = "https://discord.com/channels/1149540724648456252/1186351119232925808",
        color = 11027200,
        fields = {
            {
                name = "Target:",
                value = ply:Name()
            },
        }
    }}
    
    ReqwestLog(embeds, DG_CAL)
end
 
impulse.Dispatch.CityCodes = {
    [1] = {"STABLE", Color(0, 255, 0)}, 
    [2] = {"MARGINAL", Color(255, 165, 0)},
    [3] = {"FRACTURED", Color(255, 101, 0)},
    [4] = {"AUTONOMOUS JUDGEMENT", Color(255, 0, 0)},
    [5] = {"JUDGEMENT WAIVER", Color(139, 0, 0)},
    [6] = {"SECTOR LOST", Color(50, 0, 0)} 
}

CODE_CIVIL = 1
CODE_UNREST = 2 
CODE_FRACTURED = 3
CODE_JW = 4
CODE_AJ = 5
CODE_LOST = 6
    
function impulse.Dispatch.GetCityCode()
    return GetGlobalInt("CityCode", 1)
end

local function findAndFire(pos)
    for v,k in pairs(ents.FindByClass("func_button")) do
        if pos:DistToSqr(k:GetPos()) < (9 ^ 2) then
            k:Fire("use")
        end
    end
end

local LoadedSounds
if CLIENT then
	LoadedSounds = {} -- this table caches existing CSoundPatches
end


function globalsound(FileName)
    local sound
    local filter
    local volume 
    if SERVER then
        filter = RecipientFilter()
        filter:AddAllPlayers()
    end
    if SERVER or !LoadedSounds[FileName] then
		-- The sound is always re-created serverside because of the RecipientFilter.
		sound = CreateSound( game.GetWorld(), FileName, filter ) -- create the new sound, parented to the worldspawn (which always exists)
		if sound then
			sound:SetSoundLevel( 0 ) -- play everywhere
			if CLIENT then
				LoadedSounds[FileName] = { sound, filter } -- cache the CSoundPatch
			end
		end
	else
		sound = LoadedSounds[FileName][1]
		filter = LoadedSounds[FileName][2]
	end
	if sound then
		if CLIENT then
			sound:Stop() -- it won't play again otherwise
		end
		sound:Play()
	end
    return sound 
end  

local time = 0
local nextCityCodeSetup = 0
function impulse.Dispatch.SetupCityCode(code)
    if SERVER then
        local lastCityCode = LAST_CITYCODE or 1

        if code == lastCityCode then
            return
        end

        if code != CODE_CIVIL then
            time = CurTime()
            net.Start("DeepFracturedTimer")
            net.WriteFloat(time)
            net.Broadcast()
        end

        if nextCityCodeSetup > CurTime() then
            return 
        end

        local doWait = false 
  
        if lastCityCode == CODE_JW then
            if impulse.Config.JWDirectOff then
                ents.FindByName(impulse.Config.JWDirectOff)[1]:Fire("use")
            elseif impulse.Config.JWButtonPos then
                findAndFire(impulse.Config.JWOffButtonPos or impulse.Config.JWButtonPos)
                doWait = true
            end
        end

        --[[if lastCityCode >= 3 and code < 3 then
            net.Start("DeepResetSocioScore")
            net.Broadcast()
        end]]

        if lastCityCode >= CODE_JW and code < CODE_JW then
            timer.Simple(60, function()
                timer.UnPause("rationcycle")
                timer.UnPause("rationnotice")
            end)
        end
 
        if code == CODE_JW then
            impulse.RationsActive = false
            timer.Adjust("rationcycle", 60, 1, function() timer.Remove("rationcycle") end)
            timer.Pause("rationcycle")
            timer.Remove("rationnotice")
            if impulse.Config.JWDirectOn then
                ents.FindByName(impulse.Config.JWDirectOn)[1]:Fire("use")
            elseif impulse.Config.JWButtonPos then
                findAndFire(impulse.Config.JWButtonPos)
            end
            timer.Simple(1.5, function()
                for k, v in pairs(player.GetAll()) do
                    if v:Team() == TEAM_CP then
                        v:EmitSound("npc/overwatch/radiovoice/socialfractureinprogress.wav")
                    end
                end
            end)
            impulse.OOCClosed = true
        end   

        if code == CODE_AJ then
            if impulse.Config.AJDirectOn then
                ents.FindByName(impulse.Config.AJDirectOn)[1]:Fire("use")
            elseif impulse.Config.AJButtonPos then
                findAndFire(impulse.Config.AJButtonPos)
            end
        end

        if lastCityCode >= CODE_AJ then
            for k,v in pairs(player.GetAll()) do
                if v:Team() == TEAM_OTA and v:GetTeamRank() >= RANK_ORD then
                    v:StripWeapon("plutonic_ar1o")
                end
            end
            if impulse.Config.AJDirectOff then
                ents.FindByName(impulse.Config.AJDirectOff)[1]:Fire("use")
            elseif impulse.Config.AJButtonPos then
                findAndFire(impulse.Config.AJOffButtonPos or impulse.Config.AJButtonPos)
                doWait = true
            end
        end


        /*if lastCityCode == CODE_AJ or lastCityCode == CODE_LOST or lastCityCode == CODE_JW then
            for k, v in pairs(player.GetAll()) do
                v:ConCommand("stopsound")
            end
            timer.Remove("ajbuzzer")
            timer.Remove("ajbuzzer1")
            timer.Remove("jwbuzzzer")
            timer.Remove("lostbuzzer1")
            timer.Remove("lostbuzzer2")
            timer.Simple(4.5, function()
                globalsound("ambient/levels/labs/machine_stop1.wav" )
            end)
            timer.Simple(6, function() globalsound( "ambient/machines/wall_move1.wav") end)
            timer.Simple(7, function()
                globalsound( "ambient/levels/labs/machine_stop1.wav" )
            end)
            timer.Simple(10, function() 
                globalsound( "ambient/levels/labs/machine_stop1.wav")
            end)
            timer.Simple(12, function() globalsound( "ambient/machines/wall_move1.wav") end)
        end     */

        /*if lastCityCode == CODE_JW and code < CODE_AJ then
            timer.Remove("city8jwbuzzer")
            timer.Remove("city18buzzer")
            for k, v in pairs(player.GetAll()) do
                v:ConCommand("stopsound")
            end
            timer.Simple(7, function() 
                for k, v in pairs(player.GetAll()) do
                    v:SendLua([[surface.PlaySound("ambient/levels/labs/machine_stop1.wav")]])
                end
            end)
            timer.Simple(10, function() 
                for k, v in pairs(player.GetAll()) do
                    v:SendLua([[surface.PlaySound("ambient/levels/labs/machine_stop1.wav")]])
                end
            end)
            timer.Simple(11, function() 
                for k, v in pairs(player.GetAll()) do
                    v:SendLua([[surface.PlaySound("ambient/levels/labs/machine_stop1.wav")]])
                end
            end)
        end*/

        if lastCityCode >= CODE_JW and code < CODE_JW then
            timer.Remove("rationnotice")
            timer.Pause("rationcycle")
        end

        timer.Simple(2, function()  
            if code == 2 then
                for k, v in pairs(player.GetAll()) do
                    v:SendLua([[surface.PlaySound("ambient/cmb_alarm.mp3")]])
                end
                timer.Simple(3, function() 
                    for k, v in pairs(player.GetAll()) do
                        if v:Team() == TEAM_CP then
                            v:EmitSound("npc/overwatch/radiovoice/politistablizationmarginal.wav")
                        end 
                    end 
                end)
            end  

            if lastCityCode == CODE_AJ then
                for k,v in pairs(ents.FindByModel("models/effects/intro_vortshield.mdl")) do
                    v:Remove()
                end
            end

            if code == CODE_FRACTURED then
                for k, v in pairs(player.GetAll()) do
                    v:SendLua([[surface.PlaySound( "c24v3/social_infection.mp3" )]])
                end
            end

            /*if code == CODE_AJ then
                if lastCityCode == CODE_JW or lastCityCode == CODE_AJ then
                    for k, v in pairs(player.GetAll()) do
                        v:ConCommand("stopsound")
                    end
                end
                timer.Remove("city18buzzer")
                timer.Simple(3, function()
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav" )]])
                    end
                    timer.Simple(5, function() 
                        for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound("npc/overwatch/cityvoice/f_protectionresponse_5_spkr.wav")]]) 
                        end
                    end)
                    timer.Simple(8, function() 
                        for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav")]])
                        end
                    end) 
                    timer.Simple(12, function() 
                        for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/citadel/weaponstrip1_adpcm.wav")]])
                        end
                    end)
                    timer.Simple(26, function() 
                        for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/citadel/portal_open1_adpcm.wav")]]) 
                        end
                    end)
                    if impulse.Config.OverworldPortalModel and impulse.Config.OverworldPortalPos then
                        timer.Simple(29, function() 
                            local overworldportal = ents.Create("prop_physics")
                            overworldportal:SetModel(impulse.Config.OverworldPortalModel)
                            overworldportal:SetPos(impulse.Config.OverworldPortalPos)
                            if impulse.Config.OverworldPortalAng then
                                overworldportal:SetAngle(impulse.Config.OverworldPortalAng)
                            end
                            if impulse.Config.OverworldPortalScale then
                                overworldportal:SetScale(impulse.Config.OverworldPortalScale)
                            end
                            overworldportal:Spawn()
                        end)
                    end
                    timer.Simple(30.5, function() 
                        for k, v in pairs(player.GetAll()) do
                            v:SendLua([[surface.PlaySound( "ambient/levels/citadel/zapper_ambient_loop1.wav" )]])
                        end
                    end)
                    timer.Create("ajbuzzer1", 30.5, 2500, function() 
                        for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/citadel_alert_loop2.wav" )]])  
                        end
                    end)
                    impulse.OOCClosed = true
                end)
            end   */

            /*if code == CODE_JW then
                timer.Simple(3, function()
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav" )]])  
                    end
                end)
                timer.Simple(6, function()
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "npc/overwatch/cityvoice/f_protectionresponse_4_spkr.wav" )]])  
                    end
                end)
                timer.Simple(8, function()
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav" )]])  
                    end
                end)
                timer.Simple(10, function()
                    timer.Create("jwbuzzzer", 30, 0, function()
                        for k, v in pairs(player.GetAll()) do
                            v:SendLua([[surface.PlaySound( "ambient/alarms/citadel_alert_loop2.wav" )]])  
                        end
                    end)
                end)
            end*/

            if code == CODE_UNREST or code == CODE_CIVIL then
                timer.Remove("city18buzzer")
                impulse.OOCClosed = false
            end
            
            if code == CODE_LOST then 
                timer.Remove("city18buzzer")
                for k, v in pairs(player.GetAll()) do 
                v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav" )]]) 
                end
                timer.Create("lostbuzzer2", 6, 2500, function() 
                    for k, v in pairs(player.GetAll()) do
                    v:SendLua([[surface.PlaySound( "city8/city8-jwbuzzer.wav" )]])
                    end
                end) 
                timer.Simple(8, function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/labs/machine_stop1.wav" )]])
                    end
                end) 
                timer.Simple(12, function() 
                    for k, v in pairs(player.GetAll()) do 
                        v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav" )]])
                    end 
                end)
                timer.Simple(3,  function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound("ambient/levels/labs/machine_stop1.wav")]])
                    end 
                end)
                timer.Simple(8, function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "npc/overwatch/cityvoice/fprison_restrictorsdisengaged.wav")]])
                    end 
                end)
                timer.Simple(12, function() 
                    for k, v in pairs(player.GetAll()) do 
                        v:SendLua([[surface.PlaySound( "ambient/levels/labs/machine_stop1.wav")]]) 
                    end
                end)
                timer.Simple(17, function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/labs/machine_stop1.wav")]])
                    end 
                end)
                timer.Simple(27, function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/labs/machine_stop1.wav")]]) 
                    end
                end)
                timer.Simple(29, function() 
                    for k, v in pairs(player.GetAll()) do 
                        v:SendLua([[surface.PlaySound( "ambient/machines/wall_move1.wav" )]])
                    end 
                end)
                timer.Simple(32, function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/labs/machine_stop1.wav")]]) 
                    end
                end)
                timer.Simple(30.5, function() 
                    for k, v in pairs(player.GetAll()) do
                        v:SendLua([[surface.PlaySound( "ambient/levels/citadel/zapper_ambient_loop1.wav" )]])
                    end
                end)
                impulse.OOCClosed = true
            end
        end) 
    end

 
    LAST_CITYCODE = code
    nextCityCodeSetup = CurTime() + 10
end 

function impulse.Dispatch.SetCityCode(code)
    return SetGlobalInt("CityCode", code)
end
  