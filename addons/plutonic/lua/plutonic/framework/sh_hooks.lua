Plutonic.Hooks = Plutonic.Hooks or {}
Plutonic.Hooks.Data = Plutonic.Hooks.Data or {}
--[[
    Plutonic hook wrapper

    Previous behaviour allowed only ONE callback per hookName. That breaks when two
    modules both register the same hook
        Plutonic.Hooks.Add("SomeHook", function(...) end)
        Plutonic.Hooks.Add("SomeHook", "MyId", function(...) end)
--]]

local function normalizeArgs(hookName, idOrCb, cb)
    -- Add(hookName, callback)
    if isfunction(idOrCb) then
        return hookName, "default", idOrCb
    end

    -- Add(hookName, id, callback)
    local id = tostring(idOrCb or "default")
    return hookName, id, cb
end

Plutonic.Hooks.Add = function(hookName, idOrCb, cb)
    hookName, idOrCb, cb = normalizeArgs(hookName, idOrCb, cb)
    if not isfunction(cb) then return end

    Plutonic.Hooks.Data[hookName] = Plutonic.Hooks.Data[hookName] or {}

    if Plutonic.Hooks.Data[hookName][idOrCb] then
        Plutonic.Framework.Print("Hook: " .. hookName .. " (" .. idOrCb .. ") already exists. Overwriting...")
        Plutonic.Hooks.Remove(hookName, idOrCb)
    end

    Plutonic.Framework.Print("Hook: " .. hookName .. " (" .. idOrCb .. ") added.")
    Plutonic.Hooks.Data[hookName][idOrCb] = cb
    hook.Add(hookName, "Plutonic.Hooks." .. hookName .. "." .. idOrCb, cb)
end

Plutonic.Hooks.Remove = function(hookName, id)
    if not Plutonic.Hooks.Data[hookName] then
        Plutonic.Framework.Print("Hook: " .. hookName .. " does not exist!")
        return
    end

    -- Remove(hookName) => remove all ids for that hookName
    if id == nil then
        for k, _ in pairs(Plutonic.Hooks.Data[hookName]) do
            hook.Remove(hookName, "Plutonic.Hooks." .. hookName .. "." .. k)
        end
        Plutonic.Hooks.Data[hookName] = nil
        Plutonic.Framework.Print("Hook: " .. hookName .. " (all) removed.")
        return
    end

    id = tostring(id)
    if not Plutonic.Hooks.Data[hookName][id] then
        Plutonic.Framework.Print("Hook: " .. hookName .. " (" .. id .. ") does not exist!")
        return
    end

    Plutonic.Framework.Print("Hook: " .. hookName .. " (" .. id .. ") removed.")
    Plutonic.Hooks.Data[hookName][id] = nil
    hook.Remove(hookName, "Plutonic.Hooks." .. hookName .. "." .. id)

    -- Clean up empty table
    if next(Plutonic.Hooks.Data[hookName]) == nil then
        Plutonic.Hooks.Data[hookName] = nil
    end
end