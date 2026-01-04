local ITEM = {}

ITEM.UniqueID = "bl_apf"
ITEM.Name = "Biolinked O.S.I.A.E.R."
ITEM.Desc =  "The biolink can be severed if enough electrical charge is applied."
ITEM.Category = "Weapons"
ITEM.Model = Model("models/weapons/suppressor/w_suppressor.mdl")
ITEM.FOV = 46.239255014327
ITEM.CamPos = Vector(32.664756774902, -19.484241485596, 9.1690540313721)
ITEM.NoCenter = true
ITEM.Weight = 9.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.ConfiscateReward = 30

ITEM.Illegal = true
ITEM.CanStack = false

impulse.RegisterItem(ITEM)
