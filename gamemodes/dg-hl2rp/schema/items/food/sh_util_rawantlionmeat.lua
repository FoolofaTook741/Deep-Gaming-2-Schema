local ITEM = {}

ITEM.UniqueID = "util_rawantlionmeat"
ITEM.Name = "Raw Antlion Meat"
ITEM.Desc = "A slimy and foul smelling piece of meat."
ITEM.Model = Model("models/willardnetworks/food/raw_alienmeat.mdl")
ITEM.FOV = 50
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
