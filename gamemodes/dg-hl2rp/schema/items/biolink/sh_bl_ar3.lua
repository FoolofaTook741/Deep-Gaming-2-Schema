local ITEM = {}

ITEM.UniqueID = "bl_ar3"
ITEM.Name = "Biolinked O.S.I.P.R. MK. II"
ITEM.Desc =  "The biolink can be severed if it can be shorted electrically some how."
ITEM.Category = "Scrap"
ITEM.Model = Model("models/weapons/w_irifle.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 5

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
