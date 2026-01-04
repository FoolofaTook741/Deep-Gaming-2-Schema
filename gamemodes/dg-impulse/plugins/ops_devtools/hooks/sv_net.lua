util.AddNetworkString("opsDevGiveItem")
util.AddNetworkString("opsDevNotify")
util.AddNetworkString("opsDevForceSay")
util.AddNetworkString("opsDevSetTester")
util.AddNetworkString("opsDevSetET")
util.AddNetworkString("opsDevOpen")
util.AddNetworkString("opsDevDoAction")
util.AddNetworkString("OwOifyOn")

--[[
notice:
this is really poor security since and it only checks for net spam, and if you have the roles. it's expected that devs dont try to break their own server with broken net messages, right????
]]

net.Receive("opsDevGiveItem",function(len,ply)
    if (ply.nextGiveItem or 0) > CurTime() then return end
    ply.nextGiveItem = CurTime() + 0.01 -- less delay
    if not ply:IsSuperAdmin() then
        return 
    end

    local target = net.ReadEntity()
    local item   = net.ReadString()
    local count = net.ReadInt(32)
    if IsValid(target) then
        if target:IsPlayer() then
            if target:Alive() then -- prevent any possible bugs from the player receiving items while dead
                for i=1,count or 1 do
                    target:GiveInventoryItem(item or "testitem")
                end
                ply:Notify("Successfully gave " .. item .. " to " .. target:SteamName())
            end
        end
    end

end)

net.Receive("opsDevSetTester",function(len,ply)
    if (ply.nextDevCMD or 0) > CurTime() then return end
    ply.nextDevCMD = CurTime() + 0.1 -- less delay

    if not ply:IsSuperAdmin() then
        return 
    end

    local target = net.ReadEntity()
    local state  = net.ReadBool()

    target:SetSyncVar(SYNC_TESTER,state,true)
    if state then
        impulse.Teams.SetWhitelist(target:SteamID(),"tester",1)
    else

        impulse.Teams.SetWhitelist(target:SteamID(),"tester",0)
    end
    
end)

net.Receive("opsDevSetET",function(len,ply)
    if (ply.nextDevCMD or 0) > CurTime() then return end
    ply.nextDevCMD = CurTime() + 0.1 -- less delay

    if not ply:IsSuperAdmin() then
        return 
    end

    local target = net.ReadEntity()
    local state  = net.ReadBool()

    target:SetSyncVar(SYNC_EVENT_TEAM,state,true)
    if state then
        impulse.Teams.SetWhitelist(target:SteamID(),"eventteam",1)
    else

        impulse.Teams.SetWhitelist(target:SteamID(),"eventteam",0)
    end
    
end)

net.Receive("opsDevNotify",function(len,ply)
    if (ply.nextDevNotify or 0) > CurTime() then return end
    ply.nextDevNotify = CurTime() + 0.1 -- less delay
    if not ply:IsSuperAdmin() then
        return 
    end

    local target = net.ReadEntity()
    local str    = net.ReadString()
    if IsValid(target) then
        if target:IsPlayer() then
            target:Notify(str or "")
            ply:Notify("Successfully sent \"" .. str .. "\" to " .. target:SteamName())
        end
    end
end)

net.Receive("opsDevForceSay",function(len,ply)
    if (ply.nextForceSay or 0) > CurTime() then return end
    ply.nextForceSay = CurTime() + 0.1 -- less delay
    if not ply:IsSuperAdmin() then
        return 
    end

    local target = net.ReadEntity()
    local str    = net.ReadString()
    if IsValid(target) then
        if target:IsPlayer() then
            hook.Run("PlayerSay",target,str)
        end
    end
end)
impulse.OwOify = false
-- made it toggle but too lazy to change net message name
net.Receive("OwOifyOn",function(len,ply)
    if (ply.nextDevCMD or 0) > CurTime() then return end
    ply.nextDevCMD = CurTime() + 0.1 -- less delay
    if not ply:IsSuperAdmin() then
        return 
    end
    impulse.OwOify = not impulse.OwOify
    ply:Notify("OOC OwOify set to " .. tostring(impulse.OwOify))
end)

net.Receive("opsDevDoAction",function(len,ply)
    if (ply.nextDevCMD or 0) > CurTime() then return end
    ply.nextDevCMD = CurTime() + 0.1 -- less delay

    if not ply:IsSuperAdmin() then
        return 
    end

    local action = net.ReadString() or ""
    local args   = net.ReadTable() or {}

    if impulse.Ops.Dev[action] then
        impulse.Ops.Dev[action](args)
    else
        ply:AddChatText(Color(255,0,0,255),"[ops-dev] Action failed! (INVALID ACTION)")
    end
end)

