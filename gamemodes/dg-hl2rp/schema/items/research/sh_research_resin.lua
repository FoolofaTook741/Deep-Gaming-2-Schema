local ITEM = {}

ITEM.UniqueID = "util_resin"
ITEM.Name = "Resin"
ITEM.Desc = "A tightly compacted cluster of Resin, ready for use in the Fabricator."
ITEM.Model = Model("models/props_lab/jar01b.mdl")
ITEM.FOV = 44.061604584527
ITEM.CamPos = Vector(-6.8767910003662, 4.0114612579346, 28.080228805542)
ITEM.NoCenter = true
ITEM.Weight = 0.1
ITEM.Colour = Color(180, 180, 0)

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "plastic"
ITEM.CraftTime = 0.2

function ITEM:OnUse(ply, target)
    
    
    return true -- remove the item
end

function ITEM:ShouldTraceUse(ply, ent)
end


impulse.RegisterItem(ITEM)
