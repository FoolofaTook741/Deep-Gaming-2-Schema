--prevents player collisions in spawns and on both sides of the teleporters
local CurTime = CurTime
local ipairs = ipairs
local IsValid = IsValid

NOCOLLIDE_ZONES = {
    {
        mins = Vector(
            math.min(impulse.Config.SpawnNoCollide1.x, impulse.Config.SpawnNoCollide2.x),
            math.min(impulse.Config.SpawnNoCollide1.y, impulse.Config.SpawnNoCollide2.y),
            math.min(impulse.Config.SpawnNoCollide1.z, impulse.Config.SpawnNoCollide2.z)
        ),
        maxs = Vector(
            math.max(impulse.Config.SpawnNoCollide1.x, impulse.Config.SpawnNoCollide2.x),
            math.max(impulse.Config.SpawnNoCollide1.y, impulse.Config.SpawnNoCollide2.y),
            math.max(impulse.Config.SpawnNoCollide1.z, impulse.Config.SpawnNoCollide2.z)
        )
    },
}

local NOCOLLIDE_TELEPORTS = {}

function AddNocollideZone(vec1, vec2)
    return table.insert(NOCOLLIDE_ZONES, {
        mins = Vector(
            math.min(vec1.x, vec2.x),
            math.min(vec1.y, vec2.y),
            math.min(vec1.z, vec2.z)
        ),
        maxs = Vector(
            math.max(vec1.x, vec2.x),
            math.max(vec1.y, vec2.y),
            math.max(vec1.z, vec2.z)
        )
    })
end

function AddTeleportEntity(ent)
    return table.insert(NOCOLLIDE_TELEPORTS, ent)
end

function RemoveTeleportEntity(idOrEnt)
    if isentity(idOrEnt) then
        return table.RemoveByValue(NOCOLLIDE_TELEPORTS, idOrEnt)
    end
    if isnumber(idOrEnt) then
        return table.remove(NOCOLLIDE_TELEPORTS, idOrEnt)
    end
end

local inZone = {}

local function IsInAnyZone(pos)
    for i = 1, #NOCOLLIDE_ZONES do
        local zone = NOCOLLIDE_ZONES[i]
        if pos:WithinAABox(zone.mins, zone.maxs) then
            return true
        end
    end
    for i = 1, #NOCOLLIDE_TELEPORTS do
        local ent = NOCOLLIDE_TELEPORTS[i]
        if IsValid(ent) then
            local ang = ent:GetAngles()
            local mins = ent:GetPos() + ang:Up() * 100 + ang:Right() * 200 + ang:Forward() * 50
            local maxs = ent:GetPos() - ang:Up() * 10 - ang:Right() * 200 - ang:Forward() * 50
            if pos:WithinAABox(mins, maxs) then
                return true
            end
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