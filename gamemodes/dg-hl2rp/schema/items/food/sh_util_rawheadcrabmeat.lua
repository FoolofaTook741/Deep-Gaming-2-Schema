local ITEM = {}

ITEM.UniqueID = "util_rawheadcrabmeat"
ITEM.Name = "Raw Headcrab Meat"
ITEM.Desc = "A raw slab of headcrab meat."
ITEM.Model = Model("models/willardnetworks/food/meat5.mdl")
ITEM.FOV = 50
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
