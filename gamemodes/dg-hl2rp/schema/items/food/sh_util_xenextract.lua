local ITEM = {}

ITEM.UniqueID = "util_xenextract"
ITEM.Name = "Xen Extract"
ITEM.Desc = "A rare extract from the borderworld."
ITEM.Model = Model("models/willardnetworks/food/xen_extract.mdl")
ITEM.FOV = 50
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
