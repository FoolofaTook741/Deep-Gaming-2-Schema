local ITEM = {}

ITEM.UniqueID = "item_musical"
ITEM.Name = "Music License"
ITEM.Desc =  "This permit allows you to play radios on your personal property [This is not a mic spam permit.]."
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
