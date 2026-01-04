local ITEM = {}

ITEM.UniqueID = "item_emptymedkit"
ITEM.Name = "Empty Medical Kit"
ITEM.Desc =  "An empty medical kit used to carry various medications and first aid items."
ITEM.Category = "Medical"
ITEM.Model = Model("models/warz/items/medkit.mdl")
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
