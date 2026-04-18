--zones where players cannot spawn props

--[[
local restrictedZones = {
    --start c77
    {
        name = "Outlands",
        min = Vector(-10776.79296875, 2959.88671875, -1417.9897460938),
        max = Vector(7484.1606445313, 16435.890625, 981.810546875),
    },
    {
        name = "Tunnel",
        min = Vector(3367.5603027344, 1242.681640625, 196.59844970703),
        max = Vector(3945.7543945313, 4186.69140625, 353.7431640625),
    },
    --end c77
}

local function IsInRestrictedZone(pos)
    for _, zone in ipairs(restrictedZones) do
        if pos.x >= zone.min.x and pos.x <= zone.max.x and
           pos.y >= zone.min.y and pos.y <= zone.max.y and
           pos.z >= zone.min.z and pos.z <= zone.max.z then
            return true, zone.name
        end
    end
    return false
end

hook.Add("PlayerSpawnedProp", "impulseRestrictedZonePropCheck", function(ply, model, ent)
    if ply:IsSuperAdmin() then return end

    local restricted, zoneName = IsInRestrictedZone(ent:GetPos())
    if restricted then
        ent:Remove()
        ply:Notify("You cannot spawn props in this area (" .. zoneName .. ").")
    end
end)

hook.Add("PlayerSpawnedRagdoll", "impulseRestrictedZoneRagdollCheck", function(ply, model, ent)
    if ply:IsSuperAdmin() then return end

    local restricted, zoneName = IsInRestrictedZone(ent:GetPos())
    if restricted then
        ent:Remove()
        ply:Notify("You cannot spawn props in this area (" .. zoneName .. ").")
    end
end)

hook.Add("PlayerSpawnedSENT", "impulseRestrictedZoneSENTCheck", function(ply, ent)
    if ply:IsSuperAdmin() then return end

    local restricted, zoneName = IsInRestrictedZone(ent:GetPos())
    if restricted then
        ent:Remove()
        ply:Notify("You cannot spawn entities in this area (" .. zoneName .. ").")
    end
end) ]]--