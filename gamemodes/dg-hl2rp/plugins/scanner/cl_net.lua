target_cached = target_cached or nil 
target_scan_cam_pos = nil 
target_scan_cam_ang = nil
target_scan_ply_ang = nil
target_scan_ply_pos = nil 

net.Receive("impulseHL2RPStartScanning",function()
    local scanner = net.ReadEntity()
    local trg     = net.ReadEntity()

    target_cached = trg
    target_scan_cam_pos = LocalPlayer():EyePos() + Vector()
    target_scan_cam_ang = LocalPlayer():EyeAngles() + Angle()
    target_scan_ply_pos = target_cached:GetPos() + Vector()
    target_scan_ply_ang = target_cached:GetAngles() + Angle()

    
    table.ForceInsert(scanner.ScanningPlayers, trg)
end)

net.Receive("impulseHL2RPFinishScanning",function()
    local scanner = net.ReadEntity()
    local trg     = net.ReadEntity()
    table.RemoveByValue(scanner.ScanningPlayers, trg)
    table.ForceInsert(scanner.ScannedPlayers, trg)
end)

IllegalItems = IllegalItems or {}

net.Receive("impulseHL2RPScannerAlert", function()
    local spotter = net.ReadEntity()
    local illegal = net.ReadEntity()

    impulse.AddCombineWaypoint("CONTRABAND SPOTTED BY AIRWATCH", illegal:GetPos(), 90, 7, 4, 4, spotter)
end)

net.Receive("impulseHL2RPScannerBlind", function()
    local fadeTime = 3
    local startTime = CurTime()
    hook.Add("HUDPaint", "ScannerBlindEffect", function()
        local alpha = math.Clamp(255 * (1 - (CurTime() - startTime) / fadeTime), 0, 255)
        surface.SetDrawColor(255, 255, 255, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())
        if alpha <= 0 then
            hook.Remove("HUDPaint", "ScannerBlindEffect")
        end
    end)
end)