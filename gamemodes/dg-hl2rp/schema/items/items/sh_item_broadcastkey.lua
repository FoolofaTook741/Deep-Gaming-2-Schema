local ITEM = {}

ITEM.UniqueID = "item_broadcastkey"
ITEM.Name = "Broadcast Access Keycard"
ITEM.Desc = "A Keycard granting OCA Representatives and above access to the city broadcast system at the terminal."
ITEM.Category = "Permits"
ITEM.Model = Model("models/dorado/tarjetazero.mdl")
ITEM.FOV = 3
ITEM.CamPos = Vector(90,90,90)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = false

ITEM.DropIfRestricted = true
ITEM.DropOnDeathIfRestricted = true
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)