local ITEM = {}

ITEM.UniqueID = "util_rdxcompound"
ITEM.Name = "RDX Compound"
ITEM.Desc = "A chemical compound utilized in C4 explosives."
ITEM.Model = Model("models/props_lab/jar01b.mdl")
ITEM.FOV = 33
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "plastic"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
