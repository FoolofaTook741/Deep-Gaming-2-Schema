--prevents player collisions in spawns and on both sides of the teleporters to reduce ticket load and player annoyance
local NOCOLLIDE_ZONES = {
    -- Spawn
    {
        mins = Vector(-12804.110351563, 895.13818359375, -18.104555130005),
        maxs = Vector(-11863.908203125, 1377.6485595703, 262.765625)
    },
    --teleporter SSE side
    {
        mins = Vector(-1364.0323486328, -1777.3350830078, -687.56622314453),
        maxs = Vector(-999.14111328125, -1436.1462402344, -470.1481628418)
    },
    --teleporter OZ side
    {
        mins = Vector(13683.709960938, 13058.100585938, -573.59466552734),
        maxs = Vector(13868.69140625, 13382.095703125, -385.35528564453)
    },
}

local inZone = {}

local function IsInAnyZone(pos)
    for _, zone in ipairs(NOCOLLIDE_ZONES) do
        if pos:WithinAABox(zone.mins, zone.maxs) then
            return true
        end
    end
    return false
end

local function SetPlayerNoCollide(ply, enabled)
    if enabled then
        ply:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    else
        ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
    end
end

hook.Add("Think", "ZoneNoCollideCheck", function()
    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() then continue end

        local wasInZone = inZone[ply]
        local nowInZone = IsInAnyZone(ply:GetPos())

        if nowInZone ~= wasInZone then
            inZone[ply] = nowInZone
            SetPlayerNoCollide(ply, nowInZone)
        end
    end
end)

hook.Add("PlayerDisconnected", "ZoneNoCollideCleanup", function(ply)
    inZone[ply] = nil
end)

hook.Add("PlayerSpawn", "ZoneNoCollideSpawnReset", function(ply)
    timer.Simple(0.1, function()
        if IsValid(ply) then
            inZone[ply] = IsInAnyZone(ply:GetPos())
            SetPlayerNoCollide(ply, inZone[ply])
        end
    end)
end)

concommand.Add("zone_getpos", function(ply)
    if IsValid(ply) then
        local pos = ply:GetPos()
        print(string.format("Player pos: Vector(%d, %d, %d)", pos.x, pos.y, pos.z))
    end
end)