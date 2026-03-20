local ITEM = {}

ITEM.UniqueID = "util_lvl2plate"
ITEM.Name = "Soft Armor Panel"
ITEM.Desc = "A malleable plastic sheet used for light armor designed to stop stab and light munitions."
ITEM.Model = Model("models/squad/sf_plates/sf_plate2x2.mdl")
ITEM.Material = "sprops/trans/misc/beam_side"
ITEM.Category = "Components"
ITEM.FOV = 40.250716332378
ITEM.CamPos = Vector(12.607449531555, 0, 40.687679290771)
ITEM.Weight = 2

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 10

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 1

impulse.RegisterItem(ITEM)