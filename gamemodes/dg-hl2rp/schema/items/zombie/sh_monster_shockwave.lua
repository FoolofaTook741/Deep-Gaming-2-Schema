local ITEM = {}

ITEM.UniqueID = "monster_shockwave"
ITEM.Name = "Passive Ability: Shockwave"
ITEM.Desc =  "The electricity of your stunstick limits mobility of enemies. Each time you hit an attack, your opponent will be slowed."
ITEM.Category = "Monsters"
ITEM.Model = Model("models/weapons/w_stunbaton.mdl")
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
