local ITEM = {}

ITEM.UniqueID = "util_salt"
ITEM.Name = "salt"
ITEM.Desc = "A bag salt."
ITEM.Category = "Food"
ITEM.Model = Model("models/props_junk/garbage_bag001a.mdl")
ITEM.FOV = 50
ITEM.Weight = 0.4

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
