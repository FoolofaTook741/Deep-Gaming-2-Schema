eProtect.encodeSteamID64 = function(data)
    local converted_tbl = {}

    for k,v in pairs(data) do
        if istable(v) then v = eProtect.encodeSteamID64(v) end

        local isSteamID64 = isstring(k) and #k == 17 and util.SteamIDFrom64(k) != "STEAM_0:0:0"

        if isSteamID64 then
            converted_tbl["sid64_"..k] = v
        else
            converted_tbl[k] = v
        end
    end

    return converted_tbl
end

eProtect.decodeSteamID64 = function(data)
    local converted_tbl = {}

    for k, v in pairs(data) do
        if istable(v) then v = eProtect.decodeSteamID64(v) end

        if string.sub(k, 1, 6) == "sid64_" then
            local sid64 = string.sub(k, 7, #k)

            if util.SteamIDFrom64(sid64) != "STEAM_0:0:0" then
                k = sid64
            end
        end

        converted_tbl[k] = v
    end

   return converted_tbl
end