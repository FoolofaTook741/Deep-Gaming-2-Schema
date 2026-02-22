local ITEM = {}

ITEM.UniqueID = "util_heavyceramicplate"
ITEM.Name = "Steel Plate"
ITEM.Desc = "A heavy steel plate, used for more powerful armor. Could fit in a vest."
ITEM.Model = Model("models/hunter/plates/plate05x05.mdl")
ITEM.Material = "sprops/trans/misc/ls_m2"
ITEM.FOV = 40.250716332378
ITEM.CamPos = Vector(12.607449531555, 0, 40.687679290771)
ITEM.Weight = 3

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 40

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 1.5

impulse.RegisterItem(ITEM)
