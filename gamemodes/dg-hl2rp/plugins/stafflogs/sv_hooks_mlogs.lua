
plogs.AddHook("PlayerContainerTake", function(ply, item, source)
	if source == "corpse" then
		plogs.PlayerLog(ply, 'Inventory', ply:NameID().." picked up "..item.." from a corpse", {
			['Name'] 	= ply:Name(),
			['SteamID']	= ply:SteamID()
		})
	end
end)

local hostname = GetConVar("hostname"):GetString()
hook.Add("PlayerContainerTake", "noclipInventory", function(ply, item, source, direction, amount)

    if (ply:GetMoveType() == MOVETYPE_NOCLIP) then
		local roleID = "1112861503876505601" -- Staff Manager Role
        local assistantID = "1365691096146907262" -- ASM
		local role = "Moderator"
        if ply:IsAdmin() then
            roleID = "1365690687298732154"
			role = "Moderator"
		elseif ply:IsGameMaster() then
			roleID = "1365690799102361782" -- Game Master
            assistantID = "1365691288586027008" -- AEM
			role = "Gamemaster"
        end
        local serverName = (hostname == "Deep Gaming 2 | Half Life 2 Roleplay | discord.gg/deepgaming") and "Main" or "Dev"

        local embed = {
            {
                title = "Container Accessed In Noclip",
                description = "Noclipper utilized storage.",
                url = "https://discord.com/channels/1365688835777757295/1367695815635763200",
				color = 5763719,
                fields = {
                    {
                        name = role..":",
                        value = ply:SteamName().. " ("..ply:Name()..")"
                    },
                    {
                        name = "Item:",
                        value = item or "Unknown"
                    },
					{
						name = "Quantity:",
						value = amount
					},
                    {
                        name = "Source:",
                        value = source or "Unknown"
                    },
                    {
                        name = "Direction:",
                        value = direction or "Unknown"
                    },
                    {
                        name = "Manager:",
                        value = "<@&" .. roleID .. ">"
                    }
                }
            }
        }
        local payload = {
            content = string.format("<@&%s> <@&%s>", roleID, assistantID),
            embeds = embed,
            allowed_mentions = { roles = { roleID } }
        }
        --ReqwestLog(payload, DG_SENT)
        reqwest({
            url     = DG_SENT,
            method  = "POST",
            headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "Pinnacle Gaming",
            },
            body    = util.TableToJSON(payload),

            success = function(code, body, headers)
                print(("[noclipInventory] Discord response: %d %s"):format(code, body))
            end,

            failed = function(err)
                impulse.debugPrint("[noclipInventory] Discord error:", err)
            end,
        })
    end
end)

local trackedEntities = {
    ["impulse_money"] = true,
	["impulse_item"] = true,
	["impulse_hl2rp_rationmachine"] = true,
    ["hardpointammobox"] = true,
    ["ammobox"] = true,
    ["impulse_hl2rp_hpcharger"] = true,
    ["impulse_hl2rp_armorcharger"] = true,
    ["deep_armorcharger_balanced"] = true,
    ["impulse_hl2rp_eventammobox"] = true,
    ["chensammocrate"] = true,
    ["deep_selftreatment"] = true
}

local LogTime = {}

hook.Add("PlayerUse", "detectNoclipAboose", function(ply, ent)
    if not IsValid(ply) or not IsValid(ent) then return end
    if not trackedEntities[ent:GetClass()] then return end
    if ply:GetMoveType() ~= MOVETYPE_NOCLIP then return end

    local id = ent:EntIndex()
    local curTime = CurTime()
    if LogTime[id] and (curTime - LogTime[id] < 5) then return end
    LogTime[id] = curTime

    local embeds = {
        {
            title = "Noclip Interaction Detected",
            description = "A player in noclip interacted with an entity.",
            color = 16711680, -- red color
            fields = {
                { name = "Player:", value = "**" .. ply:SteamName() .. "** | **" .. ply:Name() .. "** (" .. ply:SteamID64() .. ")" },
                { name = "Entity Class:", value = ent:GetClass() },
                { name = "Entity Model:", value = ent:GetModel() or "N/A" },
            }
        }
    }
    ReqwestLog(embeds, DG_SENT)
end)

local _sendingLuaError = false

local function SendLuaErrorToDiscord(err, stack)
    local embeds = {
        {
            title = "Lua Error Detected",
            description = "A LUA error has occurred on the server.",
            color = 16711680,
            fields = {
                { name = "Error Message:", value = "```" .. err .. "```" },
                { name = "Timestamp:", value = os.date("%Y-%m-%d %H:%M:%S") },
                { name = "Server:", value = (GetConVar("hostname"):GetString() == "Deep Gaming 2 | Half Life 2 Roleplay | discord.gg/deepgaming") and "Main" or "Dev" }
            }
        }
    }

    local ok, payload = pcall(util.TableToJSON, { embeds = embeds })
    if not ok then
        print("[ReportLuaErrorsToDiscord] Failed to serialize payload: " .. tostring(payload))
        print("[ReportLuaErrorsToDiscord] Raw stack dump:")
        PrintTable(stack or {})
        return
    end

    reqwest({
        url     = DG_LUA,
        method  = "POST",
        headers = { ["Content-Type"] = "application/json", ["User-Agent"] = "Pinnacle Gaming" },
        body    = payload,
        success = function(code, body) print(("[LuaErrorWebhook] %d %s"):format(code, body)) end,
        failed  = function(errMsg) print("[LuaErrorWebhook] Request failed: " .. tostring(errMsg)) end,
    })
end

hook.Add("OnLuaError", "ReportLuaErrorsToDiscord", function(err, realm, stack)
    if _sendingLuaError then return end
    _sendingLuaError = true

    local ok = pcall(function()
        local errorMsg = "[" .. (realm or "UNKNOWN") .. "] " .. err .. "\n"
        if stack then
            for _, line in ipairs(stack) do
                if type(line) == "table" and line.File and line.Line then
                    errorMsg = errorMsg .. "\n" .. (line.Function or "?") .. " - " .. line.File .. ":" .. line.Line
                elseif type(line) == "string" then
                    errorMsg = errorMsg .. "\n" .. line
                else
                    errorMsg = errorMsg .. "\n[Unknown stack entry]"
                end
            end
        end
        SendLuaErrorToDiscord(errorMsg, stack)
    end)

    if not ok then
        print("[ReportLuaErrorsToDiscord] Failed to process error report")
    end

    _sendingLuaError = false
end)