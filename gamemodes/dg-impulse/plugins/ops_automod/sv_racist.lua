local slurs = {
    "nigger",
    "nigga",
    "faggot",
    "faggots",
    "nogga",
    "nogger",
--   fag removed because automod fuckups
    "fag",
    "fags",
    "f@g",
    "f@ggot",
    "fagg0t",
    "f@gg0t",
    "f4ggot",
    "f4gg0t",
    "n1gga",
    "n1gg@",
    "nigg@",
    "n0gga",
    "nogg@",
    "n0gg@",
    "n1gger",
    "n1gg3r",
    "n1gg4",
    "n1gg4r",
    "niggar",
    "UCh-VCHMsVcb-AppRsF2c2Rw",
    "sC8199W90t8",
    "nGBP2LlS2bY",
    "P_lh60aLP8c",
    "9WpptQzpmWs",
    "UCrPd2ZDrxGG2yinfoya9AEw",
    "UCz7lYPf2xyB8IG6Tve7hbzw",
    "RfVHapVJ_vg",
    "PQ2-nRbZVdk",
    "aLkHm0xkspQ",
    "rape",
    "r@pe",
    "rap3",
    "r@p3",
    "molest",
    "m0lest",
    "mol3st",
    "m0l3st",
    }

local function buildEvasionPattern(slur)
    local chars = {}
    for i = 1, #slur do
        chars[i] = slur:sub(i, i):gsub("[%(%)%.%%%+%-%*%?%[%^%$]", "%%%1") -- escape magic chars
    end
    return table.concat(chars, "[%s%p]*")
end

local function containsSlur(str, slur)
    --pad string to simplify boundary detection at start/end
    local padded = " " .. str .. " "
    
    --Normal word - must be surrounded by non-alpha characters
    local boundary = "%f[%a]" .. slur .. "%f[%A]"
    if padded:match(boundary) then return true end

    --Spaced/separated evasion
    --only matches if characters are actually separated (has separators between them)
    if #slur > 1 then
        local evasionPattern = "%A" .. buildEvasionPattern(slur) .. "%A"
        local spaced = padded:match(evasionPattern)
        if spaced and spaced:find("[%s%p]") then --must actually have separators
            return true
        end
    end

    return false
end

local function checkText(str)
    str = str:lower()
    
    if replacements then
        for mat, rep in pairs(replacements) do
            str = str:Replace(mat, rep)
        end
    end

    local risk = 0
    local matchedIndex = nil

    for code, slur in ipairs(slurs) do
        if containsSlur(str, slur) then
            risk = risk + 8
            matchedIndex = code
        end
    end

    return risk, matchedIndex
end

local function handleViolation(ply, text, risk, slurIndex)
    ply.OPS_AM_HasBeenWarned = true
    ply:Notify("Your message was blocked for containing a blacklisted word.")
end

function impulse.Ops.AutoMod.FilterMessage(ply, text)
    local risk, slurIndex = checkText(text)
    if risk > 0 then
        handleViolation(ply, text, risk, slurIndex)
        return true
    end
end

function PLUGIN:PlayerSay(ply, text)
    if text:sub(1, 7) == "/report" then return end
    local risk, slurIndex = checkText(text)
    if risk > 0 then
        handleViolation(ply, text, risk, slurIndex)
        return ""
    end
end