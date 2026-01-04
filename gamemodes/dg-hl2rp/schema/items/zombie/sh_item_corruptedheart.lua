local ITEM = {}

ITEM.UniqueID = "item_corruptedheart"
ITEM.Name = "Latched Headcrab"
ITEM.Desc =  "A headcrab is controlling you!"
ITEM.Category = "Monsters"
ITEM.Model = Model("models/Lamarr.mdl")
ITEM.FOV = 7.8252148997135
ITEM.CamPos = Vector(100, 91.690544128418, 100)
ITEM.Colour = Color(75, 0, 0)
ITEM.NoCenter = true
ITEM.Weight = 30

ITEM.Droppable = false
ITEM.DropOnDeath = false

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false

impulse.RegisterItem(ITEM)
