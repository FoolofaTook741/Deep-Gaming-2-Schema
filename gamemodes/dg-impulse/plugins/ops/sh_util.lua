if SERVER then
    util.AddNetworkString("opsGiveWarn")
    util.AddNetworkString("opsGetRecord")
end


local setHealthCommand = {
    description = "Sets health of the specified player.",
    requiresArg = true,
    gameMasterOnly = true,
    onRun = function(ply, arg, rawText)
        if !ply:IsGameMaster() and !ply:IsAdmin() then
			ply:Notify("You cannot use this command unless you are a Gamemaster or Admin.")
			return
		end
        local targ = impulse.FindPlayer(arg[1])
        local hp = arg[2]

        if not hp or not tonumber(hp) then
            return
        end

        if not ply:IsLeadAdmin() then
            hp = math.Clamp(hp, 1, 100)
        end


        if targ and IsValid(targ) then
            targ:SetHealth(hp)
            ply:Notify("You have set "..targ:Nick().."'s health to "..hp..".")
            if ply == targ then
                for v,k in pairs(player.GetAll()) do
                    if k:IsLeadAdmin() then
                        k:AddChatText(Color(135, 206, 235), "[ops] Moderator "..ply:SteamName().." set their health to "..hp..".")
                    end
                end
            end
        else
            return ply:Notify("Could not find player: "..tostring(arg[1]))
        end

        local embeds = {{
            title = "Set HP",
            description = "An admin has Set HP",
            url = "https://www.deepgaming.xyz",
            color = 10181046,
            fields = {
                {
                    name = "Admin:",
                    value = ply:Name() .. " (" .. ply:SteamID() .. ")"
                },
                {
                    name = "Target:",
                    value = targ and (targ:Nick() .. " (" .. targ:SteamID() .. ")") or tostring(arg[1])
                },
                {
                    name = "Health Set:",
                    value = tostring(hp)
                }
            }
        }}
        ReqwestLog(embeds, DG_OPS)
    end
}

impulse.RegisterChatCommand("/sethp", setHealthCommand)

local setHungerCommand = {
    description = "Sets hunger of the specified player.",
    requiresArg = true,
    gamemasterOnly = true,
    onRun = function(ply, arg, rawText)
        if !ply:IsGameMaster() and !ply:IsAdmin() then
            ply:Notify("You cannot use this command unless you are an GM or Admin.")
            return
        end
        local targ = impulse.FindPlayer(arg[1])
        local amount = arg[2]

        if not amount or not tonumber(amount) then
            return
        end

        if not ply:IsLeadAdmin() then
            amount = math.Clamp(amount, 1, 100)
        end

        if targ and IsValid(targ) then
            targ:SetHunger(amount)
            ply:Notify("You have set "..targ:Nick().."'s hunger to "..amount..".")
            if ply == targ then
                for v,k in pairs(player.GetAll()) do
                    if k:IsLeadAdmin() then
                        k:AddChatText(Color(135, 206, 235), "[ops] Moderator "..ply:SteamName().." set their hunger to "..amount..".")
                    end
                end
            end
        else
            return ply:Notify("Could not find player: "..tostring(arg[1]))
        end

        local embeds = {{
            title = "Set Hunger",
            description = "An admin has set hunger",
            url = "https://www.deepgaming.xyz",
            color = 10181046,
            fields = {
                {
                    name = "Admin:",
                    value = ply:Name() .. " (" .. ply:SteamID() .. ")"
                },
                {
                    name = "Target:",
                    value = targ and (targ:Nick() .. " (" .. targ:SteamID() .. ")") or tostring(arg[1])
                },
                {
                    name = "Hunger Set:",
                    value = tostring(amount)
                }
            }
        }}
        ReqwestLog(embeds, DG_OPS)
    end
}

impulse.RegisterChatCommand("/sethunger", setHungerCommand)

local kickCommand = {
    description = "Kicks the specified player from the server.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local name = arg[1]
        local plyTarget = impulse.FindPlayer(name)

        local reason = ""

        for v,k in pairs(arg) do
            if v != 1 then
                reason = reason.." "..k
            end
        end

        reason = string.Trim(reason)

        if reason == "" then reason = nil end

        if plyTarget and ply != plyTarget then
            if plyTarget:IsSuperAdmin() then
                return ply:Notify("You can not kick this user.")
            end
            ply:Notify("You have kicked "..plyTarget:Name().." from the server.")
            plyTarget:Kick(reason or "Kicked by a game moderator.")
            local steamid = plyTarget:SteamID64() or "BOT"

            local embeds = {{
                title = "Kick Issued",
                description = "User was kicked by a staff member.",
                url = "https://pinnacle-gaming.xyz/bans",
                color = 11027200,
                fields = {
                    {
                        name = "User:",
                        value = "**"..plyTarget:SteamName().."** ("..steamid..") ("..plyTarget:Nick()..")"
                    },
                    {
                        name = "Moderator:",
                        value = "**"..ply:SteamName().."** ("..ply:SteamID64()..")"
                    },
                    {
                        name = "Reason:",
                        value = reason or "No Reason Provided"
                    }
                }
            }}
            
            ReqwestLog(embeds, DG_OPS)
        else
            return ply:Notify("Could not find player: "..tostring(name))
        end
    end
}

impulse.RegisterChatCommand("/kick", kickCommand)

local kickbysteamidCommand = {
    description = "Kicks the specified player by their steamid, this should be used if a player is corrupted.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        local sid = arg[1]
        local target = ""
        for k,v in pairs(player.GetAll()) do
            if v:SteamID() == sid or v:SteamID64() == sid then
                target = v
                break
            end
        end
        if target == "" then
            ply:Notify("No targets found.")
            return
        end

        if target:IsSuperAdmin() then
            return ply:Notify("You can not kick this user.")
        end

        target:Kick()

        local embeds = {{
            title = "KBS Issued",
            description = "User was kicked by a staff member.",
            url = "https://pinnacle-gaming.xyz/bans",
            color = 11027200,
            fields = {
                {
                    name = "User:",
                    value = "**"..target:SteamName().."** ("..sid..") ("..target:Nick()..")"
                },
                {
                    name = "Moderator:",
                    value = "**"..ply:SteamName().."** ("..ply:SteamID64()..")"
                },
            }
        }}
        
        ReqwestLog(embeds, DG_OPS)
    end
}

impulse.RegisterChatCommand("/kbs", kickbysteamidCommand)

local snooperModeCommand = {
    description = "Makes it so you can see all of the radio channels, do not use unless you're not RPing.",
    requiresArg = false,
    leadAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply.SnooperMode == true then
            ply.SnooperMode = false
            ply:Notify("You have disabled snooper mode.")
        else
            ply.SnooperMode = true
            ply:Notify("You have enabled snooper mode.")
            timer.Simple(2, function()
                ply:Notify("Do not use this to abuse your powers. You will be punished.")
            end)
        end
    end
}

impulse.RegisterChatCommand("/snoopermode", snooperModeCommand)


local banCommand = {
    description = "Bans the specified player from the server. (time in minutes)",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply:IsAdmin() or ply:IsLeadAdmin() or ply:IsSuperAdmin() then
            local name = arg[1]
            local plyTarget = impulse.FindPlayer(name)
            local time = arg[2]
            if not time or not tonumber(time) then
                return ply:Notify("No time value supplied.")
            end
            time = tonumber(time)
            if time < 0 then
                return ply:Notify("Negative time values are not allowed.")
            end
            if time > 10000000 then
                time = 0
            end
            local reason = ""
            for v,k in pairs(arg) do
                if v > 2 then
                    reason = reason.." "..k
                end
            end
            reason = string.Trim(reason)
            if plyTarget and ply != plyTarget then
                if plyTarget:IsSuperAdmin() then
                    return ply:Notify("You can not ban this user.")
                end
                VyHub.Ban:create(plyTarget:SteamID64(), time, reason, ply:SteamID64())
                ply:Notify("You have banned "..plyTarget:SteamName().." for "..time.." minutes.")
                local steamid = plyTarget:SteamID64() or "BOT"
                local bm = "**"..ply:SteamName().."** ("..ply:SteamID()..")"
                local rs = reason or "None Provided"
                local duration = time .. " Minutes"
                local userbanned = "**"..plyTarget:SteamName().."** ("..steamid..") ("..plyTarget:Nick()..")"

                local embeds = {
                    title = "Ban Issued",
                    description = "User was banned by a staff member.",
                    url = "https://pinnacle-gaming.xyz/bans",
                    color = 15548997,
                    fields = {
                        {
                            name = "Banned User:",
                            value = userbanned
                        },
                        {
                            name = "Banning Moderator:",
                            value = bm
                        },
                        {
                            name = "Reason:",
                            value = rs
                        },
                        {
                            name = "Length:",
                            value = tostring(duration)
                        }
                    }
                }
                
                ReqwestLog(embeds, DG_OPS)

            else
                return ply:Notify("Could not find player: "..tostring(name))
            end
        end
    end
}

impulse.RegisterChatCommand("/ban", banCommand)

local warnCommand = {
    description = "Warns the specified player (reason is required).",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply:IsAdmin() or ply:IsLeadAdmin() or ply:IsSuperAdmin() then
            local name = arg[1]
            local plyTarget = impulse.FindPlayer(name)
            local reason = ""
            for v,k in pairs(arg) do
                if v > 1 then
                    reason = reason.." "..k
                end
            end
            reason = string.Trim(reason)
            if reason == "" then
                return ply:Notify("No reason provided.")
            end
            if plyTarget and ply != plyTarget then
                VyHub.Warning:create(plyTarget:SteamID64(), reason, ply:SteamID64())                
                ply:Notify("You have warned "..plyTarget:SteamName().." for "..reason..".")
                local steamid = plyTarget:SteamID64() or "BOT"

                local embeds = {
                    title = "Warn Issued",
                    description = "User was banned by a staff member.",
                    url = "https://pinnacle-gaming.xyz/bans",
                    color = 16776960,
                    fields = {
                        {
                            name = "Warned User:",
                            value = "**"..plyTarget:SteamName().."** ("..steamid..") ("..plyTarget:Nick()..")"
                        },
                        {
                            name = "Warning Moderator:",
                            value = "**"..ply:SteamName().."** ("..ply:SteamID64()..")"
                        },
                        {
                            name = "Reason:",
                            value = reason or "No Reason Provided"
                        }
                    }
                }
                
                ReqwestLog(embeds, DG_OPS)
            end
        end
    end
}
impulse.RegisterChatCommand("/warn", warnCommand)

local ipBanCommand = {
    description = "Bans a players IP, must be online. /ipban steamid. All IP Bans are permanent by default.",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if ply:IsSuperAdmin() then
            local steamid = arg[1]
            local targ = player.GetBySteamID(steamid)
            if targ:IsSuperAdmin() then
                ply:Notify("You cannot ban a superadmin's ip.")
                return
            end
            if ply:IsSuperAdmin() then
                ply:Notify(targ:Name() .. " banned via IP address.")
                game.ConsoleCommand("addip 0 " .. targ:IPAddress())
                VyHub.Ban:create(targ:SteamID64(), 0, "Synchronized Platform Ban Issued, Contact Community Management for Support.", ply:SteamID64())
                game.ConsoleCommand(writeip)
                for k,v in pairs(player.GetAll()) do
                    if v:IsSuperAdmin() then
                        v:AddChatText(Color(135, 206, 235), "[ops] SuperAdmin "..ply:SteamName().." IP banned " .. steamid .. ".")
                    end
                end
                return
            end
        end
    end
}
impulse.RegisterChatCommand("/ipban", ipBanCommand)

local resetRationCommand = {
    description = "Resets a player's ration cooldown. Args: STEAMID",
    requiresArg = true,
    adminOnly = true, -- 
    onRun = function(ply, arg, rawText)
        if not ply:IsAdmin() then
            ply:Notify("You must be an admin to use this command.")
            return
        end

        local steamid = arg[1]
        if not steamid or steamid:len() > 25 then
            ply:Notify("Invalid SteamID.")
            return
        end

        local target = player.GetBySteamID(steamid)
        if not IsValid(target) then
            ply:Notify("Player not found online.")
        else
            target.NextRation = CurTime() - 1 
            target:Notify("Your ration cooldown has been reset by " .. ply:SteamName() .. ".")
            ply:Notify("Ration cooldown reset for " .. target:Nick() .. " (" .. steamid .. ").")
        end

       
        local embeds = {{
            title = "Ration Cooldown Reset",
            description = "An admin has reset a player's ration cooldown.",
            url = "https://pinnacle-gaming.xyz/news",
            color = 10181046,
            fields = {
                {
                    name = "Admin:",
                    value = ply:Name() .. " (" .. ply:SteamID() .. ")"
                },
                {
                    name = "Target:",
                    value = target and (target:Nick() .. " (" .. steamid .. ")") or steamid
                }
            }
        }}
        ReqwestLog(embeds, DG_OPS) 
    end
}

impulse.RegisterChatCommand("/resetration", resetRationCommand)

local giveMoneyCommand = {
    description = "Gives money to the specified player by SteamID.",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not (ply:IsSuperAdmin()) then
            ply:Notify("You cannot use this command.")
            return
        end
        local steamID = arg[1]
        local amount = tonumber(arg[2])
        if amount <= 0 then
            ply:Notify("Please enter an amount greater than 0.")
            return
        end

        local targ = nil
        for _, v in pairs(player.GetAll()) do
            if v:SteamID() == steamID then
                targ = v
                break
            end
        end

        if targ and IsValid(targ) then
            local currentMoney = targ:GetMoney() or 0 
            targ:SetMoney(currentMoney + amount)
            ply:Notify("You have given " .. amount .. " credits to " .. targ:Nick() .. " (" .. steamID .. ").")
            targ:Notify(ply:Nick() .. " has given you " .. amount .. " credits.")
        else
            if not impulse.Database then
                ply:Notify("Database issue, please try again later.")
                return
            end

           
            local query = "UPDATE impulse_players SET money = money + " .. amount .. " WHERE steamid = '" .. steamID .. "'"
            impulse.Database:Query(query, function(result)
                if result then
                    ply:Notify("Gave " .. amount .. " credits to offline player " .. steamID .. ".")
                else
                    ply:Notify("Failed to give money to " .. steamID .. " (database error).")
                end
            end)
        end
        local embeds = {{
            title = "Give Money Command",
            description = "An admin has given a player money.",
            url = "https://pinnacle-gaming.xyz/news",
            color = 10181046,
            fields = {
                {
                    name = "Admin:",
                    value = ply:Name() .. " (" .. ply:SteamID() .. ")"
                },
                {
                    name = "Target:",
                    value = target and (target:Nick() .. " (" .. steamid .. ")") or steamid
                }
            }
        }}
        ReqwestLog(embeds, DG_OPS) 
    end
}

impulse.RegisterChatCommand("/givemoney", giveMoneyCommand)

local fixLegs = {
    description = "Fixes the legs of the specified player by SteamID.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if not (ply:IsAdmin()) then
            ply:Notify("You cannot use this command.")
            return
        end
        local steamID = arg[1]

        local targ = nil
        for _, v in pairs(player.GetAll()) do
            if v:SteamID() == steamID then
                targ = v
                break
            end
        end

        if targ and IsValid(targ) then
            targ:SetSyncVar(SYNC_BROKENLEGS, false, true)
            ply:Notify("You have fixed the legs of " .. targ:Nick() .. " (" .. steamID .. ").")
            targ:Notify(ply:Nick() .. " has fixed your legs.")
        else
            ply:Notify("Player not found, or is not online.")
        end

        local embeds = {{
            title = "Fix Legs Command",
            description = "An admin has fixed a player's legs.",
            url = "https://www.deepgaming.xyz",
            color = 10181046,
            fields = {
                {
                    name = "Admin:",
                    value = ply:Name() .. " (" .. ply:SteamID() .. ")"
                },
                {
                    name = "Target:",
                    value = targ and (targ:Nick() .. " (" .. steamID .. ")") or steamID
                }
            }
        }}
        ReqwestLog(embeds, DG_OPS)
    end
}

impulse.RegisterChatCommand("/fixlegs", fixLegs)

local giveSCCommand = {
    description = "Gives Sterilized Credits to the specified player by SteamID.",
    requiresArg = true,
    superAdminOnly = true,
    onRun = function(ply, arg, rawText)
        if not (ply:IsSuperAdmin()) then
            ply:Notify("You cannot use this command.")
            return
        end

        local steamID = arg[1]
        local amount = tonumber(arg[2])

        if not steamID or not string.match(steamID, "^STEAM_%d:%d:%d+$") then
            ply:Notify("Invalid SteamID format.")
            return
        end

        if not amount or amount <= 0 or math.floor(amount) ~= amount then
            ply:Notify("Please enter an amount greater than 0.")
            return
        end

        if amount > 5000 then
            ply:Notify("Amount cannot exceed 5000 SC.")
            return
        end

        local targ = nil
        for _, v in pairs(player.GetAll()) do
            if v:SteamID() == steamID then
                targ = v
                break
            end
        end

        if targ and IsValid(targ) then
            targ:AdjustSC(amount, true)
            ply:Notify("You have given " .. amount .. " SC to " .. targ:Nick() .. " (" .. steamID .. ").")
            targ:Notify(ply:Nick() .. " has given you " .. amount .. " SC.")
        else
            if not mysql then
                ply:Notify("Database issue, please try again later.")
                return
            end

            local query = mysql:Update("impulse_players")
            query:Where("steamid", steamID)
            query:Update("sterilizedcredits", amount, true)
            query:Execute(function(result)
                if result then
                    ply:Notify("Gave " .. amount .. " SC to offline player " .. steamID .. ".")
                else
                    ply:Notify("Failed to give SC to " .. steamID .. " (database error).")
                end
            end)
        end

        local embeds = {{
            title = "Give SC Command",
            description = "An admin has given a player Sterilized Credits.",
            url = "https://pinnacle-gaming.xyz/news",
            color = 10181046,
            fields = {
                {
                    name = "Admin:",
                    value = ply:Name() .. " (" .. ply:SteamID() .. ")"
                },
                {
                    name = "Target:",
                    value = targ and (targ:Nick() .. " (" .. steamID .. ")") or steamID
                },
                {
                    name = "Amount:",
                    value = amount .. " SC"
                }
            }
        }}
        ReqwestLog(embeds, DG_OPS)
    end
}

impulse.RegisterChatCommand("/givesc", giveSCCommand)

AUTHEDROGUES = AUTHEDROGUES or {}
local authRogue = {
    description = "Auth a rogue MPF unit, this will grant special equipment dependent on class.",
    requiresArg = true,
    adminOnly = true,
    onRun = function(ply, arg, rawText)
        if !ply:IsGameMaster() and !ply:IsAdmin() then
            ply:Notify("You cannot use this command unless you are a Admin.")
            return
        end
        local targ = impulse.FindPlayer(arg[1])

        if targ and IsValid(targ) then
			if targ:Team() ~= TEAM_CP then 
				ply:Notify("You can only use this command on MPF units")
				return 
			elseif targ.GetTeamRank and targ:GetTeamRank() ~= RANK_I4 then
				ply:Notify("You can only use this command on I4 units")
				return
			elseif AUTHEDROGUES[targ:SteamID()] then
				ply:Notify("This player is already authed as rogue. They must die before you can auth them again.")
				return
			end
			
			local ClassName = "Unknown"
			if targ.GetTeamClass and targ:GetTeamClass() == CLASS_UNION then
				targ:GiveInventoryItem("wep_pm63", 1, true)
				targ:GiveInventoryItem("grenade_flashbang", 1, true)
				targ:GiveInventoryItem("grenade_9bang", 1, true)
				targ:GiveInventoryItem("wep_incendiaryb", 1, true)
				targ:GiveInventoryItem("wep_wsmoke", 1, true)

				targ:TakeInventoryItemClass("wep_mp7")
				targ:TakeInventoryItemClass("wep_shotgun")
				targ:TakeInventoryItemClass("wep_mp7a8")
				targ:TakeInventoryItemClass("wep_osisg")
				targ:TakeInventoryItemClass("wep_p90")
				targ:TakeInventoryItemClass("wep_m500")
				ClassName = "Union"
			elseif targ.GetTeamClass and targ:GetTeamClass() == CLASS_HELIX then
				targ:GiveInventoryItem("item_portablehpcharger", 1, true)
				ClassName = "Helix"
			elseif targ.GetTeamClass and targ:GetTeamClass() == CLASS_GRID then
				targ:GiveInventoryItem("wep_sledgehammer", 1, true)
				targ:GiveInventoryItem("item_emp", 1, true)
				targ:GiveInventoryItem("item_lockpick", 1, true)
				ClassName = "Grid"
			else
				return ply:Notify("You can only use this command on GRID, UNION and HELIX MPF units")
			end

			AUTHEDROGUES[targ:SteamID()] = true

            local sid = targ:SteamID()

            hook.Add("PlayerChangedTeam", "ResetRogueAuth_TeamChange_" .. sid, function(ply, oldTeam, newTeam)
                if ply == targ then
                    AUTHEDROGUES[sid] = nil
                    hook.Remove("PlayerChangedTeam", "ResetRogueAuth_TeamChange_" .. sid)
                end
            end)
            
            hook.Add("PlayerDisconnected", "ResetRogueAuth_Disconnect_" .. sid, function(ply)
                if ply == targ then
                    AUTHEDROGUES[sid] = nil
                    hook.Remove("PlayerDisconnected", "ResetRogueAuth_Disconnect_" .. sid)
                end
            end)
            
            hook.Add("PlayerDeath", "ResetRogueAuth_Death_" .. sid, function(victim, inflictor, attacker)
                if victim == targ then
                    AUTHEDROGUES[sid] = nil
                    hook.Remove("PlayerDeath", "ResetRogueAuth_Death_" .. sid)
                end
            end)
	
			local message = string.format(
				"%s\nRogue %s\n%s\n%d MPF  | %d CTA\nAuthed by: %s - %s",
				targ:SteamID(),
				ClassName,
				targ and targ:Nick() or "N/A",
				team.NumPlayers(TEAM_CP),
				team.NumPlayers(TEAM_OTA),
				ply:SteamName(),
				ply:SteamID()
			)

			targ:Notify("You have been authed as a rogue by "..ply:SteamName())
			ply:Notify("You have authed "..targ:Nick().." as rogue")
			ReqwestLogMessage(message, PG_STAFFLOGS)
        else
            return ply:Notify("Could not find player: "..tostring(arg[1]))
        end
    end
}
impulse.RegisterChatCommand("/authrogue", authRogue)