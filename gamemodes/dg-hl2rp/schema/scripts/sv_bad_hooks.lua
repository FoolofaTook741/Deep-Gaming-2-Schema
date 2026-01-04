-- Playable Piano is shit at coding and always returns PlayerUse as true so we need THIS file to prevent this shit from happening
-- fuck you playable piano

-- Reworked to fix any bad addons that override core values

local BlacklistedHooks = {
    ["PlayerUse"] = {
        "InstrumentChairModelHook"
    },
    ["CanPlayerEnterVehicle"] = {
        "InstrumentChairHook"
    }
}

hook.Add("InitPostEntity","impulseRemoveBadHooks",function()
    for HookName, Identifiers in pairs(BlacklistedHooks) do
        for _, Identifier in ipairs(Identifiers) do
            hook.Remove(HookName, Identifier)
        end
    end
end)

hook.Add("OnReloaded","impulseRemoveBadHooks",function()
    for HookName, Identifiers in pairs(BlacklistedHooks) do
        for _, Identifier in ipairs(Identifiers) do
            hook.Remove(HookName, Identifier)
        end
    end
end)
