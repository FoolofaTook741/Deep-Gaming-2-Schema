local ITEM = {}

ITEM.UniqueID = "item_heavyfirearmspermit"
ITEM.Name = "Firearms Permit (.357)"
ITEM.Desc =  "This permit allows the holder to weild the .357 revolver for self defense."
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
