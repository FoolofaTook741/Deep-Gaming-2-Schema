local ITEM = {}

ITEM.UniqueID = "util_gunpowder"
ITEM.Name = "Jar of Gunpowder"
ITEM.Desc = "A jar full of gunpowder."
ITEM.Model = Model("models/props_lab/jar01b.mdl")
ITEM.FOV = 33
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 2

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "powder"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
