local ITEM = {}

ITEM.UniqueID = "monster_popcorn"
ITEM.Name = "Passive Ability: Popcorn"
ITEM.Desc =  "When you are killed, 3 pulse canisters will pop out and explode moments later."
ITEM.Category = "Monsters"
ITEM.Model = Model("models/Items/combine_rifle_ammo01.mdl")
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
