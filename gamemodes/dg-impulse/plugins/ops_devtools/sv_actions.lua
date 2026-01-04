impulse.Ops = impulse.Ops or {}

-- Actions table
impulse.Ops.Dev = impulse.Ops.Dev or {}

impulse.Ops.Dev["add_ach"] = function(args)
    local target = args[1]
    if not target then return end

    local ach = args[2]
    if not ach then return end
    target:AchievementGive(ach)
end

impulse.Ops.Dev["del_ach"] = function(args)
    local target = args[1]
    if not target then return end

    local ach = args[2]
    if not ach then return end
    target:AchievementTake(ach)
end

impulse.Ops.Dev["add_money"] = function(args)
    local target = args[1]
    if not target then return end

    local money = args[2]
    if not money then return end

    target:GiveMoney(money)
end

impulse.Ops.Dev["set_modelscale"] = function(args)
    local target = args[1]
    if not target then return end

    local scale = args[2]
    if not scale then return end

    target:SetModelScale(scale,2.5)
    target:SetWalkSpeed(impulse.Config.WalkSpeed * scale)
    target:SetRunSpeed(impulse.Config.JogSpeed * scale)
end

impulse.Ops.Dev["set_rpname"] = function(args)
    local target = args[1]
    if not target then return end

    local name = args[2]
    if not name then return end

    target:SetRPName(name)
end

impulse.Ops.Dev["set_rpname_save"] = function(args)
    local target = args[1]
    if not target then return end

    local name = args[2]
    if not name then return end

    target:SetRPName(name, true)
end