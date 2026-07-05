--prevents player collisions in spawns and on both sides of the teleporters

NOCOLLIDE_ZONES = {
    { --add more of these manually for tp zones, if applicable
        mins = impulse.Config.SpawnNoCollide2,
        maxs = impulse.Config.SpawnNoCollide1
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