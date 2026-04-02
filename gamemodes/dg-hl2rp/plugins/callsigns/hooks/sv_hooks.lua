local WL_IDENTIFIERS = {
    [TEAM_CP] = {"CP_CS_LINE", "CP_CS_NUM"},
    [TEAM_OTA] = {"OTA_CS_LINE", "OTA_CS_NUM"}
}
function PLUGIN:PlayerSetCombineRank(ply, rank, div)
    if not ply:IsCP() then return end
    local wlName = WL_IDENTIFIERS[ply:Team()] or {"NULL", "NULL"}
    local callSignLine = (ply.Whitelists and ply.Whitelists[wlName[1]]) or -1
    local callSignNum  = (ply.Whitelists and ply.Whitelists[wlName[2]]) or -1
    --[[
    local callSignLine = ply:GetTeamWhitelist(wlName[1]) or -1
    local callSignNum = ply:GetTeamWhitelist(wlName[2]) or -1
    ]]--
    local callsigns = (ply:Team() == TEAM_CP) and CP_CALLSIGNS_LINES or OTA_CALLSIGNS_LINES
    
    if not callsigns[callSignLine] and ply:Team() ~= TEAM_CA then return end
    
    local code = (ply:Team() == TEAM_CP) and "MPF" or "CTA"
    local cpranktable = {"i4", "i3", "i2", "i1", "OfC", "SqL", "DvL", "DcO", "VCmD", "CmD"}
    local otaranktable = {"CGR", "CSO", "ECS", "CCP", "CTL", "ORD", "CSC"}
    local generatedName

    if ply:Team() == TEAM_CP then
        local rankStr
        if ply:GetTeamClass() == CLASS_SWORD and ply:GetTeamRank() == RANK_DVL then
            rankStr = "SDL"
        else
            rankStr = cpranktable[ply:GetTeamRank()]
        end

        generatedName = string.format("%s:%s.%s-%s", code, rankStr, callsigns[callSignLine or 1].NiceName or "SWAG", callSignNum)

        if ply:GetTeamClass() == CLASS_DISPATCH and ply:GetTeamRank() >= RANK_OFC then
            generatedName = "Operator "..ply:GetSavedRPName()
        elseif ply:GetTeamClass() == CLASS_DISPATCH and ply:GetTeamRank() < RANK_OFC then
            generatedName = "Junior Operator "..ply:GetSavedRPName()
        end
    elseif ply:Team() == TEAM_OTA then
        local otaClassMapping = {
            [CLASS_APF] = "ADL",
            [CLASS_FIST] = "ETL",
            [CLASS_PAYBACK] = "WDL",
            [CLASS_NOMAD] = "ABL",
            [RANK_ORD] = "ORD"
        }
        local otaRank = (ply:GetTeamRank() ~= RANK_ORD) and otaranktable[ply:GetTeamRank()] or otaClassMapping[ply:GetTeamClass()]
        generatedName = string.format("%s:%s.%s-%s", code, otaRank or "ORD", callsigns[callSignLine or 1].NiceName or "SWAG", callSignNum)

    end

    if ply:Team() ~= TEAM_CA then
        ply:SetRPName(generatedName)
        ply:SetSyncVar(SYNC_CALLSIGN_LINE, callSignLine or 1)
        ply:SetSyncVar(SYNC_CALLSIGN_NUM, callSignNum or 1)
        ply:Sync()
    end

    local function sendRankUpdate()
        local recipFilter = RecipientFilter()
        for _, k in pairs(player.GetAll()) do
            if k:IsCP() then recipFilter:AddPlayer(k) end
        end
        net.Start("impulseHL2RPJoinRank")
        net.WriteUInt(ply:EntIndex(), 8)
        net.WriteUInt(ply:Team(), 8)
        net.WriteUInt(ply:GetTeamClass(), 8)
        net.Send(recipFilter)
    end

    if (ply:IsCPCommand() or (ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_FIST)) then
        sendRankUpdate()
    elseif ply:Team() == TEAM_CA and ply:IsCPCommand() then
        sendRankUpdate()
    elseif ply:Team() == TEAM_STALKER then
        sendRankUpdate()
    end
end