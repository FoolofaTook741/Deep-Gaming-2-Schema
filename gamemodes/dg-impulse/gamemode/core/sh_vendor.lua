impulse.Vendor = impulse.Vendor or {}
impulse.Vendor.Data = impulse.Vendor.Data or {}
impulse.Vendor.LiveData = impulse.Vendor.LiveData or {}
impulse.Vendor.Conditions = {}

function impulse.RegisterVendor(vendor)
    impulse.Vendor.Data[vendor.UniqueID] = vendor
end

impulse.Vendor.Conditions.Types = {
    ["rank_gte"] = {
        Label    = "Rank ≥",
        Fields   = { { name = "rank", type = "rank" } },
        Evaluate = function(cond, ply)
            local r = ply:GetTeamRank()
            return r ~= nil and r >= cond.rank
        end,
        Describe = function(cond) return "Rank ≥ " .. impulse.Vendor.Conditions.RankName(cond.rank) end,
    },
    ["rank_gt"] = {
        Label    = "Rank >",
        Fields   = { { name = "rank", type = "rank" } },
        Evaluate = function(cond, ply)
            local r = ply:GetTeamRank()
            return r ~= nil and r > cond.rank
        end,
        Describe = function(cond) return "Rank > " .. impulse.Vendor.Conditions.RankName(cond.rank) end,
    },
    ["rank_eq"] = {
        Label    = "Rank =",
        Fields   = { { name = "rank", type = "rank" } },
        Evaluate = function(cond, ply)
            local r = ply:GetTeamRank()
            return r ~= nil and r == cond.rank
        end,
        Describe = function(cond) return "Rank = " .. impulse.Vendor.Conditions.RankName(cond.rank) end,
    },
    ["rank_lt"] = {
        Label    = "Rank <",
        Fields   = { { name = "rank", type = "rank" } },
        Evaluate = function(cond, ply)
            local r = ply:GetTeamRank()
            return r ~= nil and r < cond.rank
        end,
        Describe = function(cond) return "Rank < " .. impulse.Vendor.Conditions.RankName(cond.rank) end,
    },
    ["rank_range"] = {
        Label    = "Rank between",
        Fields   = { { name = "rankMin", type = "rank" }, { name = "rankMax", type = "rank" } },
        Evaluate = function(cond, ply)
            local r = ply:GetTeamRank()
            return r ~= nil and r >= cond.rankMin and r < cond.rankMax
        end,
        Describe = function(cond)
            return "Rank " .. impulse.Vendor.Conditions.RankName(cond.rankMin) .. "–" .. impulse.Vendor.Conditions.RankName(cond.rankMax)
        end,
    },
    ["teamclass"] = {
        Label    = "Team Class",
        Fields   = { { name = "class", type = "class" } },
        Evaluate = function(cond, ply) return ply:GetTeamClass() == cond.class end,
        Describe = function(cond) return "Class = " .. impulse.Vendor.Conditions.ClassName(cond.class) end,
    },
    ["teamclass_not"] = {
        Label    = "Team Class ≠",
        Fields   = { { name = "class", type = "class" } },
        Evaluate = function(cond, ply) return ply:GetTeamClass() ~= cond.class end,
        Describe = function(cond) return "Class ≠ " .. impulse.Vendor.Conditions.ClassName(cond.class) end,
    },
    ["citycode_gte"] = {
        Label    = "City Code ≥",
        Fields   = { { name = "code", type = "code" } },
        Evaluate = function(cond, ply)
            if not impulse.Dispatch then return false end
            return impulse.Dispatch.GetCityCode() >= cond.code
        end,
        Describe = function(cond) return "City Code ≥ " .. impulse.Vendor.Conditions.CodeName(cond.code) end,
    },
    ["team"] = {
        Label    = "On Team",
        Fields   = { { name = "team", type = "team" } },
        Evaluate = function(cond, ply) return ply:Team() == cond.team end,
        Describe = function(cond) return "Team = " .. team.GetName(cond.team) end,
    },
    ["global_flag"] = {
        Label    = "Global Flag",
        Fields   = { { name = "flag", type = "string" } },
        Evaluate = function(cond, ply)
            if not cond.flag or cond.flag == "" then return true end
            return GetGlobalBool(cond.flag, false)
        end,
        Describe = function(cond) return "Flag: " .. tostring(cond.flag) end,
    },
    ["is_collaborator"] = {
        Label    = "Is Collaborator",
        Fields   = {},
        Evaluate = function(cond, ply) return ply.IsCollaborator and ply:IsCollaborator() == true end,
        Describe = function(cond) return "Is Collaborator" end,
    },
    ["any"] = {
        Label    = "Any Of (OR)",
        Fields   = {},
        Evaluate = function(cond, ply)
            for _, sub in ipairs(cond.conditions or {}) do
                if impulse.Vendor.Conditions.Evaluate(sub, ply) then return true end
            end
            return false
        end,
        Describe = function(cond)
            local parts = {}
            for _, sub in ipairs(cond.conditions or {}) do
                parts[#parts+1] = impulse.Vendor.Conditions.Describe(sub)
            end
            return "ANY[" .. table.concat(parts, " | ") .. "]"
        end,
    },
    ["all"] = {
        Label    = "All Of (AND)",
        Fields   = {},
        Evaluate = function(cond, ply)
            for _, sub in ipairs(cond.conditions or {}) do
                if not impulse.Vendor.Conditions.Evaluate(sub, ply) then return false end
            end
            return true
        end,
        Describe = function(cond)
            local parts = {}
            for _, sub in ipairs(cond.conditions or {}) do
                parts[#parts+1] = impulse.Vendor.Conditions.Describe(sub)
            end
            return "ALL[" .. table.concat(parts, " & ") .. "]"
        end,
    },
}

function impulse.Vendor.Conditions.PrimaryTeam(conditions)
    if not conditions then return nil end
    local function scan(list)
        for _, c in ipairs(list or {}) do
            if c.type == "team" then return c.team end
            if c.type == "all" or c.type == "any" then
                local t = scan(c.conditions)
                if t then return t end
            end
        end
    end
    return scan(conditions)
end

function impulse.Vendor.Conditions.Evaluate(cond, ply)
    if not cond or not cond.type then return true end
    local def = impulse.Vendor.Conditions.Types[cond.type]
    if not def then return true end
    local ok, result = pcall(def.Evaluate, cond, ply)
    if not ok then return false end
    return result
end

function impulse.Vendor.Conditions.EvaluateAll(condList, ply)
    if not condList or #condList == 0 then return true end
    for _, cond in ipairs(condList) do
        if not impulse.Vendor.Conditions.Evaluate(cond, ply) then return false end
    end
    return true
end

function impulse.Vendor.Conditions.Describe(cond)
    if not cond or not cond.type then return "?" end
    local def = impulse.Vendor.Conditions.Types[cond.type]
    if not def then return cond.type end
    return def.Describe(cond)
end

local function GetTeamRankNames(teamVal)
    local maps = {
        [TEAM_CP] = {
            [RANK_I1]  = "i1",
            [RANK_I2]  = "i2",
            [RANK_I3]  = "i3",
            [RANK_SQL] = "SqL",
            [RANK_OFC] = "RL/OFC",
            [RANK_DVL] = "DvL",
            [RANK_DCO] = "DcO",
            [RANK_VCMD] = "VCmD",
            [RANK_CMD] = "CmD",
        },
        [TEAM_OTA] = {
            [RANK_OWG] = "CGR",
            [RANK_OWS] = "CSO",
            [RANK_EOS] = "ECS",
            [RANK_OCP] = "CCP",
            [RANK_OSL] = "CTL",
            [RANK_ORD] = "ORD",
            [RANK_OSC] = "CSC",
        },
        [TEAM_CWU] = {
            [RANK_INTERN]     = "Intern",
            [RANK_EMPLOYEE]   = "Employee",
            [RANK_SUPERVISOR] = "Supervisor",
            [RANK_DIRECTOR]   = "Director",
            [RANK_MINISTER]   = "Minister",
        },
        [TEAM_CA] = {
            [RANK_ASSISTANT]         = "Assistant",
            [RANK_COUNCILOR]         = "Councilor",
            [RANK_CA]             = "CA",
        },
    }
    return maps[teamVal]
end

function impulse.Vendor.Conditions.RankName(rank, teamVal)
    local data = teamVal and impulse.Teams and impulse.Teams.Data and impulse.Teams.Data[teamVal]
    local ranks = data and data.ranks
    if ranks and ranks[rank] then
        local entry = ranks[rank]
        if type(entry) == "table" then return entry.name or entry.Name or tostring(rank) end
        if type(entry) == "string" then return entry end
    end
    return tostring(rank)
end

local classNameCache = {}
local function GetTeamClassNames(teamVal)
    if classNameCache[teamVal] then return classNameCache[teamVal] end
    local out = {}
    local data = impulse.Teams and impulse.Teams.Data and impulse.Teams.Data[teamVal]
    local classes = data and data.classes
    if classes then
        for i, entry in ipairs(classes) do
            out[i] = (type(entry) == "table" and (entry.name or entry.Name)) or tostring(i)
        end
    end
    classNameCache[teamVal] = out
    return out
end

function impulse.Vendor.Conditions.ClassNameForTeam(teamVal, class)
    if not class then return "?" end
    local map = teamVal and GetTeamClassNames(teamVal)
    if map and map[class] then return map[class] end
    return tostring(class)
end

function impulse.Vendor.Conditions.ClassName(class)
    if not class then return "?" end
    for _, teamVal in ipairs({TEAM_CP, TEAM_OTA, TEAM_CWU, TEAM_CA}) do
        local map = GetTeamClassNames(teamVal)
        if map and map[class] then return map[class] end
    end
    return tostring(class)
end

function impulse.Vendor.Conditions.CodeName(code)
    local short = {
        [1] = "STABLE",
        [2] = "MARG",
        [3] = "FRAC",
        [4] = "AJ",
        [5] = "JW",
        [6] = "LOST",
    }
    return short[code] or tostring(code)
end

local function GetRankShortTable()
    return {
        [RANK_ASSISTANT]         = "Assistant+",
        [RANK_COUNCILOR]      = "Councilor+",
        [RANK_CA]             = "CA+",
        [RANK_I1]             = "i1+",
        [RANK_I2]             = "i2+",
        [RANK_I3]             = "i3+",
        [RANK_SQL]            = "SqL+",
        [RANK_OFC]            = "OFC+",
        [RANK_DVL]            = "DvL+",
        [RANK_DCO]            = "DcO+",
        [RANK_VCMD]           = "VCmD+",
        [RANK_CMD]            = "CmD",
        [RANK_EOS]            = "ECS+",
        [RANK_OWS]            = "CSO+",
        [RANK_OCP]            = "CCP+",
        [RANK_ORD]            = "ORD+",
        [RANK_OSL]            = "CTL+",
        [RANK_ECS]            = "ECS+",
    }
end

function impulse.Vendor.Conditions.AutoDescribe(conditions, vendorTeam)
    if not conditions or #conditions == 0 then return "" end

    if not vendorTeam or vendorTeam == -1 then
        vendorTeam = impulse.Vendor.Conditions.PrimaryTeam(conditions) or vendorTeam
    end

    local classNames, rankParts, otherParts = {}, {}, {}

    local function ResolveClassName(classVal)
        if vendorTeam and vendorTeam ~= -1 then
            return impulse.Vendor.Conditions.ClassNameForTeam(vendorTeam, classVal)
        end
        return impulse.Vendor.Conditions.ClassName(classVal)
    end

    local function ResolveRankName(rankVal)
        return impulse.Vendor.Conditions.RankName(rankVal, vendorTeam)
    end

    local function RankPhrase(rtype, rval)
        local n = ResolveRankName(rval)
        if rtype == "rank_gte" then return n.."+"
        elseif rtype == "rank_gt" then return ">"..n
        elseif rtype == "rank_eq" then return n
        elseif rtype == "rank_lt" then return "<"..n end
        return n
    end

    local function DescribeGroup(sub)
        local cls, rnk, cde
        local function take(c)
            if c.type == "teamclass" then
                cls = ResolveClassName(c.class)
            elseif string.sub(c.type or "", 1, 5) == "rank_" then
                rnk = RankPhrase(c.type, c.rank)
            elseif c.type == "citycode_gte" then
                cde = impulse.Vendor.Conditions.CodeName(c.code).."+"
            end
        end
        if sub.type == "all" then
            for _, c in ipairs(sub.conditions or {}) do take(c) end
        else
            take(sub)
        end
        local parts = {}
        if cls and cls ~= "?" then parts[#parts+1] = cls end
        if rnk then parts[#parts+1] = rnk end
        if cde then parts[#parts+1] = cde end
        return table.concat(parts, " ")
    end

    local function HandleCond(cond)
        if cond.type == "teamclass" then
            local name = ResolveClassName(cond.class)
            if name and name ~= "?" then classNames[#classNames+1] = name end
        elseif cond.type == "rank_gte" then
            rankParts[#rankParts+1] = ResolveRankName(cond.rank).."+"
        elseif cond.type == "rank_gt" then
            rankParts[#rankParts+1] = ">"..ResolveRankName(cond.rank)
        elseif cond.type == "rank_eq" then
            rankParts[#rankParts+1] = ResolveRankName(cond.rank).." only"
        elseif cond.type == "rank_lt" then
            rankParts[#rankParts+1] = "<"..ResolveRankName(cond.rank)
        elseif cond.type == "rank_range" then
            rankParts[#rankParts+1] = ResolveRankName(cond.rankMin).."–"..ResolveRankName(cond.rankMax)
        elseif cond.type == "teamclass_not" then
            otherParts[#otherParts+1] = "Not "..ResolveClassName(cond.class)
        elseif cond.type == "citycode_gte" then
            otherParts[#otherParts+1] = impulse.Vendor.Conditions.CodeName(cond.code).."+"
        elseif cond.type == "team" then
            otherParts[#otherParts+1] = team.GetName and team.GetName(cond.team) or tostring(cond.team)
        elseif cond.type == "global_flag" then
            otherParts[#otherParts+1] = tostring(cond.flag)
        elseif cond.type == "is_collaborator" then
            otherParts[#otherParts+1] = "Collaborator"
        elseif cond.type == "all" then
            local d = DescribeGroup(cond)
            if d ~= "" then otherParts[#otherParts+1] = d end
        elseif cond.type == "any" then
            local groupNames = {}
            for _, sub in ipairs(cond.conditions or {}) do
                local d = DescribeGroup(sub)
                if d ~= "" then groupNames[#groupNames+1] = d end
            end
            if #groupNames > 0 then
                otherParts[#otherParts+1] = table.concat(groupNames, "/")
            end
        end
    end

    for _, cond in ipairs(conditions) do HandleCond(cond) end

    local segments = {}
    if #classNames > 0 then segments[#segments+1] = table.concat(classNames, "/") end
    if #rankParts  > 0 then segments[#segments+1] = table.concat(rankParts, "/") end
    for _, p in ipairs(otherParts) do segments[#segments+1] = p end

    return table.concat(segments, " ")
end