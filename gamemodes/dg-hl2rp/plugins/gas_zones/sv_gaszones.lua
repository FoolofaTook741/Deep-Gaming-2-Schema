local XEN_MODELS = {
    "models/jq/hlvr/props/xenpack/xen_strand_anchor004.mdl",
    "models/jq/hlvr/props/xenpack/xen_strand_anchor005.mdl",
    "models/jq/hlvr/props/xenpack/xen_strand_anchor006.mdl",
    "models/jq/hlvr/props/xenpack/xen_strand_anchor007.mdl",
    "models/jq/hlvr/props/xenpack/xen_strand_anchor008.mdl",
    "models/jq/hlvr/props/xenpack/xen_web_corner_small005.mdl",
}
local CHARPLE_MODEL   = "models/Humans/Charple04.mdl"
local MAX_ZONES       = 5
local MIN_ZONE_DIST   = 200
local ZONE_LIFESPAN   = 20 * 60
local XEN_PROP_RADIUS = 80
local BURN_TICKS      = 10   --ticks of sustained fire needed to incinerate
local BURN_RATE       = 1    --seconds between burn ticks
local BURN_RESET      = 2    --how long it takes to reset health of fire stops
local CREMATOR_PAY    = 25   --credit paytout

local activeZones = {}
local cachedBounds = nil
local cachedExclBounds = nil

local function BuildBoundsCache()
    cachedBounds = {}
    cachedExclBounds = {}
    local zoneNames = impulse.Config.XenContaminationZones
    local exclNames = impulse.Config.XenContaminationExclusionZones
    if not impulse.Config.Zones then return end

    for _, zone in pairs(impulse.Config.Zones) do
        local p1, p2 = zone.pos1, zone.pos2
        local b = {
            minX = math.min(p1.x, p2.x), maxX = math.max(p1.x, p2.x),
            minY = math.min(p1.y, p2.y), maxY = math.max(p1.y, p2.y),
            minZ = math.min(p1.z, p2.z), maxZ = math.max(p1.z, p2.z),
        }
        if zoneNames then
            for _, name in ipairs(zoneNames) do
                if zone.name == name then table.insert(cachedBounds, b) break end
            end
        end
        if exclNames then
            for _, name in ipairs(exclNames) do
                if zone.name == name then table.insert(cachedExclBounds, b) break end
            end
        end
    end
end

local function IsInContaminationZone(pos)
    if not cachedBounds then BuildBoundsCache() end
    for _, b in ipairs(cachedBounds) do
        if pos.x >= b.minX and pos.x <= b.maxX and
           pos.y >= b.minY and pos.y <= b.maxY and
           pos.z >= b.minZ and pos.z <= b.maxZ then
            for _, e in ipairs(cachedExclBounds) do
                if pos.x >= e.minX and pos.x <= e.maxX and
                   pos.y >= e.minY and pos.y <= e.maxY and
                   pos.z >= e.minZ and pos.z <= e.maxZ then
                    return false
                end
            end
            return true
        end
    end
    return false
end

hook.Add("PostInitPostEntity", "XenContam_BuildCache", function()
    BuildBoundsCache()
end)

local function TooCloseToExisting(pos)
    for zone in pairs(activeZones) do
        if IsValid(zone) and zone:GetPos():Distance(pos) < MIN_ZONE_DIST then
            return true
        end
    end
    return false
end

local function ActiveZoneCount()
    local count = 0
    for zone in pairs(activeZones) do
        if IsValid(zone) then count = count + 1 end
    end
    return count
end

local function TraceGround(pos)
    return util.TraceLine({
        start  = pos + Vector(0, 0, 10),
        endpos = pos - Vector(0, 0, 20),
        mask   = MASK_SOLID_BRUSHONLY,
    })
end

local function SpawnAshes(pos, cleaner)
    local tr = TraceGround(pos)
    local spawnPos = tr.Hit and tr.HitPos or pos

    timer.Simple(0.2, function()
        impulse.Inventory.SpawnItem("item_ashes", spawnPos + Vector(0, 0, 4))
    end)

    if IsValid(cleaner) then
        cleaner:GiveMoney(CREMATOR_PAY)
        cleaner:Notify("The remains have been incinerated. +" .. CREMATOR_PAY .. "c")
    end
end

local function TickBurn(ent, owner)
    local now = CurTime()

    if ent.LastBurnTime and (now - ent.LastBurnTime) < BURN_RATE then
        return false
    end

    if ent.LastBurnTime and (now - ent.LastBurnTime) > BURN_RESET then
        ent.BurnHealth = BURN_TICKS
    end

    ent.BurnHealth   = (ent.BurnHealth or BURN_TICKS) - 1
    ent.LastBurnTime = now

    return ent.BurnHealth <= 0
end

local function CleanupContamination(charple, xenProps, contamZone, cleaner)
    if IsValid(charple) then
        charple.XenCleanedUp = true
        charple:Extinguish()
        charple:Remove()
    end

    if IsValid(contamZone) then
        timer.Remove("xencontam_" .. contamZone:EntIndex())
        activeZones[contamZone] = nil
        contamZone:Remove()
    end

    for _, prop in ipairs(xenProps or {}) do
        if IsValid(prop) then
            timer.Simple(120, function()
                if IsValid(prop) then prop:Remove() end
            end)
        end
    end

    if IsValid(cleaner) and cleaner:Team() == TEAM_CREMATOR then
        local ashPos = IsValid(charple) and charple:GetPos() or cleaner:GetPos()
        SpawnAshes(ashPos, cleaner)
        local tr = TraceGround(ashPos)
        if tr.Hit then
            util.Decal("Scorch", tr.HitPos + Vector(0, 0, 1), tr.HitPos - Vector(0, 0, 1))
        end
    end
end

local function SpawnContaminationZone(pos)
    if ActiveZoneCount() >= MAX_ZONES then return end
    if TooCloseToExisting(pos) then return end

    local charple = ents.Create("prop_ragdoll")
    charple:SetModel(CHARPLE_MODEL)
    charple:SetPos(pos)
    charple:Spawn()
    charple.IsXenCharple = true
    charple.XenCleanedUp = false

    local xenProps = {}
    local count = math.random(2, 4)
    for i = 1, count do
        local angle  = (i / count) * 360
        local dist   = math.random(30, XEN_PROP_RADIUS)
        local offset = Vector(
            math.cos(math.rad(angle)) * dist,
            math.sin(math.rad(angle)) * dist,
            0
        )

        local tr = util.TraceLine({
            start  = pos + offset + Vector(0, 0, 50),
            endpos = pos + offset - Vector(0, 0, 100),
            mask   = MASK_SOLID_BRUSHONLY,
        })

        local prop = ents.Create("prop_physics")
        prop:SetModel(XEN_MODELS[math.random(1, #XEN_MODELS)])
        prop:SetPos(tr.HitPos)
        prop:SetAngles(Angle(0, math.random(0, 360), 0))
        prop:Spawn()
        prop:SetNWBool("IsXenProp", true)
        prop.IsXenProp = true
        print("[XenContam] Spawned xen prop: " .. tostring(prop) .. " IsXenProp: " .. tostring(prop.IsXenProp))
        table.insert(xenProps, prop)
    end

    local contamZone = ents.Create("deep_xencontamination")
    contamZone:SetPos(pos + Vector(0, 0, 10))
    contamZone:Spawn()
    contamZone.LinkedCharple  = charple
    contamZone.LinkedXenProps = xenProps
    activeZones[contamZone]   = true

    charple.LinkedContamZone = contamZone
    charple.LinkedXenProps   = xenProps

    timer.Simple(4, function()
        if IsValid(charple) then
            local phys = charple:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
                phys:Sleep()
            end
            charple:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        end

        for _, prop in ipairs(xenProps) do
            if IsValid(prop) then
                prop:SetMoveType(MOVETYPE_NONE)
                prop:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            end
        end
    end)

    timer.Create("xencontam_" .. contamZone:EntIndex(), ZONE_LIFESPAN, 1, function()
        if IsValid(contamZone) then
            CleanupContamination(charple, xenProps, contamZone, nil)
        end
    end)
end

hook.Add("PlayerRagdollSpawned", "XenContam_TagRagdoll", function(ragdoll, ply, attacker)
    if IsInContaminationZone(ragdoll:GetPos()) then
        ragdoll.IsInXenZone = true
    end
end)

hook.Add("EntityRemoved", "XenContam_EntityRemoved", function(ent)
    if ent:GetClass() ~= "prop_ragdoll" then return end

    if ent.IsInXenZone and not ent.IsXenCharple and not ent.XenBagged then
        local cachedPos = ent:GetPos()
        timer.Simple(0.1, function()
            SpawnContaminationZone(cachedPos)
        end)
        return
    end

    if ent.IsXenCharple and not ent.XenCleanedUp then
        local xenProps   = ent.LinkedXenProps
        local contamZone = ent.LinkedContamZone

        for _, prop in ipairs(xenProps or {}) do
            if IsValid(prop) then
                prop:SetNWBool("IsXenProp", true)
                prop.IsXenProp = true
                --prop:SetSolid(SOLID_VPHYSICS)
                timer.Simple(120, function()
                    if IsValid(prop) then prop:Remove() end
                end)
            end
        end

        if IsValid(contamZone) then
            timer.Remove("xencontam_" .. contamZone:EntIndex())
            activeZones[contamZone] = nil
            contamZone:Remove()
        end
    end
end)

hook.Add("CrematorIgnited", "XenContam_CrematorBurn", function(owner, ent)
    if not IsValid(ent) then return end
    if ent:GetClass() ~= "prop_ragdoll" or not ent.IsXenCharple then return end
    if ent.XenCleanedUp then return end

    if TickBurn(ent, owner) then
        ent.XenCleanedUp = true
        CleanupContamination(ent, ent.LinkedXenProps, ent.LinkedContamZone, owner)
    end
end)

hook.Add("CrematorIgnited", "XenContam_BurnRegularBody", function(owner, ent)
    if not IsValid(ent) then return end
    if ent:GetClass() ~= "prop_ragdoll" then return end
    if ent.IsXenCharple then return end
    if not ent:GetNWBool("IsDeadPlayerRagdoll", false) then return end

    if TickBurn(ent, owner) then
        local pos = ent:GetPos()
        ent.XenBagged = true
        ent:Remove()
        SpawnAshes(pos, owner)
    end
end)