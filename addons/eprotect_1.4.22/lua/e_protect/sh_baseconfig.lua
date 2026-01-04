------------------------------------------------------                                   
-- NO NOT TOUCH ANYTHING IN HERE!!!!!!!!!                                                  
------------------------------------------------------                  

local function addUsergroups(list)
    if CAMI and CAMI.GetUsergroups then
        for k,v in pairs(CAMI.GetUsergroups()) do
            list[k] = true
        end
    end
end

local function addSteamIDs(list)
    for k,v in ipairs(player.GetAll()) do
        local sid64 = v:SteamID64()
        
        if !sid64 then continue end
        
        list[sid64] = true
    end
end

eProtect = eProtect or {}

eProtect.BaseConfig = eProtect.BaseConfig or {}

eProtect.BaseConfig["disable-all-networking"] = {false, 100}

eProtect.BaseConfig["automatic-identifier"] = {1, 200, {min = 0, max = 3}}

eProtect.BaseConfig["bypass-automatic-identifier"] = {{["76561198170183094"] = true}, 250, function()
    local list = {}

    addSteamIDs(list)
    addUsergroups(list)
    
    return list
end}

eProtect.BaseConfig["block-vpn"] = {false, 300}

eProtect.BaseConfig["bypass-vpn"] = {{["76561198170183094"] = true}, 400, function()
    local list = {}

    addSteamIDs(list)
    addUsergroups(list)
    
    return list
end}

eProtect.BaseConfig["notification-groups"] = {{["superadmin"] = true}, 600, function()
    local list = {}
    
    addUsergroups(list)

    return list
end}

eProtect.BaseConfig["ratelimit"] = {500, 700, {min = -1, max = 100000}}

eProtect.BaseConfig["timeout"] = {3, 800, {min = 0, max = 5000}}

eProtect.BaseConfig["overflowpunishment"] = {2, 900, {min = 0, max = 3}}

eProtect.BaseConfig["whitelistergroup"] = {{}, 1000, function()
    local list = {}

    addUsergroups(list)

    return list
end}

eProtect.BaseConfig["bypassgroup"] = {{}, 1100, function()
    local list = {}

    addUsergroups(list)

    return list
end}

eProtect.BaseConfig["bypass_sids"] = {{["76561198170183094"] = true}, 1200, function()
    local list = {}

    addSteamIDs(list)

    return list
end}

eProtect.BaseConfig["httpfocusedurlsisblacklist"] = {true, 1300}

eProtect.BaseConfig["httpfocusedurls"] = {{}, 1400, function()
    local list = {}
    
    local tbl_http = eProtect.data["requestedHTTP"] and eProtect.data["requestedHTTP"].result or {}

    if tbl_http then
        for k,v in ipairs(tbl_http) do
            list[v.link] = true
        end
    end

    return list
end}

------------------------------------------------------           
-- NO NOT TOUCH ANYTHING IN HERE!!!!!!!!!                                                  
------------------------------------------------------76561198170183094