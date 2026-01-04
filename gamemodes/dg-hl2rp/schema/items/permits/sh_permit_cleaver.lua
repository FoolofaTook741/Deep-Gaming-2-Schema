local ITEM = {}

ITEM.UniqueID = "item_cleaverpermit"
ITEM.Name = "Cleaver Permit"
ITEM.Desc =  "This permit allows the holder to wield a cleaver for butchering of meat."
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
