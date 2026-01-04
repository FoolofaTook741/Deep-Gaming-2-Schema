local ITEM = {}

ITEM.UniqueID = "item_pumpkinslice"
ITEM.Name = "Sliced Pumpkin"
ITEM.Desc =  "A slice of a large pumpkin, used for pies."
ITEM.Category = "Food"
ITEM.Model = Model("models/halloween2015/pumbkin_gibs_01.mdl")
ITEM.Colour = Color(255, 150, 0)
ITEM.FOV = 18
ITEM.Weight = 3.0

ITEM.Droppable = true
ITEM.DropOnDeath = false

ITEM.Illegal = false
ITEM.CanStack = true

impulse.RegisterItem(ITEM)
