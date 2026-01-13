local ITEM = {}

ITEM.UniqueID = "item_crudeoil"
ITEM.Name = "Crude Oil"
ITEM.Desc =  "If heated at the right temperature, this oil can be transformed into Gasoline and other fuels."
ITEM.Category = "Items"
ITEM.Model = Model("models/props_c17/oildrum001.mdl")
ITEM.FOV = 45
ITEM.CamPos = Vector(-5, -5, -5)
ITEM.NoCenter = true
ITEM.Weight = 8

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

impulse.RegisterItem(ITEM)
