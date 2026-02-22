local ITEM = {}

ITEM.UniqueID = "ing_flour"
ITEM.Name = "Flour"
ITEM.Desc = "A common baking ingredient."
ITEM.Category = "Components"
ITEM.Model = Model("models/hls/hawke/bag_flour_1.mdl")
ITEM.FOV = 40
ITEM.Weight = 0.3

ITEM.Droppable = true
ITEM.DropOnDeath = true 

ITEM.Illegal = false
ITEM.CanStack = true

ITEM.CraftSound = "fabric"
ITEM.CraftTime = 0.2

impulse.RegisterItem(ITEM)
