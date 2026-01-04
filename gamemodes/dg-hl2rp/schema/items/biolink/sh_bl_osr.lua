local ITEM = {}

ITEM.UniqueID = "bl_osr"
ITEM.Name = "Biolinked O.S.I.S.R."
ITEM.Desc =  "The biolink can be severed if enough electrical charge is applied."
ITEM.Category = "Scrap"
ITEM.Model = Model("models/tnb/weapons/w_cisr.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 7

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 20

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.CraftSound = "metal"
ITEM.CraftTime = 1

impulse.RegisterItem(ITEM)
