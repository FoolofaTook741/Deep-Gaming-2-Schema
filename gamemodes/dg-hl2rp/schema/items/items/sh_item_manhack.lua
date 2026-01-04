local ITEM = {}

ITEM.UniqueID = "item_manhack"
ITEM.Name = "Vicerator"
ITEM.Desc =  "A robotic drone equipped with rotating blades. Has a short battery life."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/manhack.mdl")
ITEM.FOV = 6.0716332378223
ITEM.CamPos = Vector(-55.01432800293, -24.756446838379, 102.12034606934)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Deploy"

function ITEM:OnUse(ply)
    local trace = {}
    trace.start = ply:EyePos()
    trace.endpos = trace.start + ply:GetAimVector() * 85
    trace.filter = ply

    local tr = util.TraceLine(trace)

    if IsValid(tr.Entity) then
        ply:Notify("You can't deploy the Vicerator here.")
        return false
    end

    if not ply:OnGround() then
        return false
    end

    if ply:Team() == TEAM_CP then
        ply:ForceSequence("deploy", function()
        if not IsValid(ply) then
            return
        end

            local m = ents.Create("npc_manhack")
            m:SetPos(tr.HitPos)
            m:SetAngles(ply:EyeAngles())
            m:SetOwner(ply)
            m:Spawn()
            m:Activate()

            m:CallOnRemove("manhackCleaner", function()
                if IsValid(ply) then
                    ply.activeManhack = nil
                end
            end)

            for k, v in pairs(player.GetAll()) do 
                if v:Team() == TEAM_CP or v:Team() == TEAM_OTA or v:Team() == TEAM_CA then
                    m:AddEntityRelationship(v, D_LI, 99) -- be nice by default :)
                elseif v:GetMoveType() != MOVETYPE_NOCLIP then
                    m:AddEntityRelationship(v, D_LI, 99)
                elseif v:Team() == TEAM_ZOMBIE then
                    m:AddEntityRelationship(v, D_HT, 199)
                elseif v:IsRebel() then
                    m:AddEntityRelationship(v, D_HT, 99)
                else
                    m:AddEntityRelationship(v, D_NU, 99)
                end
            end

            ply.activeManhack = m

            local sid = ply:SteamID()
            local endTime = CurTime() + impulse.Config.ManhackTime
            timer.Create("impulseManhackThink"..sid, 3, 0, function()
                if not IsValid(m) then
                    timer.Remove("impulseManhackThink"..sid)
                    return
                end

                if not IsValid(ply) or ply:Team() != TEAM_CP then
                    timer.Remove("impulseManhackThink"..sid)
                    m:Remove()
                    return
                end

                if endTime < CurTime() then
                    timer.Remove("impulseManhackThink"..sid)
                    m:Remove()

                    if IsValid(ply) then
                        ply:Notify("Your Vicerator's charge has expired.")
                    end

                    return
                end

                if IsValid(m.mainTarget) then
                    if m.mainTarget:IsPlayer() and m.mainTarget:IsCP() then
                        m:AddEntityRelationship(m.mainTarget, D_LI, 300)
                    elseif m:GetMoveType() == MOVETYPE_NOCLIP then
                        m:AddEntityRelationship(m.mainTarget, D_NU, 300)
                    elseif m.mainTarget:IsPlayer() and not m.mainTarget:Alive() then
                        m:AddEntityRelationship(m.mainTarget, D_NU, 300)
                        m.mainTarget = nil
                    elseif m.mainTarget:IsRebel() == false and m.mainTarget != TEAM_ZOMBIE then
                        m:AddEntityRelationship(m.mainTarget, D_NU, 200) -- hate ppl
                        m:SetTarget(m.mainTarget)
                    else
                        m:AddEntityRelationship(m.mainTarget, D_HT, 200) -- hate ppl
                        m:SetTarget(m.mainTarget)
                    end

                    local dist = m.mainTarget:GetPos():DistToSqr(m:GetPos())

                    if dist > 2500 then
                        m.mainTarget = nil
                    end
                end
            end)
        end)
    else
        local m = ents.Create("npc_manhack")
            m:SetPos(tr.HitPos)
            m:SetAngles(ply:EyeAngles())
            m:SetOwner(ply)
            m:Spawn()
            m:Activate()

            m:CallOnRemove("manhackCleaner", function()
                if IsValid(ply) then
                    ply.activeManhack = nil
                end
            end)
            for k, v in pairs(player.GetAll()) do 
                if v:Team() == TEAM_CP or v:Team() == TEAM_OTA or v:Team() == TEAM_CA then
                    m:AddEntityRelationship(v, D_LI, 99) -- be nice by default :)
                elseif v:GetMoveType() != MOVETYPE_NOCLIP then
                    m:AddEntityRelationship(v, D_LI, 99)
                elseif v:Team() == TEAM_ZOMBIE then
                    m:AddEntityRelationship(v, D_HT, 199)
                elseif v.IsARebel then
                    m:AddEntityRelationship(v, D_HT, 99)
                else
                    m:AddEntityRelationship(v, D_NU, 99)
                end
            end
            ply.activeManhack = m 

            local sid = ply:SteamID()
            local endTime = CurTime() + impulse.Config.ManhackTime
            timer.Create("impulseManhackThinkota"..sid, 1, 0, function()
                if not IsValid(m) then
                    timer.Remove("impulseManhackThinkota"..sid)
                    return
                end

                if not IsValid(ply) or ply:Team() != TEAM_OTA then
                    timer.Remove("impulseManhackThinkota"..sid)
                    m:Remove()
                    return
                end

                if endTime < CurTime() then
                    timer.Remove("impulseManhackThinkota"..sid)
                    m:Remove()

                    if IsValid(ply) then
                        ply:Notify("Your Vicerator's charge has expired.")
                    end

                    return
                end

                if IsValid(m.mainTarget) then
                    if m.mainTarget:IsPlayer() and m.mainTarget:IsCP() then
                        return
                    end
                    if m:GetMoveType() == MOVETYPE_NOCLIP then
                        return
                    end
                    m:AddEntityRelationship(m.mainTarget, D_HT, 200) -- hate ppl
                    m:SetTarget(m.mainTarget)

                    if m.mainTarget:IsPlayer() and not m.mainTarget:Alive() then
                        m:AddEntityRelationship(m.mainTarget, D_NU, 300)
                        m.mainTarget = nil
                        return
                    end

                    local dist = m.mainTarget:GetPos():DistToSqr(m:GetPos())

                    if dist > 1000 then
                        m.mainTarget = nil
                    end
                end
            end)
    end

    ply:Notify("You have deployed a Vicerator.")    

    return true
end

impulse.RegisterItem(ITEM)
