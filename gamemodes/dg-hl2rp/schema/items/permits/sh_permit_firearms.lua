local ITEM = {}

ITEM.UniqueID = "item_firearmspermit"
ITEM.Name = "Firearms Permit (USP-9)"
ITEM.Desc =  "This permit allows the holder to weild the light firearm, USP-9, for self defense purposes."
ITEM.Category = "Permits"
ITEM.Model = Model("models/props_c17/paper01.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)
