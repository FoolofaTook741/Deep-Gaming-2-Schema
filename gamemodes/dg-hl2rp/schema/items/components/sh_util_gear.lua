local ITEM = {}

ITEM.UniqueID = "util_gear"
ITEM.Name = "Metal Gear"
ITEM.Desc = "A small metal gear."
ITEM.Category = "Components"
ITEM.Model = Model("models/props_wasteland/gear02.mdl")
ITEM.FOV = 8.4025787965616
ITEM.CamPos = Vector(100, -26.934097290039, 2.8653295040131)
ITEM.Weight = 0.6

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.5

impulse.RegisterItem(ITEM)
