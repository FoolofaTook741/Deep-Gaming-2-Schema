util.AddNetworkString("impulseHL2RPRankUse")
util.AddNetworkString("impulseHL2RPRankBecome")
util.AddNetworkString("impulseHL2RPTerminal")
util.AddNetworkString("impulseHL2RPTerminalLeave")
util.AddNetworkString("impulseHL2RPCameraView")
util.AddNetworkString("impulseHL2RPAddBOL")
util.AddNetworkString("impulseHL2RPDemoteCP")
util.AddNetworkString("impulseHL2RPDispatchAnnounce")
util.AddNetworkString("impulseHL2RPDispatchCityCode")
util.AddNetworkString("impulseHL2RPTerminalLeave")
util.AddNetworkString("impulseHL2RPCameraView")
util.AddNetworkString("impulseHL2RPChargesRequest")
util.AddNetworkString("impulseHL2RPChargesEdit")
util.AddNetworkString("impulseHL2RPRemoveBOL")
util.AddNetworkString("impulseHL2RPCivilUnrestStart")
util.AddNetworkString("impulseHL2RPDispatchAnnounce")
util.AddNetworkString("impulseHL2RPJoinRank")
util.AddNetworkString("impulseHL2RPSetBOL")
util.AddNetworkString("impulseSquadMake")
util.AddNetworkString("impulseSquadKick")
util.AddNetworkString("impulseHL2RPTearGasFX")
util.AddNetworkString("impulseHL2RPOpenLocker")
util.AddNetworkString("impulseHL2RPOpenLocker")
util.AddNetworkString("impulseHL2RPUseLocker")

--[[net.Receive("impulseHL2RPRankBecome", function()
    local division = net.ReadUInt(8)
	local rank = net.ReadUInt(8)
    local ply = net.ReadEntity()
    local team = ""
    local ranktwo = rank - 1
    if ply:Team() == TEAM_CP then
        team = "TEAM_CP"
        local plyrank = ply:GetTeamWhitelist(team)
        if plyrank >= ranktwo then
            if ply:CanBecomeTeamClass(division, true) then
                ply:ClearInventory(1)
                ply:SetTeamClass(division)
                ply:SetTeamRank(rank)
                ply:EmitSound( "ambient/levels/prison/radio_random12.wav", SNDLVL_NORM)
                ply:EmitSound( "items/suitchargeok1.wav", SNDLVL_NORM)
                ply:Notify( "You have changed your rank and division.")
            else
                ply:Notify("You must be promoted or whitelisted to use this role.")
            end
        end
    elseif ply:Team() == TEAM_OTA then
        team = "TEAM_OTA"
        local plyrank = ply:GetTeamWhitelist(team)
        if plyrank >= ranktwo then
            if ply:CanBecomeTeamClass(division, true) then
                if rank == RANK_OWG && (division == CLASS_MACE or division == CLASS_ECHO) then
                    ply:ClearInventory(1)
                    ply:SetTeamClass(division)
                    ply:SetTeamRank(rank)
                    ply:EmitSound( "ambient/levels/prison/radio_random12.wav", SNDLVL_NORM)
                    ply:EmitSound( "items/suitchargeok1.wav", SNDLVL_NORM)
                    ply:Notify( "You have changed your rank and division.")
                elseif rank != RANK_OWG then
                    ply:ClearInventory(1)
                    ply:SetTeamClass(division)
                    ply:SetTeamRank(rank)
                    ply:EmitSound( "ambient/levels/prison/radio_random12.wav", SNDLVL_NORM)
                    ply:EmitSound( "items/suitchargeok1.wav", SNDLVL_NORM)
                    ply:Notify( "You have changed your rank and division.")
                else
                    ply:Notify("Grunt units may only be on MACE or ECHO until they are promoted.")
                end
            else
                ply:Notify("You cannot become this rank or division.")
            end
        else
            ply:Notify("You must be promoted or whitelisted to use this role.")
        end
    elseif ply:Team() == TEAM_PT then
        team = "TEAM_PT"
        local plyrank = ply:GetTeamWhitelist(team)
        if plyrank < 1 then
            ply:Notify("You are not whitelisted to the Purge Trooper faction.")
        else
            if plyrank >= ranktwo then
                if ply:CanBecomeTeamClass(division, true) then
                    ply:ClearInventory(1)
                    ply:SetTeamClass(division)
                    ply:SetTeamRank(rank)
                    ply:EmitSound( "ambient/levels/prison/radio_random12.wav", SNDLVL_NORM)
                    ply:EmitSound( "items/suitchargeok1.wav", SNDLVL_NORM)
                    ply:Notify( "You have changed your rank and division.")
                end
            end
        end
    elseif ply:Team() == TEAM_BCW then
        if ply:CanBecomeTeamClass(division, true) then
            ply:ClearInventory(1)
            ply:SetTeamClass(division)
            ply:SetTeamRank(rank)
            ply:EmitSound( "ambient/levels/prison/radio_random12.wav", SNDLVL_NORM)
            ply:EmitSound( "items/suitchargeok1.wav", SNDLVL_NORM)
            ply:Notify( "You have changed your rank and division.")
        end
    else
        ply:Notify("You are not whitelisted for this rank.")
    end
end)
]]