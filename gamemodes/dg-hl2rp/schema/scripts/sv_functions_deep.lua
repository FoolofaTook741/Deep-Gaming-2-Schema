function GetICTCount()
	local amonguses = 0
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CWU and v:GetTeamClass() == CLASS_ICT then
			amonguses = amonguses + 1
		end
	end
	return amonguses
end

function GetResearchCount()
	local res = 0
	for k, v in pairs(player.GetAll()) do
		if v:Team() == TEAM_CWU and v:GetTeamClass() == CLASS_RESEARCH then
			res = res + 1
		end
	end
	return res
end


function GetSporeCount()
    local spores = 0
    for k, v in pairs(ents.FindByClass("deep_spore")) do
        spores = spores + 1
    end
    return spores
end

function GetTrashCount()
    local trash = 0
    for k, v in pairs(ents.FindByClass("pinnacle_trash")) do
        trash = trash + 1
    end
    return trash
end

function SpawnCluster(num)
    local pos = impulse.Config.SporeClusters[num]
    local spore = ents.Create("deep_spore")
    for k,v in pairs(ents.FindByClass("deep_spore")) do
        if v:GetPos():Distance(pos) < 300 then
            return
        end
    end
    spore:SetPos(pos)
    spore:SetUnFreezable(true)
    spore:SetMoveType(MOVETYPE_NONE)
    spore:Spawn()
end

function SpawnTrash(num)
    local pos = impulse.Config.TrashSpawns[num]
    if not pos then return end

    local spore = ents.Create("pinnacle_trash")
    for k,v in pairs(ents.FindByClass("pinnacle_trash")) do
        if v:GetPos():Distance(pos) < 300 then
            return
        end
    end
    spore:SetPos(pos)
    spore:SetUnFreezable(true)
    spore:SetMoveType(MOVETYPE_NONE)
    spore:Spawn()
end

function SpawnBarnacleSpawner(num)
    local pos = impulse.Config.SporeClusters[num]
    local barnacle = ents.Create("deep_barnaclespawner")
    for k, v in pairs(ents.FindByClass("deep_barnaclespawner")) do
        if v:GetPos():Distance(pos) < 300 then
            return
        end
    end
    barnacle:SetPos(pos)
    barnacle:SetUnFreezable(true)
    barnacle:SetMoveType(MOVETYPE_NONE)
    barnacle:Spawn()
end

function meta:IsCombineHighCommand()
    if self:Team() == TEAM_CP and self:GetTeamRank() >= RANK_DVL then
        return true
    elseif self:Team() == TEAM_OTA and self:GetTeamRank() >= RANK_ORD then
        return true
    elseif self:Team() == TEAM_CA and self:GetTeamRank() >= RANK_CA then
        return true
    else
        return false
    end
end

local hostname   = GetConVar("hostname"):GetString()
function ReqwestLog(embeddedmessages, webhook)

    if not webhook then
        impulse.debugPrint("Discord webhooks disabled on development servers")
        return
    end

    local serverName = (hostname == "Deep Gaming 2 | Half Life 2 Roleplay | discord.gg/deepgaming") and "Main" or "Dev"

    for _, embed in ipairs(embeddedmessages) do
        embed.fields = embed.fields or {}
        table.insert(embed.fields, {
            name  = "Server:",
            value = serverName,
            inline = false,
        })
    end

    reqwest({
        method = "POST",
        url = webhook,
        timeout = 30,
        body = util.TableToJSON({ embeds = embeddedmessages }),

        headers = {
            ["User-Agent"] = "Pinnacle Gaming",
            ["Content-Type"] = "application/json",  -- Explicitly set Content-Type to JSON
        },

        failed = function(error, errExt)
            MsgC(Color(255,0,0), "impulse discord log error: "..error.. " - " ..errExt)
        end,
        success = function(status, body, headers)
            print(status)
            print(headers)
            print(body)
        end
    })
end


function ReqwestLogMessage(message, webhook)

    if true then return end

    if not webhook then
        impulse.debugPrint("Discord webhooks disabled on development servers")
        return
    end
    reqwest({
        method = "POST",
        url = webhook,
        timeout = 30,
        body = util.TableToJSON({
            content = message
        }),

        headers = {
            ["User-Agent"] = "Pinnacle Gaming", -- This is REQUIRED to dispatch a Discord webhook
            ["Content-Type"] = "application/json"
        },

        failed = function(error, errExt) MsgC(Color(255,0,0), "impulse discord log error: "..error.. " - " ..errExt) end,
        success = function(status, body, headers) print(status) print(headers) print(body) end
    })
end
