local f = string.format

VyHub.Player = VyHub.Player or {}
VyHub.Player.connect_queue = VyHub.Player.connect_queue or {}
VyHub.Player.table = VyHub.Player.table or {}

util.AddNetworkString("vyhub_user_id")

local meta_ply = FindMetaTable("Player")

VyHub.Group = VyHub.Group or {}
VyHub.Group.player_groups = VyHub.Group.player_groups or {}

-- Load/save helpers
local function save_group_cache()
    if VyHub.Cache then
        VyHub.Cache:save("player_groups", VyHub.Group.player_groups)
    end
end

local function load_group_cache()
    if VyHub.Cache then
        VyHub.Group.player_groups = VyHub.Cache:get("player_groups") or {}
    end
end

load_group_cache()

function VyHub.Player:initialize(ply)
    if not IsValid(ply) then return end
    local steamid = tostring(ply:SteamID64())
    VyHub:msg(f("Initializing user %s, %s", ply:SteamName(), steamid))

    -- keep track if cached rank applied
    ply.vyhub_applied_cached = ply.vyhub_applied_cached or false

    local function try_api()
        VyHub.API:get("/user/%s", {steamid}, {type="STEAM"}, function(code, result)
            if not VyHub.Player.table[steamid] then
                VyHub:msg(f("Found existing user %s for steam id %s (%s).", result.id, steamid, ply:SteamName()), "success")
            end

            VyHub.Player.table[steamid] = result
            VyHub.Player:refresh(ply) -- applies rank from API
            VyHub.Player:send_user_id(ply)
            hook.Run("vyhub_ply_initialized", ply)

            -- Setup a single refresh timer
            local ply_timer_name = "vyhub_player_" .. steamid
            if not timer.Exists(ply_timer_name) then
                timer.Create(ply_timer_name, VyHub.Config.player_refresh_time, 0, function()
                    if IsValid(ply) then
                        VyHub.Player:refresh(ply)
                    else
                        timer.Remove(ply_timer_name)
                    end
                end)
            end
        end, function(code, reason)
            local cached = VyHub.Group.player_groups[steamid]
            if cached and not ply.vyhub_applied_cached then
                VyHub:msg(f("Using cached group '%s' for %s due to API failure.", cached.group_name, ply:SteamName()), "debug")
                VyHub.Player:change_game_group(ply, cached.group_name)
                ply.vyhub_applied_cached = true
            end
            -- Don't spam "Found existing user" on retry; only retry silently
            if not timer.Exists("vyhub_retry_" .. steamid) then
                timer.Create("vyhub_retry_" .. steamid, 60, 0, function()
                    if IsValid(ply) then
                        try_api()
                    else
                        timer.Remove("vyhub_retry_" .. steamid)
                    end
                end)
            end
        end)
    end

    try_api()
end

function VyHub.Player:send_user_id(ply)
    if not IsValid(ply) then return end
    ply:VyHubID(function (user_id)
        net.Start("vyhub_user_id")
            net.WriteString(user_id)
        net.Send(ply)
    end)
end

local creation_began = {}
local creation_success = {}
local creation_err = {}

function VyHub.Player:create(steamid, success, err)
    local steamid = tostring(steamid)
    if not istable(creation_success[steamid]) then creation_success[steamid] = {} end
    if not istable(creation_err[steamid]) then creation_err[steamid] = {} end
    table.insert(creation_success[steamid], success)
    table.insert(creation_err[steamid], err)

    if creation_began[steamid] and os.time() - creation_began[steamid] < 10 then
        VyHub:msg(f("Queued creation request for steamid %s", steamid), "debug")
        return
    end

    VyHub:msg(f("No existing user found for steam id %s. Creating..", steamid))
    creation_began[steamid] = os.time()

    local function reset_queue()
        creation_began[steamid] = 0
        creation_success[steamid] = {}
        creation_err[steamid] = {}
    end

    VyHub.API:post('/user/', nil, { identifier = steamid, type = 'STEAM' }, function()
        for _, success_callback in pairs(creation_success[steamid]) do
            if success_callback then success_callback() end
        end
        reset_queue()
    end, function()
        for _, err_callback in pairs(creation_err[steamid]) do
            if err_callback then err_callback() end
        end
        reset_queue()
    end)
end

function VyHub.Player:get(steamid, callback, retry)
    if steamid == nil then callback(nil) return end
    if steamid == false then callback(false) return end
    if VyHub.Player.table[steamid] != nil then callback(VyHub.Player.table[steamid]) return end

    VyHub.API:get("/user/%s", {steamid}, {type = "STEAM"}, function(code, result)
        VyHub.Player.table[steamid] = result
        callback(result)
    end, function(code)
        if code == 404 and retry == nil then
            VyHub.Player:create(steamid, function ()
                VyHub.Player:get(steamid, callback, true)
            end, function ()
                callback(false)
            end)
        else
            callback(nil)
        end
    end, {404})
end

function VyHub.Player:change_game_group(ply, group)
    if not IsValid(ply) then return end
    local steamid64 = ply:SteamID64()
    local nick = ply:SteamName()
	
	group = group or "user"

    VyHub.Group.group_changes[steamid64] = group
	
    if group ~= "user" then
        VyHub.Group.player_groups[steamid64] = { group_name = group } -- update cache
        save_group_cache()
    end

    if serverguard then
        serverguard.player:SetRank(ply, group, false, true)
    elseif ulx then
        ULib.ucl.addUser(ply:SteamID(), {}, {}, group, true)
    elseif sam then
        sam.player.set_rank(ply, group, 0, true)
    elseif xAdmin and xAdmin.Admin.RegisterBan then
        xAdmin.SetGroup(ply, group, true)
    elseif sAdmin then
        sAdmin.setRank(ply, group, 0, false, true)
    elseif impulse then
        if IsValid(ply) then ply:SetUserGroup(group) end
        local query = mysql:Update("impulse_players")
        query:Update("group", group)
        query:Where("steamid", ply:SteamID())
        query:Execute()
        ply:SetUserGroup(group, true)
        local rankCol = impulse.Config.RankColours[ply:GetUserGroup()]
        if rankCol then
            ply:SetWeaponColor(Vector(rankCol.r / 255, rankCol.g / 255, rankCol.b / 255))
        end
    else
        ply:SetUserGroup(group, true)
    end

    VyHub:msg("Added " .. nick .. " to group " .. group, "success")
    VyHub.Util:print_chat(ply, f(VyHub.lang.ply.group_changed, group))
end

function VyHub.Player:check_group(ply, callback)
    if VyHub.Config.group_disable_sync then return end
    local user_id = ply:VyHubID()
    if not user_id then return end

    VyHub.API:get("/user/%s/group", {user_id}, {serverbundle_id = VyHub.server.serverbundle_id}, function(code, result)
        if not IsValid(ply) then return end

        local highest
        for _, group in ipairs(result) do
            if not highest or highest.permission_level < group.permission_level then
                highest = group
            end
        end

        local group_name
        if highest then
            for _, mapping in ipairs(highest.mappings) do
                if not mapping.serverbundle_id or mapping.serverbundle_id == VyHub.server.serverbundle.id then
                    group_name = mapping.name
                    break
                end
            end
        end

        -- fallback to cached group if API returned nothing
        if not group_name then
            local cached = VyHub.Group.player_groups[ply:SteamID64()]
            if cached then
                group_name = cached.group_name
                VyHub:msg(f("Using cached group '%s' for %s because API returned no group.", group_name, ply:SteamName()), "neutral")
            end
        end

        if not group_name then group_name = "user" end

        if ply:GetUserGroup() ~= group_name then
            VyHub.Player:change_game_group(ply, group_name)
        end

        if callback then callback(group_name) end
    end, function()
        -- API failed, use cached if available
        local cached = VyHub.Group.player_groups[ply:SteamID64()]
        if cached and not ply.vyhub_applied_cached then
            VyHub:msg(f("Using cached group '%s' for %s due to API failure.", cached.group_name, ply:SteamName()), "neutral")
            VyHub.Player:change_game_group(ply, cached.group_name)
            ply.vyhub_applied_cached = true
            if callback then callback(cached.group_name) end
        end
    end)
end

function VyHub.Player:refresh(ply, callback)
    VyHub.Player:check_group(ply, callback)
end

function VyHub.Player:get_group(ply)
    if not IsValid(ply) then return nil end
    return VyHub.groups_mapped[ply:GetUserGroup()]
end

function VyHub.Player:check_property(ply, property)
    if not IsValid(ply) then return false end
    local group = VyHub.Player:get_group(ply)
    if group and group.properties[property] and group.properties[property].granted then
        return true
    end
    local steamid64 = ply:SteamID64()
    if VyHub.Player.table[steamid64] then return VyHub.Player.table[steamid64].admin end
    return false
end

function meta_ply:VyHubID(callback)
    if IsValid(self) then
        local user = VyHub.Player.table[self:SteamID64()]
        local id = user and user.id or nil
        if not id or id == "" then
            VyHub.Player:get(self:SteamID64(), function(user)
                if callback then callback(user and user.id or nil) end
            end)
        else
            if callback then callback(id) end
        end
        return id
    end
end

hook.Add("vyhub_ply_connected", "vyhub_ply_vyhub_ply_connected", function(ply)
    VyHub.Player:initialize(ply)
end)

hook.Add("PlayerInitialSpawn","vyhub_ply_PlayerInitialSpawn", function(ply)
    if IsValid(ply) and not ply:IsBot() then
        if VyHub.ready then
            hook.Run("vyhub_ply_connected", ply)
        else
            VyHub.Player.connect_queue[#VyHub.Player.connect_queue+1] = ply
        end
    end
end)

hook.Add("vyhub_ready", "vyhub_ply_vyhub_ready", function ()
    timer.Simple(5, function()
        for _, ply in ipairs(VyHub.Player.connect_queue) do
            if IsValid(ply) then
                hook.Run("vyhub_ply_connected", ply)
            end
        end
        VyHub.Player.connect_queue = {}
    end)
end)