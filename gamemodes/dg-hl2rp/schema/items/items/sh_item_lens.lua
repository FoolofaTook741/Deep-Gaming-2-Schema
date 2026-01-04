local ITEM = {}

ITEM.UniqueID = "util_lens"
ITEM.Name = "Helmet Lens"
ITEM.Desc = "A special lens that blocks bright flashes."
ITEM.Model = Model("models/gibs/glass_shard03.mdl")
ITEM.FOV = 18.485673352436
ITEM.CamPos = Vector(-20.057306289673, 25, 9)
ITEM.NoCenter = true
ITEM.Weight = 0.1

ITEM.Droppable = true
ITEM.DropOnDeath = false
ITEM.ConfiscateReward = 2

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
