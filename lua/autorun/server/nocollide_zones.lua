--prevents player collisions in spawns and on both sides of the teleporters
local NOCOLLIDE_ZONES = {
    -- Spawn
    {
        mins = Vector(-1673.5628662109, -3258.7395019531, -390.56838989258),
        maxs = Vector(802.36303710938, -2629.7309570313, -96.915634155273)
    },
    -- Teleporter SSE vent
    {
        mins = Vector(-436.67169189453, 355.49426269531, -761.66247558594),
        maxs = Vector(-165.6190032959, 690.93347167969, -545.87170410156)
    },
    -- Teleporter OZ side
    {
        mins = Vector(2572.109375, 3502.248046875, -733.27105712891),
        maxs = Vector(2677.5163574219, 3596.6950683594, -529.95281982422)
    },
    {
        mins = Vector(-6381.82421875, -3966.03125, -10285.446289063),
        maxs = Vector(-6035.9721679688, -3730.5651855469, -10095.234375)
    },
    {
        mins = Vector(11372.18359375, 4577.4619140625, 8670.7451171875),
        maxs = Vector(11692.609375, 4783.4057617188, 8955.5068359375)
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
        ply:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
    else
        if ply:GetCollisionGroup() == COLLISION_GROUP_PASSABLE_DOOR then
            ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
        end
    end
end

local nextZoneCheck = 0
hook.Add("Think", "ZoneNoCollideThink", function()
    local now = CurTime()
    if now < nextZoneCheck then return end
    nextZoneCheck = now + 0.1

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

hook.Add("PlayerInitialSpawn", "ZoneNoCollideInitialSpawn", function(ply)
    timer.Simple(1, function()
        if IsValid(ply) then
            inZone[ply] = IsInAnyZone(ply:GetPos())
            SetPlayerNoCollide(ply, inZone[ply])
        end
    end)
end)

hook.Add("PlayerSpawn", "ZoneNoCollideSpawnReset", function(ply)
    timer.Simple(0.5, function()
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