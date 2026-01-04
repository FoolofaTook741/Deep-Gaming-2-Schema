util.AddNetworkString("workshiftSquadMake")
util.AddNetworkString("workshiftSquadJoin")
util.AddNetworkString("workshiftSquadLeave")
util.AddNetworkString("workshiftSquadKick")
util.AddNetworkString("workshiftSquadClaim")


function PLUGIN:PlayerChangedTeam(ply, old, new)
    ply:SetSyncVar(SYNC_CWU_SQUAD, nil, true)
    ply:SetSyncVar(SYNC_CWU_SQUADLEAD, nil, true)
end


function PLUGIN:PlayerChangeClass(ply)
    if ply:GetSyncVar(SYNC_CWU_SQUAD) then
        ply:SetSyncVar(SYNC_CWU_SQUAD, nil, true)
    end
    if ply:GetSyncVar(SYNC_CWU_SQUADLEAD) then
        ply:SetSyncVar(SYNC_CWU_SQUADLEAD, nil, true)
    end
end

function PLUGIN:PlayerChangeRank(ply)
    if ply:GetSyncVar(SYNC_CWU_SQUAD) then
        ply:SetSyncVar(SYNC_CWU_SQUAD, nil, true)
    end
    if ply:GetSyncVar(SYNC_CWU_SQUADLEAD) then
        ply:SetSyncVar(SYNC_CWU_SQUADLEAD, nil, true)
    end
end

if timer.Exists("workshiftSquadThink") then
    timer.Remove("workshiftSquadThink")
end

local squadExpireIndex = squadIndex or {}
timer.Create("workshiftSquadThink", 10, 0, function()
    local temp = {}
    local temp2 = {}

    for v,k in pairs(team.GetPlayers(TEAM_CWU)) do
        local squad = k:GetSyncVar(SYNC_CWU_SQUAD)
        if squad then
            temp[squad] = true
            if k:GetSyncVar(SYNC_CWU_SQUADLEAD) then
                temp2[squad] = true
            end
        end
    end

    for v,k in pairs(temp) do
        if not temp2[v] then
            if not timer.Exists("workshiftSquadExpireCWU" .. v) then
                timer.Create("workshiftSquadExpireCWU" .. v, impulse.Config.SquadExpiryTime, 1, function()
                    local leaderFound = false
                    for a,b in pairs(team.GetPlayers(TEAM_CWU)) do
                        if b:GetSyncVar(SYNC_CWU_SQUAD, -1) == v and b:GetSyncVar(SYNC_CWU_SQUADLEAD) then
                            leaderFound = true
                        end
                    end

                    if not leaderFound then
                        for a,b in pairs(team.GetPlayers(TEAM_CWU)) do
                            if b:GetSyncVar(SYNC_CWU_SQUAD, -1) == v then
                                b:SetSyncVar(SYNC_CWU_SQUAD, nil, true)
                                b:SetSyncVar(SYNC_CWU_SQUADLEAD, nil, true)
                                b:Notify("Your squad has been disbanded as the leader was not replaced in time.")
                            end
                        end
                    end
                end)
            end
        end
    end
end)

net.Receive("workshiftSquadMake", function(len, ply)
    if (ply.nextSquadDo or 0) > CurTime() then 
        return 
    end
    ply.nextSquadDo = CurTime() + 1

    if not ply:Alive() then
        return
    end

    if not ply:CWUSquadCanMake() then
        return
    end

    local lowestFree = 1
    local squads = {}
    local biggestSquad = 0

    for v, k in pairs(team.GetPlayers(ply:Team())) do
        local squad = k:GetSyncVar(SYNC_CWU_SQUAD)
        if not squad then continue end
        squads[squad] = true
        if squad > biggestSquad then
            biggestSquad = squad
        end
    end

    for i = 1, biggestSquad + 1 do
        if not squads[i] then
            lowestFree = i
            break
        end
    end

    ply:SetSyncVar(SYNC_CWU_SQUADLEAD, true, true)
    ply:SetSyncVar(SYNC_CWU_SQUAD, lowestFree, true)
    ply:Notify("You have created a new workshift.")
end)

net.Receive("workshiftSquadLeave", function(len, ply)
    if (ply.nextSquadDo or 0) > CurTime() then 
        return 
    end
    ply.nextSquadDo = CurTime() + 1

    if not ply:Alive() then
        return
    end

    if not ply:CWUGetSquad() then
        return
    end

    if ply:GetSyncVar(SYNC_CWU_SQUADLEAD) then
        ply:SetSyncVar(SYNC_CWU_SQUADLEAD, nil, true)
    end

    ply:SetSyncVar(SYNC_CWU_SQUAD, nil, true)
    ply:Notify("You have left your workshift")
end)

net.Receive("workshiftSquadJoin", function(len, ply)
    if (ply.nextSquadDo or 0) > CurTime() then 
        return 
    end
    ply.nextSquadDo = CurTime() + 1

    if not ply:Alive() then
        return
    end

    local squadId = net.ReadUInt(8)
    
    ply:SetSyncVar(SYNC_CWU_SQUAD, squadId, true)
end)

net.Receive("workshiftSquadClaim", function(len, ply)
    if (ply.nextSquadDo or 0) > CurTime() then 
        return 
    end
    ply.nextSquadDo = CurTime() + 1

    if not ply:Alive() then
        return
    end

    if not ply:CWUSquadCanClaim() then
        ply:Notify("You need to be a supervisor+ to claim workshifts")
        return
    end
    
    ply:SetSyncVar(SYNC_CWU_SQUADLEAD, true, true)
end)

net.Receive("workshiftSquadKick", function(len, ply)
    if (ply.nextSquadDo or 0) > CurTime() then 
        return 
    end
    ply.nextSquadDo = CurTime() + 1

    if not ply:Alive() then
        return
    end

    local meHaveSquad, mySquad = ply:CWUGetSquad()
    if not meHaveSquad then
        return
    end

    if not ply:GetSyncVar(SYNC_CWU_SQUADLEAD) then
        return
    end

    local targ = net.ReadEntity()
    if not targ:IsPlayer() then
        return
    end
    
    local themHaveSquad, theirSquad = targ:CWUGetSquad()
    if not themHaveSquad then
        return
    end
    
    if mySquad ~= theirSquad then
        return
    end
    
    targ:SetSyncVar(SYNC_CWU_SQUAD, nil, true)
    targ:Notify("You have been kicked from the workshift group by " .. ply:Nick() .. ".")
    ply:Notify("You have kicked " .. targ:Nick() .. " from your workshift.")
end)

local cooldowns = {}