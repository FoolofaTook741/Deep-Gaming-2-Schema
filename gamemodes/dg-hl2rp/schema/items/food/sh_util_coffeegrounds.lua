local ITEM = {}

ITEM.UniqueID = "util_coffeegrounds"
ITEM.Name = "Coffee Grounds"
ITEM.Desc = "A container of finally ground coffee beans."
ITEM.Model = Model("models/willardnetworks/food/coffee_nescafe.mdl")
ITEM.FOV = 50
ITEM.Weight = 0.2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

impulse.RegisterItem(ITEM)
