function PLUGIN:PlayerButtonDown(ply,btn)
    -- wrapped in do-end statement to prevent any chance of fuckin up another hook
    do
        if not ply:IsScanner() then
            return
        end

        local scanner = ply:GetScannerFromPlayer()
        if btn == KEY_E then
            local trg = scanner:GetCurrentTarget()
            if IsValid(trg) then
                if (scanner.LastScan or 0) > CurTime() then
                    return
                end

                if trg:IsPlayer() then
                    ply.scanCooldowns = ply.scanCooldowns or {} 
                    ply.scanCooldowns[trg] = ply.scanCooldowns[trg] or 0
                    local currentTime = CurTime()
                    if currentTime - ply.scanCooldowns[trg] < 15 then 
                        local timeLeft = math.ceil(15 - (currentTime - ply.scanCooldowns[trg]))
                        ply:Notify("Cannot scan this target yet, " .. timeLeft .. " seconds left.")
                        return 
                    end
                end
                scanner:EmitSound(Sound(table.Random(scanner.scanSounds)))
                scanner.LastScan = CurTime() + 5
                ply:Notify("Starting scan...")
                table.ForceInsert(scanner.ScanningPlayers, trg)
                net.Start("impulseHL2RPStartScanning")
                    net.WriteEntity(scanner) -- scanner
                    net.WriteEntity(trg) -- the player getting scanned
                net.Send(ply)
                timer.Simple(3,function()
                    ply:Notify("Finished scanning!")
                    table.RemoveByValue(scanner.ScanningPlayers, trg)
                    table.ForceInsert(scanner.ScannedPlayers, trg)
                    net.Start("impulseHL2RPFinishScanning")
                        net.WriteEntity(scanner) -- scanner
                        net.WriteEntity(trg) -- the player getting scanned
                    net.Send(ply)
                    if trg:IsPlayer() then
                        ply.scanCooldowns = ply.scanCooldowns or {} 
                        ply.scanCooldowns[trg] = CurTime()
                    end
                    if IsValid(trg) and trg:IsPlayer() then 
                        trg.lastFlashTime = trg.lastFlashTime or 0 -- 
                        local currentTime = CurTime()
                        if currentTime - trg.lastFlashTime >= 15 then --
                            net.Start("impulseHL2RPScannerBlind")
                            net.Send(trg)
                            trg.lastFlashTime = currentTime -- 
                        else
                            
                            local timeLeft = math.ceil(15 - (currentTime - trg.lastFlashTime))
                            ply:Notify("Flash cooling down, " .. timeLeft .. " seconds left.")
                        end
                    end
                end)
                timer.Simple(3, function()
                    if trg:IsRebel() and !trg:IsCP() then
                        local filter = RecipientFilter()
                        for k,v in pairs(player.GetAll()) do
                            if (v:Team() == TEAM_CP or v:Team() == TEAM_OTA) and not v:IsScanner() then
                                filter:AddPlayer(v)
                            end
                        end
                        net.Start("DeepScannerTag")
                        net.WriteEntity(trg)
                        net.WriteBool(true)
                        net.Send(filter)
                    elseif !trg:IsCP() then
                        local filter = RecipientFilter()
                        for k,v in pairs(player.GetAll()) do
                            if (v:Team() == TEAM_CP or v:Team() == TEAM_OTA) and not v:IsScanner() then
                                filter:AddPlayer(v)
                            end
                        end
                        net.Start("DeepScannerTag")
                        net.WriteEntity(trg)
                        net.WriteBool(false)
                        net.Send(filter)
                    end
                end)
            end

            local item = scanner:GetCurrentTargetRaw()
            if IsValid(item) then
                if item:GetClass() == "impulse_item" then
                    local itemData = impulse.Inventory.Items[item:GetItemID()]
                    if itemData.Illegal or false then
                        local rf = RecipientFilter()
                        rf:AddRecipientsByTeam(TEAM_CP)
                        net.Start("impulseHL2RPScannerAlert")
                        net.WriteEntity(ply)
                        net.WriteEntity(item)
                        net.Send(rf)
                    end
                end
            end
        elseif btn == KEY_R then
            if not (ply.NextScannerWaypoint) or ply.NextScannerWaypoint < CurTime() then
                local scanner = ply:GetScannerFromPlayer()
                if not IsValid(scanner) then
                    return
                end
                local trace = {}
                trace.start = scanner:GetPos()
                trace.endpos = trace.start + ply:GetAimVector() * 5000 -- adjust if its not far enough
                trace.filter = {ply, scanner}
                local tr = util.TraceLine(trace)
                if not tr.HitPos then
                    return
                end
                local pos = tr.HitPos
                for k,v in pairs(player.GetAll()) do
                    if v:IsCP() then
                        v:SendCombineWaypoint("AIRWATCH POINT OF INTEREST", pos, 15, 8, 10, ply)
                    end
                end
                ply.NextScannerWaypoint = CurTime() + 15
            end
        end

        if (scanner:GetModel():find("shield_scanner")) then

            local scnpilot = scanner:GetPilot()

            if btn == KEY_T then
                if scanner.NextMineDrop and scanner.NextMineDrop > CurTime() then
                    local timeLeft = math.ceil(scanner.NextMineDrop - CurTime())
                    scnpilot:Notify("Hopper mine cooldown active! " .. timeLeft .. " seconds remaining.")
                    return
                end

                local currentSequence = scanner:GetSequence()
                local hoverClosedSequence = scanner:LookupSequence("HoverClosed")

                if currentSequence == hoverClosedSequence then
                    scanner:ScannerAnim("OpenUp", true)
                    scanner:ScannerAnim("OpenUp", true)
                    local mine
                    scanner.NextMineDrop = CurTime() + 300
    
                    timer.Simple(1, function()
                        if not IsValid(scanner) then impulse.debugPrint("Scanner no longer valid") return end
                        local attach = scanner:LookupAttachment("claw")
                        impulse.debugPrint("Attachment ID: ", attach)
                        mine = ents.Create("combine_mine")
                        local angpos = scanner:GetAttachment(attach)
                        impulse.debugPrint("Mine position: ", angpos and angpos.Pos)
                        mine:SetPos(angpos.Pos)
                        mine:SetAngles(angpos.Ang)
                        mine:SetParent(scanner)
                        mine:Spawn()
                        mine:SetOwner(ply)
                        mine:Fire("setparentattachment", "claw", 0.01)
                        scanner:EmitSound("npc/ichthyosaur/snap.wav")
                    end)
    
                    timer.Simple(3, function()
                        if not IsValid(scanner) then impulse.debugPrint("Scanner no longer valid") return end
                    
                        scanner:ScannerAnim("CloseUp", true)

                        if not IsValid(mine) then impulse.debugPrint("Mine no longer valid") return end
                        mine:SetParent(nil)
                        mine:PhysicsInit(SOLID_VPHYSICS)
                        local phys = mine:GetPhysicsObject()
                    
                        if (phys:IsValid()) then
                            impulse.debugPrint("Mine physics activated")
                            phys:Wake()
                        else
                            impulse.debugPrint("Mine physics invalid")
                        end
                    
                        scanner:EmitSound("npc/scanner/combat_scan" .. math.random(1,5) .. ".wav")
                    
                        timer.Simple(2, function()
                            if not IsValid(scanner) then impulse.debugPrint("Scanner no longer valid") return end
                            scanner:EmitSound("npc/scanner/combat_scan" .. math.random(1,5) .. ".wav")
                            scanner:ScannerAnim("HoverClosed", true)
                        end)
                    end)

                    -- Notify player when cooldown expires
                    timer.Simple(300, function()
                        if IsValid(scanner) and IsValid(scnpilot) then
                            scnpilot:Notify("Hopper mine cooldown is over! You can drop another mine.")
                        end
                    end)
                else
                    impulse.debugPrint("Sequence mismatch, skipping mine drop")
                end
            end
        end
    end
end

function PLUGIN:PlayerCanHearPlayersVoice(listener, talker)
    if talker:IsScanner() then return false end
end

function PLUGIN:PlayerDisconnected(ply)
    do
        if not ply:Team() == TEAM_CP then
            return
        end

        if not ply:IsScanner() then
            return
        end

        local scanner = ply:GetScannerFromPlayer()

        if not IsValid(scanner) then
            return
        end

        
        scanner:Remove()
    end
end

function PLUGIN:PlayerSay(ply,say)
    -- console say concmds get brokey if you dont add :IsPlayer()
    if ply then
        if ply:IsScanner() then
            if not (string.Left(say,1) == "/") then
                return ""
            end
        end
    end
end

function PLUGIN:CanPlayerChangeTeam(ply)
    if ply:IsScanner() then
        return false
    end
end

function PLUGIN:PlayerUse(ply,ent)

    -- Block scanners from triggering ENTITY:Use()
    if ply:IsScanner() then
        return false
    end

end

function PLUGIN:PlayerSwitchFlashlight(ply, enabled)
    if ply:IsScanner() then
        local scanner = ply:GetScannerFromPlayer()
        if not scanner:isSpotlightOn() then
            scanner:enableSpotlight()
        else
            scanner:disableSpotlight()
        end
        return false
    end
end

function PLUGIN:PlayerSpawnProp(ply)
    if ply:IsScanner() then
        return false
    end
end

function PLUGIN:PlayerSpawnVehicle(ply)
    if ply:IsScanner() then
        return false
    end
end