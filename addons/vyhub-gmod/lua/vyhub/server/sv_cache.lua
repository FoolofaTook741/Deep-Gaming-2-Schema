local f = string.format
local json = VyHub.Lib.json

VyHub.Cache = VyHub.Cache or {}

function VyHub.Cache:save(key, value)
    local data = {
        timestamp = os.time(),
        data = value
    }

    local filename = string.format("vyhub/%s.json", key)
    local jsonStr = util.TableToJSON(data)

    if not jsonStr then return end

    VyHub:msg("Write " .. filename, "debuga")
    file.Write(filename, jsonStr)
end

function VyHub.Cache:get(key, max_age)
    local path = f("vyhub/%s.json", key)

    if not file.Exists(path, "data") then
        return nil
    end

    local data_str = file.Read(path, "data")

    if not string.Trim(data_str) then
        return nil
    end

	local data = util.JSONToTable(data_str)
	if data == nil then return nil end

    if istable(data) and data.timestamp and data.data then
        if max_age != nil and os.time() - data.timestamp > max_age then
            return nil
        end

        return data.data
    end

    return nil
end