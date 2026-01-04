local ITEM = {}

ITEM.UniqueID = "util_ruinedotavest"
ITEM.Name = "Ruined OTA Ballistic Vest"
ITEM.Desc = "A bloodied and ruined OTA Ballistic Vest salvaged from the body of an OTA soldier."
ITEM.Model = Model("models/combine_vests/zombineregularvest.mdl")
ITEM.FOV = 50
ITEM.NoCenter = true
ITEM.Weight = 6

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
