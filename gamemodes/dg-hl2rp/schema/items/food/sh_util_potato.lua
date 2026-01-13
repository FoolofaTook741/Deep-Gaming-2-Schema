local ITEM = {}

ITEM.UniqueID = "util_potato"
ITEM.Name = "Potato"
ITEM.Desc = "A fresh potato."
ITEM.Model = Model("models/foodnhouseholditems/potato.mdl")
ITEM.FOV = 50
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
