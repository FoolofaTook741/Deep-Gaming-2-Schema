local f = string.format

VyHub.Reward = VyHub.Reward or {}
VyHub.Reward.executed_rewards_queue = VyHub.Reward.executed_rewards_queue or {}
VyHub.Reward.executed_rewards = VyHub.Reward.executed_rewards or {}
VyHub.rewards = VyHub.rewards or {}

local function toJson(v)
    if istable(v) then
        return util.TableToJSON(v, true) or "<json encode failed>"
    end

    return tostring(v)
end

local function rekey_rewards_by_identifier(result)
    local out = {}

    for _, arewards in pairs(result or {}) do
        if not (istable(arewards) and arewards[1]) then continue end

        local a = arewards[1]

        local sid = a.user and a.user.identifier

        if not sid and a.applied_packet and a.applied_packet.user then
            sid = a.applied_packet.user.identifier
        end
        if not sid and a.applied_packet and a.applied_packet.purchase and a.applied_packet.purchase.user then
            sid = a.applied_packet.purchase.user.identifier
        end

        sid = sid and tostring(sid) or nil

        if sid and sid:match("^%d+$") then
            out[sid] = arewards
        end
    end

    return out
end

local RewardEvent = {
    DIRECT = "DIRECT",
    CONNECT = "CONNECT",
    SPAWN = "SPAWN",
    DEATH = "DEATH",
    DISCONNECT = "DISCONNECT",
    DISABLE = "DISABLE",
}

local RewardType = {
    COMMAND = "COMMAND",
    SCRIPT = "SCRIPT",
    CREDITS = "CREDITS",
    MEMBERSHIP = "MEMBERSHIP",
}

function VyHub.Reward:refresh(callback, limit_players)
    local players = limit_players or player.GetHumans()

    local params = {}
    for _, ply in ipairs(players) do
        if not IsValid(ply) then continue end
        local id = ply:VyHubID()
        if id and #id == 36 then
            params[#params + 1] = "user_id=" .. id
        end
    end

    if #params == 0 then
        if limit_players == nil then
            VyHub.rewards = {}
        end
        if callback then callback() end
        return
    end

    local user_ids = "?" .. table.concat(params, "&")
    local query = f(
        "%s&active=true&serverbundle_id=%s&status=OPEN&for_server_id=%s&foreign_ids=true",
        user_ids,
        VyHub.server.serverbundle.id,
        VyHub.server.id
    )

    VyHub.API:get("/packet/reward/applied/user" .. query, nil, nil, function(code, result)
        result = rekey_rewards_by_identifier(result)

        if limit_players == nil then
            VyHub.rewards = result
            VyHub:msg(f("Found %i users with open rewards.", table.Count(result)), "debug")
        else
            for steamid, arewards in pairs(result) do
                VyHub.rewards[steamid] = arewards
            end
        end

        if callback then callback() end
    end)
end

function VyHub.Reward:set_executed(areward_id)
    self.executed_rewards_queue[areward_id] = true
    self.executed_rewards[#self.executed_rewards + 1] = areward_id
    self:save_executed()
end

function VyHub.Reward:save_executed()
    VyHub.Cache:save("executed_rewards_queue", self.executed_rewards_queue)
end

function VyHub.Reward:send_executed()
    for areward_id, val in pairs(self.executed_rewards_queue) do
        if val == nil then continue end

        VyHub.API:patch(
            "/packet/reward/applied/%s",
            { areward_id },
            { executed_on = { VyHub.server.id } },
            function(code, result)
                self.executed_rewards_queue[areward_id] = nil
                self:save_executed()
            end,
            function(code, reason)
                if code >= 400 and code < 500 then
                    VyHub:msg(f("Could not mark reward %s as executed. Aborting.", areward_id), "error")
                    self.executed_rewards_queue[areward_id] = nil
                    self:save_executed()
                end
            end
        )
    end
end

local function normalizeSteamID64(key, arewards)
    if istable(arewards) and arewards[1] and arewards[1].user and arewards[1].user.identifier then
        return tostring(arewards[1].user.identifier)
    end

    if istable(arewards) and arewards[1]
        and arewards[1].applied_packet
        and arewards[1].applied_packet.user
        and arewards[1].applied_packet.user.identifier
    then
        return tostring(arewards[1].applied_packet.user.identifier)
    end

    if isstring(key) then return key end
    if isnumber(key) then return string.format("%.0f", key) end
    return tostring(key)
end

function VyHub.Reward:exec_rewards(event, steamid)
    local allowed_events = { event }
    local rewards_by_player = VyHub.rewards

    if steamid ~= nil then
        rewards_by_player = {}
        rewards_by_player[tostring(steamid)] = VyHub.rewards[tostring(steamid)]
        if not istable(rewards_by_player[tostring(steamid)]) then
            return
        end
    else
        if event ~= RewardEvent.DIRECT then return end
    end

    if event == RewardEvent.DIRECT then
        allowed_events[#allowed_events + 1] = RewardEvent.DISABLE
    end

    for steamidKey, arewards in pairs(rewards_by_player) do
        local sid64 = normalizeSteamID64(steamidKey, arewards)
        local ply = player.GetBySteamID64(sid64)

        if not IsValid(ply) then
            VyHub:msg(f("Player %s not valid, skipping.", sid64), "debug")
            continue
        end

        for _, areward in ipairs(arewards) do
            local reward = areward.reward
            if not reward then continue end

            if not table.HasValue(allowed_events, reward.on_event) then
                continue
            end

            if table.HasValue(self.executed_rewards, areward.id) then
                VyHub:msg(f("Skipped reward %s, because it already has been executed.", areward.id), "debug")
                continue
            end

            local data = reward.data or {}
            local se = true

            if reward.type == RewardType.COMMAND then
                if data.command ~= nil then
                    local cmd = self:do_string_replacements(data.command, ply, areward)

                    if VyHub.Config.reward_command_whitelist and #VyHub.Config.reward_command_whitelist > 0 then
                        local matched = false
                        for _, cmd_pattern in ipairs(VyHub.Config.reward_command_whitelist) do
                            if string.match(cmd, cmd_pattern) ~= nil then
                                matched = true
                                break
                            end
                        end

                        if not matched then
                            VyHub:msg(f("Failed to execute reward '%s': Command '%s' does not match a command on the whitelist.", reward.name, cmd), "error")
                            continue
                        end
                    end

                    game.ConsoleCommand(cmd .. "\n")
                end

            elseif reward.type == RewardType.SCRIPT then
                if VyHub.Config.reward_disable_scripts then
                    VyHub:msg(f(
                        "Failed to execute reward '%s': Scripts are not allowed on this server. You can enable scripts in sv_config.lua or by entering 'vh_config reward_disable_scripts false' in the server console.",
                        reward.name
                    ), "error")
                    continue
                end

                local lua_str = data.script
                if lua_str ~= nil then
                    lua_str = self:do_string_replacements(lua_str, ply, areward)
                    RunString("local PLAYER = player.GetBySteamID64(\"" .. sid64 .. "\") " .. lua_str, "vyhub_reward_script")
                end

            else
                VyHub:msg(f("No implementation for reward type %s", reward.type), "warning")
            end

            VyHub:msg(f(
                "Executed reward %s for user %s (%s): %s",
                reward.type,
                ply:SteamName(),
                ply:SteamID64(),
                toJson(data)
            ))

            if se and reward.once then
                self:set_executed(areward.id)
            end
        end
    end

    self:send_executed()
end

function VyHub.Reward:do_string_replacements(inp_str, ply, areward)
    local purchase_amount = "-"

    if areward.applied_packet and areward.applied_packet.purchase ~= nil then
        purchase_amount = areward.applied_packet.purchase.amount_text
    end

    local replacements = {
        ["user_id"] = ply:VyHubID(),
        ["nick"] = ply:SteamName(),
        ["steamid64"] = ply:SteamID64(),
        ["steamid32"] = ply:SteamID(),
        ["uniqueid"] = ply:UniqueID(),
        ["applied_packet_id"] = areward.applied_packet_id,
        ["packet_title"] = (areward.applied_packet and areward.applied_packet.packet and areward.applied_packet.packet.title) or "",
        ["purchase_amount"] = purchase_amount,
    }

    inp_str = tostring(inp_str)
    for k, v in pairs(replacements) do
        inp_str = string.Replace(inp_str, "%" .. tostring(k) .. "%", tostring(v))
    end

    return inp_str
end

hook.Add("vyhub_ready", "vyhub_reward_vyhub_ready", function()
    VyHub.Reward.executed_rewards_queue = VyHub.Cache:get("executed_rewards_queue") or {}

    VyHub.Reward.executed_rewards = {}
    for id, _ in pairs(VyHub.Reward.executed_rewards_queue) do
        VyHub.Reward.executed_rewards[#VyHub.Reward.executed_rewards + 1] = id
    end

    VyHub.Reward:refresh(function()
        VyHub.Reward:exec_rewards(RewardEvent.DIRECT)
    end)

    timer.Create("vyhub_reward_refresh", 60, 0, function()
        VyHub.Reward:refresh(function()
            VyHub.Reward:exec_rewards(RewardEvent.DIRECT)
        end)
    end)

    hook.Add("vyhub_ply_initialized", "vyhub_reward_vyhub_ply_initialized", function(ply)
        local function exec_ply_rewards()
            VyHub.Reward:exec_rewards(RewardEvent.CONNECT, tostring(ply:SteamID64()))
            hook.Run("vyhub_reward_post_connect", ply)
        end

        VyHub.Reward:refresh(exec_ply_rewards, { ply })
    end)

    hook.Add("PlayerSpawn", "vyhub_reward_PlayerSpawn", function(ply)
        if ply:Alive() then
            VyHub.Reward:exec_rewards(RewardEvent.SPAWN, tostring(ply:SteamID64()))
        end
    end)

    hook.Add("PostPlayerDeath", "vyhub_reward_PostPlayerDeath", function(ply)
        VyHub.Reward:exec_rewards(RewardEvent.DEATH, tostring(ply:SteamID64()))
    end)

    hook.Add("PlayerDisconnect", "vyhub_reward_PlayerDisconnect", function(ply)
        if IsValid(ply) then
            VyHub.Reward:exec_rewards(RewardEvent.DISCONNECT, tostring(ply:SteamID64()))
        end
    end)
end)
