local ITEM = {}

ITEM.UniqueID = "util_particleaccelerator"
ITEM.Name = "Particle Accelerator Core"
ITEM.Desc = "A key component in the Tau Cannon."
ITEM.Model = Model("models/maxofs2d/hover_rings.mdl")
ITEM.FOV = 15.4025787965616
ITEM.CamPos = Vector(100, -26.934097290039, 2.8653295040131)
ITEM.Weight = 2.0

ITEM.Droppable = true
ITEM.DropOnDeath = true
ITEM.ConfiscateReward = 100

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 1

impulse.RegisterItem(ITEM)
