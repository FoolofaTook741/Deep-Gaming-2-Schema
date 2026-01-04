local ITEM = {}

ITEM.UniqueID = "monster_heavyhands"
ITEM.Name = "Passive Ability: Heavy Hands"
ITEM.Desc =  "Your strikes are more meaningful, doors have a much higher chance of being broken open."
ITEM.Category = "Monsters"
ITEM.Model = Model("models/gibs/hgibs_rib.mdl")
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
