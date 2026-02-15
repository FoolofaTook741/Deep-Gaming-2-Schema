local ITEM = {}

ITEM.UniqueID = "util_fuel"
ITEM.Name = "Fuel Can"
ITEM.Desc = "A can full of fuel."
ITEM.Category = "Components"
ITEM.Model = Model("models/props_junk/metalgascan.mdl")
ITEM.FOV = 20.651862464183
ITEM.CamPos = Vector(54.441261291504, 76.790832519531, 23.49570274353)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "fuel"
ITEM.CraftTime = 0.75

impulse.RegisterItem(ITEM)
