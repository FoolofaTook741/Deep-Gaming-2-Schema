local ITEM = {}

ITEM.UniqueID = "util_paint"
ITEM.Name = "Paint"
ITEM.Desc = "A bucket of paint."
ITEM.Model = Model("models/props_junk/metal_paintcan001a.mdl")
ITEM.FOV = 40
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "water"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
