local COOLDOWN_TIME = 32
local BUTTON_IDS = {
    [3915] = true,
    [3916] = true,
}

local nextUse = setmetatable({}, { __mode = "k" })

hook.Add("AcceptInput", "ElevatorCallCooldown", function(ent, input, activator)
    if input ~= "Use" then return end
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if ent:GetClass() ~= "func_button" then return end

    local mid = ent.MapCreationID and ent:MapCreationID()
    if not mid or not BUTTON_IDS[mid] then return end

    local now = CurTime()

    if nextUse[ent] and now < nextUse[ent] then
        activator:ChatPrint(string.format(
            "[Elevator] cooling down: %ds remaining",
            math.ceil(nextUse[ent] - now)
        ))
        return true
    end

    for id,_ in pairs(BUTTON_IDS) do
        for _,btn in ipairs(ents.FindByClass("func_button")) do
            if btn.MapCreationID and btn:MapCreationID() == id then
                nextUse[btn] = now + COOLDOWN_TIME
                btn:Fire("Disable", "", 0)
                timer.Simple(COOLDOWN_TIME, function()
                    if IsValid(btn) then
                        btn:Fire("Enable", "", 0)
                    end
                end)
            end
        end
    end
end)