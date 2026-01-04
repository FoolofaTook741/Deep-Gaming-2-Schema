local ITEM = {}

ITEM.UniqueID = "monster_enhancedvision"
ITEM.Name = "Passive Ability: Perfect Hearing"
ITEM.Desc =  "Your hearing is unmatched. Anything that moves or breathes you can hear."
ITEM.Category = "Monsters"
ITEM.Model = Model("models/Gibs/HGIBS_scapula.mdl")
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
