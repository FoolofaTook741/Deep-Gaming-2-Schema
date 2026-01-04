local ITEM = {}

ITEM.UniqueID = "bl_osiprmk1c"
ITEM.Name = "Biolinked O.S.I.P.R. MK. I-C"
ITEM.Desc =  "The biolink can be severed if it can be shorted electrically some how."
ITEM.Category = "Scrap"
ITEM.Model = Model("models/weapons/ocipr/w_ocipr.mdl")
ITEM.FOV = 12.2249283667622
ITEM.CamPos = Vector(100, 100, 36.10315322876)
ITEM.Weight = 5.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 50

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.CraftSound = "metal"
ITEM.CraftTime = 1

impulse.RegisterItem(ITEM)
