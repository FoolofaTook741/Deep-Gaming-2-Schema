local ITEM = {}

ITEM.UniqueID = "util_medicalsupplies"
ITEM.Name = "Medical Supplies"
ITEM.Desc = "A bottle of supplies used to create various medicines."
ITEM.Category = "Components"
ITEM.Model = Model("models/urinecup.mdl")
ITEM.FOV = 17.113180515759
ITEM.CamPos = Vector(-6.3037247657776, 24.641834259033, 9.7421207427979)
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "metal"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
