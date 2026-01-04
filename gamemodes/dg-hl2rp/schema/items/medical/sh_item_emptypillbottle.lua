local ITEM = {}

ITEM.UniqueID = "item_pillbottle"
ITEM.Name = "Empty Pill Bottle"
ITEM.Desc =  "An empty plastic pill bottle used to carry various medications."
ITEM.Category = "Medical"
ITEM.Model = Model("models/pills4.mdl")
ITEM.FOV = 5
ITEM.CamPos = Vector(100, 100, 0)
ITEM.NoCenter = true
ITEM.Weight = 0.5

ITEM.Droppable = true
ITEM.DropOnDeath = true

ITEM.Illegal = true
ITEM.CanStack = true

ITEM.DropIfRestricted = false
ITEM.DropOnDeathIfRestricted = false
ITEM.CraftIfRestricted = false
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
