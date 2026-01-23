local ITEM = {}

ITEM.UniqueID = "item_workbenchpermit"
ITEM.Name = "Workbench Permit"
ITEM.Desc =  "This permit allows the holder possess a workshop bench for their shop or residence."
ITEM.Category = "Permits"
ITEM.Model = Model("models/props_c17/paper01.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)
