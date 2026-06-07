local ITEM = {}

ITEM.UniqueID = "item_emptybag"
ITEM.Name = "Empty Contaminant Bag"
ITEM.Desc =  "Used to clean up various objects, corpses, and infestation points."
ITEM.Category = "ICT"
ITEM.Model = Model("models/hlvr/combine_hazardprops/combinehazardprops_clothe.mdl")
ITEM.FOV = 120
ITEM.CamPos = Vector(0, 0, 15)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

ITEM.UseName = "Bag"
ITEM.UseWorkBarTime = 8
ITEM.UseWorkBarName = "Bagging..."
ITEM.UseWorkBarFreeze = true
ITEM.UseWorkBarSound = "physics/body/body_medium_impact_soft3.wav" 

function ITEM:OnUse(ply, target)
    if not IsValid(target) then
        ply:Notify("No valid target to bag.")
        return false
    end

    local targetClass = target:GetClass()

    if targetClass == "prop_physics" and target.IsXenProp then
        if ply:CanHoldItem("item_fullbag_spore") then
            ply:Notify("You have bagged the xen growth.")
            target:Remove()
            ply:GiveInventoryItem("item_fullbag_spore")
            return true
        else
            ply:Notify("You do not have space to hold this item.")
            return false
        end
    elseif targetClass == "deep_spore" then
        if target.phase <= 1 then
            if ply:CanHoldItem("item_fullbag_spore") then
                ply:Notify("You have bagged the spore.")
                target:Remove()
                ply:GiveInventoryItem("item_fullbag_spore")
                return true
            else
                ply:Notify("You do not have space to hold this item.")
                return false
            end
        else
            ply:Notify("You cannot bag the spore in this current state.")
            return false
        end
    elseif targetClass == "deep_barnaclespawner" then
        if target.phase <= 1 then
            if ply:CanHoldItem("item_fullbag_barnacle") then
                ply:Notify("You have bagged the barnacle nest.")
                target:Remove()
                ply:GiveInventoryItem("item_fullbag_barnacle")
                return true
            else
                ply:Notify("You do not have space to hold this item.")
                return false
            end
        else
            ply:Notify("You cannot bag the barnacle spawner in this current state.")
            return false
        end
    else
        if ply:CanHoldItem("item_fullbag") then
            ply:Notify("You have bagged the contaminant.")
            if target.IsInXenZone then
                target.XenBagged = true
            end
            target:Remove()
            ply:GiveInventoryItem("item_fullbag")
            return true
        else
            ply:Notify("You do not have space to hold this item.")
            return false
        end
    end
end

function ITEM:ShouldTraceUse(ply, ent)
    print("[EmptyBag] Trace hit: " .. ent:GetClass() .. " EntIndex: " .. ent:EntIndex() .. " IsXenProp: " .. tostring(ent.IsXenProp))
    return ent:GetClass() == "prop_ragdoll" or ent:GetClass() == "deep_spore" or ent:GetClass() == "deep_barnaclespawner" or (ent:GetClass() == "prop_physics" and ent:GetNWBool("IsXenProp"))
end

impulse.RegisterItem(ITEM)
