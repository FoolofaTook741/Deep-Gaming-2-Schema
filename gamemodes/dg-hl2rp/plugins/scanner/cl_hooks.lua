surface.CreateFont("impulseHL2RPScannerFontLARGE", {
    font = "Lucida Sans Typewriter",
    antialias = true,
    outline = false,
    weight = 800,
    size = 64
})

local ScannedRebels = {}
local ScannedCitizens = {}

net.Receive("DeepScannerTag", function()
    local target = net.ReadEntity()
    local isarebel = net.ReadBool()
    if isarebel == true then
        table.insert(ScannedRebels, target)
        timer.Simple(40, function()
           table.RemoveByValue(ScannedRebels,target)
        end)
    else
        table.insert(ScannedCitizens, target)
        timer.Simple(8, function()
            table.RemoveByValue(ScannedCitizens,target)
        end)
    end
end)

hook.Add("PostDrawTranslucentRenderables", "scanneroutlines", function()
    local scannerESP = impulse.GetSetting("show_scanner_targets")
    local lp = LocalPlayer()
    if not IsValid(lp) then return end
    if lp:IsScanner() then
        local ang = lp:EyeAngles() + Angle()
        ang:RotateAroundAxis(ang:Up(), 180)

        if not lp:IsCP() then return end
        if not lp:IsScanner() then return end
        local scanner = lp:GetScannerFromPlayer()
        local trg = scanner:GetCurrentTarget()
        do
            if IsValid(trg) then
                if trg:GetMoveType() == MOVETYPE_NOCLIP then
                    return
                end
                local known = scanner:IsPlayerKnown(trg)
                local scanning = scanner:IsPlayerScanning(trg)
                local name = known and trg:Name() or (scanning and "<SCANNING...>" or "<UNKNOWN>")
                local clr = known and team.GetColor(trg:Team()) or color_white

                local targets = {trg}

                --halo.Add(targets,clr, 2, 2, 1, true, false)
                outline.Add(targets, clr, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
            end
        end



        local Ents = ents.FindInSphere(scanner:GetPos(), 300)
        for v,k in ipairs(Ents) do
            if k:IsPlayer() and not (k == lp) then
                -- prevent moderators from being seen in noclip
                if k:GetMoveType() == MOVETYPE_NOCLIP then
                    continue
                end
                local known = scanner:IsPlayerKnown(k)
                local scanning = scanner:IsPlayerScanning(k)
                local name = known and k:Name() or (scanning and "<SCANNING...>" or "<UNKNOWN>")
                local clr = known and team.GetColor(k:Team()) or color_white
                cam.Start3D2D(k:GetPos()+Vector(0,0,82),((k:GetPos()-scanner:GetPos()):GetNormalized()*Vector(-1,-1,0)):Angle() + Angle(0,90,90),0.1)
                    draw.SimpleTextOutlined(name,"impulseHL2RPScannerFontLARGE",0,0,clr,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,2,color_black)
                cam.End3D2D()
            end
        end
    elseif !lp:IsScanner() and (lp:Team() == TEAM_CP or lp:Team() == TEAM_OTA) and scannerESP then
        local colred = Color(255,0,0)
        local colyellow = Color(255,125,0)
       --halo.Add(ScannedRebels, colred, 5, 5, 2, true, true)
        outline.Add(ScannedRebels, colred, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
        --halo.Add(ScannedCitizens, colyellow, 5, 5, 2, true, true)
        outline.Add(ScannedCitizens, colyellow, OUTLINE_MODE_BOTH, OUTLINE_RENDERTYPE_AFTER_EF, 1)
    end
end)

local math = math
local clamp = math.Clamp

function PLUGIN:Think()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if not ply:IsScanner() then return end
    local scanner = ply:GetScannerFromPlayer()
    scanner.Zoom = scanner.Zoom or 90
    if input.IsMouseDown(MOUSE_LEFT) then
        scanner.Zoom = clamp(scanner.Zoom-(FrameTime()*25),30,105)
    end
    if input.IsMouseDown(MOUSE_RIGHT) then
        scanner.Zoom = clamp(scanner.Zoom+(FrameTime()*25),30,105)
    end
end

function PLUGIN:CalcView(ply,origin,angles,fov)
    if not ply:IsScanner() then return end
    local scanner = ply:GetScannerFromPlayer()
    local view = {}
    view.origin = scanner:GetPos()
    view.angles = angles
    view.fov = scanner.Zoom or 90
    return view
end

function PLUGIN:PlayerButtonDown(ply,btn)
    if not ply:IsCP() then
        return
    end
    
    if not ply:IsScanner() then
        return
    end

    if not (btn == KEY_F2) then
        return
    end

    if (ply.lastSCNExitOpen or 0) > CurTime() then return end
    ply.lastSCNExitOpen = CurTime() + 2

    Derma_Query("Do you want to exit the scanner?","Scanner Exit","Yes",function()
        net.Start("impulseHL2RPExitScanner")
        net.SendToServer()
    end,"No")
end


function DrawScanned(panel,w,h)
    if not target_scan_cam_pos then return end
    local x,y = panel:GetPos()
    x,y = panel:LocalToScreen(x,y)
    local pos, ang = WorldToLocal(target_scan_cam_pos,target_scan_cam_ang,target_scan_ply_pos-target_scan_cam_pos,target_scan_ply_ang-target_scan_cam_ang)
    cam.Start3D(pos,ang,80,x,y,w,h)
        target_cached:DrawModel()
    cam.End3D()
end