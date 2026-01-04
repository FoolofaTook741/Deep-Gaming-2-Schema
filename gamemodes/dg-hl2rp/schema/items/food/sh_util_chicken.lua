local ITEM = {}

ITEM.UniqueID = "util_chicken"
ITEM.Name = "Raw chicken"
ITEM.Desc = "A uncooked piece of chichen."
ITEM.Model = Model("models/mosi/skyrim/fooddrink/chicken.mdl")
ITEM.FOV = 50
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
