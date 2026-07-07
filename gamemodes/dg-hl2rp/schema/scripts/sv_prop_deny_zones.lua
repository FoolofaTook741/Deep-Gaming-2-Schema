--zones where players cannot spawn props

if !impulse.Config.NoPropZones then return end -- if not defined, don't even bother

local restrictedZones = impulse.Config.NoPropZones

local function IsInRestrictedZone(pos)
    for _, zone in ipairs(restrictedZones) do
        if pos:WithinAABox(zone.min, zone.max) then
            return true, zone
        end
    end
    return false, {}
end

hook.Add("PlayerSpawnedProp", "impulseRestrictedZonePropCheck", function(ply, model, ent)
    if ply:IsSuperAdmin() then return end

    local restricted, zone = IsInRestrictedZone(ent:GetPos())
    if restricted then
        if zone.allow_combine and ply:IsCP() then return end 
            
        ent:Remove()
        ply:Notify("You cannot spawn props in this area (" .. zone.name .. ").")
    end
end)

hook.Add("PlayerSpawnedRagdoll", "impulseRestrictedZoneRagdollCheck", function(ply, model, ent)
    if ply:IsSuperAdmin() then return end

    local restricted, zone = IsInRestrictedZone(ent:GetPos())
    if restricted then
        if zone.allow_combine and ply:IsCP() then return end 
            
        ent:Remove()
        ply:Notify("You cannot spawn props in this area (" .. zone.name .. ").")
    end
end)

hook.Add("PlayerSpawnedSENT", "impulseRestrictedZoneSENTCheck", function(ply, ent)
    if ply:IsSuperAdmin() then return end

    local restricted, zone = IsInRestrictedZone(ent:GetPos())
    if restricted then
        if zone.allow_combine and ply:IsCP() then return end 
            
        ent:Remove()
        ply:Notify("You cannot spawn entities in this area (" .. zone.name .. ").")
    end
end)
