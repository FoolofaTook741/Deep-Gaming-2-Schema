local ITEM = {}

ITEM.UniqueID    = "item_combinelock"
ITEM.Name = "Combine Door Lock"
ITEM.Desc = "Attach a Combine lock to a door to restrict access."
ITEM.Category = "Combine Tools"
ITEM.Model = Model("models/props_combine/combine_lock01.mdl")
ITEM.FOV = 50
ITEM.CamPos = Vector(50, 0, 0)
ITEM.Weight = 2

ITEM.Droppable = false
ITEM.DropOnDeath = false
ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.Illegal = true

ITEM.UseName = "Attach"
ITEM.UseWorkBarTime = 10
ITEM.UseWorkBarName = "Attaching Lock..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "buttons/blip2.wav"

function ITEM:ShouldTraceUse(ply, ent)
    if not IsValid(ent) then return false end
    local cls = ent:GetClass()
    return cls == "prop_door_rotating" or cls == "func_door_rotating"
end

function ITEM:OnUse(ply, ent)
    for _, lock in ipairs(ents.FindByClass("deep_combine_lock")) do
        if lock.Owner == ply then
            ply:Notify("You already have a Combine Lock placed!")
            return false
        end
    end

    if not IsValid(ent)
       or (ent:GetClass() ~= "prop_door_rotating"
       and ent:GetClass() ~= "func_door_rotating") then

        ply:Notify("You must be looking at a door to attach the lock.")
        return false
    end

    local stored = scripted_ents.GetStored("deep_combine_lock")
    if not stored or not stored.t or not stored.t.SpawnFunction then
        ply:Notify("Error: Combine Lock spawn logic missing.")
        return false
    end

    local tr = ply:GetEyeTraceNoCursor()
    tr.Entity = ent
    tr.Hit    = true

    local lock = stored.t:SpawnFunction(ply, tr)
    if not IsValid(lock) then
        ply:Notify("Failed to deploy lock.")
        return false
    end

    ply:Notify("Combine Lock attached!")
    return true
end


impulse.RegisterItem(ITEM)