local ITEM = {}

ITEM.UniqueID = "util_partskit"
ITEM.Name = "Advanced Weapon Parts Kit"
ITEM.Desc = "Powerful parts used to modify existing guns."
ITEM.Model = Model("models/props_c17/suitcase_passenger_physics.mdl")
ITEM.FOV = 40
ITEM.Weight = 1

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
