local surface = surface
local draw = draw
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math = math
local player = player
local pairs = pairs
local ScrW = ScrW
local ScrH = ScrH

local overlayCol = Color(255, 255, 255, 10)
local messagesCol = Color(0, 0, 0, 175)
local bootCol = Color(0, 0, 0, 130)
local red = Color(255, 0, 0)
local nextFlicker
local nextCheck

local otadeaths = 0
local ocadeaths = 0
local cpdeaths = 0
local socioscore = 0
local turnid = 0
local funds = 0

local segregation = false
local lockdown = false
local civtaxrate = 0
local cwtaxrate = 0
local commschannel1 = 0
local commschannel2 = 1
local lockdown = false
local separation = false
local rations = true
local fracturedstarttime = 0

local awardcredits = 0

local d2 = "OPEN"
local d3 = "OPEN"
local d4 = "OPEN"
local d57 = "OPEN"

net.Receive("DeepUpdateDistricts", function()
    local change = net.ReadString()
    local district = net.ReadUInt(8)
    if district == 2 then
        d2 = change
    elseif district == 3 then
        d3 = change
    elseif district == 4 then
        d4 = change
    elseif district == 57 then
        d57 = change
    end
end)

net.Receive("deepupdatecommstaps", function(len, ply)
    commschannel1 = net.ReadUInt(4)
    commschannel2 = net.ReadUInt(4)
end)

net.Receive("cpmessage", function(len, ply)
    cpdeaths = net.ReadUInt(6)
end)

net.Receive("otamessage", function(len, ply)
    otadeaths = net.ReadUInt(6)
end)

net.Receive("deepupdateawardcredits", function()
    local credits = net.ReadUInt(16)
    awardcredits = credits
end)


net.Receive("ocamessage", function(len, ply)
    ocadeaths = net.ReadUInt(6)
end)

net.Receive("deepupdatetaxrate_overlay", function() 
    local team = net.ReadUInt(2)
    local rate = net.ReadUInt(6)
    if team == 1 then
        civtaxrate = rate
    elseif team == 2 then
        cwtaxrate = rate
    end
end)

net.Receive("deepupdatedecree", function() 
    local id = net.ReadUInt(3)
    local boole = net.ReadBool()
    if id == 1 then 
        rations = boole
    elseif id == 2 then
        lockdown = boole
    else
        separation = boole
    end
end)

net.Receive("DeepSociostabilityScore", function(len, ply)
    socioscore = net.ReadUInt(8)
end)

net.Receive("DeepAdjustFunds", function(len, ply)
    funds = net.ReadInt(16)
end)


net.Receive("DeepResetSocioScore", function(len, ply)
    local i = 1
    while i < 5000 do
        if timer.Exists(i .. "socioscorepassivereset") then
            timer.Remove(i .. "socioscorepassivereset")
        end
        i = i + 1
    end
    realsocioscore = 0
    socioscore = 0
end)

net.Receive("DeepFracturedTimer", function()
    fracturedstarttime = net.ReadFloat()
end)


net.Receive("updatepolicy", function(len,ply)
    local policy = net.ReadUInt(8)
    local status = net.ReadBool()
    if policy == 2 then
        lockdown = status
    elseif policy != 2 then
        segregation = status
    end
end)

function UpdatePolicy(policy, status)
    if policy == "segregation" then
        if status == true then
            segregation = true
        else
            segregation = false
        end
    else
        if status == true then
            lockdown = true
        else
            lockdown = false
        end
    end
end

local CMB_OVERLAY_COLS = {
    Color(65, 120, 200), -- universal 1
    Color(75, 155, 45), -- squad 2 
    Color(255, 150, 0), -- command 3
    Color(210, 55, 50), -- danger 4
    Color(150, 150, 150), -- respond 5
    Color(125, 0, 0), -- HVA death 6
    Color(0, 157, 255), -- respond 7
    Color(150, 150, 0), -- comms 8
    Color(255, 50, 0), -- ration terminal 9
    Color(0, 157, 255), -- respond 10
    Color(255, 90, 0), -- Command Ping 11
    Color(255, 75, 0), -- Red-Orange 12
}

local CMB_OVERLAY_ICONS = {
    Material("impulse/hl2rp/overlay/move"), -- move 1
    Material("impulse/hl2rp/overlay/alert"), -- alert 2
    Material("impulse/hl2rp/overlay/flatline"), -- death 3
    Material("impulse/hl2rp/overlay/blockinspect"), -- block insp. 4
    Material("impulse/hl2rp/overlay/move_sq"), -- move squad 5
    Material("impulse/hl2rp/overlay/combine"), -- Combine 6
    Material("impulse/hl2rp/overlay/cctv"), -- camera 7
    Material("vgui/killicons/iw4_choppergunner") -- Helicopter 8
}


surface.CreateFont("impulseHL2RPOverlayBig", {
    font = "Courier New",
    size = 21,
    weight = 800,
    scanlines = 10,
    outline = true,
    antialias = true
})

surface.CreateFont("impulseHL2RPScannerFont", {
    font = "Lucida Sans Typewriter",
    antialias = false,
    outline = true,
    weight = 800,
    size = 18
})


impulse.CombineMessages = impulse.CombineMessages or {}
impulse.CombineWaypoints = impulse.CombineWaypoints or {}
impulse.CombineMessageID = impulse.CombineMessageID or 0

impulse.DefineSetting("hud_combineoverlay", {name="Combine Overlay Enabled", category="HUD", type="tickbox", default=false})
impulse.DefineSetting("hud_combinehud", {name="Combine HUD Type (Not Implemented Yet)", category="HUD", type="dropdown", options={"impulse - Original", "Deep - Indev", "Landis Horizons", "None"}, default="impulse - Original"})

local function DrawCombineWaypoints()
    local ply = LocalPlayer()
    local plyAng = ply:EyeAngles()
    local plyPos = ply:GetPos()
    
    for i = 1, #impulse.CombineWaypoints do
        local waypointData = impulse.CombineWaypoints[i]
        if not waypointData then continue end
        
        local pos = waypointData.pos:ToScreen()
        
        if not waypointData.nextUpdate or waypointData.nextUpdate < CurTime() then
            waypointData.dist = (waypointData.pos:Distance(plyPos) / 39.3701) -- 39 inches in meter
            waypointData.nextUpdate = CurTime() + 0.5
        end
        
        local dirToWaypoint = (waypointData.pos - ply:GetShootPos()):GetNormalized()
        local aimForward = plyAng:Forward()
        
        -- (1.0 = looking directly at, 0.0 = perpendicular, -1.0 = looking away)
        local dotProduct = dirToWaypoint:Dot(aimForward)
        
        -- higher dot product = more transparent (fades when looking at it)
        local opacity = 255
        if dotProduct > 0.5 then -- Start fading when aiming somewhat close to waypoint
            -- Map dot product from 0.7-1.0 to opacity 255-50
            opacity = Lerp((dotProduct - 0.5) / 0.3, 255, 50)
        end
        
        -- fade based on angular distance
        local angleToWaypoint = math.deg(math.acos(math.Clamp(dotProduct, -1, 1)))
        if angleToWaypoint < 15 then -- Start fading when within 15 degrees of waypoint
            opacity = Lerp(angleToWaypoint / 15, 50, 255)
        end
        
        -- fade based off proximity
        if waypointData.dist < 20 then
            local proximityOpacity = Lerp(waypointData.dist / 20, 100, opacity)
            opacity = math.min(opacity, proximityOpacity)
        end
        
        opacity = math.Clamp(opacity, 0, 255)
        
        if not waypointData.mat then
            surface.SetMaterial(Material("impulse/hl2rp/overlay/move"))
        else
            surface.SetMaterial(waypointData.mat)
        end
        
        local baseColor = waypointData.colour or Color(100, 100, 100)
        surface.SetDrawColor(Color(baseColor.r, baseColor.g, baseColor.b, opacity))
        
        surface.DrawTexturedRect(pos.x - 16, pos.y, 32, 32)
        
        local textAlpha = math.Clamp(opacity, 100, 255) -- keep text slightly more visible
        local textColor = waypointData.textcolour or color_white
        textColor.a = textAlpha
        
        draw.SimpleText("<:: "..waypointData.text.." ::>", "BudgetLabel", pos.x, pos.y + 30, textColor, TEXT_ALIGN_CENTER)

        if waypointData.name then
            local prefix = waypointData.prefix or "UNIT"
            local text = waypointData.name

            draw.SimpleText("<:: "..prefix..": "..text.." ::>", "BudgetLabel", pos.x, pos.y + 42, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)
            draw.SimpleText("<:: DIST: "..math.Round(waypointData.dist).."m ::>", "BudgetLabel", pos.x, pos.y + 54, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("<:: DIST: "..math.Round(waypointData.dist).."m ::>", "BudgetLabel", pos.x, pos.y + 42, Color(255, 255, 255, textAlpha), TEXT_ALIGN_CENTER)
        end

        if waypointData.endtime and waypointData.endtime < CurTime() then
            impulse.CombineWaypoints[i] = nil
            LocalPlayer():EmitSound("buttons/button17.wav", 35, 60)
        end 
    end
end

local scannerColorModify = {
    ["$pp_colour_addr"] = 0,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = 0,
    ["$pp_colour_brightness"] = 0,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 1,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0
}

local lineYPos = 75
local lastTargetTime = 0
local lastTarget
local scanPercentage = 0
local lineWide = 5
local lineCol =  Color(190, 190, 190, 180)
local faceShadeCol =  Color(40, 40, 40, 60)
local redColor = 0
local loopDirection = true

local function DrawScannerPlayerBox(target, scanner, percentage)
    local head = target:LookupBone("ValveBiped.Bip01_Head1")

    if not head then
        return
    end

    local ang = LocalPlayer():GetAngles()
    local bottomPos = target:GetBonePosition(head) - (ang:Up() * 4)
    local xGap = ang:Right() * 7.5
    local topPos = bottomPos + (ang:Up() * 15)
    local bottomL = bottomPos - xGap
    local bottomR = bottomPos + xGap
    local topL = topPos - xGap
    local topR = topPos + xGap

    local tl = topL:ToScreen()
    local br = bottomR:ToScreen()
    
    local w = br.x - tl.x
    local h = br.y - tl.y
    
    surface.SetDrawColor(faceShadeCol)
    surface.DrawRect(tl.x, tl.y, w, h)

    surface.SetDrawColor(lineCol)
    surface.DrawOutlinedRect(tl.x, tl.y, w, h)

    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.SetFont("BudgetLabel")
    surface.SetTextPos(tl.x + 2, tl.y + 2)
    if scanner:GetIsScanning() and target == scanner:GetScanTarget() then
        surface.DrawText(percentage .. "%")
    else
        surface.DrawText("IDLE...")
    end
end

local function DrawScannerHUD() 
    local scanner = LocalPlayer():GetScannerFromPlayer()
    local target = scanner:GetCurrentTarget()

    DrawColorModify(scannerColorModify)

    -- nutscript style scanner hud
    local boxWide, boxHeight = 580, 420
    local boxWide2, boxHeight2 = boxWide * 0.5, boxHeight * 0.5
    local scrW, scrH = ScrW() * 0.5, ScrH() * 0.5
    local x, y = scrW - boxWide2, scrH - boxHeight2
    local pos = scanner:GetPos()
    local ang = LocalPlayer():GetAimVector():Angle()

    draw.SimpleText("POS ("..math.floor(pos[1])..", "..math.floor(pos[2])..", "..math.floor(pos[3])..")", "impulseHL2RPScannerFont", x + 8, y + 8, color_white)
    draw.SimpleText("ANG ("..math.floor(ang[1])..", "..math.floor(ang[2])..", "..math.floor(ang[3])..")", "impulseHL2RPScannerFont", x + 8, y + 24, color_white)
    draw.SimpleText("IAS ("..math.Round(scanner:GetVelocity():Length2D())..")", "impulseHL2RPScannerFont", x + 8, y + 40, color_white)
    draw.SimpleText("ID  ("..LocalPlayer():Name()..")", "impulseHL2RPScannerFont", x + 8, y + 56, color_white)
    draw.SimpleText("ZM  ("..math.Round(scanner.Zoom or 90)..")", "impulseHL2RPScannerFont", x + 8, y + 72, color_white)
    draw.SimpleText("F2  (DISMOUNT)", "impulseHL2RPScannerFont", x + 8, y + 88, color_white)
    surface.SetDrawColor(235, 235, 235, 230)

    surface.DrawLine(x, y, x + 128, y)
    surface.DrawLine(x, y, x, y + 128)

    x = scrW + boxWide2

    surface.DrawLine(x, y, x - 128, y)
    surface.DrawLine(x, y, x, y + 128)

    x = scrW - boxWide2
    y = scrH + boxHeight2

    surface.DrawLine(x, y, x + 128, y)
    surface.DrawLine(x, y, x, y - 128)

    x = scrW + boxWide2

    surface.DrawLine(x, y, x - 128, y)
    surface.DrawLine(x, y, x, y - 128)
end

local squadCol = Color(75, 155, 45, 255)
local grey = Color(60, 60, 60, 255)

local function DrawCombineSquad()
    local scrH = ScrH()
    local w, h = 15, scrH/2.5
    local yadd = 18
    local scrHH = scrH - (scrH - h)
    local lp = LocalPlayer()

    surface.SetTextColor(squadCol)
    surface.SetFont("BudgetLabel")

    surface.SetTextPos(w, scrHH)

    local squadId = lp:GetSyncVar(SYNC_SQUAD_ID, 0)
    local squadComp = {}
    local i = 2

    for v,k in pairs(team.GetPlayers(lp:Team())) do
        if k:GetSyncVar(SYNC_SQUAD_ID, -1) == squadId then
            if k:GetSyncVar(SYNC_SQUAD_LEADER, false) then
                squadComp[1] = k
            else
                squadComp[i] = k
                i = i + 1
            end
        end
    end

    local squadName = "SQUAD"
    if lp:Team() == TEAM_CP then
        squadName = "PATROL TEAM"
    end

    surface.DrawText(squadName.." "..squadId..":")

    for i=1,#squadComp do
        local k = squadComp[i]

        if not IsValid(k) then
            if i == 1 then
                surface.SetTextPos(w, scrHH + yadd)
                surface.DrawText("⏺ NO LEADER (F6)")
                yadd = yadd + 18
            end
            continue
        end

        surface.SetTextPos(w, scrHH + yadd)

        local hp = k:Health()
        if not k:Alive() then
            surface.SetTextColor(grey)
            hp = 0
        elseif hp < 26 then
            surface.SetTextColor(CMB_OVERLAY_COLS[4])
        else
            surface.SetTextColor(squadCol)
        end

        surface.DrawText("⏺ "..k:Nick().." ["..hp.."]")
        yadd = yadd + 18
    end

    return squadComp
end


local direction = {
    [0] = "N",
    [45] = "NE",
    [90] = "E",
    [135] = "SE",
    [180] = "S",
    [225] = "SW",
    [270] = "W",
    [315] = "NW",
    [360] = "N"
}

local function DrawCombineCompass(squad)
    local ang = LocalPlayer():EyeAngles()
    local bearing = impulse.AngleToBearing(ang)
    local width = ScrW() * .23
    local w2 = width / 2
    local m = 1
    local spacing = (width * m) / 360
    local lines = width / spacing
    local rang = math.Round(ang.y)
    local comX = ScrW() / 2
    local me = LocalPlayer()

    surface.SetDrawColor(messagesCol)
    surface.DrawRect(ScrW() / 2 - (width / 2) - 8, 30, width + 16, 40)

    if squad then
        local myPos = LocalPlayer():GetPos()

        for v,k in pairs(squad) do
            if k == me or not k:Alive() then
                continue
            end
            
            local isLeader = v == 1 and true or false

            local pos = k:GetPos()
            local yAng = ang.y - (pos - myPos):GetNormalized():Angle().y
            local squadMarker = math.Clamp(((comX + (w2 * m)) - (((-yAng - 180) % 360) * spacing)), comX - w2, comX + w2)

            draw.SimpleText(isLeader and "(SL)" or "⏺", "BudgetLabel", squadMarker, 40, squadCol, TEXT_ALIGN_CENTER)
        end
    end

    draw.SimpleText(bearing, "BudgetLabel", ScrW() / 2, 58, color_white, TEXT_ALIGN_CENTER)

    for i = (rang - (lines / 2)) % 360, ((rang - (lines / 2)) % 360) + lines do
        local x = (comX + (width / 2)) - ((i - ang.y - 180) % 360) * spacing

        if i % 30 == 0 and i > 0 then
            local text = direction[360 - (i % 360)] and direction[360 - (i % 360)] or 360 - (i % 360)

            draw.SimpleText(text, "BudgetLabel", x, 30, color_white, TEXT_ALIGN_CENTER)
        end
    end
end

local function DrawLowAmmo(offset)
    draw.SimpleText("WARNING:\nLocal unit low on ammunition!", "BudgetLabel", ScrW() * 0.52, ScrH() * 0.45 + offset, CMB_OVERLAY_COLS[4])
end

local modeNames = {
    [0] = "Grounded",
    [1] = "Grounded",
    [2] = "Pacify",
    [3] = "Active"
}

local function DrawBatonStatus(baton, offset)
    local mode = baton:GetMode() or 1

    draw.SimpleText("BATON STATUS:\n"..modeNames[mode], "BudgetLabel", ScrW() * 0.52, ScrH() * 0.45 + offset, CMB_OVERLAY_COLS[1])
end

local plyName = "combine"

local function RandomTypeWriterSound()
    local t = math.random(1,4)
    local s = {"impulse/typewriter1.wav","impulse/typewriter2.wav","impulse/typewriter3.wav","impulse/typewriter4.wav"}
    return s[t]
end
local bootCmds = {
    "$ Initializing OS...|||",
    "$ Verifying...|||",
    "$ Welcome to cmbOS v.1.10!||",
    "root@144.48.106.180 $ Enter username: ||||COMBINE",
    plyName.."@144.48.106.180 $ Enter password: ||||****|******|**",
    "$ Establishing connection to ctOS...||||||",
    "$ Connection Established! (took 624ms)",
    plyName.."@144.48.106.180 $ systemctl start nginx||",
    plyName.."@144.48.106.180 $ systemctl start wings||",
    plyName.."@144.48.106.180 $ systemctl start scrombine||",
    "[FATAL ERROR]|| (line 4891) 'trew moltov at scrombine when clearly not'",
    plyName.."@144.48.106.180 $ cd /data/cmb/",
    plyName.."@144.48.106.180 $ open event_" .. game.GetMap() .. ".txt",
    "[ERROR]|| Permission denied",
    plyName.."@144.48.106.180 $ sudo get-apt combine-overlay|||||",
    "Done!|",
    "loading libraries...",
    "CMB1-001-CONNECTED",
    "CMB1-002-CONNECTED",
    "CMB1-003-CONNECTED",
    "CMB2-001-CONNECTED",
    "CMB3-001-CONNECTED",
    "CMB3-002-CONNECTED",
    "CMB4-001-FAILED",
    "connecting to local hardware...",
    "ASB vocoder - CONNECTED",
    "VHF/UHF two-way radio - CONNECTED",
    "biosignal controller - CONNECTED",
    "visual receptor - CONNECTED",
    "internal biolink - CONNECTED",
    "firearm RFID interface - CONNECTED",
    "./sh/os32.z",
    "./sh/js-compact.js",
    "...",
    "....",
    ".....",
    "......",
    "JESUS IS KING (OOC VOID BIND)",
    "FOOL OF A TOOK!",
    "completed boot sequence! (last serviceID: 4349271)"
}

local command = 1
local nextCommand
local nextChar
local bootDone = 0
local startTime
local commandPos = 0

local function DrawBootSequence()
    if bootDone and bootDone < CurTime() then
        startTime = nil
        return true
    end

    local blue
    
    if LocalPlayer():Team() == TEAM_OTA then
        blue = team.GetColor(TEAM_OTA) 
    elseif LocalPlayer():Team() == TEAM_CP then
        blue = team.GetColor(TEAM_CP) 
    elseif LocalPlayer():Team() == TEAM_CA then
        blue = team.GetColor(TEAM_CA)
    else
        blue = team.GetColor(LocalPlayer():Team())
    end 

    local x, y = ScrW() * .35, ScrH() * .25
    startTime = startTime or CurTime()

    surface.SetDrawColor(blue)
    surface.SetMaterial(CMB_OVERLAY_ICONS[6])
    surface.DrawTexturedRect(x, y, 128, 128)

    if startTime + 0.2 < CurTime() then
        draw.SimpleText("<:: CENTRAL DISPATCH INTERFACE", "impulseHL2RPOverlayBig", x + 140, y + 20, blue)
    end
    
    if startTime + 0.5 < CurTime() then
        draw.SimpleText("Booting...                          "..bit.tohex(bit.tobit(math.Rand(-1000000,1000000))), "BudgetLabel", x + 140, y + 40, blue)
        draw.SimpleText("Please wait...", "BudgetLabel", x + 140, y + 50, color_white)
    end

    if startTime + 1.5 < CurTime() then
        if (commandPos < (bootCmds[command] or bootCmds[1]):len()) then
            if ((nextChar or 0) < CurTime()) then
                commandPos = (commandPos or 0) + 1
                if (commandPos / 4) == math.floor(commandPos/4) then surface.PlaySound(RandomTypeWriterSound()) end
                if ((bootCmds[command] or "")[commandPos or 1] or "") == "|" then
                    nextChar = CurTime() + 0.1
                else
                    nextChar = CurTime() + 0.01
                end
            end
        elseif not bootDone and (not nextCommand or nextCommand < CurTime()) then
            command = command + 1

            surface.PlaySound(RandomTypeWriterSound())

            if not bootCmds[command] then
                bootDone = CurTime() + 1.1
                surface.PlaySound("ambient/levels/prison/radio_random12.wav")
                surface.PlaySound("items/suitchargeok1.wav")
            end

            local wait = 0.1

            if command == 22 or command == 30 or command == 13 then
                wait = wait + 0.9
            end

            nextChar = CurTime() + 0.1

            nextCommand = CurTime() + wait
            commandPos = 0
        end

        for i = 1, command do
            local cmd = bootCmds[i] or ""

            if cmd then

                if i == command then
                    cmd = string.sub(cmd,0,commandPos)
                end

                cmd = cmd:Replace("|","")
               
                surface.SetFont("BudgetLabel")
                local w,h = surface.GetTextSize(cmd)
                draw.SimpleText(cmd, "BudgetLabel", 5, (5) + (h * (i-1)))     
            end
        end
    end
end

concommand.Add("landishl2rp_new_bootseq", function()
    bootDone = nil
    command = 1
    nextCommand = nil
end)

local medCol = Color(255, 228, 0)
local armCol = Color(255, 0, 0)
local nextArmFlash = 0
local function DrawAuxData(offset)
    local zone = LocalPlayer():GetZoneName()
    local scrW = ScrW()
    local pos = LocalPlayer():GetPos()
    local grid = math.Round(pos.x / 100).."/"..math.Round(pos.y / 100)
    local hp = LocalPlayer():Health()
    local armour = LocalPlayer():Armor()
    local cityCode = impulse.Dispatch.GetCityCode()
    local cityCodeData = impulse.Dispatch.CityCodes[cityCode]
    local add = 0
    local sps = false
    local spores = GetSporeCount() or 0

    draw.SimpleText("AUX DATA ::>", "BudgetLabel", scrW - 8, 24 + offset, nil, TEXT_ALIGN_RIGHT)
    draw.SimpleText("BIOSIGNAL: ON ::>", "BudgetLabel", scrW - 8, 38 + offset, nil, TEXT_ALIGN_RIGHT)
    draw.SimpleText("BIOSIGNAL ZONE: "..zone.." ::>", "BudgetLabel", scrW - 8, 52 + offset, nil, TEXT_ALIGN_RIGHT)
    draw.SimpleText("BIOSIGNAL GRID: "..grid.." ::>", "BudgetLabel", scrW - 8, 66 + offset, nil, TEXT_ALIGN_RIGHT)

    local width = ScrW() * 0.58
    local w2 = width
    
    if LocalPlayer():Team() == TEAM_OTA then
        teamColor = Color(255,10,10)
    elseif LocalPlayer():Team() == TEAM_CP then
        teamColor = Color(10,10,255)
    elseif LocalPlayer():Team() == TEAM_CWU and LocalPlayer():GetTeamClass() == CLASS_ICT then
        teamColor = Color(255, 255, 10)
    else
        teamColor = Color(10,255,10)
    end

    if LocalPlayer():Team() == TEAM_OTA then
        NVGColor = red
        NVGPosition = 70
    end

    local NVGColor = Color( 0, 119, 255)
    local NVGPosition = 90


    if LocalPlayer():Team() == TEAM_OTA or (LocalPlayer():Armor() > 0) then
        if LocalPlayer():Team() == TEAM_OTA then
            sps = true
        end
        draw.SimpleText("SUIT PROTECTION SYSTEM CHARGE: "..armour.." ::>", "BudgetLabel", scrW - 8, 80 + offset, nil, TEXT_ALIGN_RIGHT)
        add = add + 14
    elseif LocalPlayer():Team() == TEAM_CWU and LocalPlayer():GetTeamClass() == CLASS_ICT then
        draw.SimpleText("SPORE REPORT AMT: "..spores.." ::>", "BudgetLabel", scrW - 8, 80 + offset, nil, TEXT_ALIGN_RIGHT)
        add = add + 14
    end

    draw.SimpleText("POLITI-STABILIZATION INDEX: "..cityCodeData[1].." ::>", "BudgetLabel", scrW - 8, 80 + add, cityCodeData[2], TEXT_ALIGN_RIGHT)

    add = add + 28
    local colindexes = {Color(0, 255, 0), Color(100, 255, 0), Color(255, 255, 0), Color(255, 100, 0), Color(255, 0, 0)}
    local sociocolor
    if socioscore == 0 then
        sociocolor = 1
    else
        sociocolor = math.ceil(socioscore/20)
    end

    if impulse.Dispatch.GetCityCode() == CODE_LOST then
        draw.SimpleText("SECTOR LOST - EVACUATION IMMINENT ::>", "BudgetLabel", scrW - 8, 80 + add, Color(50,0,0), TEXT_ALIGN_RIGHT)
    elseif impulse.Dispatch.GetCityCode() == CODE_AJ then
        draw.SimpleText("SOCIETAL COLLAPSE IMMINENT ::>", "BudgetLabel", scrW - 8, 80 + add, Color(139,0,0), TEXT_ALIGN_RIGHT)
    elseif impulse.Dispatch.GetCityCode() == CODE_FRACTURED or impulse.Dispatch.GetCityCode() == CODE_JW then
        draw.SimpleText("SOCIAL FRACTURE IMMINENT ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255,0,0), TEXT_ALIGN_RIGHT)
    else
        draw.SimpleText("SOCIAL FRACTURE LIKELIHOOD: "..socioscore.."% ::>", "BudgetLabel", scrW - 8, 80 + add, colindexes[sociocolor], TEXT_ALIGN_RIGHT)
    end

    if impulse.Dispatch.GetCityCode() != CODE_CIVIL then
        add = add + 28
		local elapsed = math.floor(CurTime() - fracturedstarttime)
		local hours   = math.floor(elapsed / 3600)
		local minutes = math.floor((elapsed % 3600) / 60)
		local seconds = elapsed % 60
		draw.SimpleText("TIME SINCE LAST CODE CHANGE: " .. string.format("%02d:%02d:%02d", hours, minutes, seconds) .. " AGO ::>", "BudgetLabel", scrW - 8, 80 + add, color_white, TEXT_ALIGN_RIGHT)    end
    if LocalPlayer():Team() ~= TEAM_CWU then      
        add = add + 28

        draw.SimpleText("M.P.F. LOSSES [15m]: "..cpdeaths.." ::>", "BudgetLabel", scrW - 8, 80 + add, Color(200, 200, 255), TEXT_ALIGN_RIGHT)
        
        add = add + 14

        draw.SimpleText("C.T.A. LOSSES [15m]: "..otadeaths.." ::>", "BudgetLabel", scrW - 8, 80 + add, Color(160, 160, 160), TEXT_ALIGN_RIGHT)

        add = add + 14

        draw.SimpleText("O.C.A. LOSSES [15m]: "..ocadeaths.." ::>", "BudgetLabel", scrW - 8, 80 + add, Color(150, 0, 0), TEXT_ALIGN_RIGHT)

        add = add + 28
    end

    if (LocalPlayer():Team() == TEAM_CA and LocalPlayer():GetTeamClass() == CLASS_BASE) or LocalPlayer():IsCPCommand() or (LocalPlayer():Team() == TEAM_OTA and LocalPlayer():GetTeamClass() == CLASS_NOMAD) then
        draw.SimpleText("O.C.A.A.B. TREASURY: C" .. funds .. " ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

        add = add + 14

        draw.SimpleText("CURRENT C.W. TAX RATE: " .. cwtaxrate .. "% ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255, 255, 255), TEXT_ALIGN_RIGHT)
        
        add = add + 14

        draw.SimpleText("CURRENT CIVILIAN TAX RATE: " .. civtaxrate .. "% ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

        add = add + 14
    end
    add = add + 28

    if LocalPlayer():IsCPCommand() and LocalPlayer():Team() == TEAM_CP and awardcredits != 0 then
        draw.SimpleText("AWARD CREDITS: " ..awardcredits .. " ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

        add = add + 28
    end

    if LocalPlayer():Team() == TEAM_CP and LocalPlayer():GetTeamClass() == CLASS_GHOST then
        draw.SimpleText("CHANNELS TAPPED: " .. commschannel1 .. " & " .. commschannel2 .. " ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255, 255, 255), TEXT_ALIGN_RIGHT)

        add = add + 28
    end

    local radd = add + 14
--[[
    if lockdown == true then
        draw.SimpleText("<:: CITY LOCKDOWN: ACTIVE", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
    else
        draw.SimpleText("<:: CITY LOCKDOWN: INACTIVE", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 0, 0), TEXT_ALIGN_LEFT)
    end

    radd = radd - 14
--]]
    if rations == true then
        draw.SimpleText("<:: CIVIC RATIONS: ACTIVE", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
    else
        draw.SimpleText("<:: CIVIC RATIONS: SUSPENDED", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 0, 0), TEXT_ALIGN_LEFT)
    end

    radd = radd - 14

    if separation == true then
        draw.SimpleText("<:: CITY SEPARATION: ACTIVE", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
    else
        draw.SimpleText("<:: CITY SEPARATION: INACTIVE", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 0, 0), TEXT_ALIGN_LEFT)
    end

    radd = radd + 72

    --[[add = add + 14

    if impulse.Rations == true then
        draw.SimpleText("CIVIC RATIONS: ACTIVE ::>", "BudgetLabel", scrW - 8, 80 + add, Color(0, 255, 0), TEXT_ALIGN_RIGHT)
    else
        draw.SimpleText("CIVIC RATIONS: SUSPENDED ::>", "BudgetLabel", scrW - 8, 80 + add, Color(255, 0, 0), TEXT_ALIGN_RIGHT)
    end]]

    if game.GetMap() == "rp_city17_futuristic_cloudy" then
        draw.SimpleText("<:: DISTRICT STATUS", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(200, 200, 200), TEXT_ALIGN_LEFT)
        radd = radd + 14
        if d2 == "OPEN" then
            draw.SimpleText("[: DISTRICT 2: " .. d2, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
        elseif d2 == "OPENING" or d2 == "CLOSING" then
            draw.SimpleText("[: DISTRICT 2: " .. d2, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 255, 0), TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("[: DISTRICT 2: " .. d2, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 0, 0), TEXT_ALIGN_LEFT)
        end
        radd = radd + 14
        if d3 == "OPEN" then
            draw.SimpleText("[: DISTRICT 3: " .. d3, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
        elseif d3 == "OPENING" or d3 == "CLOSING" then
            draw.SimpleText("[: DISTRICT 3: " .. d3, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 255, 0), TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("[: DISTRICT 3: " .. d3, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 0, 0), TEXT_ALIGN_LEFT)
        end
        radd = radd + 14
        if d4 == "OPEN" then
            draw.SimpleText("[: DISTRICT 4: " .. d4, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
        elseif d4 == "OPENING" or d4 == "CLOSING" then
            draw.SimpleText("[: DISTRICT 4: " .. d4, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 255, 0), TEXT_ALIGN_LEFT)
        else
            draw.SimpleText("[: DISTRICT 4: " .. d4, "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(255, 0, 0), TEXT_ALIGN_LEFT)
        end
        radd = radd + 14
        draw.SimpleText("[: DISTRICT 7: OPEN", "BudgetLabel", scrW - (scrW - 8), 80 + radd, Color(0, 255, 0), TEXT_ALIGN_LEFT)
    end

    if hp <= 70 then
        add = add + 28
        draw.SimpleText("WARNING: LOCAL UNIT REQUIRES MEDICAL ATTENTION.", "BudgetLabel", scrW - 8, 80 + add + offset, medCol, TEXT_ALIGN_RIGHT)
    end

    if sps and armour <= 40 then
        if armour <= 5 then
            if CurTime() > nextArmFlash + 1 then
                nextArmFlash = CurTime() + 1
            end
        end
        add = add + 19

        if CurTime() > nextArmFlash then
            draw.SimpleText("ATTENTION: SPS SYSTEM FAILING, RETURN TO RECHARGE POINT.", "BudgetLabel", scrW - 8, 80 + add + offset, armCol, TEXT_ALIGN_RIGHT)
        end
    end

end

local function DrawCombineMessages(offset)
    local x, y

    for i = 1, #impulse.CombineMessages do
        local msgData = impulse.CombineMessages[i]
        x, y = 8 + offset, (i - 1) * 16 + 8

        surface.SetFont("BudgetLabel")
        local w, h = surface.GetTextSize(msgData.message)

        surface.SetDrawColor(msgData.bgCol or messagesCol)
        surface.DrawRect(x, y + 6, w + 12, h)

        draw.SimpleText(msgData.message, "BudgetLabel", x + 6, y + 6, color_white, 0, 0)
    end

    return y
end

local function DrawCombineCameraOverlay()
    if not IsValid(WATCHING_CAM) then
        return
    end

    local x = ScrW() * 0.3
    local y = ScrH() * 0.3
    local ang = WATCHING_CAM:GetAttachment(1).Ang

    DrawColorModify(scannerColorModify)

    draw.SimpleText("CAM-"..WATCHING_CAM:GetSyncVar(SYNC_CAM_CAMID, 0), "BudgetLabel", x, y, color_white)
    draw.SimpleText("ANG: "..math.floor(ang[1]).." "..math.floor(ang[2]).." "..math.floor(ang[3]), "BudgetLabel", x, y + 10, color_white)
    draw.SimpleText("STATUS: ONLINE", "BudgetLabel", x, y + 20, color_white)
    draw.SimpleText("HEALTH: "..WATCHING_CAM:Health(), "BudgetLabel", x, y + 30, color_white)
end

surface.CreateFont("DFTitle", {
    font = "Courier New",
    size = 30,
    weight = 900,
    antialias = true,
    outline = true
})
surface.CreateFont("DFSubTitle", {
    font = "Courier New",
    size = 26,
    weight = 900,
    antialias = true,
    outline = true
})

local function DrawCombineObjective(citycode)
    local x = ScrW() * .5
    local y = ScrH() * .2
    local order = CP_OBJECTIVE.message or ""
    local sac = CP_OBJECTIVE.saccode or false
    local localobj = CP_OBJECTIVE.localteamobj or false
    local squadorder = CP_OBJECTIVE.squadorder or false
    local priosuss = CP_OBJECTIVE.pos or false

    if citycode then
        if citycode == CODE_UNREST then
            order = "POLITI-STABILIZATION INDEX UPDATED TO MARGINAL. USE EXTREME CAUTION AND MONITOR SUSPICIOUS INDIVIDUALS."
        elseif citycode == CODE_FRACTURED then
            order = "SOCIAL FRACTURE IMMINENT. ALL AVAILABLE UNITS MOVE TO RECTIFY UNREST."
        elseif citycode == CODE_JW then
            order = "AUTONOMOUS JUDGEMENT is now in effect. Sentencing is now discretionary."
        elseif citycode == CODE_AJ then
            order = "JUDGEMENT WAIVER is now in effect. Capital prosecution is discretionary."
        else
            order = "COMBINE STRATEGIC COMMAND HAS DECLARED COMPLETE SECTOR LOSS. BEGIN EVACUATION PROCEDURES."
        end
    end
    
    surface.SetFont("DFTitle")
    local minX = surface.GetTextSize(citycode and (impulse.Dispatch.CityCodes[citycode][1].." IN EFFECT") or "INCOMING TRANSMISSSION FROM COMBINE CENTRAL COMMAND")
    surface.SetFont("DFSubTitle")
    local orderSize = surface.GetTextSize(order)
    local wide = math.Clamp(orderSize, minX, ScrW()) + 30

    surface.SetDrawColor(ColorAlpha(messagesCol, 180))
    surface.DrawRect(x - (wide / 2), y, wide, 100)

    local textSpeed = .04

    if citycode then
        textSpeed = .08
    end

    CP_OBJECTIVE.textPos = CP_OBJECTIVE.textPos or 0
    CP_OBJECTIVE.nextText = CP_OBJECTIVE.nextText or CurTime() + textSpeed

    if CurTime() > CP_OBJECTIVE.nextText then
        CP_OBJECTIVE.textPos = CP_OBJECTIVE.textPos + 1
        CP_OBJECTIVE.nextText = CurTime() + textSpeed
    end

    if citycode then
        draw.SimpleText(string.sub("POLITI-STABILIZATION INDEX ESCALATION IMMINENT", 1, CP_OBJECTIVE.textPos), "DFTitle", x, y, impulse.Dispatch.CityCodes[citycode][2], TEXT_ALIGN_CENTER)
        draw.SimpleText(string.sub("BY ORDER OF COMBINE STRATEGIC COMMAND", 1, CP_OBJECTIVE.textPos), "DebugFixed", x, y + 30, nil, TEXT_ALIGN_CENTER)

        draw.SimpleText(string.sub(order:upper(), 1, CP_OBJECTIVE.textPos), "DFSubTitle", x, y + 60, nil, TEXT_ALIGN_CENTER)
        return
    end
    if sac && not squadorder && not priosuss then
        draw.SimpleText(string.sub("SACRIFICE CODE NOW IN EFFECT", 1, CP_OBJECTIVE.textPos), "DFTitle", x, y, Color(0, 148, 255), TEXT_ALIGN_CENTER)
        draw.SimpleText(string.sub("BY ORDER OF "..CP_OBJECTIVE.sender, 1, CP_OBJECTIVE.textPos), "DebugFixed", x, y + 30, nil, TEXT_ALIGN_CENTER)

        draw.SimpleText(string.sub(order:upper(), 1, CP_OBJECTIVE.textPos), "DFSubTitle", x, y + 60, nil, TEXT_ALIGN_CENTER)
        return
    elseif not sac && squadorder && not priosuss then
        draw.SimpleText(string.sub("INCOMING SQUAD OBJECTIVE", 1, CP_OBJECTIVE.textPos), "DFTitle", x, y, Color(20, 140, 0), TEXT_ALIGN_CENTER)
        draw.SimpleText(string.sub("DIRECTIVE RECEIVED FROM "..CP_OBJECTIVE.sender, 1, CP_OBJECTIVE.textPos), "DebugFixed", x, y + 30, nil, TEXT_ALIGN_CENTER)

        draw.SimpleText(string.sub(order:upper(), 1, CP_OBJECTIVE.textPos), "DFSubTitle", x, y + 60, nil, TEXT_ALIGN_CENTER)
        return
    elseif not sac && not squadorder && priosuss then
        draw.SimpleText(string.sub("MANHUNT UNDERWAY - ANTI-CITIZEN ONE IDENTIFIED", 1, CP_OBJECTIVE.textPos), "DFTitle", x, y, Color(20, 140, 0), TEXT_ALIGN_CENTER)
        draw.SimpleText(string.sub("MANHUNT DECLARED BY "..CP_OBJECTIVE.sender, 1, CP_OBJECTIVE.textPos), "DebugFixed", x, y + 30, nil, TEXT_ALIGN_CENTER)

        draw.SimpleText(string.sub(order, 1, CP_OBJECTIVE.textPos), "DFSubTitle", x, y + 60, nil, TEXT_ALIGN_CENTER)
        return
    elseif localobj then
        draw.SimpleText(string.sub("INCOMING DIRECTIVE FROM LOCAL COMMAND", 1, CP_OBJECTIVE.textPos), "DFTitle", x, y, Color(51, 51, 51), TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(string.sub("INCOMING DIRECTIVE FROM CENTRAL COMMAND", 1, CP_OBJECTIVE.textPos), "DFTitle", x, y, Color(255, 100, 0), TEXT_ALIGN_CENTER)
    end
    if CP_OBJECTIVE.sender && not sac && not squadorder && not priosuss then
        draw.SimpleText(string.sub("BY ORDER OF "..CP_OBJECTIVE.sender, 1, CP_OBJECTIVE.textPos), "DebugFixed", x, y + 30, nil, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(string.sub("BY ORDER OF COMBINE STRATEGIC COMMAND", 1, CP_OBJECTIVE.textPos), "DebugFixed", x, y + 30, nil, TEXT_ALIGN_CENTER)
    end
    draw.SimpleText(string.sub(order:upper(), 1, CP_OBJECTIVE.textPos), "DFSubTitle", x, y + 60, nil, TEXT_ALIGN_CENTER)
end

local otaWallsRange =  820 ^ 2
local function DrawCombineHUD()
    local lp = LocalPlayer()
    local offset = 0

    if not lp:IsICT() and not lp:IsCP() then
        return
    end

    if lp:GetTeamClass() == 0 then
        return
    end

    if not DrawBootSequence() then
        return
    end

    if (not WATCHING_CAM and impulse.hudEnabled == false) or (IsValid(impulse.MainMenu) and impulse.MainMenu:IsVisible()) then
        return
    end

    if not CMB_OVERLAY then
        CMB_OVERLAY = Material("effects/combine_binocoverlay")
        CMB_OVERLAY:SetFloat("$salpha", "0.2")
        CMB_OVERLAY:Recompute()
    end

    if impulse.GetSetting("hud_combineoverlay", false) or WATCHING_CAM then
        surface.SetDrawColor(overlayCol)
        surface.SetMaterial(CMB_OVERLAY)
        surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end

    if nextFlicker and nextFlicker > CurTime() then
        surface.SetDrawColor(messagesCol)
        surface.DrawRect(ScrW() * .3, ScrH() * .3, 700, 20)
        draw.SimpleText("FATAL ERROR: SYSTEM REQUIRES IMMEDIATE SERVICE. REBOOTING...", "BudgetLabel", ScrW() * .5, (ScrH() * .3) + math.random(1, 2), red, TEXT_ALIGN_CENTER, 0)
        return
    end

    local hp = lp:Health()
    if hp <= 25 and (not nextCheck or nextCheck < CurTime()) then
        local ubound = math.Clamp(hp, 8, 20)
        local rand = math.random(1, ubound)

        if rand == ubound then
            nextFlicker = CurTime() + math.Rand(0.1, 1)
            surface.PlaySound("ambient/levels/prison/radio_random"..math.random(1,13)..".wav")
        else
            nextCheck = CurTime() + 0.1
            offset = math.random(10, 80)
        end
    end

    
    
    DrawCombineWaypoints()

    if WATCHING_CAM then
        DrawCombineCameraOverlay()
    end

    local sqData
    if lp:GetSyncVar(SYNC_SQUAD_ID, nil) then
        sqData = DrawCombineSquad()
    end

    if lp:Team() == TEAM_OTA or lp:Team() == TEAM_CP or (lp:Team() == TEAM_CWU and lp:GetTeamClass() == CLASS_ICT) then
        local pos = lp:GetPos()

        DrawCombineCompass(sqData)

        local wep = lp:GetActiveWeapon()
        if wep and IsValid(wep) then
            local clip = wep:Clip1()
            local maxClip = wep:GetMaxClip1()

            if maxClip > 0 and clip < maxClip * 0.2 then
                DrawLowAmmo(offset)
            end
        end
    elseif lp:Team() == TEAM_CP then
        local wep = lp:GetActiveWeapon()

        if wep and IsValid(wep) and wep:GetClass() == "plutonic_stunstick" and lp:IsWeaponRaised() then
            DrawBatonStatus(wep, offset)
        end
    end
    
    if lp:GetSyncVar(SYNC_BLEEDING,false) then
        draw.SimpleText("<:: UNIT IS BLEEDING, SEEK MEDICAL ATTENTION! ::>","BudgetLabel",ScrW()/2, ScrH()/2+100, Color(255,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local h = DrawCombineMessages(offset)
    DrawAuxData(offset)

    if CP_OBJECTIVE then
        if CP_OBJECTIVE.endTime < CurTime() then
            CP_OBJECTIVE = nil
        else
            DrawCombineObjective(CP_OBJECTIVE.citycode)
        end
    end
    if lp:IsScanner() then
        DrawScannerHUD()         
    end
end

hook.Add("HUDPaint", "impulseHL2RPCombineOverlay", DrawCombineHUD)

local function CameraView(ply, pos, ang, fov)
    if not WATCHING_CAM then
        return
    end

    if not IsValid(WATCHING_CAM) then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    if not WATCHING_CAM:IsCameraEnabled() then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return LocalPlayer():Notify("Camera signal lost.")
    end

    if not LocalPlayer():Alive() then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    if not LocalPlayer():IsCP() then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    if WATCHING_CAM_POS:DistToSqr(LocalPlayer():GetPos()) > (70 ^ 2) then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return ply:Notify("You moved too far from the terminal.")
    end

    local eyes = WATCHING_CAM:LookupAttachment("eyes")

    if not eyes then
        impulse.hudEnabled = true
        WATCHING_CAM = nil
        return
    end

    local data = WATCHING_CAM:GetAttachment(eyes)
    data.Pos = data.Pos + data.Ang:Forward() * 2.8

    local view = {}
    view.origin = data.Pos
    view.angles = data.Ang
    view.fov = 110

    return view
end

hook.Add("CalcView", "impulseHL2RPCombineCamView", CameraView)

function impulse.AddCombineMessage(text, col, noSound)
    impulse.CombineMessageID = impulse.CombineMessageID + 1
    text = "<:: "..string.upper(text)

    if col then
        col.a = 175
    end

    local msgData = {
        message = "",
        bgCol = col
    }

    table.insert(impulse.CombineMessages, msgData)

    if (#impulse.CombineMessages > 8) then
        table.remove(impulse.CombineMessages, 1)
    end

    local i = 1
    local id = "impulse_CombineOverlay"..impulse.CombineMessageID

    timer.Create(id, 0.005, #text + 1, function()
        msgData.message = string.sub(text, 1, i + 2)
        i = i + 3

        if msgData.message == #text then
            LocalPlayer():EmitSound("buttons/button24.wav", 40, 135)
            timer.Remove(id)
        end
    end)

    if not noSound then
        LocalPlayer():EmitSound("buttons/button24.wav")
    end
end

function impulse.AddCombineWaypoint(message, pos, duration, icon, colour, textcolour, unit, sender, citizen)
    local waypoint = {
        text = message,
        pos = pos,
        endtime = duration and (CurTime() + duration) or nil,
        mat = CMB_OVERLAY_ICONS[icon or 1],
        colour = CMB_OVERLAY_COLS[colour or 1],
        textcolour = CMB_OVERLAY_COLS[textcolour or 1] or color_white
    }

    if unit and IsValid(unit) then
        waypoint.name = unit:Nick()
        waypoint.prefix = "UNIT"
    elseif sender and IsValid(sender) then
        waypoint.name = sender:Nick()
        waypoint.prefix = "SENDER"
    elseif citizen then
        waypoint.name = citizen:Nick()
        waypoint.prefix = "TARGET"
    end

    local id = table.insert(impulse.CombineWaypoints, waypoint)

    LocalPlayer():EmitSound("buttons/button17.wav", 45, 135)

    return id
end

net.Receive("impulseHL2RPCombineMessage", function()
    local message = net.ReadString()
    local col = net.ReadColor()

    if col == Color(0, 0, 0) then
        impulse.AddCombineMessage(message)
    else
        impulse.AddCombineMessage(message, col)
    end
end)

net.Receive("impulseHL2RPCombineWaypoint",function()
    local message = net.ReadString()
    local pos = net.ReadVector()
    local duration = net.ReadUInt(10)
    local icon = net.ReadUInt(8)
    local colour = net.ReadUInt(8)
    local unit = net.ReadUInt(8)

    if unit != 0 then
        unit = Entity(unit)

        if not IsValid(unit) then
            unit = nil
        end
    end

    impulse.AddCombineWaypoint(message, pos, duration, icon, colour, colour, unit or nil)
end)

net.Receive("impulseHL2RPCombineOverlayBoot", function()
    if impulse.GetSetting("bootskip") == false then
        bootDone = nil
        command = 1
        nextCommand = nil
    end
end)

local nextMessage
local lastMessage
local idleMessages = {
        "Idle connection...",
        "Pinging loopback...",
        "Updating biosignal coordinates...",
        "Establishing DC link...",
        "Checking exodus protocol status...",
        "Updating politi-stabilization index...",
        "Scanning for infection hotpoints...",
        "Synchronizing status with scanner database...",
        "Radio Status: OK...",
        "Calculating socio-fracture probability...",
        "Scanning for firewall breaches...",
        "Searching for unaccounted units...",
        "Testing connection to Sector Citadel... CONNECTED...",
        "Awaiting confirmation from Nova Prospekt transport team...",
        "Sending commdata to dispatch...",
        "SPR. INDX #: " .. GetSporeCount()
}


hook.Add("Think", "impulseAmbientMessages", function()
    local lp = LocalPlayer()

    if (lp:Team() == TEAM_CP or lp:Team() == TEAM_OTA or lp:Team() == TEAM_CA or (lp:Team() == TEAM_CWU and lp:GetTeamClass() == CLASS_ICT)) and (nextMessage or 0) < CurTime() then
        local message = idleMessages[math.random(1, #idleMessages)]

        if message != (lastMessage or "") then
            impulse.AddCombineMessage(message, nil, true)
            lastMessage = message
        end

        nextMessage = CurTime() + 30 + math.random(10, 38)
    end
end)
