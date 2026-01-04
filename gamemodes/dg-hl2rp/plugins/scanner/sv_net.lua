util.AddNetworkString("impulseHL2RPDeployScanner")
util.AddNetworkString("impulseHL2RPStartScanning")
util.AddNetworkString("impulseHL2RPFinishScanning")
util.AddNetworkString("impulseHL2RPExitScanner")
util.AddNetworkString("impulseHL2RPScannerAlert")
util.AddNetworkString("impulseHL2RPScannerScan")
util.AddNetworkString("DeepScannerTag")
util.AddNetworkString("impulseHL2RPScannerBlind")

net.Receive("impulseHL2RPDeployScanner",function(len,ply)
    -- 2 checks, 1 notifies 1 doesnt. to save on netstream hook being exploited
    if (ply.rateLimitScanner or 0) > CurTime() then
        return
    end

    ply.rateLimitScanner = CurTime() + 1
    if (ply.nextScannerDeploy or 0) > CurTime() then
        return ply:Notify("Please wait " .. string.NiceTime(ply.nextScannerDeploy - CurTime()) .. " before attempting to deploy another scanner.")
    end

	ply.nextScannerDeploy = CurTime() + 90

    if not ply:IsCP() then
        return 
    end
    if not (ply:GetTeamClass() == CLASS_GRID) and not (ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_NOMAD) and not (ply:GetTeamRank() >= RANK_OFC and ply:Team() == TEAM_CP) then
        return ply:Notify("You must be a GRID/NOMAD unit to deploy Scanners!")
    end

    if ply:IsScanner() then
        return
    end

    ply.PreScannerName = ply:Name()
    ply.PreScannerTeam = ply:Team()
    ply.PreScannerModel = ply:GetModel()
    ply.PreScannerPos = ply:GetPos()
    ply.PreScannerRank = ply:GetTeamRank()
    ply.PreScannerClass = ply:GetTeamClass()

    ply:SetRPName(impulse.MakeScannerTagline(),false)

    for v,k in ipairs(team.GetPlayers(TEAM_CP)) do
        k:SendCombineMessage(ply:Name() .. " IS ONLINE",Color(0,0,0))
    end

    local scanner = ents.Create("impulse_hl2rp_scanner")
    scanner:SetPos(impulse.Config.ScannerSpawnPos)
    scanner:Spawn()
    scanner:setPilot(ply)

    if (ply:GetTeamRank() >= RANK_OFC and ply:Team() == TEAM_CP) then
	ply:SetRPName(impulse.MakeScannerTagline("disp"),false)
        scanner:SetHP(75)
    end

    if ply:Team() == TEAM_OTA and ply:GetTeamClass() == CLASS_NOMAD then
        ply:SetRPName(impulse.MakeScannerTagline("claw"),false)
        scanner:setClawScanner()
    end
end)

net.Receive("impulseHL2RPExitScanner",function(len,ply)
    if (ply.nextTryScannerQuit or 0) > CurTime() then
        return 
    end
    ply.nextTryScannerQuit = CurTime() + 1

    if not ply:IsCP() then
        return 
    end

    if not ply:IsScanner() then
        return
    end

    local scanner = ply:GetScannerFromPlayer()

    if IsValid(scanner) then
        scanner:Remove()
        ply.nextScannerDeploy = CurTime() + 90
        ply:ScreenFade(SCREENFADE.IN, Color(0,0,0), 1, 0.01)
        ply:Spawn()
        ply:SetTeam(ply.PreScannerTeam)
        ply:SetTeamClass(ply.PreScannerClass)
        ply:SetTeamRank(ply.PreScannerRank)
        ply:SetPos(ply.PreScannerPos)
        ply:SetRPName(ply.PreScannerName,false)
    end
end)

net.Receive("impulseHL2RPScannerScan",function(len,ply)
    if (ply.nextTryScannerScan or 0) > CurTime() then
        return 
    end
    ply.nextTryScannerScan = CurTime() + 1

    if not ply:IsCP() then
        return 
    end

    if not ply:IsScanner() then
        return
    end

    local scanner = ply:GetScannerFromPlayer()

    if IsValid(scanner) then

    end
end)
